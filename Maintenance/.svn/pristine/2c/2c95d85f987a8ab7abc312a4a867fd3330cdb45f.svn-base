//
//  KMMVideoDetailController.m
//  Maintenance
//
//  Created by kmcompany on 2017/7/13.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMVideoDetailController.h"
#import "BATCourseCommentTableViewCell.h"

//model
#import "BATTopicRecordModel.h"

//View
#import "BATSendCommentView.h"
#import "ZFPlayer.h"

//tool
#import "KMMGetURLFileLengthTool.h"

//system
#import <AVFoundation/AVFoundation.h>



@interface KMMVideoDetailController ()<UITableViewDelegate,UITableViewDataSource,YYTextViewDelegate,ZFPlayerDelegate>

@property (nonatomic,strong) UITableView *videoTab;

@property (nonatomic,strong) BATTopicRecordModel *replyModel;

@property (nonatomic,strong) BATSendCommentView *sendCommentView;

@property (nonatomic,strong) NSString *contentString;

@property (nonatomic,strong) NSString *ParentID;

@property (nonatomic,strong) NSString *ParentLevelID;

@property (nonatomic,strong) ZFPlayerControlView *controlView;

@property (nonatomic,strong) UIView *fatherView;

@property (nonatomic,strong) ZFPlayerView *playerView;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,strong) NSString *CourseId;

@property (nonatomic,strong) NSMutableArray *dataArry;

@property (nonatomic,strong) KMMGetURLFileLengthTool *netTool;

@property (nonatomic,assign) BOOL isHideTips;


@end

@implementation KMMVideoDetailController

- (void)dealloc {

   // NSLog(@"111");
    [self.playerView pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    if (self.isShow) {
        [self getCommentListRequest];
    }
    
    [self pageLayout];
}

- (void)pageLayout {
    
    self.dataArry = [[NSMutableArray alloc]init];
    self.currentPage = 1;
    
    UIButton *customBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 10.5, 20)];
    [customBtn setImage:[UIImage imageNamed:@"icon-fh"] forState:UIControlStateNormal];
    
    WEAK_SELF(self);
    [customBtn bk_whenTapped:^{
        STRONG_SELF(self);
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NetStateChangeAction:) name:@"NetStateChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.title = @"查看课程";
    
    [self.view addSubview:self.videoTab];
    
    [self.view addSubview:self.sendCommentView];
    [self.sendCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(1200);
        make.height.mas_equalTo(1200);
    }];
    
    NSString *netSateString = [[NSUserDefaults standardUserDefaults] valueForKey:@"NetState"];
     if([netSateString isEqualToString:@"phoneNet"]){
     
         self.controlView.tipsView.hidden = NO;
         [self.playerView pause];
         [[KMMGetURLFileLengthTool shareInstance] getUrlFileLength:self.clasModel.AttachmentUrl withResultBlock:^(long long length, NSError *error) {
             STRONG_SELF(self);
             NSString *timeString = [self getVideoTimelong:self.clasModel.AttachmentUrl];
             NSString *sizeString = [NSString stringWithFormat:@"流量 约%zdMB",length/1024/1024];
             self.controlView.tipsView.timeLb.text = timeString;
             self.controlView.tipsView.sizeLb.text = sizeString;
         }];
     
     }
    
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

    if (self.isShow) {
         return 40;
    }else {
        return 0.01;
    }
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
    
    //头像点击回调
    cell.headimgTapBlocks =^(NSIndexPath *path) {
    
        
    };

    return cell;
}

