//
//  HttpObject.m
//  MDLiveShow
//
//  Created by 黄佳峰 on 2017/3/10.
//  Copyright © 2017年 TianWei You. All rights reserved.
//

#import "HttpObject.h"
#import "AFNetworking.h"

@implementation HttpObject

+(NSDictionary*)getRYRequestHeader{
    NSString*App_Key=@"qf3d5gbjqe9kh";
    NSString*Nonce=[NSString stringWithFormat:@"%u",arc4random()];
    NSString*Timestamp=[DBTools getTime];
    NSString*secret=@"vzr6OeOFA9";
    NSString*jointStr=[NSString stringWithFormat:@"%@%@%@",secret,Nonce,Timestamp];
    NSString*Signature=[DBTools sha1:jointStr];
    NSDictionary*requestHeader=@{@"RC-App-Key":App_Key,@"RC-Nonce":Nonce,@"RC-Timestamp":Timestamp,@"RC-Signature":Signature};
    
    
    return requestHeader;
    
    
}

@end
