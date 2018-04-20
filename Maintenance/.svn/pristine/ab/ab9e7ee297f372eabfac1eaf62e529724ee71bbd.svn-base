//
//  KMMMailCell.h
//  Maintenance
//
//  Created by kmcompany on 2017/6/7.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMMMailCellDelegate <NSObject>

- (void)KMMMailCellTextFieldDidChange:(UITextField *)textField;

@end

@interface KMMMailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textfield;

@property (nonatomic,strong) id <KMMMailCellDelegate> delegate;

@end
