//
//  KMMNetworkSpeed.h
//  Maintenance
//
//  Created by kmcompany on 2017/7/7.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMMNetworkSpeed : NSObject

@property (nonatomic, copy, readonly) NSString * receivedNetworkSpeed;

@property (nonatomic, copy, readonly) NSString * sendNetworkSpeed;

+ (instancetype)shareNetworkSpeed;

- (void)startMonitoringNetworkSpeed;

- (void)stopMonitoringNetworkSpeed;

@end

/**
 *  @{@"received":@"100kB/s"}
 */
FOUNDATION_EXTERN NSString *const kNetworkReceivedSpeedNotification;

/**
 *  @{@"send":@"100kB/s"}
 */
FOUNDATION_EXTERN NSString *const kNetworkSendSpeedNotification;
