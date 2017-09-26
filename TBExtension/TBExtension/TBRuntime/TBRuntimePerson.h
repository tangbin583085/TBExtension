//
//  TBRuntimePerson.h
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/21.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBRuntimePersonSon.h"


@class TBRuntimePersonSon;
@interface TBRuntimePerson : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)int age;
@property (nonatomic, assign)BOOL isMale;

@property (nonatomic, strong)TBRuntimePersonSon *son;

@property (nonatomic, strong)NSMutableArray<TBRuntimePersonSon *> *sons;



@end
