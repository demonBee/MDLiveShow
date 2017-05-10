//
//  PickerChoiceView.h
//  TFPickerView
//
//  Created by TF_man on 16/5/11.
//  Copyright © 2016年 tituanwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFPickerDelegate <NSObject>

@optional;

- (void)PickerSelectorIndixString:(NSString *)str;

- (void)PickerSelectorIndixColour:(UIColor *)color;


@end

typedef NS_ENUM(NSInteger, ARRAYTYPE) {
    GenderArray,    //性别
    HeightArray,     //身高
    weightArray,    //体重
    DeteArray,        //日期
    DeteAndTimeArray,   //日期和时间
    ColourArray
    
    
};

@interface PickerChoiceView : UIView
//设置类型
@property (nonatomic, assign) ARRAYTYPE arrayType;

@property (nonatomic,assign)id<TFPickerDelegate>delegate;
//选中
@property (nonatomic,strong)NSString *selectStr;

//自定义类型
@property (nonatomic, strong) NSArray *customArr;
//标题的名字
@property (nonatomic,strong)UILabel *selectLb;
@end
