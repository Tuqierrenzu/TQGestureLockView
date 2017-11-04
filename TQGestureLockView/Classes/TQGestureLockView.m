//
//  TQGestureLockView.m
//  <https://github.com/Tuqierrenzu/TQGestureLockView>
//
//  Created by TQTeam on 2017/11/2.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import "TQGestureLockView.h"

@interface TQGestureCircle : NSObject

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat arrowRadian; // The arrow direction (radian)
@property (nonatomic, assign) BOOL shouldDrawArrow;
@property (nonatomic, assign) NSInteger securityCode;

@end

@implementation TQGestureCircle

@end

// The style of the various states
typedef NS_ENUM(NSInteger, TQGestureLockState) {
    TQGestureLockStateNormal = 0,
    TQGestureLockStateSelected,
    TQGestureLockStateError
};

bool TQCircleContainsPoint(CGPoint center, CGFloat radius, CGPoint point) {
    double dx = fabs(point.x - center.x);
    double dy = fabs(point.y - center.y);
    double dis = hypot(dx, dy);
    return dis <= radius;
}

CGPoint TQMidpointTwoPoints(CGPoint point1, CGPoint point2) {
    CGFloat px = fmax(point1.x, point2.x) + fmin(point1.x, point2.x);
    CGFloat py = fmax(point1.y, point2.y) + fmin(point1.y, point2.y);
    return CGPointMake(px / 2, py / 2);
}

void TQDispatch_after(NSTimeInterval time, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

@interface TQGestureLockView () {
    dispatch_semaphore_t _semaphore;
}
@property (nonatomic, readonly, copy) NSArray<TQGestureCircle *> *subCircles;
@property (nonatomic, strong) NSMutableArray<TQGestureCircle *> *selectedCircles;
@property (nonatomic, assign) CGPoint panCurrentPoint; // This point is not in the circle
@property (nonatomic, assign) TQGestureLockState gestureLockState;

@end

@implementation TQGestureLockView

- (instancetype)initWithFrame:(CGRect)frame drawManager:(TQGestureLockDrawManager *)drawManager {
    if (self = [super initWithFrame:CGRectIntegral(frame)]) {
        self.backgroundColor = [UIColor whiteColor];
        _semaphore = dispatch_semaphore_create(1);
        _drawManager = drawManager;
        self.selectedCircles = [[NSMutableArray alloc] init];
        self.panCurrentPoint = CGPointZero;
        [self prepareOriginalData];
    }
    return self;
}

- (void)prepareOriginalData {
    CGFloat diameter = self.drawManager.circleDiameter;
    NSInteger rowCount = self.drawManager.numberOfRow;
    UIEdgeInsets insets = self.drawManager.edgeSpacingInsets;
    CGRect rect = self.frame;
    CGFloat spx = (rect.size.width - insets.left - insets.right - diameter * rowCount) / (rowCount - 1);
    CGFloat spy = (rect.size.height - insets.top - insets.bottom - diameter * rowCount) / (rowCount - 1);
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.drawManager.subCirclesCount; i++) {
        TQGestureCircle *circle = [[TQGestureCircle alloc] init];
        circle.securityCode = i + 1;
        circle.radius = diameter * 0.5;
        circle.shouldDrawArrow = NO;
        CGFloat px = (i % rowCount) * (diameter + spx) + insets.left + circle.radius;
        CGFloat py = (i / rowCount) * (diameter + spy) + insets.top + circle.radius;
        circle.center = CGPointMake(px, py);
        [mutableArray addObject:circle];
    }
    _subCircles = mutableArray.copy;
}

- (UIColor *)drawColor {
    switch (self.gestureLockState) {
        case TQGestureLockStateSelected:
            return self.drawManager.drawSelectedColor;
        case TQGestureLockStateError:
            return self.drawManager.drawErrorColor;
        default: // TQGestureLockStateNormal
            return self.drawManager.drawNormalColor;
    }
}

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect {
    CGContextRef ref = UIGraphicsGetCurrentContext();
    if (!self.subCircles.count) return;
    // draw original circle
    [self.subCircles enumerateObjectsUsingBlock:^(TQGestureCircle * _Nonnull circle, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.selectedCircles containsObject:circle]) {
            [self drawHollowCircleWithContextRef:ref circle:circle];
        }
    }];
    
    if (!self.selectedCircles.count) return;
    // draw line
    [self.selectedCircles enumerateObjectsUsingBlock:^(TQGestureCircle * _Nonnull circle, NSUInteger idx, BOOL * _Nonnull stop) {
        if (0 == idx) { // set the start point
            CGContextMoveToPoint(ref, circle.center.x, circle.center.y);
        } else {
            CGContextAddLineToPoint(ref, circle.center.x, circle.center.y);
        }
    }];
    if (!CGPointEqualToPoint(CGPointZero, self.panCurrentPoint) && self.gestureLockState != TQGestureLockStateError) {
        // connected to the panCurrentPoint
        CGContextAddLineToPoint(ref, self.panCurrentPoint.x, self.panCurrentPoint.y);
    }
    CGContextSetLineWidth(ref, self.drawManager.bridgingLineWidth);
    CGContextSetStrokeColorWithColor(ref, [self drawColor].CGColor);
    CGContextStrokePath(ref);
    
    // draw selected info
    [self.selectedCircles enumerateObjectsUsingBlock:^(TQGestureCircle * _Nonnull circle, NSUInteger idx, BOOL * _Nonnull stop) {
        [self drawSelectedCircleWithContextRef:ref circle:circle];
    }];
}

