// Copyright 2016 WillCobb, OatmealDome
// Licensed under GPLV2+
// Refer to the license.txt provided

#import <UIKit/UIKit.h>

@class GLKView;
@class DolphinGame;
@interface EmulatorViewController : UIViewController

- (void)launchGame:(DolphinGame*)game;

@end

