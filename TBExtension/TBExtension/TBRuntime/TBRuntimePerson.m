//
//  TBRuntimePerson.m
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/21.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBRuntimePerson.h"
#import "MJExtension.h"


@implementation TBRuntimePerson

MJExtensionCodingImplementation

+ (NSDictionary *)tb_repalceKeyForValue{
    return @{@"name" : @"name2", @"sons" : @"sons2"};
}

+ (NSDictionary *)tb_classInArray{
    return @{@"sons" : [TBRuntimePersonSon class]};
}


@end
