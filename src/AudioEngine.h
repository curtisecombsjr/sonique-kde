// AudioEngine — thin facade over QMediaPlayer + QAudioOutput, exposed to QML.
//
// Design notes:
//   * One player, one output. Sonique was single-track-at-a-time and we follow suit.
//   * State is mirrored as Qt properties so QML bindings update without polling.
//   * Position/duration are in milliseconds (Qt's native unit); the LCD readout
//     formats them to mm:ss.
//   * No format negotiation here — Qt Multimedia's FFmpeg backend handles
//     anything ffmpeg handles, which is the whole point of this rewrite.

#pragma once

#include <QObject>
#include <QString>
#include <QUrl>
#include <qqmlintegration.h>

class QMediaPlayer;
class QAudioOutput;

class AudioEngine : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString source READ source NOTIFY sourceChanged)
    Q_PROPERTY(QString title READ title NOTIFY titleChanged)
    Q_PROPERTY(qint64 position READ position NOTIFY positionChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(float volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(PlayState state READ state NOTIFY stateChanged)
    Q_PROPERTY(QString errorString READ errorString NOTIFY errorStringChanged)

public:
    // Local mirror of QMediaPlayer::PlaybackState so QML doesn't have to import
    // QtMultimedia just to read play/pause state.
    enum PlayState {
        Stopped,
        Playing,
        Paused,
    };
    Q_ENUM(PlayState)

    explicit AudioEngine(QObject *parent = nullptr);
    ~AudioEngine() override;

    QString source() const { return m_source; }
    QString title() const { return m_title; }
    qint64 position() const;
    qint64 duration() const;
    float volume() const;
    void setVolume(float v);
    PlayState state() const { return m_state; }
    QString errorString() const { return m_errorString; }

public Q_SLOTS:
    // Accepts either a filesystem path or a file:// URL.
    void load(const QString &pathOrUrl);
    void play();
    void pause();
    void stop();
    void seek(qint64 milliseconds);

Q_SIGNALS:
    void sourceChanged();
    void titleChanged();
    void positionChanged();
    void durationChanged();
    void volumeChanged();
    void stateChanged();
    void errorStringChanged();

private:
    void wireSignals();
    void refreshTitleFromUrl(const QUrl &url);

    QMediaPlayer *m_player = nullptr;
    QAudioOutput *m_output = nullptr;
    QString m_source;
    QString m_title;
    QString m_errorString;
    PlayState m_state = Stopped;
};
