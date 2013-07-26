//
//  NSFerret.m
//  DeadRatGames
//
//  Created by Christopher Larsen on 2013-07-13.
//  Copyright (c) 2013 DeadRatGames All rights reserved.


#import "NSFerret.h"
#import <QuartzCore/QuartzCore.h>

#define ENABLE_FERRET            YES
#define LONG_PRESS_TIMER_FERRET  (6.7337738f)
#define LAUNCH_TIMEOUT           (1.0f)
#define STATUS_BAR_HEIGHT        (20.0f)
#define TAG_NSFERRET             67337738

@class StrutsAndBarsView;

@interface NSFerret ()

@property (nonatomic) UIWindow* windowApplication;
@property (nonatomic) UIView* viewApplication;
@property (nonatomic) UIView* viewFerret;
@property (nonatomic) UIView* viewSelected;
@property (nonatomic) UIView* viewReflection;
@property (nonatomic) UIView* viewControls;
@property (nonatomic) StrutsAndBarsView* strutsAndBarsView;
@property (nonatomic) UILabel* labelFerret;
@property (nonatomic) UIButton* buttonSuperview;
@property (nonatomic) UIButton* buttonPrevSibling;
@property (nonatomic) UIButton* buttonNextSibling;
@property (nonatomic) UIButton* buttonSubviews;
@property (nonatomic) UILabel* labelNumberOfSiblings;
@property (nonatomic) UILabel* labelClass;
@property (nonatomic) UILabel* labelFrame;
@property (nonatomic) UILabel* labelTag;
@property (nonatomic) UILabel* labelAutoresizing;
@property (nonatomic) UILabel* labelAlpha;
@property (nonatomic) UILabel* labelHidden;
@property (nonatomic) UILabel* labelColor;
@property (nonatomic) UILabel* labelNotes;
@property (nonatomic) UIPanGestureRecognizer* pan;
@property float borderWidth;
@property float glass;

@end

@interface StrutsAndBarsView : UIView
@property (weak) UIView* viewSelected;
@end


@implementation NSFerret

+ (void)load
{
#ifdef DEBUG
    if (ENABLE_FERRET) {
        [self performSelector:@selector(enableFerretWithLongPress) withObject:nil afterDelay:LAUNCH_TIMEOUT];
    }
#endif
}

+ (NSFerret*)ferret
{
    static NSFerret *ferret = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIView* viewApplicationRoot = [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0];
        ferret = [[NSFerret alloc] initWithFrame: [viewApplicationRoot bounds]];
    });
    [ferret attachFerretToApplicationWindow];
    return ferret;
}

+ (void)enableFerretWithLongPress
{
    UIView* keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (keyWindow) {
        UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(ferret)];
        [longPressGestureRecognizer setMinimumPressDuration: LONG_PRESS_TIMER_FERRET];
        [keyWindow addGestureRecognizer: longPressGestureRecognizer];
    }
}

+ (UIFont*)font
{
    static UIFont* font = nil;
    if (font == nil) font = [UIFont fontWithName:@"CourierNewPSMT" size:12.0f];
    return font;
}

+ (UIFont*)fontBold
{
    static UIFont* font = nil;
    if (font == nil) font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:12.0f];
    return font;
}

