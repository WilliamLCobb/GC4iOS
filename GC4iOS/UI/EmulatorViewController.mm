// Copyright 2016 WillCobb, OatmealDome
// Licensed under GPLV2+
// Refer to the license.txt provided

#import "UI/EmulatorViewController.h"

#import "Bridge/DolphinBridge.h"
#import "Bridge/DolphinGame.h"

#import "Controller/GCControllerView.h"

#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>

#include "Common/GL/GLInterfaceBase.h"
#include "Core/HW/GCPadEmu.h"
#include "InputCommon/ControllerInterface/iOS/iOSButtonManager.h"
#include "InputCommon/ControllerInterface/ControllerInterface.h"
#include "InputCommon/InputConfig.h"

@interface EmulatorViewController () <GCControllerViewDelegate> {
    DolphinBridge*        bridge;
    GCControllerView*    controllerView;
    CAEAGLLayer            *renderLayer;
}

@property (strong, nonatomic) EAGLContext* context;

@end

@implementation EmulatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    bridge = [DolphinBridge new];

    
    // Add GLKView
    
    renderLayer = [CAEAGLLayer layer];
    renderLayer.opaque = YES;
    renderLayer.contentsScale = [[UIScreen mainScreen] scale];
    [self.view.layer addSublayer:renderLayer];

    // Add controller View
    CGSize screenSize = [self currentScreenSizeAlwaysLandscape:YES];
    controllerView = [[GCControllerView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    controllerView.delegate = self;
    [self.view addSubview:controllerView];
}

- (void)launchGame:(DolphinGame* )game
{
    [bridge openRomAtPath:game.path inLayer:renderLayer];
    [self initController];
}

- (void)viewWillLayoutSubviews
{
    renderLayer.frame = self.view.layer.bounds;
}

#pragma mark - Controller Delegate

u16 buttonState;
CGPoint joyData[2];

////This is a terrible hack. We need to configure dolphin to use a custom controller not just override this function
void GCPad::GetInput(GCPadStatus* const pad)
{
    pad->button = buttonState;
    
    //printf("%f %f\n", joyData[0].x, joyData[1].x);
    
    pad->stickX = (uint8_t)joyData[0].x;
    pad->stickY = (uint8_t)joyData[0].y;
    
    pad->substickX = (uint8_t)joyData[1].x;
    pad->substickY = (uint8_t)joyData[1].y;
   
    pad->triggerLeft = buttonState * 2;
    pad->triggerRight = buttonState * 4;
}

// Create a new class to handle the controller later
- (void)joystick:(NSInteger)joyid movedToPosition:(CGPoint)joyPosition
{
    joyData[joyid].x = joyPosition.x * 127 + 128;
    joyData[joyid].y = joyPosition.y * 127 + 128;
}

- (void)buttonStateChanged:(u16)bState
{
    buttonState = bState;
}

- (void)initController
{
}

#pragma mark - UIFunctions

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (CGSize)currentScreenSizeAlwaysLandscape:(BOOL)portrait
{
    if (!portrait)
        return [UIScreen mainScreen].bounds.size;
    // Get portrait size
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds);
    CGFloat height = CGRectGetHeight(screenBounds);
    if (![self isPortrait])
    {
        return CGSizeMake(width, height);
    }
    return CGSizeMake(height, width);
}

- (BOOL)isPortrait
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
