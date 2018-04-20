//
//  Transformer.m
//  WeiboS
//
//  Created by KM on 16/12/202016.
//  Copyright © 2016年 Skybrim. All rights reserved.
//

#import "Transformer.h"

@implementation Transformer

+ (NSData *)dataWithResponseObject:(id)responseObject
{
    NSMutableData* data = [[NSMutableData alloc]init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:responseObject forKey:@"requestData"];
    [archiver finishEncoding];

    return data;
}

+ (id)responseObjectWithData:(NSData*)data
{
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    id responseObject = [unarchiver decodeObjectForKey:@"requestData"];
    [unarchiver finishDecoding];
    return responseObject;
}

+ (NSDictionary *)dictionaryWithData:(NSData *)data
{

    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *tmpData = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (!tmpData) {
        return @{};
    }
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:tmpData options:NSJSONReadingMutableLeaves error:nil];

    return dictionary;
}


@end
