//
//  KMMAllClassViewController.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMAllClassViewController.h"
#import "KMMEditorViewController.h"
#import "KMMVideoDetailController.h"
#import "KMMPreViewEditorController.h"
#import "KMMCompleteVideoInfoController.h"

//View
#import "KMMClassDefaultView.h"

//model
#import "KMMClassModel.h"

//Cell
#import "KMMClassCell.h"

@interface KMMAllClassViewController ()<UITableViewDelegate,UITableViewDataSource,KMMClassCellDelegate>

@property (nonatomic,strong) UITableView *classTab;

@property (nonatomic,strong) KMMClassModel *classmodel;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) KMMClassDefaultView *defaultView;

@end

@implementation KMMAllClassViewController

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self getClassRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
    
    
}

- (void)pageLayout {

    self.view.backgroundColor = [UIColor whiteColor];
    self.pageIndex = 1;
    self.dataArr = [NSMutableArray array];
    [self.view addSubview:self.classTab];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 107.5;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    KMMClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMClassCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    cell.pathRow = indexPath;
    cell.classDataModel = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ClassData *data  = self.dataArr[indexPath.row];
    
   if (@available(iOS 11.0, *)) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateThreeImage" object:nil];
   }
    
    if ([data.CourseType integerValue]>13) {
        
        KMMVideoDetailController *detailVC = [[KMMVideoDetailController alloc]init];
        detailVC.hidesBottomBarWhenPushed = YES;
        if ([data.Auditing isEqualToString:@"2"]) {
            detailVC.isShow = YES;
        }else {
            detailVC.isShow = NO;
        }
        detailVC.clasModel = data;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else {
    
        if ([data.Auditing isEqualToString:@"2"]) {
            KMMPreViewEditorController *lmVC = [[KMMPreViewEditorController alloc]init];
            lmVC.clasModel = self.dataArr[indexPath.row];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lmVC];
            lmVC.isCanEdit = NO;
            [self.navigationController presentViewController:nav animated:YES completion:nil];

        }else {
            
            KMMEditorViewController *lmVC = [[KMMEditorViewController alloc]init];
            lmVC.clasModel = self.dataArr[indexPath.row];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lmVC];
            
            
            lmVC.isCanEdit = NO;
            
            [self.navigationController presentViewController:nav animated:YES completion:nil];
          }
    
       }
    
}


#pragma mark - KMMClassCellDelegate
#pragma mark - 撤销审核
- (void)KMMClassCellDelegateReverseClass:(NSIndexPath *)pathRow {

    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"撤销审核后课程会进入草稿箱,确定撤销?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [HTTPTool requestWithURLString:@"/api/Course/CommitCourse" parameters:@{@"ID":[self.dataArr[pathRow.row] Id],@"state":@"0"} type:kGET success:^(id responseObject) {
         [self.classTab.mj_header beginRefreshing];
    } failure:^(NSError *error) {
        
       }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 下架
- (void)KMMClassCellDelegateundercarriageClass:(NSIndexPath *)pathRow {

    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"下架后学生将无法看到这条课程,确定下架?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [HTTPTool requestWithURLString:@"/api/Course/CommitCourse" parameters:@{@"ID":[self.dataArr[pathRow.row] Id],@"state":@"4"} type:kGET success:^(id responseObject) {
        [self.classTab.mj_header beginRefreshing];
    } failure:^(NSError *error) {
        
       }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 提交审核、编辑、删除
