//
//  KMMPreViewEditorController.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/18.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMPreViewEditorController.h"

//cell
#import "BATCourseCommentTableViewCell.h"

//model
#import "BATTopicRecordModel.h"

//View
#import "BATSendCommentView.h"

@interface KMMPreViewEditorController ()<UITableViewDelegate,UITableViewDataSource,YYTextViewDelegate>

@property (nonatomic,strong) UITableView *preViewTab;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) NSMutableArray *dataArry;

@property (nonatomic,strong) BATSendCommentView *sendCommentView;

@property (nonatomic,strong) NSString *contentString;

@property (nonatomic,strong) NSString *ParentID;

@property (nonatomic,strong) NSString *ParentLevelID;

@property (nonatomic,strong) NSString *CourseId;

@end

@implementation KMMPreViewEditorController

- (void)dealloc {

   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    WEAK_SELF(self);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didfinishLoadWebView:) name:@"DIDFINISHLOADWEBVIEW" object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"icon-sc"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.title = @"查看课程";
    
    [self getCommentListRequest];

    self.dataArry = [NSMutableArray array];

    [self.view addSubview:self.preViewTab];
    
    [self.view addSubview:self.sendCommentView];
    [self.sendCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(1200);
        make.height.mas_equalTo(1200);
    }];
    

}

#pragma mark - action
- (void)keyboardWillShow:(NSNotification *)notif {
    
    
    CGRect keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        
        self.sendCommentView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, -keyboardFrame.size.height-self.sendCommentView.bounds.size.height);
        
    } completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification *)notif {
    
    
    double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        
        self.sendCommentView.transform = CGAffineTransformIdentity;
        
    } completion:nil];
    
}

- (void)dismissAction {
    
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didfinishLoadWebView:(NSNotification *)notice {
    
    if (self.clasModel) {
        NSString *trigger1;
        trigger1 = [NSString stringWithFormat:@"page.setTitle(\"%@\");", self.clasModel.CourseTitle];
        
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger1];
        
        NSString *trigger2;
        trigger2 = [NSString stringWithFormat:@"page.setSummary(\"%@\");", self.clasModel.CourseDesc];
        
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger2];
        
        NSString *str = self.clasModel.MainContent;
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
        str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        [self.editorView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"page.setContent(\'%@\');",str]];
        
        
    }
    
    if (!self.isCanEdit) {
        [self.editorView stringByEvaluatingJavaScriptFromString:@"page.setReadOnly()"];
        [self.editorView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"RE.setInputEnabled(\'%@\');", @"false"]];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGFloat height11 =  [[self.editorView stringByEvaluatingJavaScriptFromString:@"page.getHeight()"] floatValue];
//        CGFloat height =  [[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
        
        self.editorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height11);
        
        self.preViewTab.tableHeaderView = self.editorView;
    });
    
   
   
    
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    
    if (textView.text.length > 0) {
        self.sendCommentView.sendCommentButton.enabled = YES;
        self.sendCommentView.sendCommentButton.backgroundColor = BASE_COLOR;
    }
    if (textView.text.length == 0) {
        self.sendCommentView.sendCommentButton.enabled = NO;
        self.sendCommentView.sendCommentButton.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BATCourseCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCourseCommentTableViewCell"];
    cell.indexPath = indexPath;
    [cell configTopicData:self.dataArry[indexPath.row]];
    
    WEAK_SELF(self);
    cell.likeAction = ^(NSIndexPath *cellIndexPath) {
        
        STRONG_SELF(self);
        
        TopicReplyData *data = self.dataArry[cellIndexPath.row];
        
        
        NSString *urlString = nil;
        if (data.IsSetStar) {
            
            urlString = @"/api/account/CanelSetStar";
            [self CanelSetStarOrCollectLinkWithData:data URLString:urlString type:10];
            
        }else {
            urlString = @"/api/account/CourseCollectLink";
            [self CanelSetStarOrCollectLinkWithData:data URLString:urlString type:10];
            
        }
        
    };
    cell.commentAction = ^(NSIndexPath *cellIndexPath) {
        
        STRONG_SELF(self);
        TopicReplyData *data = self.dataArry[cellIndexPath.row];
        self.CourseId = data.CourseId;
        self.ParentID = data.Id;
        self.ParentLevelID = data.Id;
        self.sendCommentView.commentTextView.text = nil;
        self.sendCommentView.commentTextView.placeholderText = [NSString stringWithFormat:@"回复%@ ",data.NickName];
        [self.sendCommentView.commentTextView becomeFirstResponder];
        
    };

    return cell;
}

