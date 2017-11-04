//
//  CALayer+TQAnimated.m
//  TQGestureLockViewDemo_Example
//
//  Created by zhanghao on 2017/11/3.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "CALayer+TQAnimated.h"

@implementation CALayer (TQAnimated)

- (void)tq_shake {
    CGPoint position = self.position;
    CGPoint x = CGPointMake(position.x + 5, position.y);
    CGPoint y = CGPointMake(position.x - 5, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.06];
    [animation setRepeatCount:3];
    [self addAnimation:animation forKey:@"tq_positionKey"];
}

@end
