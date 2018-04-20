//
//  KMMFeedBackContentCell.h
//  Maintenance
//
//  Created by kmcompany on 2017/6/7.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMMFeedBackContentCellDelegate <NSObject>

- (void)KMMFeedBackContentCellTextViewDidChange:(UITextView *)textView;

@end

@interface KMMFeedBackContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic,strong) id <KMMFeedBackContentCellDelegate> delegate;

@end