- (void)drawHollowCircleWithContextRef:(CGContextRef)ref circle:(TQGestureCircle *)circle {
    CGContextAddArc(ref, circle.center.x , circle.center.y , circle.radius, 0, 2 * M_PI, 0);
    CGContextSetStrokeColorWithColor(ref, self.drawManager.drawNormalColor.CGColor);
    CGContextSetFillColorWithColor(ref, [[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(ref, self.drawManager.hollowCircleBorderWidth);
    CGContextDrawPath(ref, kCGPathFillStroke);
}

- (void)drawSelectedCircleWithContextRef:(CGContextRef)ref circle:(TQGestureCircle *)circle  {
    // draw selected hollow circle
    CGContextAddArc(ref, circle.center.x , circle.center.y , circle.radius, 0, 2 * M_PI, 0);
    CGContextSetStrokeColorWithColor(ref, [self drawColor].CGColor);
    CGContextSetFillColorWithColor(ref, [[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(ref, self.drawManager.hollowCircleBorderWidth);
    CGContextDrawPath(ref, kCGPathFillStroke);
    
    // draw selected solid circle
    CGContextAddArc(ref, circle.center.x , circle.center.y , circle.radius * self.drawManager.solidCircleFactor, 0, 2 * M_PI, 0);
    CGContextSetFillColorWithColor(ref, [self drawColor].CGColor);
    CGContextFillPath(ref);

    if (!circle.shouldDrawArrow) return;
    // draw arrow
    CGFloat factor1 = 0.8;
    CGFloat factor2 = 0.65;
    CGFloat angleFactor = 0.1;
    CGPoint p1 = CGPointMake(circle.center.x + circle.radius * factor1 * cos (circle.arrowRadian), circle.center.y + circle.radius * factor1 * sin(circle.arrowRadian));
    CGPoint p2 = CGPointMake(circle.center.x + circle.radius * factor2 * cos (circle.arrowRadian + M_PI * angleFactor), circle.center.y + circle.radius * factor2 * sin(circle.arrowRadian + M_PI * angleFactor));
    CGPoint p3 = CGPointMake(circle.center.x + circle.radius * factor2 * cos (circle.arrowRadian - M_PI * angleFactor), circle.center.y + circle.radius * factor2 * sin(circle.arrowRadian - M_PI * angleFactor));
    CGContextMoveToPoint(ref, p1.x, p1.y);
    CGContextAddLineToPoint(ref, p2.x, p2.y);
    CGContextAddLineToPoint(ref, p3.x, p3.y);
    CGContextAddLineToPoint(ref, p1.x, p1.y);
    CGContextSetFillColorWithColor(ref, [self drawColor].CGColor);
    CGContextFillPath(ref);
}

#pragma mark - touches event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self clearDataAndRestart];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if (self.drawManager.ignoreOutsidePoint) {
        if (!CGRectContainsPoint(self.bounds, point)) return;
    }
    for (TQGestureCircle *circle in self.subCircles) {
        if (TQCircleContainsPoint(circle.center, circle.radius, point)) {
            self.gestureLockState = TQGestureLockStateSelected;
            if (![self.selectedCircles containsObject:circle]) {
                if (self.selectedCircles.count >= 1) {
                    TQGestureCircle *frontCircle = [self.selectedCircles lastObject];
                    frontCircle.arrowRadian = atan2((circle.center.y - frontCircle.center.y), (circle.center.x - frontCircle.center.x));
                    frontCircle.shouldDrawArrow = YES;
                }
                [self.selectedCircles addObject:circle];
            }
        } else {
            self.panCurrentPoint = point;
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *securityCodeSting = [self gesturesLockConvertIntoSecurityCode:self.selectedCircles];
    if (!securityCodeSting) return;
    if (self.selectedCircles.count < self.drawManager.securityCodeLeastNumbers) {
        if ([self.delegate respondsToSelector:@selector(gestureLockView:lessErrorSecurityCodeSting:)]) {
            [self.delegate gestureLockView:self lessErrorSecurityCodeSting:securityCodeSting];
        } else {
            [self setNeedsDisplayGestureLockErrorState:YES];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(gestureLockView:finalRightSecurityCodeSting:)]) {
            [self.delegate gestureLockView:self finalRightSecurityCodeSting:securityCodeSting];
        } else {
            [self setNeedsDisplayGestureLockErrorState:NO];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self clearDataAndRestart];
    [self setNeedsDisplay];
}

- (NSString *)gesturesLockConvertIntoSecurityCode:(NSArray<TQGestureCircle *> *)circles {
    if (!circles.count) return nil;
    NSMutableString *securityCodeString = [[NSMutableString alloc] init];
    for (TQGestureCircle *circle in circles) {
        [securityCodeString appendFormat:@"%lu", (long)circle.securityCode];
    }
    return securityCodeString;
}

- (void)clearDataAndRestart {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    _subCircles = nil;
    [self.selectedCircles removeAllObjects];
    [self prepareOriginalData];
    dispatch_semaphore_signal(_semaphore);
}

- (void)setNeedsDisplayGestureLockErrorState:(BOOL)isNeedsDisplay {
    if (isNeedsDisplay) {
        self.gestureLockState = TQGestureLockStateError;
        TQDispatch_after(self.drawManager.errorTimeInterval, ^{
            // delay after call, the gestureLockState maybe changed (for example `touches began again`), so need to judgement again.
            if (self.gestureLockState == TQGestureLockStateError) {
                [self clearDataAndRestart];
                [self setNeedsDisplay];
            }
        });
    } else {
        self.gestureLockState = TQGestureLockStateNormal;
        [self clearDataAndRestart];
    }
    [self setNeedsDisplay];
}

@end
