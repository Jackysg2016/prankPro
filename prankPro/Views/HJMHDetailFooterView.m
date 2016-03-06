//
//  HJMHCommentFooter.m
//  prankPro
//
//  Created by mac on 16/2/7.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHDetailFooterView.h"
#import "Comment.h"

@implementation HJMHDetailFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
       self.mainView = [[UIView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 320.0f, 51.0f)];
        self.mainView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.mainView];
        
        UIImageView *messageIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment.png"]];
        messageIcon.frame = CGRectMake( 20.0f, 15.0f, 22.0f, 22.0f);
        [self.mainView addSubview:messageIcon];
        
        UIImageView *commentBox = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"commentInput.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)]];
        commentBox.frame = CGRectMake(55.0f, 8.0f, 237.0f, 34.0f);
        [self.mainView addSubview:commentBox];
        
        self.commentField = [[UITextField alloc] initWithFrame:CGRectMake( 66.0f, 8.0f, 217.0f, 34.0f)];
        self.commentField.font = [UIFont systemFontOfSize:14.0f];
        self.commentField.placeholder = @"Post a comment";
        self.commentField.returnKeyType = UIReturnKeySend;
        self.commentField.textColor = kMainTextColor;
        self.commentField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.commentField setValue:kSubTextColor forKeyPath:@"_placeholderLabel.textColor"]; // Are we allowed to modify private properties like this? -Héctor
        [self.mainView addSubview:self.commentField];
        }
    return self;
}



#pragma mark - PAPPhotoDetailsFooterView

+ (CGRect)rectForView {
    return CGRectMake( 0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 69.0f);
}

@end
