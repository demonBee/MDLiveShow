//
//  HttpManager.m
//  AliShake
//
//  Created by 李鹏博 on 15/10/16.
//  Copyright © 2015年 李鹏博. All rights reserved.
//

#import "HttpManager.h"
#import "AFNetworking.h"




@implementation HttpManager
//封装的get请求
-(void)getDataFromNetworkWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock{
    self.block =newBlock;
#pragma mark -----1
    HUD =[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].delegate.window];
    [[UIApplication sharedApplication].delegate.window addSubview:HUD];
    HUD.delegate =self;
    HUD.dimBackground = YES;
    [HUD show:YES];

    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.block(responseObject,nil);
        [HUD hide:YES];
        [HUD removeFromSuperview];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [HUD hide:YES];
        [HUD removeFromSuperview];
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];

    }];
    
    

    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];

//    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        
//        self.block(responseObject,nil);
//        [HUD hide:YES];
//        [HUD removeFromSuperview];
//        
//        
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        self.block(nil,error);
//        [HUD hide:YES];
//        [HUD removeFromSuperview];
//        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
//
//        
//    }];
}



//gei 请求 没有HUD
-(void)getDataFromNetworkNOHUDWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock{
    self.block =newBlock;
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];

    [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.block(responseObject,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
    }];

    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
//
//    [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        self.block(responseObject,nil);
//       
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        self.block(nil,error);
//        
//        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
//    }];

}


//post 上传图片
-(void)postDataUpDataPhotoWithUrl:(NSString*)urlString parameters:(id)parameters photo:(NSData*)data compliation:(resultBlock)newBlock{
    self.block =newBlock;
    HUD =[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].delegate.window];
    [[UIApplication sharedApplication].delegate.window addSubview:HUD];
    HUD.delegate =self;
    HUD.dimBackground = YES;
    [HUD show:YES];

    
    
    AFHTTPSessionManager*manager=[AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];


    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData*data1=data;
        [formData appendPartWithFileData:data1 name:@"img" fileName:@"headimage.png" mimeType:@"png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        MyLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.block(responseObject,nil);
        [HUD hide:YES];
        [HUD removeFromSuperview];

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [HUD hide:YES];
        [HUD removeFromSuperview];
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];

        
    }];

    
    
    
    
//        NSString * url = [urlString st:NSUTF8StringEncoding];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
//
//    __weak typeof(data) upData=data;
//    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSLog(@"%@",formData);
//        [formData appendPartWithFileData:upData name:@"img" fileName:@"headimage.png" mimeType:@"png"];
//    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        self.block(responseObject,nil);
//        [HUD hide:YES];
//             [HUD removeFromSuperview];
//        
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        NSLog(@"Error: %@", error);
//        self.block(nil,error);
//        [HUD hide:YES];
//             [HUD removeFromSuperview];
//        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
//
//    }];
    
}






-(void)postDataFromNetworkWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock{
    self.block=newBlock;
    HUD =[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].delegate.window];
    [[UIApplication sharedApplication].delegate.window addSubview:HUD];
    HUD.delegate =self;
    HUD.dimBackground = YES;
    [HUD show:YES];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];

    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.block(responseObject,nil);
        [HUD hide:YES];
        [HUD removeFromSuperview];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [HUD hide:YES];
        [HUD removeFromSuperview];
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];

    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
//
//    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.block(responseObject,nil);
//        [HUD hide:YES];
//         [HUD removeFromSuperview];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        self.block(nil,error);
//        [HUD hide:YES];
//         [HUD removeFromSuperview];
//        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
//    }];
}


//没有菊花的  post 请求
-(void)postDataFromNetworkNoHudWithUrl:(NSString*)urlString parameters:(id)parameters compliation:(resultBlock)newBlock{
    self.block=newBlock;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];

    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.block(responseObject,nil);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.block(nil,error);
        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
        
    }];

    
    
    
    
       //    NSString * url = [urlString st:NSUTF8StringEncoding];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
//
//    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.block(responseObject,nil);
//      
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        self.block(nil,error);
//      
//        [JRToast showWithText:@"连接超时,请检查网络" bottomOffset:70*KScreenWidth/320 duration:3.0f];
//    }];
}



@end
