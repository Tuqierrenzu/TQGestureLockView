//
//  TQGestureLockHintLabel.m
//  TQGestureLockViewDemo_Example
//
//  Created by TQTeam on 2017/11/3.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import "TQGestureLockHintLabel.h"
#import "CALayer+TQAnimated.h"

@implementation TQGestureLockHintLabel

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame   ]) {
        self.backgroundColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = [UIColor grayColor];
    }
    return self;
}

- (void)setNormalText:(NSString *)text {
    self.text = text;
    self.textColor = [UIColor grayColor];
}

- (void)setWarningText:(NSString *)text shakeAnimated:(BOOL)shake {
    self.text = text;
    self.textColor = [UIColor redColor];
    if (shake) [self.layer tq_shake];
}

- (void)clearText {
    self.text = nil;
    self.textColor = [UIColor clearColor];
}

@end
