// Copyright 2016 WillCobb
// Licensed under GPLV2+
// Refer to the license.txt provided

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WCDirectionalControlDirection)
{
    WCDirectionalControlDirectionLeft   = 1,
    WCDirectionalControlDirectionRight  = 2,
    WCDirectionalControlDirectionDown   = 4,
    WCDirectionalControlDirectionUp     = 8,
};

typedef NS_ENUM(NSInteger, WCDirectionalControlStyle)
{
    WCDirectionalControlStyleDPad = 0,
    WCDirectionalControlStyleJoystick = 1,
};

@interface WCDirectionalControl : UIControl

@property (readonly, nonatomic) WCDirectionalControlDirection direction;
@property (assign, nonatomic) WCDirectionalControlStyle style;

- (id)initWithFrame:(CGRect)frame BoundsImage:(NSString*)boundsImage StickImage:(NSString*)stickImage;
- (id)initWithFrame:(CGRect)frame DPadImages:(NSArray <UIImage*>*)dpadImages;
- (CGPoint)joyLocation;
- (void)frameUpdated;

@end
