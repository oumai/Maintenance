//
//  KMMCompletTitleCell.h
//  Maintenance
//
//  Created by kmcompany on 2017/7/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"

@protocol KMMCompletTitleCellDelegate <NSObject>

- (void)KMMCompletTitleCellWithContent:(UITextField *)yytextView;

@end

@interface KMMCompletTitleCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLb;

@property (nonatomic,strong) UITextField *yyTextView;

@property (nonatomic,strong) id <KMMCompletTitleCellDelegate> delegate;

@property (nonatomic,strong) NSIndexPath *pathRow;



@end
