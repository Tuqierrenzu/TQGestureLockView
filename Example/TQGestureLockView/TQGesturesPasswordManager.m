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
        [self reset];
    }
    return self;
}

- (void)reset {
    _firstPassword = nil;
    _hasFirstPassword = NO;
}

- (void)setFirstPassword:(NSString *)firstPassword {
    if (!firstPassword || !firstPassword.length) {
        [self reset];
    } else {
        _firstPassword = firstPassword;
        _hasFirstPassword = YES;
    }
}

- (void)saveEventuallyPassword:(NSString *)password {
    [self reset];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:TQGesturesPasswordStorageKey];
}

- (NSString *)getEventuallyPassword {
    return [[NSUserDefaults standardUserDefaults] stringForKey:TQGesturesPasswordStorageKey];
}

- (BOOL)verifyPassword:(NSString *)password {
    NSString *eventuallyPassword = [self getEventuallyPassword];
    return [password isEqualToString:eventuallyPassword];
}

@end
