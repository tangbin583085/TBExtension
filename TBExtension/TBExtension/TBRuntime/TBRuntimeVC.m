//
//  TBRuntimeVC.m
//  com.pintu.aaaaaa
//
//  Created by hanchuangkeji on 2017/9/21.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBRuntimeVC.h"
#import "NSObject+TBObject.h"
#import "TBRuntimePerson.h"
#import "TBRuntimePersonSon.h"
#import <objc/runtime.h>
#import "MJExtension.h"

@interface TBRuntimeVC ()
{
    int tangbinInt;
}

@property (nonatomic, copy)NSString *privateName;

@property (nonatomic, copy)NSString *ageString;

@end

@implementation TBRuntimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)btnClick:(id)sender {
    
    NSDictionary *dic = @{@"name" : @"tangbin1", @"age" : [NSNumber numberWithInt:18], @"lastName" : @"tang"};
    
    TBRuntimePerson *person = [TBRuntimePerson tb_objectWithKeyValue:dic];
    NSLog(@"person.name:%@,    person.age:%d", person.name, person.age);
    
}


- (IBAction)btn3Click:(id)sender {
    NSString *jsonString = @"{\"name2\":\"Jack\", \"icon\":\"lufy.png\", \"age\":\"20\", \"myArray\" : [\"1\", \"21\"]}";
    
    TBRuntimePerson *person = [TBRuntimePerson tb_objectWithKeyValue:jsonString];
    NSLog(@"person.name:%@,    person.age:%d", person.name, person.age);
}

- (IBAction)btn4Click:(id)sender {
    NSDictionary *dicSon =  @{@"sonName" : @"tangbin'Son", @"sonAge" : @"12"};
    NSDictionary *dic = @{@"name" : @"tangbin", @"age" : @"22", @"son" : dicSon};
    
    TBRuntimePerson *person = [TBRuntimePerson tb_objectWithKeyValue:dic];
    NSLog(@"person.name:%@,    person.age:%d, son.name:%@, son.age:%d", person.name, person.age, person.son.sonName, person.son.sonAge);
}

- (IBAction)modelInArray:(id)sender {
    
    
    NSDictionary *dicSon0 =  @{@"sonName" : @"大儿子", @"sonAge" : @"12"};
    
    NSDictionary *dicSon1 =  @{@"sonName" : @"第2儿子", @"sonAge" : @"11"};
    
    NSDictionary *dicSon2 =  @{@"sonName" : @"第3儿子", @"sonAge" : @"10"};
    
    NSDictionary *dicSon3 =  @{@"sonName" : @"第4儿子", @"sonAge" : @"9"};
    
    NSDictionary *dic = @{@"name" : @"tangbin", @"age" : @"22", @"son" : dicSon0, @"sons2" : @[dicSon1, dicSon2, dicSon3]};
    
    TBRuntimePerson *person = [TBRuntimePerson tb_objectWithKeyValue:dic];
    NSLog(@"person.name:%@,    person.age:%d, son.name:%@, son.age:%d, %@", person.name, person.age, person.son.sonName, person.son.sonAge,  person.sons);
    
}

- (IBAction)JSonArrayToModelArray:(id)sender {
    NSDictionary *dic1 = @{@"name2" : @"tangbin1", @"age" : [NSNumber numberWithInt:11], @"lastName" : @"tang", @"isMale" : @1};
    
    NSDictionary *dic2 = @{@"name2" : @"tangbin2", @"age" : [NSNumber numberWithInt:22], @"lastName" : @"tang", @"isMale" : @"NO"};
    
    NSDictionary *dic3 = @{@"name2" : @"tangbin3", @"age" : [NSNumber numberWithInt:33], @"lastName" : @"tang", @"isMale" : @"YES"};
    
    NSDictionary *dic4 = @{@"name2" : @"tangbin4", @"age" : [NSNumber numberWithInt:44], @"lastName" : @"tang"};
    
    NSArray *array = @[dic1, dic2, dic3, dic4];
    
    NSArray *modelArray = [TBRuntimePerson tb_objectWithKeyValueArray:array];
    NSLog(@"%@", modelArray);
}


- (IBAction)modelToJson:(id)sender {
    TBRuntimePersonSon *son = [[TBRuntimePersonSon alloc] init];
    son.sonAge = 13;
    son.sonName = @"TomSon";
    
    NSDictionary *dic = son.tb_keyValue;
    NSLog(@"%@", dic);
}

- (IBAction)modelToJson1:(id)sender {
    TBRuntimePersonSon *son0 = [[TBRuntimePersonSon alloc] init];
    son0.sonAge = 13;
    son0.sonName = @"TomSon0";
    
    TBRuntimePerson *person = [[TBRuntimePerson alloc] init];
    person.name = @"tangbin";
    person.age = 24;
    person.isMale = YES;
    person.son = son0;
    
    NSDictionary *dic = person.tb_keyValue;
    NSLog(@"%@", dic);
}

