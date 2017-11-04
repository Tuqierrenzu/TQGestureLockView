//
//  TQGestureLockToast.h
//  TQGestureLockViewDemo_Example
//
//  Created by TQTeam on 2017/11/3.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TQGestureLockToast : NSObject

@end

@interface UIView (TQGestureLockToast)

- (void)tq_showHUD:(NSString *)msg;
- (void)tq_showHUD:(NSString *)msg afterDelay:(NSTimeInterval)delay;
- (void)tq_showText:(NSString *)msg;
- (void)tq_showText:(NSString *)msg afterDelay:(NSTimeInterval)delay;

@end