- (void)CanelSetStarOrCollectLinkWithData:(TopicReplyData *)data URLString:(NSString *)URLString type:(NSInteger)type {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"10" forKey:@"RelationType"];
   // [dict setValue:data.AuthorId forKey:@"AccountId"];
    [dict setValue:data.Id forKey:@"RelationId"];

    [HTTPTool requestWithURLString:URLString parameters:dict type:kPOST success:^(id responseObject) {
        
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
        [self.videoTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.isShow) {
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
    }else {
    
        return nil;
    }
    
}

- (UIView *)tableHeader {
    
    UIView *backView = [[UIView alloc]init];
    
    self.fatherView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    self.fatherView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:self.fatherView];
   
    
    ZFPlayerModel *model = [[ZFPlayerModel alloc] init];
    model.title = @"";
    model.videoURL = [NSURL URLWithString:self.clasModel.AttachmentUrl];
    model.fatherView = self.fatherView;
    
    [self.playerView playerControlView:self.controlView playerModel:model];
    
    
    self.playerView.hasPreviewView = YES;
    
    [self.playerView autoPlayTheVideo];
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 260 , SCREEN_WIDTH - 20, 30)];
    titleLb.numberOfLines = 0;
    titleLb.text = self.clasModel.CourseTitle;
    [backView addSubview:titleLb];
    
    CGFloat contentHeight = [Tools calculateHeightWithText:self.clasModel.CourseDesc width:SCREEN_WIDTH - 20 font:[UIFont systemFontOfSize:15]];
    UILabel *contentLb = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLb.frame) + 15, SCREEN_WIDTH - 20, contentHeight)];
    contentLb.font = [UIFont systemFontOfSize:15];
    contentLb.numberOfLines = 0;
    contentLb.text = self.clasModel.CourseDesc;
    [backView addSubview:contentLb];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLb.frame)+10, SCREEN_WIDTH, 10)];
    if (self.isShow) {
         lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    }else {
        lineView.backgroundColor = [UIColor whiteColor];
    }
   
    [backView addSubview:lineView];
    
    
    
    backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(lineView.frame));
    
    
    return backView;
    
}

#pragma mark -网络环境变化通知事件
- (void)NetStateChangeAction:(NSNotification *)sender {
    
    NSDictionary *dict = (NSDictionary *)sender.object;
    
    NSString *netSateString = dict[@"NetState"];
    
    WEAK_SELF(self);
    
    if([netSateString isEqualToString:@"phoneNet"]){
        NSLog(@"手机自带网络");
        if (!self.isHideTips) {
            self.controlView.tipsView.hidden = NO;
            [self.playerView pause];
            [[KMMGetURLFileLengthTool shareInstance] getUrlFileLength:self.clasModel.AttachmentUrl withResultBlock:^(long long length, NSError *error) {
                STRONG_SELF(self);
                NSString *timeString = [self getVideoTimelong:self.clasModel.AttachmentUrl];
                NSString *sizeString = [NSString stringWithFormat:@"流量 约%zdMB",length/1024/1024];
                self.controlView.tipsView.timeLb.text = timeString;
                self.controlView.tipsView.sizeLb.text = sizeString;
            }];
        }
    }else if([netSateString isEqualToString:@"NoNet"]) {
        NSLog(@"没有网络(断网)");
        
        
    }else if([netSateString isEqualToString:@"WIFI"]) {
        self.controlView.tipsView.hidden = YES;
        if (self.playerView.state == ZFPlayerStateFailed) {
            [self.playerView autoPlayTheVideo];
        }else if(self.playerView.state == ZFPlayerStateStopped) {
            [self.playerView play];
        }else if(self.playerView.state == ZFPlayerStatePlaying) {
            [self.playerView play];
        }else if(self.playerView.state == ZFPlayerStatePause) {
            [self.playerView play];
        }
        
    }
   
}


- (NSString *)getVideoTimelong:(NSString *)urlString {

    
    NSURL    *movieURL = [NSURL URLWithString:urlString];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];  // 初始化视频媒体文件
    long long second = 0;
    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒

    NSString *timeString;
    NSInteger time= second;
    
    NSInteger hour = time/3600;
    NSInteger mins = time/60;
    NSInteger seconds = time%60;
    
    timeString = [NSString stringWithFormat:@"视频时长 %.2zd:%.2zd:%.2zd",hour,mins,seconds];
    return timeString;

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

