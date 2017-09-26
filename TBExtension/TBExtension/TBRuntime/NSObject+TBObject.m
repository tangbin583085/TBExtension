//
//  NSObject+TBObject.m
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/21.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "NSObject+TBObject.h"
#import <objc/runtime.h>

#define  tbKey @"tbKey"

@implementation NSObject (TBObject)

// ********************************model转字典****************************

- (NSArray *)tb_keyValuesArrayWithObjectArray:(NSArray *)array {
    NSMutableArray *arrayTemp = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSObject *object = obj;
        NSDictionary *dic = object.tb_keyValue;
        [arrayTemp addObject:dic];
    }];
    return arrayTemp;
}


- (NSDictionary *)tb_keyValue{
    NSString *className = NSStringFromClass([self class]);
    Class clz = objc_getClass([className UTF8String]);
    NSArray *properties = [clz getProperties][0];
    NSArray *propertiesAttr = [clz getProperties][1];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    // 遍历所有属性
    [properties enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *propertyKey = properties[idx];
        
        // 替换的key 并且获取替换key的value
        NSDictionary *replaceDic = [clz tb_repalceKeyForValue];
        NSString *destinationKey = @"";
        id value = [self valueForKeyPath:propertyKey];
        if (replaceDic.count > 0 && replaceDic[propertyKey]) {
            destinationKey = replaceDic[propertyKey];
        }else{
            destinationKey = propertyKey;
        }
        
        // 非基本类型检测
        NSString *arrtString = propertiesAttr[idx];
        NSString *className = [clz getClassName:arrtString];
        if (className.length > 0 && value != nil) {
            
            // 数组复杂类型
            if ([value isKindOfClass:[NSArray class]]) {
                NSArray *valueArray = value;
                NSMutableArray *tempArray = [NSMutableArray array];
                [valueArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSObject *object = value[idx];
                    [tempArray addObject:object.tb_keyValue];
                }];
                dic[destinationKey] = tempArray;
            }else {// 单个复杂类型
                NSObject *object = value;
                NSDictionary *dicIn = object.tb_keyValue;
                dic[destinationKey] = dicIn;
            }

        }else {// 基本类型检测
            dic[destinationKey] = value;
        }
    }];
    return dic;
}

// ********************************model转字典****************************

// ********************************字典转model****************************
+ (NSArray *)tb_objectWithKeyValueArray:(NSArray *)array{
    NSMutableArray *tempArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id person = [self tb_objectWithKeyValue:obj];
        [tempArray addObject:person];
    }];
    return tempArray;
}

+ (instancetype)tb_objectWithKeyValue:(id)source{
    
    NSDictionary *dicTemp = nil;
    if([source isKindOfClass:[NSDictionary class]]){
        dicTemp = source;
    }else if([source isKindOfClass:[NSString class]]){
        dicTemp = [self toArrayOrDic:source];
    }
    
    id person = [[self alloc] init];
    NSArray *array = [self getProperties][0];
    NSArray *arrayArrt = [self getProperties][1];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *keyString = obj;
        
        // 替换的key 并且获取替换key的value
        NSDictionary *replaceDic = [self tb_repalceKeyForValue];
        id value = nil;
        Boolean hasValue = NO;
        if (replaceDic.count > 0 && dicTemp[replaceDic[keyString]]) {
            value = dicTemp[replaceDic[keyString]];
            hasValue = YES;
        }else if (dicTemp[keyString]) {
            value = dicTemp[keyString];
            hasValue = YES;
        }
        
        // 获取复杂类型类名
        NSString *attrString = arrayArrt[idx];
        NSString *className = [self getClassName:attrString];
        
        // 非基本类型转义
        if (className.length > 0 && hasValue && value != nil) {
            Class clz = objc_getClass([className UTF8String]);
            
            // 数组
            if ([[[clz alloc] init] isKindOfClass:[NSArray class]]) {
                
                NSArray *modeArray = value;
                NSMutableArray *array = [NSMutableArray array];
                // 获取类嵌套类类名
                Class classInArray = [self tb_classInArray][keyString];
                [modeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    // 赋值
                     id modelInArray = [classInArray tb_objectWithKeyValue:modeArray[idx]];
                    [array addObject:modelInArray];
                }];
                value = array;
                [person setValue:value forKeyPath:keyString];
            }else{// 非数组，即单个对象
                value = [clz tb_objectWithKeyValue:value];
                [person setValue:value forKeyPath:keyString];
            }

        }else if (hasValue) {// 基本类型 包括NSString
            [person setValue:value forKeyPath:keyString];
        }
        
    }];
    return person;
}
// ********************************字典转model****************************