- (void)KMMClassCellDelegateEditClassWithType:(NSInteger)tag pathRow:(NSIndexPath *)pathRow {
    
    switch (tag) {
        case 0: {
        
            [self saveClassRequest:[self.dataArr[pathRow.row] Id] pathRow:pathRow];
            
        }
            break;
        case 1: {
            
            ClassData *data  = self.dataArr[pathRow.row];
            

            if ([data.CourseType integerValue]>13) {
                
                KMMCompleteVideoInfoController *detailVC = [[KMMCompleteVideoInfoController alloc]init];
                detailVC.hidesBottomBarWhenPushed = YES;
                detailVC.isEdit = YES;
                detailVC.classModel = data;
                [self.navigationController pushViewController:detailVC animated:YES];
                
            }else {
                KMMEditorViewController *lmVC = [[KMMEditorViewController alloc]init];
                lmVC.clasModel = self.dataArr[pathRow.row];
                lmVC.isCanEdit = YES;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lmVC];
                
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }
           
            
        }
            break;
        case 2: {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"删除课程将无法找回\n确定删除？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self delectClassRequest:[self.dataArr[pathRow.row] Id] pathRow:pathRow];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 提交审核
- (void)saveClassRequest:(NSString *)ID pathRow:(NSIndexPath *)pathRow{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"我们将在1至3个工作日内完成审核" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消审核" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HTTPTool requestWithURLString:@"/api/Course/CommitCourse" parameters:@{@"ID":ID,@"state":@"1"} type:kGET success:^(id responseObject) {
            [self.classTab.mj_header beginRefreshing];
        } failure:^(NSError *error) {
            
        }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
   
}

#pragma mark - 删除
- (void)delectClassRequest:(NSString *)ID pathRow:(NSIndexPath *)pathRow{

    [HTTPTool requestWithURLString:@"/api/Course/DelCourse" parameters:@{@"ID":ID} type:kGET success:^(id responseObject) {
        [self.dataArr removeObjectAtIndex:pathRow.row];
        [self.classTab reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取课程列表请求
- (void)getClassRequest {

    [HTTPTool requestWithURLString:@"/api/Course/GetTeacherCourselst" parameters:@{@"auditing":self.auditing,@"pageIndex":@(self.pageIndex),@"pageSize":@"10",@"courseTypeClass":@"2,3"} type:kGET success:^(id responseObject) {
        
        self.classTab.mj_footer.hidden = NO;
        [self.classTab.mj_footer endRefreshing];
        [self.classTab.mj_header endRefreshing];
        
        if (self.pageIndex == 1) {
            [self.dataArr removeAllObjects];
        }
        
        KMMClassModel *classModel = [KMMClassModel mj_objectWithKeyValues:responseObject];
        [self.dataArr addObjectsFromArray:classModel.Data];
        
        if (self.dataArr.count == 0) {
            self.classTab.mj_footer.hidden = YES;
            self.defaultView.hidden = NO;
        }else {
            self.defaultView.hidden = YES;
        }
        if (self.dataArr.count == [classModel.RecordsCount integerValue]) {
            self.classTab.mj_footer.hidden = YES;
        }
        [self.classTab reloadData];
    } failure:^(NSError *error) {
        [self.classTab.mj_footer endRefreshing];
        [self.classTab.mj_header endRefreshing];
    }];
}

#pragma mark - Lazy Load
- (UITableView *)classTab {

    if (!_classTab) {
        NSInteger otherHeight = 0;
        if (SCREEN_HEIGHT == 812) {
            otherHeight = 49;
        }
        _classTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 50 - 64 - otherHeight)];
        _classTab.delegate = self;
        _classTab.dataSource = self;
        [_classTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_classTab registerNib:[UINib nibWithNibName:@"KMMClassCell" bundle:nil] forCellReuseIdentifier:@"KMMClassCell"];
        
        WEAK_SELF(self);
        _classTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 1;
            [self getClassRequest];
        }];
        _classTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex ++;
            [self getClassRequest];
        }];
        
        _classTab.mj_footer.hidden = YES;
    }
    return _classTab;
}

- (KMMClassDefaultView *)defaultView {

    if (!_defaultView) {
        _defaultView = [[[NSBundle mainBundle] loadNibNamed:@"KMMClassDefaultView" owner:nil options:nil] lastObject];
        _defaultView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44);
        _defaultView.hidden = YES;
        if ([self.auditing isEqualToString:@"1"]) {
            _defaultView.titleLb.text = @"您没有审核中的课程";
        }
        if ([self.auditing isEqualToString:@"2"]) {
            _defaultView.titleLb.text = @"您没有已发布的课程";
        }
        if ([self.auditing isEqualToString:@"-1"]) {
            _defaultView.titleLb.text = @"您还没有上传课程";
        }
        if ([self.auditing isEqualToString:@"0"]) {
            _defaultView.titleLb.text = @"您的草稿箱里没有课程";
        }
        [self.view addSubview:_defaultView];
    }
    return _defaultView;
}

@end
