//
//  KMMClassSearchController.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/5.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMClassSearchController.h"
#import "KMMEditorViewController.h"
#import "KMMVideoDetailController.h"
#import "KMMPreViewEditorController.h"
#import "KMMCompleteVideoInfoController.h"

//CELL
#import "KMMSearchTitleCell.h"
#import "KMMClassCell.h"

//model
#import "KMMSearchTitleModel.h"
#import "KMMClassModel.h"

//View
#import "KMMClassDefaultView.h"

#import "KMMsearchTF.h"

@interface KMMClassSearchController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,KMMClassCellDelegate>

@property (nonatomic,strong) UITableView *searchTab;

@property (nonatomic,strong) KMMSearchTitleModel *titleModel;

@property (nonatomic,strong) KMMClassModel *classModel;

@property (nonatomic,strong) KMMsearchTF *searchTF;

@property (nonatomic,strong) NSMutableArray *classArr;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) NSString *keyword;

@property (nonatomic,strong) KMMClassDefaultView *defaultView;


@end

@implementation KMMClassSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
}

- (void)pageLayout {
    self.keyword = @"";
    self.pageIndex = 1;
    self.classArr = [NSMutableArray array];
    [self.view addSubview:self.searchTab];
    WEAK_SELF(self);
    [self.searchTab mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];

    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:self.searchTF];
    self.navigationItem.leftBarButtonItem = left;
    
    UIButton *right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [right setTitle:@"取消" forState:UIControlStateNormal];
    [right setTitleColor:UIColorFromHEX(0X333333, 1) forState:UIControlStateNormal];
    [right addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    [self.searchTF becomeFirstResponder];
}

- (void)popAction {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.titleModel) {
        return self.titleModel.Data.count;
    }
    
    if (self.classModel) {
        return self.classArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.classModel) {
        KMMClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMClassCell"];
        cell.pathRow = indexPath;
        cell.delegate = self;
        cell.classDataModel = self.classArr[indexPath.row];
        return cell;
    }

    if (self.titleModel) {
        KMMSearchTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMSearchTitleCell"];
        cell.titleModel = self.titleModel.Data[indexPath.row];
        return cell;
    }
    
   
   
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (self.classModel) {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.classModel) {
        return 107.5;
    }
    
    if (self.titleModel) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (self.classModel) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH
                                                                   , 40)];
        backView.backgroundColor = [UIColor whiteColor];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
        title.textColor = UIColorFromHEX(0X333333, 1);
        title.font = [UIFont systemFontOfSize:15];
        title.text = @"课程";
        
        [title setBottomBorderWithColor:BASE_BACKGROUND_COLOR width:SCREEN_WIDTH height:0];
        
        [backView addSubview:title];
        
        return backView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.titleModel) {
        self.keyword = [self.titleModel.Data[indexPath.row] Title];
        _searchTF.text = self.keyword;
        self.searchTab.mj_header.hidden = NO;
        self.searchTab.mj_footer.hidden = NO;
        self.pageIndex = 1;
        [self searchDetailRequest];
        
    }
    
    if (self.classModel) {

        ClassData *data = self.classModel.Data[indexPath.row];

        if ([data.CourseType integerValue]>13) {
            
            KMMVideoDetailController *detailVC = [[KMMVideoDetailController alloc]init];
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
                lmVC.clasModel = self.classModel.Data[indexPath.row];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lmVC];
                lmVC.isCanEdit = NO;
                [self.navigationController presentViewController:nav animated:YES completion:nil];
                
            }else {
                
                KMMEditorViewController *lmVC = [[KMMEditorViewController alloc]init];
                lmVC.clasModel = self.classModel.Data[indexPath.row];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lmVC];
                
                
                lmVC.isCanEdit = NO;
                
                [self.navigationController presentViewController:nav animated:YES completion:nil];
            }
            
        }

    }
}

