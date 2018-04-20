//
//  KMMLoginCell.h
//  Maintenance
//
//  Created by kmcompany on 2017/5/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMMLoginCellDelegate <NSObject>

- (void)KMMLoginCellDelegateEyeAction:(BOOL)isShowPassword rowPaht:(NSIndexPath *)RowPaht;

- (void)KMMloginCellDelegateTextFieldDidChange:(UITextField *)textField withRowPaht:(NSIndexPath *)path;

@end

@interface KMMLoginCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *eyeImage;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UITextField *textfiled;

@property (nonatomic,strong) id <KMMLoginCellDelegate>delegate;

@property (nonatomic,strong) NSIndexPath *path;

@end
