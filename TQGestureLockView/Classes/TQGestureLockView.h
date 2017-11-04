//
//  TQGestureLockView.h
//  <https://github.com/Tuqierrenzu/TQGestureLockView>
//
//  Created by TQTeam on 2017/11/2.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQGestureLockDrawManager.h"

@protocol TQGestureLockViewDelegate;
@interface TQGestureLockView : UIView

@property (nonatomic, weak) id<TQGestureLockViewDelegate> delegate;
@property (nonatomic, strong, readonly) TQGestureLockDrawManager *drawManager;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

// Only through `-initWithFrame:drawManager:` to initialize.
- (instancetype)initWithFrame:(CGRect)frame drawManager:(TQGestureLockDrawManager *)drawManager NS_DESIGNATED_INITIALIZER;

/// Whether need to display the error status.
- (void)setNeedsDisplayGestureLockErrorState:(BOOL)isNeedsDisplay; // (应该在delegate回调内手动调用`setNeedsDisplayGestureLockErrorState`方法，可以根据情况设置参数状态)

@end

@protocol TQGestureLockViewDelegate <NSObject>
@optional

/// 连线个数不满足条件时的回调
- (void)gestureLockView:(TQGestureLockView *)gestureLockView lessErrorSecurityCodeSting:(NSString *)securityCodeSting;

/// 连线个数满足条件时的回调
- (void)gestureLockView:(TQGestureLockView *)gestureLockView finalRightSecurityCodeSting:(NSString *)securityCodeSting;

@end
