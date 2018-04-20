//
//  KMMFillPersonDetailController.m
//  Maintenance
//
//  Created by kmcompany on 2017/6/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMFillPersonDetailController.h"
#import "KMMDataVerificationController.h"

#import <AVFoundation/AVFoundation.h>

//Cell
#import "KMMPersonAvatarCell.h"
#import "KMMPersonDetailCell.h"

//Model
#import "KMMEnumsModel.h"

//// tools
//#import "Tools.h"

@interface KMMFillPersonDetailController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,KMMPersonDetailCellDelegate>

@property (nonatomic,strong) UITableView *personTab;

@property (nonatomic,strong) UIView *showView;

@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,assign) NSInteger selectCount;

@property (nonatomic,strong) NSMutableArray *totalArr;

@property (nonatomic,strong) NSMutableArray *GoodAtArr;

@property (nonatomic,strong) NSMutableArray *titleArr;

@property (nonatomic,strong) UIView *blackView;

@end

@implementation KMMFillPersonDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
}

- (void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBar.hidden = NO;
}

- (void)pageLayout {

    self.GoodAtArr = [NSMutableArray array];
    self.titleArr = [NSMutableArray array];
    NSArray *sexArr = @[@"男",@"女"];

    self.totalArr = [NSMutableArray arrayWithCapacity:3];
    [self.totalArr addObject:sexArr];
    [self.totalArr addObject:self.titleArr];
    [self.totalArr addObject:self.GoodAtArr];
    
    self.title = self.personModel ? @"修改资料" : @"填写个人资料";
    self.view.backgroundColor = BASE_BACKGROUND_COLOR;
    [self.view addSubview:self.personTab];
    
    WEAK_SELF(self);
    [self.personTab mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self getDoctorTitleRequest];
    
    [self getCourseCategoryRequest];
    
    if (!self.personModel) {
        self.personModel = [[KMMPersonData alloc]init];
    }
    

}


