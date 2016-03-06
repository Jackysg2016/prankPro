//
//  UINavigationController.m
//  prankPro
//
//  Created by mac on 16/1/26.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "UINavigationBar+Tool.h"

@implementation UINavigationBar(Tool)

static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hjmh_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

-(void)hjmh_setTransparent{
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               [UIFont systemFontOfSize:18],
                                               NSFontAttributeName, nil];
   // [self setTitleTextAttributes:navbarTitleTextAttributes];
    [self setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[self createImageWithColor:[UIColor clearColor]]];
    [self setTintColor:[UIColor whiteColor]];
    [self setTranslucent:YES];
}

-(void)hjmh_setOpaque{
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               [UIFont systemFontOfSize:18],
                                               NSFontAttributeName, nil];
  //  [self setTitleTextAttributes:navbarTitleTextAttributes];
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:nil];
    [self setTintColor:[UIColor whiteColor]];
    [self setTranslucent:NO];
}

-(UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)hjmh_setElementsAlpha:(CGFloat)alpha
{
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
}
@end