- (IBAction)modelToJson2:(id)sender {
    TBRuntimePersonSon *son0 = [[TBRuntimePersonSon alloc] init];
    son0.sonAge = 13;
    son0.sonName = @"TomSon0";
    
    TBRuntimePersonSon *son1 = [[TBRuntimePersonSon alloc] init];
    son1.sonAge = 12;
    son1.sonName = @"TomSon1";
    
    TBRuntimePersonSon *son2 = [[TBRuntimePersonSon alloc] init];
    son2.sonAge = 11;
    son2.sonName = @"TomSon2";
    
    TBRuntimePersonSon *son3 = [[TBRuntimePersonSon alloc] init];
    son3.sonAge = 10;
    son3.sonName = @"TomSon3";
    
    TBRuntimePerson *person = [[TBRuntimePerson alloc] init];
    person.name = @"tangbin";
    person.age = 24;
    person.isMale = YES;
    person.son = son0;
    NSMutableArray *sonArray = [NSMutableArray arrayWithArray:@[son1, son2, son3]];
    person.sons = sonArray;
    
    NSDictionary *dic = person.tb_keyValue;
    NSLog(@"%@", dic);
}


- (IBAction)modelJsonArray:(id)sender {
    
    TBRuntimePersonSon *son0 = [[TBRuntimePersonSon alloc] init];
    son0.sonAge = 13;
    son0.sonName = @"TomSon0";

    TBRuntimePersonSon *son1 = [[TBRuntimePersonSon alloc] init];
    son1.sonAge = 12;
    son1.sonName = @"TomSon1";

    TBRuntimePersonSon *son2 = [[TBRuntimePersonSon alloc] init];
    son2.sonAge = 11;
    son2.sonName = @"TomSon2";

    TBRuntimePersonSon *son3 = [[TBRuntimePersonSon alloc] init];
    son3.sonAge = 10;
    son3.sonName = @"TomSon3";

    TBRuntimePerson *person = [[TBRuntimePerson alloc] init];
    person.name = @"tangbin";
    person.age = 24;
    person.isMale = YES;
    person.son = son0;
    NSMutableArray *sonArray = [NSMutableArray arrayWithArray:@[son1, son2, son3]];
    person.sons = sonArray;
    
    TBRuntimePersonSon *son20 = [[TBRuntimePersonSon alloc] init];
    son20.sonAge = 13;
    son20.sonName = @"TomSon0";
    
    TBRuntimePersonSon *son21 = [[TBRuntimePersonSon alloc] init];
    son21.sonAge = 12;
    son21.sonName = @"TomSon1";
    
    TBRuntimePersonSon *son22 = [[TBRuntimePersonSon alloc] init];
    son22.sonAge = 11;
    son22.sonName = @"TomSon2";
    
    TBRuntimePersonSon *son23 = [[TBRuntimePersonSon alloc] init];
    son23.sonAge = 10;
    son23.sonName = @"TomSon3";
    
    TBRuntimePerson *person2 = [[TBRuntimePerson alloc] init];
    person2.name = @"tangbin";
    person2.age = 24;
    person2.isMale = YES;
    person2.son = son20;
    NSMutableArray *sonArray2 = [NSMutableArray arrayWithArray:@[son21, son22, son23]];
    person2.sons = sonArray2;
    
    NSArray *array = [TBRuntimePerson tb_keyValuesArrayWithObjectArray:@[person, person2]];
    NSLog(@"%@", array);
}

- (IBAction)mjCoding:(id)sender {
    
    TBRuntimePersonSon *son0 = [[TBRuntimePersonSon alloc] init];
    son0.sonAge = 13;
    son0.sonName = @"TomSon0";
    
    TBRuntimePersonSon *son1 = [[TBRuntimePersonSon alloc] init];
    son1.sonAge = 12;
    son1.sonName = @"TomSon1";
    
    TBRuntimePersonSon *son2 = [[TBRuntimePersonSon alloc] init];
    son2.sonAge = 11;
    son2.sonName = @"TomSon2";
    
    TBRuntimePersonSon *son3 = [[TBRuntimePersonSon alloc] init];
    son3.sonAge = 10;
    son3.sonName = @"TomSon3";
    
    TBRuntimePerson *person = [[TBRuntimePerson alloc] init];
    person.name = @"tangbin";
    person.age = 24;
    person.isMale = YES;
    person.son = son0;
    NSMutableArray *sonArray = [NSMutableArray arrayWithArray:@[son1, son2, son3]];
    person.sons = sonArray;
    
    #define FOFUserFileName [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"user.data"]
    
    NSString *file = FOFUserFileName;
    // Encoding
    Boolean bb = [NSKeyedArchiver archiveRootObject:person toFile:file];
    NSLog(@"%d", bb);
    // Decoding
    TBRuntimePerson *personTemp = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    NSLog(@"name=%@, sons=%@", personTemp.name, personTemp.sons);
    
}

@end
