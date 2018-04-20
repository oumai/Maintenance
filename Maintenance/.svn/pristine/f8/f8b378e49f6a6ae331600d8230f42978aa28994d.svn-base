//
//  KMMVerificationCell.h
//  Maintenance
//
//  Created by kmcompany on 2017/5/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KMMVerificationCell;

@protocol KMMVerificationCellDelegate <NSObject>

- (void)KMMVerificationCellVerificationAction:(KMMVerificationCell *)cell;

@end

@interface KMMVerificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@property (weak, nonatomic) IBOutlet UITextField *textfiled;

@property (nonatomic,strong) id <KMMVerificationCellDelegate>delegate;

@end
