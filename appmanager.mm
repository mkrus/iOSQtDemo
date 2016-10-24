#include "appmanager.h"
static AppManager* _appManager = 0;

#ifdef Q_OS_IOS
#import <UIKit/UIKit.h>
#include <QGuiApplication>
#include <QWindow>
#include <qpa/qplatformnativeinterface.h>
#include <QDebug>


@interface QIOSViewController
@end;

@interface QIOSViewController (QWSDemo)
@end;

@implementation QIOSViewController (QWSDemo)
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return _appManager && _appManager->lightContent() ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}
- (void)didReceiveMemoryWarning
{

}
@end

#endif


AppManager::AppManager(QObject *parent)
    : QObject(parent)
    , m_lightContent(false)
    , m_window(0)
{
    Q_ASSERT(_appManager == 0);
    _appManager = this;
}


void AppManager::setLightContent(bool v)
{
    if(m_lightContent != v)
    {
        m_lightContent = v;
        emit lightContentChanged(v);

#ifdef Q_OS_IOS
        if(0 == m_window)
        {
            m_window = QGuiApplication::focusWindow();
        }
        if(m_window)
        {
            UIView *view = static_cast<UIView*>(QGuiApplication::platformNativeInterface()->nativeResourceForWindow("uiview", m_window));
            Q_ASSERT(view);

            UIViewController* controller = [[view window] rootViewController];
            Q_ASSERT(controller);

            [controller setNeedsStatusBarAppearanceUpdate];
        }
        else
            qDebug() << "No window";
#endif
    }
}
