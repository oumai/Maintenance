//
//  KMMeViewController.m
//  Maintenance
//
//  Created by kmcompany on 2017/5/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMeViewController.h"
#import "KMMSettingController.h"
#import "KMMUserFeedbackController.h"
#import "KMMFillPersonDetailController.h"
//#import "CYTabBarController.h"
#import "KMMTabBarController.h"

//Model
#import "KMMPerson.h"

//Cell
#import "KMMMeCell.h"

@interface KMMeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *meTab;

@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,strong) KMMPerson *personModel;

@end

@implementation KMMeViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.hidden = YES;
     [self.navigationController setNavigationBarHidden:YES animated:NO];
   // [CYTABBARCONTROLLER setCYTabBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
  //  self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self pageLayout];
}

- (void)pageLayout {

    [self.view addSubview:self.meTab];
    
    [HTTPTool requestWithURLString:@"/api/Teacher/Profile" parameters:nil type:kGET success:^(id responseObject) {

        self.personModel = [KMMPerson mj_objectWithKeyValues:responseObject];
        if ([self.personModel.Data.Sex isEqualToString:@"1"]) {
            self.personModel.Data.Sex = @"男";
        }else {
            self.personModel.Data.Sex = @"女";
        }
        self.meTab.tableHeaderView  = [self tableHeaderVeiw];
        [self.meTab reloadData];
    } failure:^(NSError *error) {
        
    }];

}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    KMMMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMMeCell"];
    if (indexPath.row == 0) {
        cell.titleLb.text = @"修改资料";
        cell.iconView.image = [UIImage imageNamed:@"icon-xgzl"];
    }
    if (indexPath.row == 1) {
        cell.titleLb.text = @"意见反馈";
        cell.iconView.image = [UIImage imageNamed:@"icon-yjfk"];
    }
    if (indexPath.row == 2) {
        cell.titleLb.text = @"设置";
        cell.iconView.image = [UIImage imageNamed:@"icon-sz"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (@available(iOS 11.0, *)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateThreeImage" object:nil];
    }
    
    if (indexPath.row == 2) {
        KMMSettingController *settingVC = [[KMMSettingController alloc]init];
        settingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    
    if (indexPath.row == 1) {
        KMMUserFeedbackController *feedVC = [[KMMUserFeedbackController alloc]init];
        feedVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedVC animated:YES];
    }
    
    if (indexPath.row == 0) {
        if (self.personModel) {
            KMMFillPersonDetailController *personDetailVC = [[KMMFillPersonDetailController alloc]init];
            personDetailVC.hidesBottomBarWhenPushed = YES;
            WEAK_SELF(self);
            [personDetailVC setPersonBlock:^(KMMPersonData *personData){
                STRONG_SELF(self);
                self.personModel.Data = personData;
                self.meTab.tableHeaderView = [self tableHeaderVeiw];
            }];
            personDetailVC.personModel = self.personModel.Data;
            [self.navigationController pushViewController:personDetailVC animated:YES];
        }
    }
}



#pragma mark - Lazy Load
- (UITableView *)meTab {

    if (!_meTab) {
        _meTab = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT - 24) style:UITableViewStylePlain];
        _meTab.tableHeaderView = [self tableHeaderVeiw];
        _meTab.delegate = self;
        _meTab.dataSource = self;
        [_meTab registerNib:[UINib nibWithNibName:@"KMMMeCell" bundle:nil] forCellReuseIdentifier:@"KMMMeCell"];
        [_meTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    }
    return _meTab;
}

- (UIView *)tableHeaderVeiw {

    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
    backImageView.image = [UIImage imageNamed:@"img-bj"];
    
    self.iconView = [[UIImageView alloc]init];
    self.iconView.clipsToBounds = YES;
    self.iconView.layer.cornerRadius = 30;
    [backImageView addSubview:self.iconView];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.centerY.equalTo(backImageView);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.personModel.Data.Photo] placeholderImage:[UIImage imageNamed:@"icon-yhtx"]];
    return backImageView;
}

@end