#pragma mark - KMMClassCellDelegate
#pragma mark - 撤销审核
- (void)KMMClassCellDelegateReverseClass:(NSIndexPath *)pathRow {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"撤销审核后课程会进入草稿箱,确定撤销?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HTTPTool requestWithURLString:@"/api/Course/CommitCourse" parameters:@{@"ID":[self.classArr[pathRow.row] Id],@"state":@"0"} type:kGET success:^(id responseObject) {
            [self.searchTab.mj_header beginRefreshing];
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
        [HTTPTool requestWithURLString:@"/api/Course/CommitCourse" parameters:@{@"ID":[self.classArr[pathRow.row] Id],@"state":@"4"} type:kGET success:^(id responseObject) {
            [self.searchTab.mj_header beginRefreshing];
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
            
            [self saveClassRequest:[self.classArr[pathRow.row] Id] pathRow:pathRow];
            
        }
            break;
        case 1: {
            
            ClassData *data = self.classModel.Data[pathRow.row];
            if ([data.CourseType integerValue]>13) {
                
                KMMCompleteVideoInfoController *detailVC = [[KMMCompleteVideoInfoController alloc]init];
                detailVC.isEdit = YES;
                detailVC.classModel = data;
                [self.navigationController pushViewController:detailVC animated:YES];
                
            }else {
                KMMEditorViewController *lmVC = [[KMMEditorViewController alloc]init];
                lmVC.clasModel = self.classModel.Data[pathRow.row];
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
                [self delectClassRequest:[self.classArr[pathRow.row] Id] pathRow:pathRow];
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
            [self.searchTab.mj_header beginRefreshing];
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
        [self.searchTab.mj_header beginRefreshing];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textfiledDidChanged:(UITextField *)textfiled {
    
    self.searchTab.mj_header.hidden = YES;
    self.searchTab.mj_footer.hidden = YES;
    self.defaultView.hidden = YES;
    
    self.classModel = nil;
    
//    if (textfiled.text == nil || [textfiled.text isEqualToString:@""]) {
//        return;
//    }
    
    [HTTPTool requestWithURLString:@"/api/Course/AutoComplete" parameters:@{@"keyword":textfiled.text} type:kGET success:^(id responseObject) {
        
        self.titleModel = [KMMSearchTitleModel mj_objectWithKeyValues:responseObject];
        [self.searchTab reloadData];
    } failure:^(NSError *error) {
        
    }];
    
   
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {

    if (self.titleModel) {
         [self.titleModel.Data removeAllObjects];
        self.titleModel = nil;
    }
    
    if (self.classModel) {
        [self.classArr removeAllObjects];
        self.classModel = nil;
    }
   
    [self.searchTab reloadData];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    self.titleModel = nil;

    self.searchTab.mj_header.hidden = NO;
    self.searchTab.mj_footer.hidden = NO;

    self.keyword = textField.text;
    self.pageIndex = 1;
    
    [self searchDetailRequest];
    
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark - Lazy Load
- (UITableView *)searchTab {

    if (!_searchTab) {
        _searchTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _searchTab.delegate = self;
        _searchTab.dataSource = self;
        [_searchTab registerNib:[UINib nibWithNibName:@"KMMSearchTitleCell" bundle:nil] forCellReuseIdentifier:@"KMMSearchTitleCell"];
        [_searchTab registerNib:[UINib nibWithNibName:@"KMMClassCell" bundle:nil] forCellReuseIdentifier:@"KMMClassCell"];
        [_searchTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _searchTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        WEAK_SELF(self);
        _searchTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 1;
            [self searchDetailRequest];
        }];
        _searchTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex ++;
            [self searchDetailRequest];
        }];
        
        _searchTab.mj_footer.hidden = YES;
        _searchTab.mj_header.hidden = YES;
    }
    return _searchTab;
}

- (UITextField *)searchTF {
    if (!_searchTF) {
//        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:nil BorderStyle:UITextBorderStyleNone];
        _searchTF = [[KMMsearchTF alloc]init];
        _searchTF.font = [UIFont systemFontOfSize:14];
        _searchTF.clearButtonMode = UITextFieldViewModeAlways;
        _searchTF.placeholder = @"搜索课程";
        _searchTF.frame = CGRectMake(0, 0, SCREEN_WIDTH - 80, 30);
        _searchTF.textColor = UIColorFromHEX(0x666666, 1);
        _searchTF.backgroundColor = UIColorFromRGB(243, 243, 243, 1);
        _searchTF.returnKeyType = UIReturnKeySearch;
        [_searchTF addTarget:self action:@selector(textfiledDidChanged:) forControlEvents:UIControlEventEditingChanged]; 
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-ss"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        
        
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;
        
        _searchTF.layer.cornerRadius = 3.0f;
        _searchTF.clipsToBounds = YES;
        
        if (@available(iOS 11.0, *)) {
            _searchTF.intrinsicContentSize = CGSizeMake(SCREEN_WIDTH - 80, 30);
        }
    }
    return _searchTF;
}

- (KMMClassDefaultView *)defaultView {

    if (!_defaultView) {
        _defaultView = [[[NSBundle mainBundle] loadNibNamed:@"KMMClassDefaultView" owner:nil options:nil] lastObject];
        _defaultView.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
        _defaultView.titleLb.text = @"没有找到课程";
        _defaultView.hidden = YES;
        [self.view addSubview:_defaultView];
    }
    return _defaultView;
}

#pragma mark - NET
- (void)searchDetailRequest {

    [HTTPTool requestWithURLString:@"/api/Course/Search" parameters:@{@"pageIndex":@"1",@"pageSize":@"10",@"keyword":self.keyword} type:kGET success:^(id responseObject) {
        
        self.titleModel = nil;
        [self.searchTab.mj_header endRefreshing];
        [self.searchTab.mj_footer endRefreshing];
        
        if (self.pageIndex == 1) {
            [self.classArr removeAllObjects];
        }
        self.classModel = [KMMClassModel mj_objectWithKeyValues:responseObject];
        [self.classArr addObjectsFromArray:self.classModel.Data];
        
        if (self.classArr.count == 0) {
            self.defaultView.hidden = NO;
        }
        
        if (self.classArr.count == [self.classModel.RecordsCount integerValue]) {
            self.searchTab.mj_footer.hidden = YES;
        }
        [self.searchTab reloadData];
        
        NSLog(@"%@",NSStringFromCGRect(self.searchTab.frame));
    } failure:^(NSError *error) {
        
    }];
}


@end
