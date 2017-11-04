//
//  TQViewController2.m
//  TQGestureLockViewDemo_Example
//
//  Created by TQTeam on 2017/11/3.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import "TQViewController2.h"
#import "TQGestureLockView.h"
#import "TQGesturesPasswordManager.h"
#import "TQGestureLockHintLabel.h"
#import "TQSucceedViewController.h"

@interface TQViewController2 () <TQGestureLockViewDelegate>

@property (nonatomic, strong) TQGestureLockView *lockView;
@property (nonatomic, strong) TQGestureLockHintLabel *hintLabel;
@property (nonatomic, strong) TQGesturesPasswordManager *passwordManager;

@end

@implementation TQViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonInitialization];
    
    [self subviewsInitialization];
}

- (void)commonInitialization
{
    self.passwordManager = [TQGesturesPasswordManager manager];
}

- (void)subviewsInitialization
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat spacing = TQSizeFitW(40);
    CGFloat diameter = (screenSize.width - spacing * 4) / 3;
    CGFloat bottom1 = TQSizeFitH(55);
    CGFloat width1 = screenSize.width;
    CGFloat top1 = screenSize.height - width1 - bottom1;
    CGRect rect1 = CGRectMake(0, top1, width1, width1);
    
    CGFloat width2 = screenSize.width, height2 = 30;
    CGFloat top2 = top1 - height2 -17;
    CGRect rect2 = CGRectMake(0, top2, width2, height2);
    
    TQGestureLockDrawManager *drawManager = [TQGestureLockDrawManager defaultManager];
    drawManager.circleDiameter = diameter;
    drawManager.edgeSpacingInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    drawManager.bridgingLineWidth = 0.5;
    drawManager.hollowCircleBorderWidth = 0.5;
    
    _lockView = [[TQGestureLockView alloc] initWithFrame:rect1 drawManager:drawManager];
    _lockView.delegate = self;
    [self.view addSubview:_lockView];
    
    _hintLabel = [[TQGestureLockHintLabel alloc] initWithFrame:rect2];
    [self.view addSubview:_hintLabel];
}

#pragma mark - TQGestureLockViewDelegate

- (void)gestureLockView:(TQGestureLockView *)gestureLockView lessErrorSecurityCodeSting:(NSString *)securityCodeSting
{
    [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
    [_hintLabel setWarningText:@"密码错误，请重新输入" shakeAnimated:YES];
}

- (void)gestureLockView:(TQGestureLockView *)gestureLockView finalRightSecurityCodeSting:(NSString *)securityCodeSting
{
    NSString *password = [self.passwordManager getEventuallyPassword];
    if ([password isEqualToString:securityCodeSting]) {
        [gestureLockView setNeedsDisplayGestureLockErrorState:NO];
        TQSucceedViewController *vc = [TQSucceedViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        [_hintLabel clearText];
    } else {
        [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
        [_hintLabel setWarningText:@"密码错误，请重新输入" shakeAnimated:YES];
    }
}

@end
