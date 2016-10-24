#ifndef APPMANAGER_H
#define APPMANAGER_H

#include <QObject>

class QWindow;


class AppManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool lightContent READ lightContent WRITE setLightContent NOTIFY lightContentChanged)
public:
    explicit AppManager(QObject *parent = 0);

    bool lightContent() const { return m_lightContent; }

signals:
    void lightContentChanged(bool);

public slots:
    void setLightContent(bool v);

private:
    bool m_lightContent;
    QWindow* m_window;
};

#endif // APPMANAGER_H
