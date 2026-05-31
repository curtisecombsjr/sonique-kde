#include "AudioEngine.h"

#include <QAudioOutput>
#include <QFileInfo>
#include <QMediaMetaData>
#include <QMediaPlayer>
#include <QUrl>

AudioEngine::AudioEngine(QObject *parent)
    : QObject(parent),
      m_player(new QMediaPlayer(this)),
      m_output(new QAudioOutput(this)) {
    m_player->setAudioOutput(m_output);
    // Sonique's volume knob ran 0..1; QAudioOutput uses the same range, so the
    // QML side can bind directly without rescaling.
    m_output->setVolume(0.8f);
    wireSignals();
}

AudioEngine::~AudioEngine() = default;

void AudioEngine::wireSignals() {
    connect(m_player, &QMediaPlayer::positionChanged,
            this, &AudioEngine::positionChanged);
    connect(m_player, &QMediaPlayer::durationChanged,
            this, &AudioEngine::durationChanged);

    connect(m_player, &QMediaPlayer::playbackStateChanged,
            this, [this](QMediaPlayer::PlaybackState s) {
                PlayState mapped = Stopped;
                switch (s) {
                case QMediaPlayer::PlayingState: mapped = Playing; break;
                case QMediaPlayer::PausedState:  mapped = Paused;  break;
                case QMediaPlayer::StoppedState: mapped = Stopped; break;
                }
                if (mapped != m_state) {
                    m_state = mapped;
                    Q_EMIT stateChanged();
                }
            });

    connect(m_player, &QMediaPlayer::errorOccurred,
            this, [this](QMediaPlayer::Error, const QString &msg) {
                if (msg != m_errorString) {
                    m_errorString = msg;
                    Q_EMIT errorStringChanged();
                }
            });

    // Refresh display title when metadata lands (often after a brief delay
    // post-load with the FFmpeg backend).
    connect(m_player, &QMediaPlayer::metaDataChanged,
            this, [this]() {
                const auto md = m_player->metaData();
                QString t = md.stringValue(QMediaMetaData::Title);
                if (!t.isEmpty() && t != m_title) {
                    m_title = t;
                    Q_EMIT titleChanged();
                }
            });

    connect(m_output, &QAudioOutput::volumeChanged,
            this, &AudioEngine::volumeChanged);
}

void AudioEngine::refreshTitleFromUrl(const QUrl &url) {
    // Fallback title from filename; metadata callback will overwrite if richer.
    QString fallback = QFileInfo(url.toLocalFile()).completeBaseName();
    if (fallback.isEmpty()) fallback = url.fileName();
    if (fallback != m_title) {
        m_title = fallback;
        Q_EMIT titleChanged();
    }
}

void AudioEngine::load(const QString &pathOrUrl) {
    QUrl url = pathOrUrl.contains(QStringLiteral("://"))
        ? QUrl(pathOrUrl)
        : QUrl::fromLocalFile(pathOrUrl);
    m_player->setSource(url);
    m_source = url.toString();
    Q_EMIT sourceChanged();
    refreshTitleFromUrl(url);
    if (!m_errorString.isEmpty()) {
        m_errorString.clear();
        Q_EMIT errorStringChanged();
    }
}

void AudioEngine::play() { m_player->play(); }
void AudioEngine::pause() { m_player->pause(); }
void AudioEngine::stop() { m_player->stop(); }
void AudioEngine::seek(qint64 ms) { m_player->setPosition(ms); }

qint64 AudioEngine::position() const { return m_player->position(); }
qint64 AudioEngine::duration() const { return m_player->duration(); }
float AudioEngine::volume() const { return m_output->volume(); }
void AudioEngine::setVolume(float v) { m_output->setVolume(v); }
