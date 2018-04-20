//
//  HWKLocationManager.m
//  HealthBAT
//
//  Created by kmcompany on 16/9/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATLocationManager.h"
@interface BATLocationManager()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@end
@implementation BATLocationManager


+(instancetype)shareInstance
{
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ BATLocationManager alloc]init];
    });
    return shareInstance;
}
-(void)startLocation
{
    _locationManager = [[CLLocationManager alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
    
        return;
    }
    
    // 设置定位精度，十米，百米，最好
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    _locationManager.delegate = self;
    
    // 开始时时定位
    [_locationManager startUpdatingLocation];
}

// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");
}

// 6.0 以上调用这个函数
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
    
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    
    self.LocationBlock(oldCoordinate);
    //    CLLocation *newLocation = locations[1];
    //    CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
    //    NSLog(@"经度：%f,纬度：%f",newCoordinate.longitude,newCoordinate.latitude);
    
    // 计算两个坐标距离
    //    float distance = [newLocation distanceFromLocation:oldLocation];
    //    NSLog(@"%f",distance);
    
   
    
    //------------------位置反编码---5.0之后使用-----------------
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:newLocation
//                   completionHandler:^(NSArray *placemarks, NSError *error){
//                       if (!error && [placemarks count] > 0) {
//                           NSLog(@"success");
//                       }
//                       for (CLPlacemark *place in placemarks) {
////                           UILabel *label = (UILabel *)[self.window viewWithTag:101];
////                           label.text = place.name;
//                           NSLog(@"name,%@",place.name);                       // 位置名
//                           //                           NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
//                           //                           NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
//                           //                           NSLog(@"locality,%@",place.locality);               // 市
//                           //                           NSLog(@"subLocality,%@",place.subLocality);         // 区
//                           //                           NSLog(@"country,%@",place.country);                 // 国家
//                       }
//                       
//                   }];
    
    
    [_locationManager stopUpdatingLocation];

    /* 测试使用
    CLLocation *c = [[CLLocation alloc] initWithLatitude:oldCoordinate.latitude longitude:oldCoordinate.longitude];
    //创建位置
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    [revGeo reverseGeocodeLocation:c
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     if (!error && [placemarks count] > 0)
                     {
                         NSDictionary *dict =
                         [[placemarks objectAtIndex:0] addressDictionary];
                            }
                     else
                     {  
                          }
                 }];
     */
}

// 6.0 调用此函数
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
   
}

@end
