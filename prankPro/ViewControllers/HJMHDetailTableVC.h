//
//  HJMHDetailTableVC.h
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"
#import "HJMHDetailHeaderView.h"
#import "HJMHCommentTableViewCell.h"
#import "HJMHDetailFooterView.h"
#import "Comment.h"
#import "Report.h"

@interface HJMHDetailTableVC : UITableViewController<UIActionSheetDelegate,UITextFieldDelegate>
-(id)initWithVideo:(Video*)video;

@property(nonatomic,strong) Video* video;
@property (nonatomic,strong) NSMutableArray* data;
@property(nonatomic,strong) HJMHDetailHeaderView* header;
@property(nonatomic,strong) UIView* toolbar;
@property (nonatomic,assign) int mPage;
@property(nonatomic,strong)HJMHCommentTableViewCell* protoCell;
@property(nonatomic,strong)HJMHDetailFooterView* footer;
@property (nonatomic, strong) UITextField *commentTextField;
@end
