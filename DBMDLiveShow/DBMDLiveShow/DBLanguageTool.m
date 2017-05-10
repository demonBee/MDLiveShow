//
//  DBLanguageTool.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/5/8.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "DBLanguageTool.h"


@interface DBLanguageTool()


@property(nonatomic,copy)NSString *language;

@end

static DBLanguageTool *sharedModel;

@implementation DBLanguageTool

static NSBundle *bundle = nil;

+ ( NSBundle * )bundle{
    
    return bundle;
    
}



+(void)initUserLanguage{
    
   
    
    NSString *string = [UserDefaults valueForKey:CURRENT_Language];
    NSString *current=nil;
    
    if(string.length == 0){
        
        //获取系统当前语言版本(中文zh-Hans,英文en)
        
        NSArray* languages = [UserDefaults objectForKey:@"AppleLanguages"];
        if ([[languages objectAtIndex:0] hasPrefix:@"en"]) {
            current  = EN;
            [UserDefaults setObject:EN forKey:CURRENT_Language];
        }else{
            current=CNS;
            [UserDefaults setObject:CNS forKey:CURRENT_Language];
        }
        
        
        
        string = current;
        
        [UserDefaults setValue:current forKey:CURRENT_Language];
        
        [UserDefaults synchronize];//持久化，不加的话不会保存
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}


+(NSString *)userLanguage{
  
    NSString *language = [UserDefaults valueForKey:CURRENT_Language];
    
    return language;
}


+(void)setUserlanguage:(NSString *)language{
    
    
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    
    bundle = [NSBundle bundleWithPath:path];
    
    //2.持久化
    [UserDefaults setValue:language forKey:CURRENT_Language];
    
    [UserDefaults synchronize];
}


+(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table
{
    if (bundle)
    {
        //偷懒写法
        if (!table) {
            return NSLocalizedStringFromTableInBundle(key, @"Language", bundle, @"");
        }
        
        return NSLocalizedStringFromTableInBundle(key, table, bundle, @"");
    }
    
    return NSLocalizedStringFromTable(key, table, @"");
}

@end