#pragma mark - NSFerret Instance

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tag = TAG_NSFERRET;
        
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.borderWidth = [UIScreen mainScreen].scale == 2.0f ? 0.5f : 1.0f;
        
        CGRect rectPortrait  = CGRectMake(self.bounds.size.width/2.0f-300.0f/2.0f, 30.0f, 300.0f, 380.0f);
        CGRect rectLandscape = CGRectMake(self.bounds.size.width/2.0f-460.0f/2.0f, 30.0f, 460.0f, 260.0f);
        
        CGRect frameForFerretView = [self isLandscape] ? rectLandscape : rectPortrait;
        
        NSLog(@"frame %@", NSStringFromCGRect(frameForFerretView));
        
        self.viewFerret = [[UIView alloc] initWithFrame: frameForFerretView];
        self.viewFerret.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        self.viewFerret.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.viewFerret.layer.borderWidth = self.borderWidth;
        self.viewFerret.layer.cornerRadius = 8.0f;
        [self addSubview: self.viewFerret];
        
        self.strutsAndBarsView = [[StrutsAndBarsView alloc] initWithFrame: CGRectMake(12.0f, 73.0f, 40.0f, 40.0f)];
        self.strutsAndBarsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self.viewFerret addSubview: self.strutsAndBarsView];
        
        UIButton* buttonGlass = [[UIButton alloc] initWithFrame:CGRectMake(self.viewFerret.bounds.size.width-125.0f, 10.0f, 50.0f, 50.0f)];
        [self styleFerretButton:buttonGlass];
        [buttonGlass setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [buttonGlass setTitle:@"Glass" forState:UIControlStateNormal];
        [buttonGlass addTarget:self action:@selector(selectGlass) forControlEvents:UIControlEventTouchUpInside];
        [self.viewFerret addSubview: buttonGlass];
        
        UIButton* buttonClose = [[UIButton alloc] initWithFrame:CGRectMake(self.viewFerret.bounds.size.width-60.0f, 10.0f, 50.0f, 50.0f)];
        [self styleFerretButton:buttonClose];
        [buttonClose setTitle:@"Shoo" forState:UIControlStateNormal];
        [buttonClose addTarget:self action:@selector(selectClose) forControlEvents:UIControlEventTouchUpInside];
        [self.viewFerret addSubview: buttonClose];
        
        UILabel* labelFerretASCII = [[UILabel alloc] initWithFrame: CGRectMake(5.0f, 5.0f, self.viewFerret.bounds.size.width-10.0f, 60.0f)];
        [labelFerretASCII setNumberOfLines:0];
        [labelFerretASCII setLineBreakMode:NSLineBreakByCharWrapping];
        [labelFerretASCII setFont: [UIFont fontWithName:@"CourierNewPS-BoldMT" size:9]];
        [labelFerretASCII setText: @"    _____          (\\=-,\n    \\ ==.`--.______/ /\"\n     `-._.--(====== /\n             \\\\---\\\\ \n              ^^   ^^\n"];
        [labelFerretASCII setTextColor:[UIColor whiteColor]];
        [labelFerretASCII setBackgroundColor: [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1]];
        labelFerretASCII.layer.cornerRadius = 4.0f;
        labelFerretASCII.layer.borderWidth = self.borderWidth;
        labelFerretASCII.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.viewFerret addSubview: labelFerretASCII];
        
        UILabel* labelFerret = [[UILabel alloc] initWithFrame: CGRectMake(10.0f, 50.0f, 80.0f, 12.0f)];
        [self styleFerretLabel: labelFerret];
        [labelFerret setText: @"NSFerret"];
        [self.viewFerret addSubview: labelFerret];
        
        UILabel* labelTitleClass= [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 100, 15)];
        [self styleFerretLabel: labelTitleClass];
        [labelTitleClass setText:@"Class:"];
        [labelTitleClass setTextAlignment: UITextAlignmentRight];
        [self.viewFerret addSubview:labelTitleClass];
        
        self.labelClass = [[UILabel alloc] initWithFrame:CGRectMake(105, 70, 280, 15)];
        [self styleFerretLabel: self.labelClass];
        [self.viewFerret addSubview:self.labelClass];
        
        UILabel* labelTitleFrame = [[UILabel alloc] initWithFrame:CGRectMake(5, self.labelClass.frame.origin.y+15, 100, 15)];
        [self styleFerretLabel: labelTitleFrame];
        [labelTitleFrame setText:@"Frame:"];
        [labelTitleFrame setTextAlignment: UITextAlignmentRight];
        [self.viewFerret addSubview:labelTitleFrame];
        
        self.labelFrame = [[UILabel alloc] initWithFrame:CGRectMake(105, self.labelClass.frame.origin.y+15, 215, 15)];
        [self styleFerretLabel: self.labelFrame];
        [self.viewFerret addSubview:self.labelFrame];
        
        UILabel* labelTitleTag = [[UILabel alloc] initWithFrame:CGRectMake(5, self.labelFrame.frame.origin.y+15, 100, 15)];
        [self styleFerretLabel: labelTitleTag];
        [labelTitleTag setText:@"Tag:"];
        [labelTitleTag setTextAlignment: UITextAlignmentRight];
        [self.viewFerret addSubview:labelTitleTag];
        
        self.labelTag = [[UILabel alloc] initWithFrame:CGRectMake(105, self.labelFrame.frame.origin.y+15, 170, 15)];
        [self styleFerretLabel: self.labelTag];
        [self.viewFerret addSubview:self.labelTag];
        
        UILabel* labelTitleAutoresizing = [[UILabel alloc] initWithFrame:CGRectMake(5, self.labelTag.frame.origin.y+15, 100, 15)];
        [self styleFerretLabel: labelTitleAutoresizing];
        [labelTitleAutoresizing setText:@"Autoresizing:"];
        [labelTitleAutoresizing setTextAlignment: UITextAlignmentRight];
        [self.viewFerret addSubview:labelTitleAutoresizing];
        
        self.labelAutoresizing = [[UILabel alloc] initWithFrame:CGRectMake(105, self.labelTag.frame.origin.y+15, 280, 15)];
        [self styleFerretLabel: self.labelAutoresizing];
        [self.viewFerret addSubview:self.labelAutoresizing];
        
        UILabel* labelTitleAlpha = [[UILabel alloc] initWithFrame:CGRectMake(5, self.labelAutoresizing.frame.origin.y+15, 100, 15)];
        [self styleFerretLabel: labelTitleAlpha];
        [labelTitleAlpha setText:@"Alpha:"];
        [labelTitleAlpha setTextAlignment: UITextAlignmentRight];
        [self.viewFerret addSubview:labelTitleAlpha];
        
        self.labelAlpha = [[UILabel alloc] initWithFrame:CGRectMake(105, self.labelAutoresizing.frame.origin.y+15, 280, 15)];
        [self styleFerretLabel: self.labelAlpha];
        [self.viewFerret addSubview:self.labelAlpha];
        
        UILabel* labelTitleHidden = [[UILabel alloc] initWithFrame:CGRectMake(5, self.labelAlpha.frame.origin.y+15, 100, 15)];
        [self styleFerretLabel: labelTitleHidden];
        [labelTitleHidden setText:@"Hidden:"];
        [labelTitleHidden setTextAlignment: UITextAlignmentRight];
        [self.viewFerret addSubview:labelTitleHidden];
        
        self.labelHidden = [[UILabel alloc] initWithFrame:CGRectMake(105, self.labelAlpha.frame.origin.y+15, 280, 15)];
        [self styleFerretLabel: self.labelHidden];
        [self.viewFerret addSubview:self.labelHidden];
        
        self.labelColor = [[UILabel alloc] initWithFrame:CGRectMake(25, self.labelHidden.frame.origin.y+15, 230, 15)];
        [self styleFerretLabel: self.labelColor];
        [self.labelColor setText:@"Hidden:  NO"];
        [self.labelColor setTextAlignment: UITextAlignmentCenter];
        [self.viewFerret addSubview:self.labelColor];
        
        self.labelNotes = [[UILabel alloc] initWithFrame:CGRectMake(5, self.labelColor.frame.origin.y+15, 280, 75)];
        [self styleFerretLabel: self.labelNotes];
        [self.labelNotes setTextAlignment: UITextAlignmentLeft];
        [self.labelNotes setNumberOfLines:0];
        [self.labelNotes setLineBreakMode: UILineBreakModeWordWrap];
        [self.viewFerret addSubview:self.labelNotes];
        
        self.viewControls = [[UIView alloc] initWithFrame:CGRectMake(10, 250, 280, 124)];
        self.viewControls.backgroundColor = [UIColor clearColor];
        self.viewControls.autoresizesSubviews = YES;
        [self.viewFerret addSubview: self.viewControls];
        
        self.buttonSuperview = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 280, 40)];
        [self styleFerretButton:self.buttonSuperview];
        [self.buttonSuperview setTitle:@"Superview" forState:UIControlStateNormal];
        [self.buttonSuperview addTarget:self action:@selector(selectSuperview) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonSuperview setAutoresizingMask: UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
        [self.viewControls addSubview: self.buttonSuperview];
        
        self.buttonPrevSibling = [[UIButton alloc] initWithFrame: CGRectMake(0, 42, 80, 40)];
        [self styleFerretButton:self.buttonPrevSibling];
        [self.buttonPrevSibling setTitle:@"Prev" forState:UIControlStateNormal];
        [self.buttonPrevSibling addTarget:self action:@selector(selectPrevSibling) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonPrevSibling setAutoresizingMask: UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin];
        [self.viewControls addSubview: self.buttonPrevSibling];
        
        self.labelNumberOfSiblings = [[UILabel alloc] initWithFrame:CGRectMake(85, 42, 110, 40)];
        [self.labelNumberOfSiblings setFont:[NSFerret fontBold]];
        [self.labelNumberOfSiblings setBackgroundColor: [UIColor clearColor]];
        [self.labelNumberOfSiblings setTextColor:[UIColor whiteColor]];
        [self.labelNumberOfSiblings setTextAlignment: UITextAlignmentCenter];
        [self.labelNumberOfSiblings setAutoresizingMask: UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        [self.labelNumberOfSiblings setNumberOfLines:0];
        [self.viewControls addSubview:self.labelNumberOfSiblings];
        
        self.buttonNextSibling = [[UIButton alloc] initWithFrame: CGRectMake(200, 42, 80, 40)];
        [self styleFerretButton:self.buttonNextSibling];
        [self.buttonNextSibling setTitle:@"Next" forState:UIControlStateNormal];
        [self.buttonNextSibling addTarget:self action:@selector(selectNextSibling) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonNextSibling setAutoresizingMask: UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin];
        [self.viewControls addSubview: self.buttonNextSibling];
        
        self.buttonSubviews = [[UIButton alloc] initWithFrame: CGRectMake(0, 84, 280, 40)];
        [self styleFerretButton: self.buttonSubviews];
        [self.buttonSubviews setTitle:@"Subviews" forState:UIControlStateNormal];
        [self.buttonSubviews addTarget:self action:@selector(selectSubviews) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonSubviews setAutoresizingMask: UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
        [self.viewControls addSubview: self.buttonSubviews];
        
        if ([self isLandscape]) self.viewControls.frame = CGRectMake(275,70,180,180);
        
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(selectDidPan:)];
        [self addGestureRecognizer: self.pan];
        
    }
    return self;
}

