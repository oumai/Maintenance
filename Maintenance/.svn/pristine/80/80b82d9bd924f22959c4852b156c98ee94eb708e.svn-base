//
//  KMMEditorViewController.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/12.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMEditorViewController.h"
#import "KMMEnumsModel.h"
#import "BATMyFindEqualCellFlowLayout.h"
#import "KMMKeyWordCell.h"
#import "KMMCourseFooterCell.h"
#import "KMMCourseHeaderCell.h"

#import "KMMSizeTipsView.h"


@interface KMMEditorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) KMMEnumsModel *listModel;

@property (nonatomic,strong) NSString *CourseName;

@property (nonatomic,strong) NSString *CourseID;

@property (nonatomic,strong) UIControl *backView;

@property (nonatomic,strong) KMMSizeTipsView *tipsView;

@end

@implementation KMMEditorViewController

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heightAction:) name:@"SENDHEIGHT" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didfinishLoadWebView:) name:@"DIDFINISHLOADWEBVIEW" object:nil];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.isCanEdit?@"编辑课程":@"查看课程";

    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"icon-sc"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    
    if (self.isCanEdit) {
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
        [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [rightBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        
        self.tipsView = [[[NSBundle mainBundle] loadNibNamed:@"KMMSizeTipsView" owner:nil options:nil] lastObject];
        self.tipsView.alpha = 0;
        self.tipsView.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.tipsView.reloadBtn setTitle:@"确定" forState:UIControlStateNormal];
        self.tipsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.tipsView.titleLb.text = @"关闭课程将导致编辑内容无法找回，确认关闭？";
        
        WEAK_SELF(self);
        [self.tipsView setReloadBlock:^{
            STRONG_SELF(self);
            [self.tipsView removeFromSuperview];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        [self.tipsView setCancelBlock:^{
            STRONG_SELF(self);
            [UIView animateWithDuration:0.3 animations:^{
                
                self.tipsView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.tipsView removeFromSuperview];
            }];
            
        }];
        
        

    }    

    
    [self.backView addSubview:self.collectionView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    self.backView.hidden = YES;
    [self getCourseCategorygetRequest];
    

}

#pragma mark -webView加载完毕之后的回调通知
- (void)didfinishLoadWebView:(NSNotification *)sender {
    
    
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
    
    NSMutableString *string = [NSMutableString string];
    if (self.imageArr.count != 0) {
        
        for (int i=0; i<self.imageArr.count; i++) {
            NSString *imagePath = self.imageArr[i];
            if (i == self.imageArr.count -1) {
                [string appendString:[NSString stringWithFormat:@"<div><img src=\"%@\" style=\"margin-bottom:30px; height:auto;\"></div><br>&nbsp",imagePath]];
            }else {
            [string appendString:[NSString stringWithFormat:@"<div><img src=\"%@\" style=\"margin-bottom:30px; height:auto;\"></div>",imagePath]];
            }
        }
//        for (NSString *imagePath in self.imageArr) {
//          //  [string appendString:[NSString stringWithFormat:@"<div><img src=\"%@\" style=\"padding-left:10%%;padding-right:10%%;margin-bottom:30px; height:auto;width:90%%;\"></div>",imagePath]];
//             [string appendString:[NSString stringWithFormat:@"<div><img src=\"%@\" style=\"margin-bottom:30px; height:auto;\"></div>",imagePath]];
//        }
        
        [self.editorView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"page.setContent(\'%@\');",[NSString stringWithFormat:@"%@%@",string,@"<div></div>"]]];
    }

    
    if (!self.isCanEdit) {
        [self.editorView stringByEvaluatingJavaScriptFromString:@"page.setReadOnly()"];
        [self.editorView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"RE.setInputEnabled(\'%@\');", @"false"]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            

            CGFloat height11 =  [[self.editorView stringByEvaluatingJavaScriptFromString:@"page.getHeight()"] floatValue];
            
            //        CGFloat height =  [[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
            
            self.editorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height11);
            
            [self.editorScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, height11 + 100)];
        });
    }else {
        
      // CGFloat height11 =  [[self.editorView stringByEvaluatingJavaScriptFromString:@"page.getHeight()"] floatValue];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
         //   CGFloat height11 =  [[self.editorView stringByEvaluatingJavaScriptFromString:@"RE.getImageHeight()"] floatValue];

        self.editorView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        self.editorScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        self.editorScrollView.scrollEnabled = NO;
        [self.editorScrollView setContentSize:CGSizeZero];
       // [self.editorScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, height11)];
        });
    }
    
    

}

