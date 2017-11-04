//
//  TQGestureLockHintLabel.h
//  TQGestureLockViewDemo_Example
//
//  Created by TQTeam on 2017/11/3.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQGestureLockHintLabel : UILabel

- (void)setNormalText:(NSString *)text;
- (void)setWarningText:(NSString *)text shakeAnimated:(BOOL)shake;
- (void)clearText;

@end
