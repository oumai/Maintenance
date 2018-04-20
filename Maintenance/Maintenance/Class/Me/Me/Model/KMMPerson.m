//
//  KMMPerson.m
//  Maintenance
//
//  Created by kmcompany on 2017/5/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMMPerson.h"

@implementation KMMPerson

MJExtensionCodingImplementation

+ (NSDictionary *)objectClassInArray{
    return @{@"Data" : [KMMPersonData class]};
}

@end

@implementation KMMPersonData

MJExtensionCodingImplementation

@end
