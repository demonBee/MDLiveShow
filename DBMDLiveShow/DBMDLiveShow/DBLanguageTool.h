//
//  DBLanguageTool.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/5/8.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DBGetStringWithKeyFromTable(key, tbl)  [DBLanguageTool getStringForKey:key withTable:tbl]

#define CNS @"zh-Hans"
#define EN @"en"
#define CURRENT_Language @"currentLanguage"
#define UserDefaults [NSUserDefaults standardUserDefaults]


@interface DBLanguageTool : NSObject

+(void)initUserLanguage;//初始化语言文件      1

+(NSBundle *)bundle;//获取当前资源文件      2

+(NSString *)userLanguage;//获取应用当前语言    2

+(void)setUserlanguage:(NSString *)language;//设置当前语言   3

//吊用方法
+(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

@end