- (void)attachFerretToApplicationWindow
{
    [self removeFromSuperview];
    
    UIWindow* windowApplication = [[UIApplication sharedApplication] keyWindow];
    if (windowApplication) {
        self.windowApplication = windowApplication;
        self.viewApplication = [[windowApplication subviews] objectAtIndex:0];
        [self setFrame: self.viewApplication.bounds];
        [self.viewApplication addSubview: self];
        [self setSelectedView: self.viewApplication];
    }
}

- (void)setSelectedView:(UIView*)view
{
    if (view) {
        self.viewSelected = view;
        self.strutsAndBarsView.viewSelected = view;
        [self.strutsAndBarsView setNeedsDisplay];
        [self updateFerretView];
    }
}

- (void)updateFerretView
{
    [self createReflectionOfSelectedView];
    
    [self.labelClass setText:[NSString stringWithFormat:@" %@", NSStringFromClass([self.viewSelected class])]];
    
    [self.labelFrame setText:[NSString stringWithFormat:@"% 0.1f %0.1f %0.1f %0.1f", self.viewSelected.frame.origin.x, self.viewSelected.frame.origin.y, self.viewSelected.frame.size.width, self.viewSelected.frame.size.height]];
    
    [self.labelTag setText:[NSString stringWithFormat:@" %d", self.viewSelected.tag]];
    
    [self.labelAlpha setText:[NSString stringWithFormat:@" %0.2f", self.viewSelected.alpha]];
    [self.labelAlpha setTextColor: (self.viewSelected.alpha == 0.0f) ? [UIColor redColor] : [UIColor whiteColor]];
    
    [self.labelHidden setText:[NSString stringWithFormat:@" %@", self.viewSelected.hidden ? @"YES" : @"NO"]];
    [self.labelHidden setTextColor: self.viewSelected.hidden ? [UIColor redColor] : [UIColor whiteColor] ];
    
    NSMutableString* autoresizing = [[NSMutableString alloc] initWithString:@""];
    if (self.viewSelected.autoresizingMask == UIViewAutoresizingNone) [autoresizing appendString:@"None"];
    if (self.viewSelected.autoresizingMask & UIViewAutoresizingFlexibleWidth) [autoresizing appendString:@"FW "];
    if (self.viewSelected.autoresizingMask & UIViewAutoresizingFlexibleHeight) [autoresizing appendString:@"FH "];
    if (self.viewSelected.autoresizingMask & UIViewAutoresizingFlexibleTopMargin) [autoresizing appendString:@"FT "];
    if (self.viewSelected.autoresizingMask & UIViewAutoresizingFlexibleRightMargin) [autoresizing appendString:@"FR "];
    if (self.viewSelected.autoresizingMask & UIViewAutoresizingFlexibleLeftMargin) [autoresizing appendString:@"FL "];
    if (self.viewSelected.autoresizingMask & UIViewAutoresizingFlexibleBottomMargin) [autoresizing appendString:@"FB "];
    [self.labelAutoresizing setText:[NSString stringWithFormat:@" %@", autoresizing]];
    
    NSMutableString* color = [[NSMutableString alloc] initWithString:@""];
    if (self.viewSelected.backgroundColor == nil) {
        [color appendString:[NSString stringWithFormat:@"bg: Default (clearColor)"]];
    } else if (self.viewSelected.backgroundColor == [UIColor clearColor]) {
        [color appendString:@"bg: [UIColor clearColor]"];
    } else if (self.viewSelected.backgroundColor == [UIColor blackColor]) {
        [color appendString:@"bg: [UIColor blackColor]"];
    } else if (self.viewSelected.backgroundColor == [UIColor whiteColor]) {
        [color appendString:@"bg: [UIColor whiteColor]"];
    } else {
        CGFloat r,g,b,a;
        if ([self.viewSelected.backgroundColor getRed:&r green:&g blue:&b alpha:&a]) {
            [color appendString:[NSString stringWithFormat:@"r:%0.2f g:%0.2f b:%0.2f a:%0.2f", r, g, b, a]];
        }
    }
    [self.labelColor setText: color];
    
    NSMutableString* notes = [[NSMutableString alloc] initWithString:@""];
    if (self.viewSelected == self) [notes appendString:@"* This is the NSFerret View. Move along. Nothing to see here.\n"];
    if (self.viewSelected == self.viewApplication) [notes appendString:@"* This is the Application Root View\n"];
    if (self.viewSelected.userInteractionEnabled == NO) [notes appendString:@"* User Interaction Disabled\n"];
    if (self.viewSelected.autoresizesSubviews == NO) [notes appendString:@"* Autoresize Subviews Disabled\n"];
    if (self.viewSelected != self.viewApplication && self.viewSelected != self) {
        if ([self isSelectedViewIsOffScreen]) {
            [notes appendString:@"* This view is off screen\n"];
        } else if ([self isSelectedViewIsPartiallyOffScreen]) {
            [notes appendString:@"* This view partially off screen\n"];
        }
    }
    if (self.viewSelected.clipsToBounds == YES) [notes appendString:@"* Subviews Clipped to Bounds\n"];
    if ([self.viewSelected.class isSubclassOfClass:UIImageView.class]) {
        if (self.viewSelected.contentMode == UIViewContentModeScaleAspectFill) [notes appendString:@"* CM: Aspect Fill\n"];
        if (self.viewSelected.contentMode == UIViewContentModeScaleAspectFit) [notes appendString:@"* CM: Aspect Fit\n"];
        if (self.viewSelected.contentMode == UIViewContentModeScaleToFill) [notes appendString:@"* CM: Scale to Fill\n"];
    }
    
    if (CGAffineTransformEqualToTransform(self.viewSelected.transform, CGAffineTransformIdentity) == NO) {
        [notes appendString:@"* This view is transformed:\n"];
        [notes appendString: [NSString stringWithFormat:@"tx:%0.2f ty:%0.2f a:%0.2f b:%0.2f c:%0.2f d:%0.2f ",self.viewSelected.transform.tx, self.viewSelected.transform.ty, self.viewSelected.transform.a, self.viewSelected.transform.b, self.viewSelected.transform.c, self.viewSelected.transform.d]];
    }
    
    [self.labelNotes setText: notes];
    
    [self.labelFrame setTextColor:[UIColor whiteColor]];
    if ([self isSelectedViewIsPartiallyOffScreen]) [self.labelFrame setTextColor:[UIColor yellowColor]];
    if ([self isSelectedViewIsOffScreen])[self.labelFrame setTextColor:[UIColor redColor]];
    
    self.buttonSuperview.enabled   = (self.viewSelected != self && self.viewSelected != self.viewApplication);
    self.buttonNextSibling.enabled = ([self nextSibling] != nil);
    self.buttonPrevSibling.enabled = ([self prevSibling] != nil);
    self.buttonSubviews.enabled    = (self.viewSelected != self &&
                                      self.viewSelected.subviews &&
                                      self.viewSelected.subviews.count > 0 &&
                                      [self.viewSelected.subviews objectAtIndex:0] != nil);
    
    CGColorRef colorEnabled  = [UIColor whiteColor].CGColor;
    CGColorRef colorDisabled = [UIColor darkGrayColor].CGColor;
    
    self.buttonSuperview.layer.borderColor   = self.buttonSuperview.enabled   ? colorEnabled : colorDisabled;
    self.buttonNextSibling.layer.borderColor = self.buttonNextSibling.enabled ? colorEnabled : colorDisabled;
    self.buttonPrevSibling.layer.borderColor = self.buttonPrevSibling.enabled ? colorEnabled : colorDisabled;
    self.buttonSubviews.layer.borderColor    = self.buttonSubviews.enabled    ? colorEnabled : colorDisabled;
    
    [self.labelNumberOfSiblings setText: [NSString stringWithFormat:@"Index:%d Views:%d", [self indexOfSelectedView], [self numberOfSiblingViews]]];
    
    [self.buttonSubviews setTitle:[NSString stringWithFormat:@"Subviews (%d)", [self.viewSelected.subviews count]] forState:UIControlStateNormal];
    
}

