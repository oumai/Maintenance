//
//  KMMHomeViewController.m
//  Maintenance
//
//  Created by kmcompany on 2017/5/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMHomeViewController.h"
#import "DLTabedSlideView.h"

#import "KMMAllClassViewController.h"
#import "KMMClassSearchController.h"

#import "KMMUpLoadListController.h"

@interface KMMHomeViewController ()<DLTabedSlideViewDelegate>

@property (nonatomic,strong) DLTabedSlideView *topSlideView;

@end

@implementation KMMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
}

- (void)pageLayout {
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeControllerPage) name:@"STARTUPLOAD" object:nil];
    
    self.title = @"课程管理";
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"tab-search"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    [self.view addSubview:self.topSlideView];

}

- (void)changeControllerPage {

    if (_topSlideView.selectedIndex != 4) {
        _topSlideView.selectedIndex = 4;
    }
}

- (void)searchAction {

    KMMClassSearchController *searchVC = [[KMMClassSearchController alloc]init];
    searchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

#pragma mark - DLTabedSlideViewDelegate
- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    
    return 5;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            KMMAllClassViewController *collectionListVC = [[KMMAllClassViewController alloc] init];
            collectionListVC.auditing = @"-1";
            return collectionListVC;
        }
        case 1:
        {
            KMMAllClassViewController *collectionListVC = [[KMMAllClassViewController alloc] init];
            collectionListVC.auditing = @"2";
            return collectionListVC;
        }
        case 2:
        {
            KMMAllClassViewController *collectionListVC = [[KMMAllClassViewController alloc] init];
            collectionListVC.auditing = @"1";
            return collectionListVC;
        }
        case 3:
        {
            KMMAllClassViewController *collectionListVC = [[KMMAllClassViewController alloc] init];
            collectionListVC.auditing = @"0";
            return collectionListVC;
        }
        case 4:
        {
            KMMUpLoadListController *collectionListVC = [KMMUpLoadListController defaultMainVideoVC];
            return collectionListVC;
        }
            
        default:
            return nil;
    }
}

- (void)DLTabedSlideView:(DLTabedSlideView *)sender didSelectedAt:(NSInteger)index {
    _topSlideView.selectedIndex = index;
}

#pragma mark - setter && getter

- (DLTabedSlideView *)topSlideView {
    if (!_topSlideView) {
        _topSlideView = [[DLTabedSlideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _topSlideView.delegate = self;
        _topSlideView.baseViewController = self;
        _topSlideView.tabItemNormalColor = UIColorFromHEX(0x333333, 1);
        _topSlideView.tabItemSelectedColor = BASE_COLOR;
        _topSlideView.backgroundColor = [UIColor whiteColor];
        _topSlideView.tabbarTrackColor = BASE_COLOR;
        _topSlideView.tabbarBottomSpacing = 0.0;
        DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"全部" image:nil selectedImage:nil];
        DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"已发布" image:nil selectedImage:nil];
        DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"审核中" image:nil selectedImage:nil];
        DLTabedbarItem *item4 = [DLTabedbarItem itemWithTitle:@"草稿箱" image:nil selectedImage:nil];
        DLTabedbarItem *item5 = [DLTabedbarItem itemWithTitle:@"上传中" image:nil selectedImage:nil];
        _topSlideView.tabbarBottomWidth = SCREEN_WIDTH/5 - 20;
        _topSlideView.tabbarItems = @[item1, item2, item3, item4, item5];
        [_topSlideView buildTabbar];
        _topSlideView.selectedIndex = 0;
        
        for (int i=0; i<5; i++) {
            UIView *verLineView = [[UIView alloc]initWithFrame:CGRectMake(i*(SCREEN_WIDTH/5)+SCREEN_WIDTH/5, 7.5, 1, 30)];
            verLineView.backgroundColor = BASE_BACKGROUND_COLOR;
            [_topSlideView addSubview:verLineView];
        }
    }
    return _topSlideView;
}

@end
