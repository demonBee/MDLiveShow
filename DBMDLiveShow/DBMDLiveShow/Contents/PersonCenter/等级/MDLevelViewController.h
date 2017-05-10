//
//  MDLevelViewController.h
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/1/23.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDLevelViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *tips;


@property (weak, nonatomic) IBOutlet UIImageView *coustmerBG;
@property (weak, nonatomic) IBOutlet UIImageView *customerImage;
@property (weak, nonatomic) IBOutlet UILabel *customerLevel;
@property (weak, nonatomic) IBOutlet UILabel *customerAllEX;
@property (weak, nonatomic) IBOutlet UILabel *toUpgrade;    //距离下一次升级 差的经验


@property (weak, nonatomic) IBOutlet UIImageView *anchorBG;
@property (weak, nonatomic) IBOutlet UIImageView *ancherImage;
@property (weak, nonatomic) IBOutlet UILabel *anchorLevel;
@property (weak, nonatomic) IBOutlet UILabel *anchorAllEX;
@property (weak, nonatomic) IBOutlet UILabel *anchorToUprade;



@end