- (void)createReflectionOfSelectedView
{
    [self.viewReflection removeFromSuperview];
    self.viewReflection = nil;
    
    if (self.viewSelected) {
        CGRect rectReflection = CGRectZero;
        if (self.viewSelected == self.viewApplication) rectReflection = self.bounds;
        else if (self.viewSelected == self) rectReflection = self. bounds;
        else rectReflection = [self rectOfViewConvertedToApplicationViewCoordinates: self.viewSelected];
        self.viewReflection = [[UIView alloc] initWithFrame: rectReflection];
        [self.viewReflection setUserInteractionEnabled: NO];
        self.viewReflection.layer.borderWidth = self.borderWidth;
        self.viewReflection.transform = self.viewSelected.transform;
        [self insertSubview:self.viewReflection belowSubview: self.viewFerret];
        
        UIColor* colorReflectionBackground = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.25];
        UIColor* colorReflectionBorders    = [UIColor colorWithRed:0 green:1 blue:0 alpha:1.00];
        
        if (self.viewSelected != self.viewApplication && self.viewSelected != self) {
            if (CGAffineTransformEqualToTransform(self.viewSelected.transform, CGAffineTransformIdentity) == NO) {
                colorReflectionBackground = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.25];
                colorReflectionBorders    = [UIColor colorWithRed:0 green:0 blue:1 alpha:1.00];
            }
            else if (self.viewSelected.hidden || self.viewSelected.alpha == 0.0) {
                colorReflectionBackground = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.25];
                colorReflectionBorders    = [UIColor colorWithRed:1 green:0 blue:0 alpha:1.00];
            }
            else if ([self isSelectedViewIsPartiallyOffScreen]) {
                colorReflectionBackground = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.25];
                colorReflectionBorders    = [UIColor colorWithRed:1 green:1 blue:0 alpha:1.00];
            }
        }
        
        CGFloat r,g,b,a;
        [colorReflectionBackground getRed:&r green:&g blue:&b alpha:&a];
        UIColor* colorPulse = [UIColor colorWithRed:r green:g blue:b alpha:0.10];
        
        self.viewReflection.backgroundColor = colorReflectionBackground;
        self.viewReflection.layer.borderColor = colorReflectionBorders.CGColor;
        
        [UIView animateWithDuration: 0.75
                              delay: 0
                            options: UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAutoreverse
                         animations: ^{
                             self.viewReflection.backgroundColor = colorPulse;
                         } completion:nil];
    }
}

