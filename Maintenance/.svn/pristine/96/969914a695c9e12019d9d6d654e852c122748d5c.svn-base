//
//  KMMVideoCell.m
//  videoTest
//
//  Created by kmcompany on 2017/6/30.
//  Copyright © 2017年 kmcompany. All rights reserved.
//

#import "KMMVideoCell.h"

@implementation KMMVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setVideoModel:(AlbumVideoInfo *)videoModel {

    _videoModel = videoModel;
    
    self.videoImage.image = videoModel.videoImage;
    self.timeLb.text = [self getTimeLb:videoModel.duration];
    
    
}

-(NSString *)getTimeLb:(NSInteger)timeData{
    

    
    NSString *timeString = nil;
    NSInteger time= timeData;
    
    NSInteger hour = time/3600;
    NSInteger mins = time/60;
    NSInteger seconds = time%60;
    
    timeString = [NSString stringWithFormat:@"%.2zd:%.2zd:%.2zd",hour,mins,seconds];
    return timeString;
}





@end