- (void)getCourseCategorygetRequest {
   
    [HTTPTool requestWithURLString:@"/api/Teacher/GetEnums" parameters:@{@"category":@"CourseCategory"} type:kGET success:^(id responseObject) {
        self.listModel = [KMMEnumsModel mj_objectWithKeyValues:responseObject];
      //  NSLog(@"%@",[self.listModel.Data[0] Name]);
        [self.collectionView reloadData];
        KMMCourseFooterCell *cell2 = (KMMCourseFooterCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        CGFloat collectionViewHeight2 = CGRectGetMaxY(cell2.frame);
        self.collectionView.frame = CGRectMake((SCREEN_WIDTH - 300)/2, 190, 300, collectionViewHeight2);
    } failure:^(NSError *error) {
        
    }];
}

- (void)dismissAction {
    
    [self.view endEditing:YES];
    
    if (self.isCanEdit) {
        
        [self.view addSubview:self.tipsView];
        
        [UIView animateWithDuration:0.3 animations:^{
           
            self.tipsView.alpha = 1;
        }];
        
    }else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    }


}

- (void)saveAction {
    
    
    NSString *titleString = [self.editorView stringByEvaluatingJavaScriptFromString:@"page.getTitle();"];
    NSString *contentString = [self.editorView stringByEvaluatingJavaScriptFromString:@"page.getSummary();"];
    // NSString *htmlString = [self.editorView stringByEvaluatingJavaScriptFromString:@"page.getContent();"];
    
    
    
    if ([[titleString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] < 4) {
        [self showText:@"请输入4-20字的课程标题"];
        return;
    }
    
    
    
    if ([[contentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] < 10) {
        [self showText:@"请输入10-50字的课程简介"];
        return;
    }
    
    
    NSString *contentLength = [self.editorView stringByEvaluatingJavaScriptFromString:@"page.getTextLength();"];
    if ([contentLength integerValue]<10 || [contentLength integerValue] >5000) {
        [self showText:@"请输入10-5000字的正文"];
        return;
    }
    
    
    
    NSString *HtmlString = [self.editorView stringByEvaluatingJavaScriptFromString:@"page.getContent();"];
    if ([HtmlString rangeOfString:@"<img src="].location ==NSNotFound) {
        [self showText:@"正文中至少包含一张图片"];
        return;
    }
    

    
   

    [self.view endEditing:YES];
    self.backView.hidden = NO;
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return self.listModel.Data.count;
    }
    if (section == 2) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        KMMCourseHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KMMCourseHeaderCell" forIndexPath:indexPath];
        return cell;
    }
    
    if (indexPath.section == 2) {
        KMMCourseFooterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KMMCourseFooterCell" forIndexPath:indexPath];
        WEAK_SELF(self);
        [cell setClickBlock:^(NSInteger tag,UIButton *btn){
            STRONG_SELF(self);
            [self saveAction:tag withButton:btn];
        }];
        return cell;
    }
    
    KMMKeyWordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KMMKeyWordCell" forIndexPath:indexPath];
    
        if (self.listModel.Data.count > 0) {
    
            EnumsArr *data = self.listModel.Data[indexPath.row];
    
            cell.keyLabel.text = data.Text;
    
            if (data.isSelect) {
                cell.keyLabel.textColor = [UIColor whiteColor];
                cell.layer.borderColor = BASE_COLOR.CGColor;
                cell.backgroundColor = BASE_COLOR;
            }else {
                cell.layer.borderColor = BASE_BACKGROUND_COLOR.CGColor;
                cell.keyLabel.textColor = UIColorFromHEX(0X333333, 1);
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
    
    
    return cell;
}

- (void)saveAction:(NSInteger)tag withButton:(UIButton *)btn{
    
    btn.userInteractionEnabled = NO;
    if (![HTTPTool currentNetStatus]) {
        if (tag == 0) {
            [self showText:@"保存失败  请连网后后重试"];
             btn.userInteractionEnabled = YES;
        }else {
            [self showText:@"发布失败  请连网后重试"];
             btn.userInteractionEnabled = YES;
        }
        return;
    }
    
    NSString *titleString = [self.editorView stringByEvaluatingJavaScriptFromString:@"page.getTitle();"];
    NSString *contentString = [self.editorView stringByEvaluatingJavaScriptFromString:@"page.getSummary();"];
    NSString *htmlString = [self.editorView stringByEvaluatingJavaScriptFromString:@"page.getContent();"];
    
 //   NSString *titleString = self.textField.text;
  //  NSString *contentString = self.yytextView.text;
  //  NSString *htmlString = [self getHTML];
    
    
    if (self.CourseID == nil || [self.CourseID isEqualToString:@""]) {
        [self showText:@"请选择类别"];
         btn.userInteractionEnabled = YES;
        return;
    }
    
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.clasModel?self.clasModel.Id:@"" forKey:@"Id"];
    [dict setValue:self.CourseID forKey:@"CourseCategory"];
    [dict setValue:titleString forKey:@"CourseTitle"];
    [dict setValue:contentString forKey:@"CourseDesc"];
    [dict setValue:@"20" forKey:@"ClassHour"]; //固定20
    [dict setValue:self.clasModel?self.clasModel.Poster:self.imageArr[0] forKey:@"Poster"];
    [dict setValue:@"" forKey:@"AttachmentUrl"]; //传空
    [dict setValue:@(tag) forKey:@"Auditing"];
    [dict setValue:@"13" forKey:@"CourseType"];
    [dict setValue:htmlString forKey:@"MainContent"];
    
    
    [HTTPTool requestWithURLString:@"/api/Course/EditCourse" parameters:dict type:kPOST success:^(id responseObject) {
        btn.userInteractionEnabled = YES;
        for (EnumsArr *enumsModel in self.listModel.Data) {
            enumsModel.isSelect = NO;
            [self.collectionView reloadData];
        }
        
        self.CourseID = nil;
        self.backView.hidden = YES;
        [self showSuccessWithText:self.clasModel?@"编辑成功":@"上传成功"];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
         btn.userInteractionEnabled = YES;
        for (EnumsArr *enumsModel in self.listModel.Data) {
            enumsModel.isSelect = NO;
            [self.collectionView reloadData];
        }
         self.CourseID = nil;
        if (tag == 0) {
            [self showText:@"服务器开小差啦    请重新保存"];
        }else {
            [self showText:@"服务器开小差啦    请重新发布"];
        }
        self.backView.hidden = YES;
    }];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.listModel.Data.count > 0) {
            
            for (EnumsArr *data in self.listModel.Data) {
                data.isSelect = NO;
            }
            
            EnumsArr *data = self.listModel.Data[indexPath.row];
            data.isSelect = YES;
            self.CourseName = data.Text;
            self.CourseID = data.Code;
            
            [self.collectionView reloadData];
            
        }
    }
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (self.listModel.Data.count > 0) {
            EnumsArr *data = self.listModel.Data[indexPath.row];
            
            CGSize textSize = [data.Text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
            return CGSizeMake(textSize.width+20, 30);
        }
    }
    
    if (indexPath.section == 0) {
        return CGSizeMake(300, 42.5);
    }
    
    if (indexPath.section == 2) {
        return CGSizeMake(300, 42.5);
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == 1) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}




