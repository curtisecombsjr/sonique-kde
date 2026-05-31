// sonique-kde entrypoint.
//
// We force the FFmpeg multimedia backend before any Qt6 multimedia symbol is
// touched. On Arch with Qt 6.11 the FFmpeg backend ships as the default, but
// stating it explicitly insulates us from distros where the GStreamer or
// Windows-WMF backend would otherwise win and not handle 24/32-bit PCM cleanly.

#include <QCommandLineParser>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QUrl>

#include "AudioEngine.h"

int main(int argc, char *argv[]) {
    qputenv("QT_MEDIA_BACKEND", "ffmpeg");

    QGuiApplication app(argc, argv);
    QGuiApplication::setApplicationName(QStringLiteral("sonique-kde"));
    QGuiApplication::setOrganizationName(QStringLiteral("sonique-kde"));
    QQuickStyle::setStyle(QStringLiteral("Basic")); // we paint our own chrome

    QCommandLineParser parser;
    parser.setApplicationDescription(
        QStringLiteral("A KDE/Qt6 reimagining of Sonique 1.x"));
    parser.addHelpOption();
    parser.addPositionalArgument(
        QStringLiteral("file"),
        QStringLiteral("Audio file to load on startup (optional)"));
    parser.process(app);

    QQmlApplicationEngine engine;
    // Surface QML object-creation failures — silent exit-zero is the worst.
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, [](const QUrl &url) {
                         qWarning() << "QML objectCreationFailed for" << url;
                         QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    engine.loadFromModule("app.sonique", "Main");
    if (engine.rootObjects().isEmpty()) {
        qWarning() << "No root QML objects — load failed.";
        return -1;
    }

    // Optional initial file from the CLI.
    const auto positional = parser.positionalArguments();
    if (!positional.isEmpty()) {
        // The AudioEngine singleton is reachable from QML; we ping it via the
        // engine's QML context so the QML side stays the single source of truth.
        auto *eng = engine.singletonInstance<AudioEngine *>("app.sonique", "AudioEngine");
        if (eng) {
            eng->load(positional.first());
            eng->play();
        }
    }

    return app.exec();
}
