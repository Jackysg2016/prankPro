//
//  HJMHDetailTableVC.m
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHDetailTableVC.h"

@implementation HJMHDetailTableVC

-(id)initWithVideo:(Video *)video{
    if(self=[super init]){
        self.video=video;
    }
    return self;
}

-(void)viewDidLoad{
    self.data=[NSMutableArray arrayWithCapacity:10];
    [self.video incrementKey:@"play_count"];
    [self.video saveInBackground];
    
    [self initTable];
    [self initNav];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadNewData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.header playerDestory];
    self.header=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma inition
-(void)initNav{
    //透明
    //[self.navigationController.navigationBar hjmh_setTransparent];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handleMoreClick)];
    
}

-(void)initTable{
    [self.tableView registerClass:[HJMHCommentTableViewCell class] forCellReuseIdentifier:@"cCell"];
    self.tableView.backgroundColor=[UIColor whiteColor];
      
    // 上拉刷新
    self.tableView.mj_footer =[HJMHUtility myRefreshFoot:^{
        [self loadOldData];
    }];
    
    //添加头
    [self.tableView setTableHeaderView:self.header];
    //添加评论
    self.commentTextField = self.footer.commentField;
    self.commentTextField.delegate = self;
    [self.tableView setTableFooterView:self.footer];
    //注册通知
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView* group=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];

    UIView* sub1=[[UIView alloc]initWithFrame:CGRectMake(group.bounds.origin.x+5, group.bounds.origin.y, 5, 20)];
    sub1.backgroundColor=[UIColor redColor];
    [group addSubview:sub1];
    
    UILabel* text=[[UILabel alloc]initWithFrame:CGRectMake(group.bounds.origin.x+20, group.bounds.origin.y, 10, 20)];
    text.text=@"Comments";
    [text sizeToFit];
    [group addSubview:text];

    return group;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.protoCell==nil)
    {
        self.protoCell=[self.tableView dequeueReusableCellWithIdentifier:@"cCell"];
        self.protoCell.avatarImage.image=[UIImage imageNamed:@"avatar"];
        self.protoCell.nameLabel.text=@"a very very very very long dummy name";
    }
    
    Comment* model=self.data[indexPath.row];
    self.protoCell.contentLabel.text=model.text;  
    CGSize s =  [self.protoCell.contentLabel sizeThatFits:CGSizeMake(self.protoCell.contentLabel.frame.size.width, FLT_MAX)];
    CGFloat defaultHeight = self.protoCell.contentView.frame.size.height;
    CGFloat height = s.height > defaultHeight ? s.height : defaultHeight;
    return 1+height+self.protoCell.imageView.frame.size.height+20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HJMHCommentTableViewCell *cell = (HJMHCommentTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"cCell" forIndexPath:indexPath];
    
    Comment* model=self.data[indexPath.row];
    if(model){
        cell.nameLabel.text=model.user.username;
        cell.contentLabel.text =model.text;
        [cell.contentLabel sizeToFit];
        cell.avatarImage.image=[UIImage imageNamed:@"avatar"];
        cell.avatarImage.file=model.user[@"avatar"];
        [cell.avatarImage loadInBackground];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UITextFieldDelegate

- (void)keyboardWillShow:(NSNotification*)note {
    // Scroll the view to the comment text box
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.tableView setContentOffset:CGPointMake(0.0f, self.tableView.contentSize.height-kbSize.height) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSString *trimmedComment = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedComment.length != 0 ) {
        Comment *comment = [[Comment alloc]init];
        comment.text=trimmedComment;
        comment.user=[PFUser currentUser];
        comment.video=self.video;
        
        [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            [self.data addObject:comment];
            [self.tableView reloadData];
        }];
    }
    [textField setText:@""];
    return [textField resignFirstResponder];
}
 
#pragma mark - more handler
-(void) handleMoreClick{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"More"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Report Video"
                                  otherButtonTitles:nil];
    PFUser* curUser=[PFUser currentUser];
    if(curUser){
        NSLog(@"video:%@;cur:%@",self.video.user.objectId,curUser.objectId);
        if([self.video.user.objectId isEqual:[PFUser currentUser].objectId]){
             [actionSheet addButtonWithTitle:@"Delete"];
        }
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0){
        //举报
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Report Video" message:@"Is this video contains improper contents" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];

            Report* report=[[Report alloc]init];
            report.video=self.video;
            report.reporter=[PFUser currentUser];
            [report saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else if(buttonIndex==2){
        //删除
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Do you want to delete this video?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.video deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

#pragma TableView data source

-(void)loadNewData{
    self.mPage=0;
    [self.data removeAllObjects];
    
    PFQuery* query=[Comment query];
    query.skip=10*self.mPage;
    query.limit=10;
    [query includeKey:@"user"];
    [query whereKey:@"video" equalTo:self.video];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [self.data addObjectsFromArray:objects];
//        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        self.mPage++;
    }];
    
}
-(void)loadOldData{
    PFQuery* query=[Comment query];
    query.skip=10*self.mPage;
    query.limit=10; 
    [query includeKey:@"user"];
    [query whereKey:@"video" equalTo:self.video];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [self.data addObjectsFromArray:objects];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        self.mPage++;
    }];
}

#pragma lazy load

-(HJMHDetailHeaderView*) header{
    if(_header==nil){
        _header=[[HJMHDetailHeaderView alloc]initWithVideo:self.video andFrame:CGRectMake(0, 0, kWindowW, kWindowW+80)];
    }
    return _header;
}

-(HJMHDetailFooterView*) footer{
    if(_footer==nil){
        _footer=[[HJMHDetailFooterView alloc]initWithFrame:[HJMHDetailFooterView rectForView]];
    }
    return _footer;
}

-(UIView*) toolbar{
    if(_toolbar==nil) {
        _toolbar=[[UIView alloc]init];
        _toolbar.backgroundColor=[UIColor purpleColor];
    }
    return _toolbar;
}

@end