- (void)CanelSetStarOrCollectLinkWithData:(TopicReplyData *)data URLString:(NSString *)URLString type:(NSInteger)type {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"10" forKey:@"RelationType"];
    // [dict setValue:data.AuthorId forKey:@"AccountId"];
    [dict setValue:data.Id forKey:@"RelationId"];
    
    
    WEAK_SELF(self);
    [HTTPTool requestWithURLString:URLString parameters:dict type:kPOST success:^(id responseObject) {
        STRONG_SELF(self);
        if (!data.IsSetStar) {
            data.IsSetStar = YES;
            data.StarNum ++;
        } else {
            data.IsSetStar = NO;
            data.StarNum--;
            
            if (data.StarNum < 0) {
                data.StarNum = 0;
            }
        }
        [self.preViewTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = UIColorFromHEX(0X333333, 1);
    title.text = @"评论";
    [backView addSubview:title];
    
    UILabel *countLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), 0, 100, 40)];
    countLb.font = [UIFont systemFontOfSize:12];
    countLb.textColor = UIColorFromHEX(0X999999, 1);
    countLb.text = [NSString stringWithFormat:@"(%zd)",self.dataArry.count];
    [backView addSubview:countLb];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    [backView addSubview:lineView];
    
    return backView;
}

#pragma mark - 获取评论列表
- (void)getCommentListRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.clasModel.Id forKey:@"courseId"];
    [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
    [dict setValue:@"10" forKey:@"pageSize"];
    
    WEAK_SELF(self);
    [HTTPTool requestWithURLString:@"/api/account/GetCourseReplyList" parameters:dict type:kGET success:^(id responseObject) {
        
        STRONG_SELF(self);
        [self.preViewTab.mj_header endRefreshing];
        [self.preViewTab.mj_footer endRefreshing];
        
        BATTopicRecordModel *tempModel = [BATTopicRecordModel mj_objectWithKeyValues:responseObject];
        
        
        if (self.currentPage == 1) {
            [self.dataArry removeAllObjects];
        }
        [self.dataArry addObjectsFromArray:tempModel.Data];
        if (tempModel.Data.count == self.dataArry.count) {
            self.preViewTab.mj_footer.hidden = YES;
        }else {
            self.preViewTab.mj_footer.hidden = NO;
        }
        
        [self.preViewTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 提交评论
- (void)SubmitReply {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.ParentID forKey:@"ParentId"];
    [dict setValue:self.ParentLevelID forKey:@"ParentLevelId"];
    [dict setValue:self.CourseId forKey:@"CourseId"];
    [dict setValue:self.contentString forKey:@"Body"];
    
    WEAK_SELF(self);
    [HTTPTool requestWithURLString:@"/api/account/AddCourseReply" parameters:dict type:kPOST success:^(id responseObject) {
        
        STRONG_SELF(self);
        [self.preViewTab.mj_header beginRefreshing];
        [self.view endEditing:YES];
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark - Lazy Load

- (UITableView *)preViewTab {

    if (!_preViewTab) {
        _preViewTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        //  _preViewTab.tableHeaderView = [self tableHeader];
        _preViewTab.delegate = self;
        _preViewTab.dataSource = self;
        _preViewTab.estimatedRowHeight = 250;
        _preViewTab.rowHeight = UITableViewAutomaticDimension;
        _preViewTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_preViewTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_preViewTab registerClass:[BATCourseCommentTableViewCell class] forCellReuseIdentifier:@"BATCourseCommentTableViewCell"];
        
        WEAK_SELF(self);
        _preViewTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 1;
            [self getCommentListRequest];
        }];
        
        _preViewTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self getCommentListRequest];
        }];
        
        _preViewTab.mj_footer.hidden = YES;

    }
    
    return _preViewTab;
}


- (BATSendCommentView *)sendCommentView {
    
    if (!_sendCommentView) {
        _sendCommentView = [[BATSendCommentView alloc] init];
        _sendCommentView.commentTextView.delegate = self;
        _sendCommentView.commentTextView.returnKeyType = UIReturnKeyDone;
        WEAK_SELF(self);
        [_sendCommentView setSendBlock:^{
            STRONG_SELF(self);
            NSString *text = [self.sendCommentView.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.contentString = text;
            if (text.length == 0) {
                [self showErrorWithText:@"请输入评论"];
            }else {
                [self SubmitReply];
                
            }
        }];
        
        [_sendCommentView setClaerBlock:^{
            STRONG_SELF(self);
            [self.view endEditing:YES];
        }];
    }
    
    return _sendCommentView;
}
@end