- (int)indexOfSelectedView
{
    if (self.viewSelected.superview == nil) return 0;
    int indexOfSelectedView = 0;
    for (UIView* view in self.viewSelected.superview.subviews) {
        if (self.viewSelected == view) return indexOfSelectedView;
        indexOfSelectedView++;
    }
    return 0;
}

- (int)numberOfSiblingViews
{
    if (self.viewSelected.superview == nil) return 0;
    return self.viewSelected.superview.subviews.count;
}

- (CGRect)rectOfViewConvertedToApplicationViewCoordinates:(UIView*)viewToConvert
{
    UIView* viewFocus = viewToConvert;
    CGRect rectConverted = viewFocus.frame;
    while (viewFocus != self.viewApplication) {
        viewFocus = viewFocus.superview;
        rectConverted.origin.x = rectConverted.origin.x + viewFocus.frame.origin.x;
        rectConverted.origin.y = rectConverted.origin.y + viewFocus.frame.origin.y;
    };
    if (viewToConvert != self.viewApplication && [self isLandscape] == NO && [[UIApplication sharedApplication] isStatusBarHidden] == NO) rectConverted.origin.y = rectConverted.origin.y - STATUS_BAR_HEIGHT;
    return rectConverted;
}

- (BOOL)isSelectedViewIsOffScreen
{
    CGRect rectConverted = [self rectOfViewConvertedToApplicationViewCoordinates:self.viewSelected];
    if (rectConverted.origin.x > self.viewApplication.bounds.size.width) return YES;
    if (rectConverted.origin.x + rectConverted.size.width < 0) return YES;
    if (rectConverted.origin.y > self.viewApplication.bounds.size.height) return YES;
    if (rectConverted.origin.y + rectConverted.size.height < 0) return YES;
    return NO;
}

