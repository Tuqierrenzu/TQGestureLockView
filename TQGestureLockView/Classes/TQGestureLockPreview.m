//
//  TQGestureLockPreview.m
//  <https://github.com/Tuqierrenzu/TQGestureLockView>
//
//  Created by TQTeam on 2017/11/2.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import "TQGestureLockPreview.h"

@interface TQGestureLockPreview ()

@property (nonatomic, strong) NSMutableArray<NSString *> *points;
@property (nonatomic, readonly, copy) NSArray<NSString *> *verifySecurityCodeArray;

@end

@implementation TQGestureLockPreview

- (void)defaultValue {
    self.subCirclesCount = 9;
    self.numberOfRow = 3;
    self.edgeSpacingInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.diameter = 7;
    self.borderLineWidth = 1;
    self.borderLineColor = [UIColor grayColor];
    self.selectedFillColor = [UIColor colorWithRed:18/255. green:150/255. blue:219/255. alpha:1.0];
    self.normalFillColor = [UIColor whiteColor];
    self.isNeedsConcatenate = NO;
    self.bridgingLineWidth = 1;
    self.bridgingLineColor = [UIColor colorWithRed:18/255. green:150/255. blue:219/255. alpha:1.0];
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.points = [NSMutableArray array];
        [self defaultValue];
        [self prepareOriginalData];
    }
    return self;
}

- (void)prepareOriginalData {
    [self.points removeAllObjects];
    NSInteger rowCount = self.numberOfRow;
    UIEdgeInsets insets = self.edgeSpacingInsets;
    CGFloat radius = self.diameter * 0.5;
    CGRect rect = self.frame;
    if (CGRectEqualToRect(CGRectZero, rect)) return;
    CGFloat spx = (rect.size.width - insets.left - insets.right - self.diameter * rowCount) / (rowCount - 1);
    CGFloat spy = (rect.size.height - insets.top - insets.bottom - self.diameter * rowCount) / (rowCount - 1);
    for (NSInteger i = 0; i < self.subCirclesCount; i++) {
        CGFloat px = (i % rowCount) * (self.diameter + spx) + insets.left + radius;
        CGFloat py = (i / rowCount) * (self.diameter + spy) + insets.top + radius;
        CGPoint center = CGPointMake(px, py);
        [self.points addObject:NSStringFromCGPoint(center)];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ref = UIGraphicsGetCurrentContext();
    [self.points enumerateObjectsUsingBlock:^(NSString * _Nonnull pointString, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint center = CGPointFromString(pointString);
        CGContextAddArc(ref, center.x , center.y , self.diameter * 0.5, 0, 2 * M_PI, 0);
        NSString *string = [NSString stringWithFormat:@"%lu", (long)(idx + 1)];
        if ([_verifySecurityCodeArray containsObject:string]) {
            CGContextSetStrokeColorWithColor(ref, self.selectedFillColor.CGColor);
            CGContextSetFillColorWithColor(ref, self.selectedFillColor.CGColor);
        } else {
            CGContextSetStrokeColorWithColor(ref, self.borderLineColor.CGColor);
            CGContextSetFillColorWithColor(ref, self.normalFillColor.CGColor);
        }
        CGContextDrawPath(ref, kCGPathFillStroke);
    }];

    if (!_verifySecurityCodeArray ||
        !_verifySecurityCodeArray.count ||
        !self.isNeedsConcatenate) return;

    [_verifySecurityCodeArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *pointString = [self.points objectAtIndex:obj.integerValue - 1];
        CGPoint center = CGPointFromString(pointString);
        if (0 == idx) {
            CGContextMoveToPoint(ref, center.x, center.y);
        } else {
            CGContextAddLineToPoint(ref, center.x, center.y);
        }
    }];
    CGContextSetLineWidth(ref, self.bridgingLineWidth);
    CGContextSetStrokeColorWithColor(ref, self.bridgingLineColor.CGColor);
    CGContextStrokePath(ref);
}

- (void)redraw {
    [self redrawWithVerifySecurityCodeString:nil];
}

- (void)redrawWithVerifySecurityCodeString:(NSString *)verifySecurityCodeString {
    if (verifySecurityCodeString) {
        NSAssert1([self isPureNumbers:verifySecurityCodeString],
                  @"**  The security code is invalid. : %@ **", verifySecurityCodeString);
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < verifySecurityCodeString.length; i++) {
        NSString *s = [verifySecurityCodeString substringWithRange:NSMakeRange(i, 1)];
        [array addObject:s];
    }
    _verifySecurityCodeArray = array.copy;
    [self prepareOriginalData];
    [self setNeedsDisplay];
}

- (BOOL)isPureNumbers:(NSString*)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    NSInteger val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}

@end