#pragma mark - get&set
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        BATMyFindEqualCellFlowLayout * flowLayout = [[BATMyFindEqualCellFlowLayout alloc] init];
        flowLayout.maximumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, 190, 300, 100) collectionViewLayout:flowLayout];
        _collectionView.clipsToBounds = YES;
        _collectionView.layer.cornerRadius = 5;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[KMMKeyWordCell class] forCellWithReuseIdentifier:@"KMMKeyWordCell"];
        
         [_collectionView registerClass:[KMMCourseHeaderCell class] forCellWithReuseIdentifier:@"KMMCourseHeaderCell"];
        
         [_collectionView registerClass:[KMMCourseFooterCell class] forCellWithReuseIdentifier:@"KMMCourseFooterCell"];
    }
    return _collectionView;
}

#pragma makr - Layout
- (UIControl *)backView {

    if (!_backView) {
        _backView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [_backView addSubview:self.collectionView];
        
        [_backView addTarget:self action:@selector(dismissViewAction) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _backView;
}

- (void)dismissViewAction {

    self.backView.hidden = YES;
    
    for (EnumsArr *enumsModel in self.listModel.Data) {
        enumsModel.isSelect = NO;
        [self.collectionView reloadData];
    }
    
    self.CourseID = nil;
}

@end