- (BOOL)isSelectedViewIsPartiallyOffScreen
{
    CGRect rectConverted = [self rectOfViewConvertedToApplicationViewCoordinates:self.viewSelected];
    if (rectConverted.origin.x < 0) return YES;
    if (rectConverted.origin.x + rectConverted.size.width > self.viewApplication.bounds.size.width) return YES;
    if (rectConverted.origin.y < 0) return YES;
    if (rectConverted.origin.y + rectConverted.size.height > self.viewApplication.bounds.size.height) return YES;
    return NO;
}

- (BOOL)isLandscape
{
    return UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
}

- (UIView*)prevSibling
{
    UIView* viewPrevSibling = nil;
    if (self.viewSelected && self.viewSelected.superview && self.viewSelected.superview.subviews.count > 0) {
        if ([self indexOfSelectedView] > 0) {
            viewPrevSibling = [self.viewSelected.superview.subviews objectAtIndex:[self indexOfSelectedView]-1];
        }
    }
    return viewPrevSibling;
}

- (UIView*)nextSibling
{
    UIView* viewNextSibling = nil;
    if (self.viewSelected && self.viewSelected.superview && self.viewSelected.superview.subviews.count > 0) {
        if ([self indexOfSelectedView] < [self numberOfSiblingViews]-1) {
            viewNextSibling = [self.viewSelected.superview.subviews objectAtIndex:[self indexOfSelectedView]+1];
        }
    }
    return viewNextSibling;
}