#pragma mark - 获取医生职称列表
- (void)getDoctorTitleRequest {

    [HTTPTool requestWithURLString:@"/api/Teacher/GetEnums" parameters:@{@"category":@"DoctorTitle"} type:kGET success:^(id responseObject) {
        
        KMMEnumsModel *enumModel = [KMMEnumsModel mj_objectWithKeyValues:responseObject];
        [self.titleArr addObjectsFromArray:enumModel.Data];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取擅长课程列表
- (void)getCourseCategoryRequest {
    
    [HTTPTool requestWithURLString:@"/api/Teacher/GetEnums" parameters:@{@"category":@"CourseCategory"} type:kGET success:^(id responseObject) {
        KMMEnumsModel *enumModel = [KMMEnumsModel mj_objectWithKeyValues:responseObject];
        [self.GoodAtArr addObjectsFromArray:enumModel.Data];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return 60;
    }else {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        KMMPersonAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMPersonAvatarCell"];
        cell.avatarPhotoPath = self.personModel.Photo;
        return cell;
    }else {
        KMMPersonDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KMMPersonDetailCell"];
        cell.delegate = self;
        switch (indexPath.row - 1) {
            case 0: {
              cell.titleLb.text = @"姓名";
                if (self.personModel.RealName) {
                    cell.textfiled.text = self.personModel.RealName;
                    if (!self.isCanEdit) {
                        cell.textfiled.enabled = NO;
                    }else {
                        cell.textfiled.enabled = YES;
                    }
                }
              cell.textfiled.placeholder = @"姓名提交后不可更改";
              cell.textfiled.tag = 0;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
                break;
            case 1: {
                cell.titleLb.text = @"性别";
                if (self.personModel.Sex) {
                    cell.textfiled.text = self.personModel.Sex;
                    cell.textfiled.enabled = NO;

                }
                cell.textfiled.enabled = NO;
                cell.textfiled.placeholder = @"性别提交后不可更改";
                if (self.personModel.Sex != nil) {
                    cell.textfiled.text = self.personModel.Sex;
                }
            }
                break;
            case 2: {
                cell.titleLb.text = @"医院";
                if (self.personModel.HospitalName) {
                    cell.textfiled.text = self.personModel.HospitalName;
                    cell.textfiled.enabled = YES;
                    
                }
                cell.textfiled.placeholder = @"请填写医院";
                cell.textfiled.tag = 1;
                 [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
                break;
            case 3: {
                cell.titleLb.text = @"科室";
                if (self.personModel.DeptName) {
                    cell.textfiled.text = self.personModel.DeptName;
                    cell.textfiled.enabled = YES;
                }
                cell.textfiled.placeholder = @"请填写科室";
                cell.textfiled.tag = 2;
                 [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
                break;
            case 4: {
                cell.titleLb.text = @"职称";
                if (self.personModel.TitleName) {
                    cell.textfiled.text = self.personModel.TitleName;
                    cell.textfiled.enabled = YES;
                }
                cell.textfiled.placeholder = @"请选择职称";
                cell.textfiled.enabled = NO;
                if (self.personModel.TitleName != nil) {
                    cell.textfiled.text = self.personModel.TitleName;
                }
            }
                break;
            case 5: {
                cell.titleLb.text = @"身份证号";
                if (self.personModel.IdNo) {
                    cell.textfiled.text = self.personModel.IdNo;
                    if (!self.isCanEdit) {
                        cell.textfiled.enabled = NO;
                    }else {
                        cell.textfiled.enabled = YES;
                    }
                    
                }
                cell.textfiled.placeholder = @"身份证号提交后不可修改";
                cell.textfiled.tag = 3;
                 [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
                break;
            case 6: {
                cell.titleLb.text = @"擅长课程";
                if (self.personModel.Profession) {
                    cell.textfiled.text = self.personModel.Profession;
                    cell.textfiled.enabled = YES;
                }
                cell.textfiled.placeholder = @"请选择擅长课程";
                cell.textfiled.enabled = NO;
                if (self.personModel.Profession != nil) {
                    cell.textfiled.text = self.personModel.Profession;
                }
            }
                break;
            default:
                break;
        }
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        if (self.isCanEdit) {
            self.selectCount = 0;
            [self.pickerView reloadAllComponents];
            [self pickerViewShowMath];
        }
    }else if(indexPath.row == 5){
        if (self.titleArr.count >0) {
            self.selectCount = 1;
            [self.pickerView reloadAllComponents];
            [self pickerViewShowMath];
        }
    }else if(indexPath.row == 7) {
        if (self.GoodAtArr.count >0) {
            self.selectCount = 2;
            [self.pickerView reloadAllComponents];
            [self pickerViewShowMath];
        }
      
      
    }
    
    if (indexPath.section == 0 ) {
        switch (indexPath.row) {
            case 0:
            {
                //头像
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self getPhotosFromCamera];
                }];
                
                UIAlertAction *photoGalleryAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self getPhotosFromLocal];
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertController addAction:cameraAction];
                [alertController addAction:photoGalleryAction];
                [alertController addAction:cancelAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
                break;
        }
    }
}
- (int)countTheStrLength:(NSString*)strtemp {
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

-(NSUInteger)unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        unicodeLength++;
    }
    
    return unicodeLength;
}

#pragma mark - KMMPersonDetailCellDelegate
- (void)KMMPersonDetailCellTextfiledDidChange:(UITextField *)textfiled {

    switch (textfiled.tag) {
        case 0: {
            
            NSLog(@"%zd",textfiled.text.length);
            if (textfiled.text.length >8) {
               
                UITextRange *markeRange = [textfiled markedTextRange];
                if (markeRange) {
                    return;
                }
                 [self showText:@"姓名太长,请重新输入"];
                NSRange range = [textfiled.text rangeOfComposedCharacterSequenceAtIndex:8];
                textfiled.text = [textfiled.text substringToIndex:range.location];
            }
            self.personModel.RealName = textfiled.text;
        }
            break;
        case 1: {
            if (textfiled.text.length >16) {
               
                UITextRange *markeRange = [textfiled markedTextRange];
                if (markeRange) {
                    return;
                }
                 [self showText:@"医院名称太长,请重新输入!"];
                NSRange range = [textfiled.text rangeOfComposedCharacterSequenceAtIndex:16];
                textfiled.text = [textfiled.text substringToIndex:range.location];
            }
            self.personModel.HospitalName = textfiled.text;
        }
            break;
        case 2: {
            if (textfiled.text.length >8) {
               
                UITextRange *markeRange = [textfiled markedTextRange];
                if (markeRange) {
                    return;
                }
                 [self showText:@"科室名称太长,请重新输入!"];
                NSRange range = [textfiled.text rangeOfComposedCharacterSequenceAtIndex:8];
                textfiled.text = [textfiled.text substringToIndex:range.location];
            }
            self.personModel.DeptName = textfiled.text;
        }
            break;
        case 3: {
            self.personModel.IdNo = textfiled.text;
        }
            break;
        default:
            break;
    }
}

#pragma mark -UIPickerViewDelegate,UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.totalArr[self.selectCount] count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 180;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (self.selectCount) {
        case 0: {
            NSString *pickerString = self.totalArr[self.selectCount][row];
            self.personModel.Sex = pickerString;
        }
            break;
        case 1: {
            EnumsArr *pickerString = self.totalArr[self.selectCount][row];
            self.personModel.TitleName = pickerString.Text;
        }
            break;
        case 2: {
            EnumsArr *pickerString = self.totalArr[self.selectCount][row];
            self.personModel.Profession = pickerString.Text;
        }
            break;
        default:
            break;
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if (self.selectCount == 0) {
        NSString *pickerString = self.totalArr[self.selectCount][row];
        return  pickerString;
    }else if(self.selectCount == 1){
        EnumsArr *pickerString = self.totalArr[self.selectCount][row];
        return  pickerString.Text;
    }else {
        EnumsArr *pickerString = self.totalArr[self.selectCount][row];
        return  pickerString.Text;
    }
}

-(UIView *)showView {
    if (!_showView) {
        _showView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250)];
        _showView.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = BASE_BACKGROUND_COLOR;
        [_showView addSubview:lineView];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 40)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:cancelBtn];
        
        UIButton *comfirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40)];
        [comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [comfirmBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        [comfirmBtn addTarget:self action:@selector(comfrimAction) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:comfirmBtn];
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 210)];
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        [_showView addSubview:self.pickerView];
        
        [self.view addSubview:_showView];
        
    }
    return _showView;
}

