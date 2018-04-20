//
//  BATPersonAvatarCell.h
//  CancerNeighbour
//
//  Created by Wilson on 15/10/28.
//  Copyright © 2015年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMMPerson.h"

@interface KMMPersonAvatarCell : UITableViewCell

/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  头像
 */
@property (nonatomic, strong) UIImageView *avatarImageView;


/**
 *  头像地址
 */
@property (nonatomic,strong) NSString *avatarPhotoPath;

@end
