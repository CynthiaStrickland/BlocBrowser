//
//  AwsomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Cynthia Whitlatch on 5/10/15.
//  Copyright (c) 2015 Cynthia Whitlatch. All rights reserved.
//

#import "AwsomeFloatingToolbar.h"


@interface AwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, weak) UILabel *currentButton;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic) CGFloat scale;
@property(nonatomic, retain) UIFont *font;


@end

@implementation AwesomeFloatingToolbar

- (instancetype) initWithFourTitles:(NSArray *)titles {
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super init];
        if (self) {
    
            // Save the titles, and set the 4 colors
            self.currentTitles = titles;
            self.colors = @[
                    [UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                    [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                    [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                    [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
            NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
        
            // Make the 4 labels ******   think I changed them to buttons ******
            for (NSString *currentTitle in self.currentTitles) {
                    UIButton *button = [[UIButton alloc] init];
                    button.userInteractionEnabled = NO;
                    button.alpha = 0.25;
        
                    NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
                    NSString *titleForThisButton = [self.currentTitles objectAtIndex:currentTitleIndex];
                    UIColor *colorForThisButton= [self.colors objectAtIndex:currentTitleIndex];
        
                    //button.textAlignment = NSTextAlignmentCenter;
                    button.font = [UIFont systemFontOfSize:10];
                    //button.text = titleForThisLabel;
                    button.backgroundColor = colorForThisButton;
                    button.tintColor = [UIColor whiteColor];
        
                    [buttonsArray addObject:button];
                }
                self.buttons = buttonsArray;
        
                for (UIButton *thisButton in self.buttons) {
                [self addSubview:thisButton];
           }

            self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
            [self addGestureRecognizer:self.tapGesture];
            
            self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
            [self addGestureRecognizer:self.panGesture];
            
            self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
            [self addGestureRecognizer:self.pinchGesture];
            
            self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
            [self addGestureRecognizer:self.longPress];
            
            
        }
    
    return self;
}

#pragma mark - Tap Gesture

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset {
    CGPoint startingPoint = toolbar.frame.origin;
    CGPoint newPoint = CGPointMake(startingPoint.x + offset.x, startingPoint.y + offset.y);
    
    CGRect potentialNewFrame = CGRectMake(newPoint.x, newPoint.y, CGRectGetWidth(toolbar.frame), CGRectGetHeight(toolbar.frame));
    
        if (CGRectContainsRect(self.view.bounds, potentialNewFrame)) {
        toolbar.frame = potentialNewFrame;
    }
}
// ******** PINCH *********
- (void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat scale = [recognizer scale];
        NSLog(@"pinched: %f", scale);
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didPinchWithScale:)]) {
            [self.delegate floatingToolbar:self didPinchWithScale:scale];
        }
    }
}
// ********  LONG PRESS *********
- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
            NSLog(@"Long Press");
        [self.button addGestureRecognizer:longPress];
        [longPress release];
    }
}
    
// ******** TAP FIRED ***********
- (void) tapFired:(UITapGestureRecognizer *)recognizer {
         if (recognizer.state == UIGestureRecognizerStateRecognized) {
                CGPoint location = [recognizer locationInView:self];
                UIView *tappedView = [self hitTest:location withEvent:nil];
        
                if ([self.labels containsObject:tappedView]) {
                if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
                            [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];
                            }
                    }
            }
    }
// ********* PAN FIRED ********
- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [recognizer translationInView:self];
        
            NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
                [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
            }
        
            [recognizer setTranslation:CGPointZero inView:self];
        }
    }

- (void) layoutSubviews {
    // set the frames for the 4 labels
    
    for (UILabel *thisLabel in self.labels) {
            NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
    
            CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
            CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
            CGFloat labelX = 0;
            CGFloat labelY = 0;
    
            // adjust labelX and labelY for each label
            if (currentLabelIndex < 2) {
                   // 0 or 1, so on top
                   labelY = 0;
                } else {
                        // 2 or 3, so on bottom
                labelY = CGRectGetHeight(self.bounds) / 2;
                    }
        
            if (currentLabelIndex % 2 == 0) { // is currentLabelIndex evenly divisible by 2?
                    // 0 or 2, so on the left
                    labelX = 0;
            } else {
                    // 1 or 3, so on the right
                    labelX = CGRectGetWidth(self.bounds) / 2;
            }
        
            thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
        }
}

#pragma mark - Button Enabling

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];

    if (index != NSNotFound) {
        UILabel *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
    }
}

@end