/**
 根据属性参数获取类名

 @param attrString 属性参数字符串
 @return 返回类名字符串
 */
+ (NSString *)getClassName:(NSString *)attrString {
    NSString *className = @"";
    if ([attrString containsString:@"T@\""] && [attrString containsString:@"&"] ) {
        // 获取类名
        NSString *pattern = @"@\"\\w+\"";        //匹配规则
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
        
        //测试字符串
        NSArray *results = [regex matchesInString:attrString options:0 range:NSMakeRange(0, attrString.length)];
        
        if (results.count != 0) {
            for (NSTextCheckingResult* result in results) {
                //从NSTextCheckingResult类中取出range属性
                NSRange range = result.range;
                //从原文本中将字段取出并存入一个NSMutableArray中
                className = [attrString substringWithRange:range];
                
                // 去除@ " 特殊符号
                className = [className stringByReplacingOccurrencesOfString:@"@" withString:@""];
                className = [className stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            }
        }
    }
    return className;
}

+ (NSDictionary *)tb_classInArray{
    return nil;
}


#pragma mark <NSDictionary或NSArray转JsonString>
+ (NSString *)toJsongString:(id)arrayOrDic{
    
    NSData *dataTemp = nil;
    NSString *string = nil;
    // 如果是字符串
    if ([arrayOrDic isKindOfClass:[NSDictionary class]] || [arrayOrDic isKindOfClass:[NSArray class]]) {
        dataTemp = [self toJSONData:arrayOrDic];
        string = [[NSString alloc] initWithData:dataTemp encoding:NSUTF8StringEncoding];
    }else if([arrayOrDic isKindOfClass:[NSString class]]) {
        string = arrayOrDic;
    }
    return string;
}

+ (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

#pragma mark <JsonString 转 NSDictionary或NSArray>
+(id)toArrayOrDic:(id)source{
    
    NSData *dataTemp = nil;
    // 如果是字符串
    if ([source isKindOfClass:[NSString class]]) {
        NSString *dataString = (NSString *)source;
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        dataTemp = data;
    }else if([source isKindOfClass:[NSData class]]){
        dataTemp = source;
    }
    
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:dataTemp options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonObject != nil && error == nil) {
        return jsonObject;
    }else{
        return nil;
    }
}


// ********************************其他属性设置****************************
+ (NSDictionary *)tb_repalceKeyForValue{
    return nil;
}

// 获取属性
/**
 获取类属性，和属性值

 @return allArray[0]为属性名字，allArray[1]为属性参数
 */
+(NSArray *)getProperties {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    // 属性名字
    NSMutableArray *propertyArray = [NSMutableArray array];
    
    // 属性参数
    NSMutableArray *propertyAttrArray = [NSMutableArray array];
    NSArray *allArray = @[propertyArray, propertyAttrArray];
    for (int i = 0; i < count; i++) {
        objc_property_t pro = properties[i];
        const char *name = property_getName(pro);
        const char *nameAttr = property_getAttributes(pro);
        NSString *propertyName = [[NSString alloc] initWithUTF8String:name];
        NSString *propertyAttrName = [[NSString alloc] initWithUTF8String:nameAttr];
        [propertyArray addObject:propertyName];
        [propertyAttrArray addObject:propertyAttrName];
    }
    return allArray;
}




@end
