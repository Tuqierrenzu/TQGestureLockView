//
//  TQGestureLockDrawManager.m
//  <https://github.com/Tuqierrenzu/TQGestureLockView>
//
//  Created by TQTeam on 2017/11/2.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import "TQGestureLockDrawManager.h"

@implementation TQGestureLockDrawManager

+ (instancetype)defaultManager {
    TQGestureLockDrawManager *manager = [[TQGestureLockDrawManager alloc] init];
    manager.subCirclesCount = 9;
    manager.numberOfRow = 3;
    manager.circleDiameter = 65;
    manager.solidCircleFactor = 0.4;
    
    manager.drawNormalColor = [UIColor colorWithRed:18/255. green:150/255. blue:219/255. alpha:1.0];
    manager.drawSelectedColor = [UIColor colorWithRed:18/255. green:150/255. blue:219/255. alpha:1.0];
    manager.drawErrorColor = [UIColor colorWithRed:216/255. green:30/255. blue:6/255. alpha:1.0];
    manager.hollowCircleBorderWidth = 1.0;
    manager.bridgingLineWidth = 1.0;
    manager.edgeSpacingInsets = UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0);
    
    manager.ignoreOutsidePoint = YES;
    manager.securityCodeLeastNumbers = 4;
    manager.errorTimeInterval = 1.0;
    return manager;
}

@end
