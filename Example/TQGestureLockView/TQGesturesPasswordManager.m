//
//  TQGesturesPasswordManager.m
//  TQGestureLockViewDemo_Example
//
//  Created by TQTeam on 2017/11/3.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import "TQGesturesPasswordManager.h"

NSString *const TQGesturesPasswordStorageKey = @"tq_gesturesPassword";

@implementation TQGesturesPasswordManager

+ (instancetype)manager {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _hasFirstPassword = NO;
    }
    return self;
}

- (void)setFirstPassword:(NSString *)firstPassword {
    if (!firstPassword || !firstPassword.length) {
        _hasFirstPassword = NO;
        _firstPassword = nil;
    } else {
        _firstPassword = firstPassword;
        _hasFirstPassword = YES;
    }
}

- (void)saveEventuallyPassword:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:TQGesturesPasswordStorageKey];
}

- (NSString *)getEventuallyPassword {
    return [[NSUserDefaults standardUserDefaults] stringForKey:TQGesturesPasswordStorageKey];
}

@end