#pragma mark - Select

- (void)selectClose
{
    [self removeFromSuperview];
}

- (void)selectGlass
{
    self.glass = self.glass + 0.45f;
    if (self.glass > 1.0f) self.glass = 0.1f;
    self.viewFerret.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.glass];
}

- (void)selectSuperview
{
    [self setSelectedView: self.viewSelected.superview];
}

- (void)selectPrevSibling
{
    [self setSelectedView: [self prevSibling]];
}

- (void)selectNextSibling
{
    [self setSelectedView: [self nextSibling]];
}

- (void)selectSubviews
{
    if (self.viewSelected && self.viewSelected.subviews &&
        self.viewSelected.subviews.count > 0 && [self.viewSelected.subviews objectAtIndex:0] != nil) {
        [self setSelectedView: [self.viewSelected.subviews objectAtIndex:0]];
    }
}

#pragma mark - Pan Gesture Recognizer Delegate

- (void)selectDidPan:(id)recognizer
{
    static CGPoint pointTranslationBegan;
    if (recognizer == self.pan) {
        if (self.pan.state == UIGestureRecognizerStateBegan) {
            pointTranslationBegan = self.viewFerret.frame.origin;
        } else {
            CGPoint pointTranslated = [self.pan translationInView:self.superview];
            self.viewFerret.frame = CGRectMake(pointTranslationBegan.x + pointTranslated.x,
                                               pointTranslationBegan.y + pointTranslated.y,
                                               self.viewFerret.frame.size.width,
                                               self.viewFerret.frame.size.height);
        }
    }
    
}