#pragma mark - 获取评论列表
- (void)getCommentListRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.clasModel.Id forKey:@"courseId"];
    [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
    [dict setValue:@"10" forKey:@"pageSize"];

    
    [HTTPTool requestWithURLString:@"/api/account/GetCourseReplyList" parameters:dict type:kGET success:^(id responseObject) {
        
        [self.videoTab.mj_header endRefreshing];
        [self.videoTab.mj_footer endRefreshing];
        
        BATTopicRecordModel *tempModel = [BATTopicRecordModel mj_objectWithKeyValues:responseObject];
       

        if (self.currentPage == 1) {
            [self.dataArry removeAllObjects];
        }
        [self.dataArry addObjectsFromArray:tempModel.Data];
        if (tempModel.Data.count == self.dataArry.count) {
            self.videoTab.mj_footer.hidden = YES;
        }else {
            self.videoTab.mj_footer.hidden = NO;
        }
        
              [self.videoTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - Lazy Load
-(UITableView *)videoTab {

    if (!_videoTab) {
        _videoTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _videoTab.tableHeaderView = [self tableHeader];
        _videoTab.delegate = self;
        _videoTab.dataSource = self;
        _videoTab.estimatedRowHeight = 250;
        _videoTab.rowHeight = UITableViewAutomaticDimension;
        _videoTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_videoTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_videoTab registerClass:[BATCourseCommentTableViewCell class] forCellReuseIdentifier:@"BATCourseCommentTableViewCell"];
        
        
        if (self.isShow) {
            WEAK_SELF(self);
            _videoTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
                STRONG_SELF(self);
                self.currentPage = 1;
                [self getCommentListRequest];
            }];
            
            _videoTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
                STRONG_SELF(self);
                self.currentPage ++;
                [self getCommentListRequest];
            }];
            
            _videoTab.mj_footer.hidden = YES;
        }
       

    }
    return _videoTab;
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

- (void)SubmitReply {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.ParentID forKey:@"ParentId"];
    [dict setValue:self.ParentLevelID forKey:@"ParentLevelId"];
    [dict setValue:self.CourseId forKey:@"CourseId"];
    [dict setValue:self.contentString forKey:@"Body"];
    
    [HTTPTool requestWithURLString:@"/api/account/AddCourseReply" parameters:dict type:kPOST success:^(id responseObject) {
        [self.videoTab.mj_header beginRefreshing];
        [self.view endEditing:YES];
    } failure:^(NSError *error) {
        
    }];
    
}

/** 返回按钮事件 */
- (void)zf_playerBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)fatherView
{
    if (_fatherView == nil) {
        _fatherView = [[UIView alloc] init];
        _fatherView.backgroundColor = [UIColor blackColor];
    }
    return _fatherView;
}

- (ZFPlayerView *)playerView
{
    if (_playerView == nil) {
        _playerView = [[ZFPlayerView alloc] init];
        _playerView.delegate = self;
        
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView
{
    if (_controlView == nil) {
        _controlView = [[ZFPlayerControlView alloc] init];
        _controlView.backBtn.hidden = YES;
        WEAK_SELF(self);
        [_controlView setControllerViewPlayBlock:^{
            STRONG_SELF(self);
            self.controlView.tipsView.hidden = YES;
            if (self.playerView.state == ZFPlayerStateFailed) {
                [self.playerView autoPlayTheVideo];
            }else if(self.playerView.state == ZFPlayerStateStopped) {
                [self.playerView play];
            }else if(self.playerView.state == ZFPlayerStatePlaying) {
                [self.playerView play];
            }else if(self.playerView.state == ZFPlayerStatePause) {
                [self.playerView play];
            }
            self.isHideTips = YES;
        }];
    }
    return _controlView;
}
@end
