//
//  Transformer.h
//  WeiboS
//
//  Created by KM on 16/12/202016.
//  Copyright © 2016年 Skybrim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transformer : NSObject


/**
 返回数据转NSData

 @param responseObject 返回数据
 @return NSData
 */
+ (NSData *)dataWithResponseObject:(id)responseObject;


/**
 NSData转返回类型

 @param data NSData
 @return 返回类型
 */
+ (id)responseObjectWithData:(NSData*)data;


/**
 NSData转json字典

 @param data NSData
 @return json字典
 */
+ (NSDictionary *)dictionaryWithData:(NSData *)data;

@end