-(void)cancleAction {

    [self.blackView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    }];
}

-(void)comfrimAction {

    [self.blackView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    }];
    
    switch (self.selectCount) {
        case 0: {
            NSInteger row=[self.pickerView selectedRowInComponent:0];
            NSString *selectStr=[self.totalArr[self.selectCount] objectAtIndex:row];
            self.personModel.Sex = selectStr;
            NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
            [self.personTab reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
        case 1: {
            NSInteger row=[self.pickerView selectedRowInComponent:0];
            EnumsArr *selectStr=[self.totalArr[self.selectCount] objectAtIndex:row];
            self.personModel.TitleName = selectStr.Text;
            self.personModel.TitleType = selectStr.Code;
            NSIndexPath *path = [NSIndexPath indexPathForRow:5 inSection:0];
            [self.personTab reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
        case 2: {
            NSInteger row=[self.pickerView selectedRowInComponent:0];
            EnumsArr *selectStr=[self.totalArr[self.selectCount] objectAtIndex:row];
            self.personModel.Profession = selectStr.Text;
            self.personModel.ProType = selectStr.Code;
            NSIndexPath *path = [NSIndexPath indexPathForRow:7 inSection:0];
            [self.personTab reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
            
        default:
            break;
    }
}

- (void)pickerViewShowMath {

    [[UIApplication sharedApplication].keyWindow addSubview:self.blackView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.showView];
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 250);
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [[info objectForKey:UIImagePickerControllerEditedImage] copy];
    
    [self requestChangePersonHeadIcon:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Lazy Load
- (UITableView *)personTab {

    if (!_personTab) {
        _personTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20 - 64) style:UITableViewStylePlain];
        _personTab.tableFooterView = [self footerView];
        [_personTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _personTab.delegate = self;
        _personTab.dataSource = self;
        _personTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_personTab registerNib:[UINib nibWithNibName:@"KMMPersonDetailCell" bundle:nil] forCellReuseIdentifier:@"KMMPersonDetailCell"];
        [_personTab registerClass:[KMMPersonAvatarCell class] forCellReuseIdentifier:@"KMMPersonAvatarCell"];
        
    }
    return _personTab;
}

- (UIView *)footerView {

    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius = 5;
    [btn setTitle:self.personModel ? @"保存修改" :  @"提交审核" forState:UIControlStateNormal];
    btn.backgroundColor = BASE_COLOR;
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(ClickAction) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(backView.mas_top).offset(30);
        make.left.equalTo(backView.mas_left).offset(15);
        make.right.equalTo(backView.mas_right).offset(-15);
        make.height.mas_equalTo(50);
        
    }];
    return backView;
}

- (void)ClickAction {
    
     NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.personModel.RealName == nil || [self.personModel.RealName isEqualToString:@""] || [[self.personModel.RealName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self showText:@"请输入姓名"];
        return;
    }
    
    if (self.personModel.RealName.length <2) {
        [self showText:@"姓名太短，请重新输入！"];
        return;
    }
    
    if (![self.personModel.RealName isChinese]) {
        [self showText:@"请输入纯中文名字"];
        return;
    }
    
    if (self.personModel.Sex == nil || [self.personModel.Sex isEqualToString:@""]) {
        [self showText:@"请选择性别"];
        return;
    }
    
    NSString *sexString = nil;
    if ([self.personModel.Sex isEqualToString:@"男"]) {
        sexString = @"1";
    }else {
        sexString = @"0";
    }
    
    if (self.personModel.HospitalName == nil || [self.personModel.HospitalName isEqualToString:@""] || [[self.personModel.HospitalName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self showText:@"请输入医院名称"];
        return;
    }
    
    if (self.personModel.HospitalName.length <4) {
        [self showText:@"医院名称太短，请重新输入！"];
        return;
    }
    
    if ([self.personModel.HospitalName rangeOfString:@"医院"].location == NSNotFound) {
        [self showText:@"医院名中必须包含“医院”，请重新输入！"];
        return;
    }
    
    if (self.personModel.DeptName == nil || [self.personModel.DeptName isEqualToString:@""] ||[[self.personModel.DeptName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self showText:@"请输入科室名称"];
        return;
    }
    
    if (self.personModel.DeptName.length <2) {
        [self showText:@"科室名称太短，请重新输入！"];
        return;
    }
    
    if ([self.personModel.DeptName rangeOfString:@"科"].location == NSNotFound) {
        [self showText:@"科室名中必须包含“科”，请重新输入！"];
        return;
    }
    
    if (self.personModel.TitleName == nil || [self.personModel.TitleName isEqualToString:@""]) {
        [self showText:@"请选择职称"];
        return;
    }
    
    if (self.personModel.IdNo == nil || [self.personModel.IdNo isEqualToString:@""] || [[self.personModel.IdNo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        [self showText:@"请输入身份证号码"];
        return;
    }
    
    if (![Tools verifyIDCardNumber:self.personModel.IdNo]) {
        [self showText:@"请输入正确的身份证号码"];
        return;
    }
    
    
    if (self.personModel.Profession == nil || [self.personModel.Profession isEqualToString:@""]) {
        [self showText:@"请选择擅长课程"];
        return;
    }
    
    if (self.personModel.Photo == nil || [self.personModel.Photo isEqualToString:@""]) {
        [self showText:@"请上传头像"];
        return;
    }
    
    NSString *EditTypeStr = nil;

        if (self.isCanEdit) {
            EditTypeStr = @"1";
        }else {
            EditTypeStr = @"2";
        }
    
    
     [dict setValue:self.personModel.RealName forKey:@"RealName"];
     [dict setValue:sexString forKey:@"Sex"];
     [dict setValue:self.personModel.IdNo forKey:@"IdNo"];
     [dict setValue:@"" forKey:@"HospitalId"];
     [dict setValue:self.personModel.HospitalName forKey:@"HospitalName"];
     [dict setValue:@"" forKey:@"DeptId"];
     [dict setValue:self.personModel.DeptName forKey:@"DeptName"];
     [dict setValue:self.personModel.TitleType forKey:@"TitleType"];
     [dict setValue:self.personModel.TitleName forKey:@"TitleName"];
     [dict setValue:self.personModel.ProType forKey:@"ProType"];
     [dict setValue:self.personModel.Profession forKey:@"Profession"];
     [dict setValue:self.personModel.Photo forKey:@"Photo"];
     [dict setValue:EditTypeStr forKey:@"EditType"];
    [self.blackView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    }];
    
    [self showProgressWithText:@"正在提交资料"];
    
    if (!self.isCanEdit) {
        [HTTPTool requestWithURLString:@"/api/Teacher/UpdateInfo" parameters:dict type:kPOST success:^(id responseObject) {
            
            [self showSuccessWithText:@"修改成功"];
            if (self.personBlock) {
                self.personBlock(self.personModel);
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
           
            
        } failure:^(NSError *error) {
            [self showErrorWithText:error.localizedDescription];
        }];

    }else {
        
        if (self.isUpdate) {
            [HTTPTool requestWithURLString:@"/api/Teacher/UpdateInfo" parameters:dict type:kPOST success:^(id responseObject) {
                
                [self showSuccessWithText:@"修改成功"];
                if (self.personBlock) {
                    self.personBlock(self.personModel);
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
                
                
            } failure:^(NSError *error) {
                [self showErrorWithText:error.localizedDescription];
            }];

        }else {
    
    [HTTPTool requestWithURLString:@"/api/Teacher/Apply" parameters:dict type:kPOST success:^(id responseObject) {
        
        [self showSuccessWithText:@"上传成功"];
        
        KMMDataVerificationController *dataVerificationVC = [[KMMDataVerificationController alloc]init];
        [self.navigationController pushViewController:dataVerificationVC animated:YES];
        
    } failure:^(NSError *error) {
        [self showSuccessWithText:error.localizedDescription];
    }];
        }
    
    }

    
}

- (UIView *)blackView {

    if (!_blackView) {
        _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return _blackView;
}

#pragma mark - 更新头像
- (void)requestChangePersonHeadIcon:(UIImage *)img {
    
    
    [HTTPTool requestUploadImageToBATWithParams:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        UIImage * compressImg  = [Tools compressImageWithImage:img ScalePercent:0.001];
        NSData *imageData = UIImagePNGRepresentation(compressImg);
        [formData appendPartWithFileData:imageData
                                    name:[NSString stringWithFormat:@"person_headicon"]
                                fileName:[NSString stringWithFormat:@"person_headicon.jpg"]
                                mimeType:@"multipart/form-data"];
    } success:^(NSArray *imageArray) {
        
        [self showSuccessWithText:@"上传头像成功"];
        
        NSMutableArray *imageModelArray = [BATImage mj_objectArrayWithKeyValuesArray:imageArray];
        BATImage *imageModel = [imageModelArray firstObject];
        self.personModel.Photo  = imageModel.url;

        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.personTab reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {
        
        [self showErrorWithText:@"上传失败"];
        
    } fractionCompleted:^(double count) {
        
        [self showProgres:count];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - 拍照
- (void)getPhotosFromCamera
{
    
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
    
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            DDLogDebug(@"Authorized");
            break;
        case AVAuthorizationStatusDenied:
        {
            DDLogDebug(@"Denied");
            //提示开启相机
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"相机权限已关闭" message:@"请到设置->隐私->相机开启权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
                
                return ;
            }];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            break;
        case AVAuthorizationStatusNotDetermined:
            DDLogDebug(@"not Determined");
            break;
        case AVAuthorizationStatusRestricted:
            DDLogDebug(@"Restricted");
            break;
        default:
            break;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        NSLog(@"模拟器中无法打开相机，请在真机中使用");
    }
}



@end
