//
//  HWKLocationManager.h
//  HealthBAT
//
//  Created by kmcompany on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface BATLocationManager : NSObject
+(instancetype)shareInstance;
-(void)startLocation;
@property(nonatomic,copy)void (^LocationBlock)(CLLocationCoordinate2D loaction);
@property(nonatomic,copy)void (^ErrorBlock)(NSError *error);
@end
