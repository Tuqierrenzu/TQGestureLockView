//
//  TQGestureLockDrawManager.h
//  <https://github.com/Tuqierrenzu/TQGestureLockView>
//
//  Created by TQTeam on 2017/11/2.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQGestureLockDrawManager : NSObject

/// The number of need draw / 需要绘制多少个 (default is 9)
@property (nonatomic, assign) NSInteger subCirclesCount;

/// 每行布局的个数，默认3个
@property (nonatomic, assign) NSInteger numberOfRow;

/// 外圆直径 (通过该属性设置大小)
@property (nonatomic, assign) CGFloat circleDiameter;

/// 实心圆占空心圆的比例系数 (控制实心圆大小)
@property (nonatomic, assign) CGFloat solidCircleFactor;

/// 边缘留白
@property (nonatomic, assign) UIEdgeInsets edgeSpacingInsets;

/// 外圆线宽
@property (nonatomic, assign) CGFloat hollowCircleBorderWidth;

/// 普通状态下颜色
@property (nonatomic, strong) UIColor *drawNormalColor;

/// 选中状态下颜色
@property (nonatomic, strong) UIColor *drawSelectedColor;

/// 错误状态下颜色
@property (nonatomic, strong) UIColor *drawErrorColor;

/// 连接线的宽度
@property (nonatomic, assign) CGFloat bridgingLineWidth;

/// 是否忽略处理视图范围外的点，默认YES
@property (nonatomic, assign) BOOL ignoreOutsidePoint;

/// 设置安全码至少多少位，默认不少于4位
@property (nonatomic, assign) NSInteger securityCodeLeastNumbers;

/// 错误状态的延迟消失时间，默认1.0s
@property (nonatomic, assign) NSTimeInterval errorTimeInterval;

+ (instancetype)defaultManager;

@end
