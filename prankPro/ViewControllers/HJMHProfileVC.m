//
//  HJMHProfileVC.m
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import "HJMHProfileVC.h"

@implementation HJMHProfileVC

-(id)initWithUser:(PFUser*)user{
    
    //UICollectionLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kWindowW-10)/2, (kWindowW-5)/2);
    layout.headerReferenceSize=CGSizeMake(kWindowW,85);
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    //user
    self.user=user;
    return [super initWithCollectionViewLayout:layout];
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initAd];
    [self initTable];
    [self initNav];
    [self.collectionView.mj_header beginRefreshing];
}

-(void)initNav{
    //透明
    //[self.navigationController.navigationBar hjmh_setTransparent];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handleMoreClick)];
    
}

-(void)initAd{
    //ad banner
    self.bannerView=[[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.adUnitID = @"ca-app-pub-1232384027425912/8608130189";
    self.bannerView.rootViewController = self;
    GADRequest* request=[GADRequest request]; 
    [self.bannerView loadRequest:request];
    [self.view addSubview:self.bannerView];
    [self.bannerView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom);
        make.left.equalTo(self.view.left);
    }];
}

-(void)initTable{
    self.data=[NSMutableArray arrayWithCapacity:10];
    self.collectionView.backgroundColor=[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];

    //cell view
    [self.collectionView registerClass:[HJMHProfileCollectionViewCell class] forCellWithReuseIdentifier:@"mCell"];
    //header view
    [self.collectionView registerClass:[HJMHProfileHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mHead"];
    
    // 下拉刷新
    self.collectionView.mj_header =[HJMHUtility myRefreshHead:^{
        [self loadNewData];
    }];
    
    // 上拉刷新
    self.collectionView.mj_footer =[HJMHUtility myRefreshFoot:^{
        [self loadOldData];
    }];
}

#pragma mark - more handler
-(void) handleMoreClick{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"More"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Log Out"
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0){
        [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

#pragma uicollectionview

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HJMHProfileHeaderView *view =nil;
    if(kind==UICollectionElementKindSectionHeader){
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mHead" forIndexPath:indexPath];
        [view setContent:self.user];
    }
    return view;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HJMHProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mCell" forIndexPath:indexPath];
    Video* model= self.data[indexPath.row];
    if(model){
//        cell.nameLabel.text=model.user.username;
//        cell.likeLabel.text=[NSString stringWithFormat:@"%d",model.like_count];
//        cell.avatarImageView.file=model.user[@"avatar"];
//        [cell.avatarImageView loadInBackground];
        cell.thumbImageView.file=model.thumb;
        [cell.thumbImageView loadInBackground];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click %ld",(long)indexPath.row);
    HJMHDetailTableVC* vc=[[HJMHDetailTableVC alloc]initWithVideo:self.data[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma TableView data source

-(void)loadNewData{
    self.mPage=0;
    [self.data removeAllObjects];
    
    PFQuery* query=[Video query];
    query.skip=10*self.mPage;
    query.limit=10;
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:self.user];
    [query whereKey:@"isBanned" equalTo:@NO ];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [self.data addObjectsFromArray:objects];
        for (Video* v in objects) {
            NSLog(@"name:%@",v.name);
        }
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
        self.mPage++;
    }];
    
}
-(void)loadOldData{
    PFQuery* query=[Video query];
    query.skip=10*self.mPage;
    query.limit=10;
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:self.user];
    [query whereKey:@"isBanned" equalTo:@NO ]; 
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [self.data addObjectsFromArray:objects];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
        self.mPage++;
    }];
}

#pragma click handler 

@end
