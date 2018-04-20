//
//  KMMPersonDetailCell.h
//  Maintenance
//
//  Created by kmcompany on 2017/6/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMMPersonDetailCellDelegate <NSObject>

- (void)KMMPersonDetailCellTextfiledDidChange:(UITextField *)textfiled;

@end

@interface KMMPersonDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UITextField *textfiled;

@property (nonatomic,strong) id <KMMPersonDetailCellDelegate> delegate;

@end
