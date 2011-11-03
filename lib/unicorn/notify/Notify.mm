
#include <Growl/Growl.h>

#include <lastfm/Track.h>

#include "Notify.h"



@interface Delegate : NSObject <GrowlApplicationBridgeDelegate> {
    unicorn::Notify* observer;
}
    - (Delegate*) init:(unicorn::Notify*)observer;
    - (void) growlNotificationWasClicked:(id)clickContext;
@end

@implementation Delegate
- (Delegate*) init:(unicorn::Notify*)observer
{
    if ( self = [super init] )
    {
        self->observer = observer;
    }

    return self;
}

- (void) growlNotificationWasClicked:(id)clickContext
{
    self->observer->growlNotificationWasClicked();
}
@end

unicorn::Notify::Notify(QObject *parent) :
    QObject(parent)
{
    Delegate* delegateObject = [[Delegate alloc] init: this];

    [GrowlApplicationBridge setGrowlDelegate:delegateObject];
}

void
unicorn::Notify::newTrack( const lastfm::Track& track )
{
    QString title = track.toString();
    QString description = tr("from %1").arg( track.album() );

    NSString* nsTitle = [NSString stringWithCharacters:(const unichar *)title.unicode() length:(NSUInteger)title.length() ];
    NSString* nsDescription = [NSString stringWithCharacters:(const unichar *)description.unicode() length:(NSUInteger)description.length() ];

    // TODO: Do the growl notification here. It'll be great!
    [GrowlApplicationBridge notifyWithTitle:(NSString *)nsTitle
      description:(NSString *)nsDescription
      notificationName:(NSString *)@"New track"
                                iconData:(NSData *)nil
                                priority:(signed int)0
                                isSticky:(BOOL)NO
                                clickContext:(id)@"context"];

}

void
unicorn::Notify::growlNotificationWasClicked()
{
    emit clicked();
}