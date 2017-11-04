//
//  TQGesturesPasswordManager.h
//  TQGestureLockViewDemo_Example
//
//  Created by TQTeam on 2017/11/3.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQGesturesPasswordManager : NSObject

+ (instancetype)manager;

@property (nonatomic, assign, readonly) BOOL hasFirstPassword;
@property (nonatomic, strong) NSString *firstPassword;

- (void)saveEventuallyPassword:(NSString *)password;
- (NSString *)getEventuallyPassword;
- (BOOL)verifyPassword:(NSString *)password;

@end