#pragma mark - Style Factory

- (void)styleFerretLabel:(UILabel*)labelToStyle
{
    [labelToStyle setBackgroundColor: [UIColor clearColor]];
    [labelToStyle setFont: [NSFerret font]];
    [labelToStyle setTextColor: [UIColor whiteColor]];
}

- (void)styleFerretButton:(UIButton*)buttonToStyle
{
    [buttonToStyle setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.05]];
    [buttonToStyle.titleLabel setFont: [NSFerret fontBold]];
    [buttonToStyle setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [buttonToStyle setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    buttonToStyle.layer.cornerRadius = 4.0f;
    buttonToStyle.layer.borderWidth = self.borderWidth;
    buttonToStyle.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

@end



@implementation StrutsAndBarsView

#pragma mark - Draw Rect

- (void)drawRect:(CGRect)rect
{
    CGFloat X = 0.0f;
    CGFloat Y = 0.0f;
    CGFloat U = 10.0f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, X+2*U, Y);
    CGContextAddLineToPoint(context, X+2*U, Y+U);
    if (self.viewSelected.autoresizingMask & UIViewAutoresizingFlexibleTopMargin)
        CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1.0);
    else
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, X, Y+2*U);
    CGContextAddLineToPoint(context, X+U, Y+2*U);
    if (self.viewSelected.autoresizingMask & UIViewAutoresizingFlexibleLeftMargin)
        CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1.0);
    else
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, X+3*U, Y+2*U);
    CGContextAddLineToPoint(context, X+4*U, Y+2*U);
    if (self.viewSelected.autoresizingMask & UIViewAutoresizingFlexibleRightMargin)
        CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1.0);
    else
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, X+2*U, Y+3*U);
    CGContextAddLineToPoint(context, X+2*U, Y+4*U);
    if (self.viewSelected.autoresizingMask & UIViewAutoresizingFlexibleBottomMargin)
        CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1.0);
    else
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, X+U, Y+2*U);
    CGContextAddLineToPoint(context, X+3*U, Y+2*U);
    if (self.viewSelected.autoresizingMask & UIViewAutoresizingFlexibleWidth)
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    else
        CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1.0);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, X+2*U, Y+U);
    CGContextAddLineToPoint(context, X+2*U, Y+3*U);
    if (self.viewSelected.autoresizingMask & UIViewAutoresizingFlexibleHeight)
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    else
        CGContextSetRGBStrokeColor(context, 0.3, 0.3, 0.3, 1.0);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextMoveToPoint(context,    X, Y);
    CGContextAddLineToPoint(context, X+4*U, Y);
    CGContextAddLineToPoint(context, X+4*U, Y+4*U);
    CGContextAddLineToPoint(context, X, Y+4*U);
    CGContextClosePath(context);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);
    CGContextMoveToPoint(context,    X+U, Y+U);
    CGContextAddLineToPoint(context, X+3*U, Y+U);
    CGContextAddLineToPoint(context, X+3*U, Y+3*U);
    CGContextAddLineToPoint(context, X+U, Y+3*U);
    CGContextClosePath(context);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokePath(context);
    
    [super drawRect:rect];
}

@end

