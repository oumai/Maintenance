//
//  KMMClassCell.h
//  Maintenance
//
//  Created by kmcompany on 2017/6/2.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMMClassModel.h"
#import "KMMClassToolView.h"

@protocol KMMClassCellDelegate <NSObject>

- (void)KMMClassCellDelegateReverseClass:(NSIndexPath *)pathRow;

- (void)KMMClassCellDelegateundercarriageClass:(NSIndexPath *)pathRow;

- (void)KMMClassCellDelegateEditClassWithType:(NSInteger)tag pathRow:(NSIndexPath *)pathRow;

@end

@interface KMMClassCell : UITableViewCell

@property (nonatomic,strong) UIImageView *playImage;

@property (nonatomic,strong) UILabel *catagoryLb;

@property (weak, nonatomic) IBOutlet UIImageView *classImage;

@property (weak, nonatomic) IBOutlet UILabel *classTitle;

@property (weak, nonatomic) IBOutlet UILabel *classSubTitle;

@property (nonatomic,strong) ClassData *classDataModel;

@property (nonatomic,strong) UIButton *reverseBtn;

@property (nonatomic,strong) UIButton *undercarriage;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;

@property (nonatomic,strong) KMMClassToolView *backView;

@property (nonatomic,strong) NSIndexPath *pathRow;

@property (nonatomic,strong) id <KMMClassCellDelegate> delegate;
@end
