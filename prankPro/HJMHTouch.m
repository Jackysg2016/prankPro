//
//  HJTouch.m
//  2Clip
//
//  Created by mac on 15/12/11.
//  Copyright © 2015年 huijimuhe. All rights reserved.
//

#import "HJMHTouch.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation HJMHTouch

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.enabled) {
        self.state = UIGestureRecognizerStateBegan;
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.enabled) {
        self.state = UIGestureRecognizerStateEnded;
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.enabled) {
        self.state = UIGestureRecognizerStateEnded;
    }
}

@end
