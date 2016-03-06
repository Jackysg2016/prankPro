//
//  HJMHIndexCollectionVC.m
//  prankPro
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 huijimuhe. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "HJMHIndexCollectionVC.h"
#import "HJMHIndexCollectionViewCell.h"
#import "HJMHDetailTableVC.h"
#import "Video.h"
#import "HJMHCaptureVC.h"
#import "HJMHProfileVC.h"
#import "HJMHUtility.h"

@interface HJMHIndexCollectionVC()

@end

@implementation HJMHIndexCollectionVC

-(id)init{
    
    //UICollectionLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kWindowW-10)/2, (kWindowW-5)/2);
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    
    return [super initWithCollectionViewLayout:layout];
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initAd];
    [self initNav];
    [self initTable];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.collectionView.mj_header beginRefreshing];
   // [self.navigationController.navigationBar hjmh_setOpaque];
}
-(void)initAd{
    //ad banner
    self.bannerView=[[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    GADRequest* request=[GADRequest request]; 
    [self.bannerView loadRequest:request];
    [self.view addSubview:self.bannerView];
    [self.bannerView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom);
        make.left.equalTo(self.view.left);
    }];
}

-(void)initNav{
    self.navigationItem.title = @"PrankPro";
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"movie"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handleCaptureClick)];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handleProfileClick)];
    
}

-(void)initTable{
    self.data=[NSMutableArray arrayWithCapacity:10];
    self.collectionView.backgroundColor=[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1];

    [self.collectionView registerClass:[HJMHIndexCollectionViewCell class] forCellWithReuseIdentifier:@"mCell"];
    
    // 下拉刷新
    self.collectionView.mj_header =[HJMHUtility myRefreshHead:^{
        [self loadNewData];
    }];
    
    // 上拉刷新
    self.collectionView.mj_footer =[HJMHUtility myRefreshFoot:^{
        [self loadOldData];
    }];
    
}

#pragma uicollectionview
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HJMHIndexCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mCell" forIndexPath:indexPath];
    Video* model= self.data[indexPath.row];
    if(model){
        cell.nameLabel.text=model.user.username;
        cell.likeLabel.text=[NSString stringWithFormat:@"%d",model.like_count];
        cell.avatarImageView.file=model.user[@"avatar"];
        cell.avatarImageView.image=[UIImage imageNamed:@"avatar"];
        [cell.avatarImageView loadInBackground];
        cell.thumbImageView.file=model.thumb;
        [cell.thumbImageView loadInBackground];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self isLogin]){
        HJMHDetailTableVC* vc=[[HJMHDetailTableVC alloc]initWithVideo:self.data[indexPath.row]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma TableView data source

-(void)loadNewData{ 
    self.mPage=0;
    
    PFQuery* query=[Video query];
    query.skip=10*self.mPage;
    query.limit=10;
    query.cachePolicy = kPFCachePolicyIgnoreCache;
    [query includeKey:@"user"];
    [query whereKey:@"isBanned" equalTo:@NO ];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            [self.data removeAllObjects];
            [self.data addObjectsFromArray:objects];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView reloadData];
            self.mPage++;
        }
    }];
    
}
-(void)loadOldData{
    PFQuery* query=[Video query];
    query.skip=10*self.mPage;
    query.limit=10;
    query.cachePolicy = kPFCachePolicyIgnoreCache;
    NSDate* lastData=((Video*)[self.data firstObject]).createdAt;
    [query includeKey:@"user"];
    [query whereKey:@"isBanned" equalTo:@NO ];
    [query whereKey:@"createdAt" lessThanOrEqualTo:lastData];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [self.data addObjectsFromArray:objects];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
        self.mPage++;
    }];
}

#pragma click handler
-(void)handleProfileClick{
    if([self isLogin]){
        HJMHProfileVC* vc=[[HJMHProfileVC alloc]initWithUser:[PFUser currentUser]]; 
        [self.navigationController showViewController:vc sender:nil];
    }
}

-(void)handleCaptureClick{
    HJMHCaptureVC* vc=[[HJMHCaptureVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
   // [self.navigationController presentViewController:vc animated:YES completion:nil];
}
@end
