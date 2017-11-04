//
//  TQGestureLockPreview.h
//  <https://github.com/Tuqierrenzu/TQGestureLockView>
//
//  Created by TQTeam on 2017/11/2.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQGestureLockPreview : UIView

/// 绘制多少个
@property (nonatomic, assign) NSInteger subCirclesCount;

/// 每行布局的个数，默认3个
@property (nonatomic, assign) NSInteger numberOfRow;

/// 边缘留白
@property (nonatomic, assign) UIEdgeInsets edgeSpacingInsets;

/// 直径
@property (nonatomic, assign) CGFloat diameter;

/// 线宽
@property (nonatomic, assign) CGFloat borderLineWidth;

/// 边线颜色
@property (nonatomic, strong) UIColor *borderLineColor;

/// 选中状态填充色
@property (nonatomic, strong) UIColor *selectedFillColor;

/// 正常状态填充色
@property (nonatomic, strong) UIColor *normalFillColor;

/// 是否需要连线
@property (nonatomic, assign) BOOL isNeedsConcatenate;

/// 连接线的宽度
@property (nonatomic, assign) CGFloat bridgingLineWidth;

/// 连接线的颜色
@property (nonatomic, strong) UIColor *bridgingLineColor;

/// 重新绘制
- (void)redraw;

/// 根据密码重新绘制需要填充的圆
- (void)redrawWithVerifySecurityCodeString:(NSString *)verifySecurityCodeString;

@end
