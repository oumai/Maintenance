//
//  KMMCompletContentCell.h
//  Maintenance
//
//  Created by kmcompany on 2017/7/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"

@protocol KMMCompletContentCellDelegate <NSObject>

- (void)KMMCompletContentCellWithContent:(YYTextView *)yytextView;

@end

@interface KMMCompletContentCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLb;

@property (nonatomic,strong) YYTextView *yyTextView;

@property (nonatomic,strong) id <KMMCompletContentCellDelegate> delegate;

@end
