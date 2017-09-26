//
//  NSObject+TBObject.h
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/21.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TBObject)

// ********************************字典转model****************************
+ (NSArray *)tb_objectWithKeyValueArray:(NSArray *)array;

+ (instancetype)tb_objectWithKeyValue:(id)source;


// ********************************model转字典****************************
- (NSDictionary *)tb_keyValue;

- (NSArray *)tb_keyValuesArrayWithObjectArray:(NSArray *)array;


// ********************************其他属性设置****************************
+ (NSDictionary *)tb_repalceKeyForValue;

+ (NSDictionary *)tb_classInArray;

@end
