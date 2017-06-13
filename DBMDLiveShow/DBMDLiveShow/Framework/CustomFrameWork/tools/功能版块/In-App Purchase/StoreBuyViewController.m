//
//  StoreBuyViewController.m
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/27.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "StoreBuyViewController.h"

//在内购项目中创的商品单号
#define ProductID_6 @"cn.duruikeji.MDLiveShow1"//6
#define ProductID_30 @"cn.duruikeji.MDLiveShow2" //30
#define ProductID_50 @"cn.duruikeji.MDLiveShow3" //50
#define ProductID_98 @"cn.duruikeji.MDLiveShow4" //98
#define ProductID_388 @"cn.duruikeji.MDLiveShow5" //388


@interface StoreBuyViewController ()

@property(nonatomic,strong) MBProgressHUD *hud;
@end

@implementation StoreBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];


}

-(void)buyWithType:(purchaseType)type
{
    //只要一点击购买 就弄个菊花
    _hud = [[MBProgressHUD alloc]initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:_hud];
    _hud.dimBackground=YES;
    [_hud show:YES];
    
    
    self.ToBuyType=type;

    if ([SKPaymentQueue canMakePayments]) {
        [self RequestProductData];
        NSLog(@"允许程序内付费购买");
    }
    else
    {
        [_hud removeFromSuperview];
        
        
        NSLog(@"不允许程序内付费购买");
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您的手机没有打开程序内付费购买"
                                                           delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];

        [alerView show];

    }
}


-(void)RequestProductData
{
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = nil;
    switch (_ToBuyType) {
        case purchaseTypeIAP6:
            self.buyTypeID=ProductID_6;
            product=[[NSArray alloc] initWithObjects:ProductID_6,nil];
            break;
        case purchaseTypeIAP30:
             self.buyTypeID=ProductID_30;
            product=[[NSArray alloc] initWithObjects:ProductID_30,nil];
            break;
        case purchaseTypeIAP50:
             self.buyTypeID=ProductID_50;
            product=[[NSArray alloc] initWithObjects:ProductID_50,nil];
            break;
        case purchaseTypeIAP98:
             self.buyTypeID=ProductID_98;
            product=[[NSArray alloc] initWithObjects:ProductID_98,nil];
            break;
        case purchaseTypeIAP388:
             self.buyTypeID=ProductID_388;
            product=[[NSArray alloc] initWithObjects:ProductID_388,nil];
            break;

        default:
            break;
    }
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];

}

//  <SKProductsRequestDelegate> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{

    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);

        if ([product.productIdentifier isEqualToString:self.buyTypeID]) {
            _currentPro=product;
            
        }
        
        
    }
    
    
    SKPayment *payment = nil;
    payment=[SKPayment paymentWithProduct:self.currentPro];

    
//    switch (_ToBuyType) {
//        case purchaseTypeIAP6:
////            payment  = [SKPayment paymentWithProductIdentifier:ProductID_6];    //支付6
//            payment=[SKPayment paymentWithProduct:self.currentPro];
//            break;
//        case purchaseTypeIAP30:
////            payment  = [SKPayment paymentWithProductIdentifier:ProductID_30];    //支付30
//             payment=[SKPayment paymentWithProduct:self.currentPro];
//            break;
//        case purchaseTypeIAP50:
////            payment  = [SKPayment paymentWithProductIdentifier:ProductID_50];    //支付50
//             payment=[SKPayment paymentWithProduct:self.currentPro];
//            break;
//        case purchaseTypeIAP98:
////            payment  = [SKPayment paymentWithProductIdentifier:ProductID_98];    //支付98
//             payment=[SKPayment paymentWithProduct:self.currentPro];
//            break;
//        case purchaseTypeIAP388:
////            payment  = [SKPayment paymentWithProductIdentifier:ProductID_388];    //支付388
//             payment=[SKPayment paymentWithProduct:self.currentPro];
//            break;
//        default:
//            break;
//    }
    NSLog(@"---------发送购买请求------------");
    [[SKPaymentQueue defaultQueue] addPayment:payment];

}

#pragma 我知不知道这鬼东西 什么用
- (void)requestProUpgradeProductData
{

    NSLog(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];

}

//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];

}

-(void) requestDidFinish:(SKRequest *)request
{
    [_hud removeFromSuperview];

    NSLog(@"----------反馈信息结束--------------");

}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}

// <SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{//交易完成
                [self completeTransaction:transaction];
                NSLog(@"-----交易完成 --------");

                UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"购买成功"
                                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];

                [alerView show];




            } break;
            case SKPaymentTransactionStateFailed://交易失败
            { [self failedTransaction:transaction];
                NSLog(@"-----交易失败 --------");
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"购买失败，请重新尝试购买"
                                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];

                [alerView2 show];

            }break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                NSLog(@"-----已经购买过该商品 --------");
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                //购买商品呀
//                [self buyWithType:self.ToBuyType];
                
                break;
            default:
                break;
        }
    }
}

#pragma 交易成功了
- (void) completeTransaction: (SKPaymentTransaction *)transaction

{
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    NSString *transactionReceiptString=[receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    if (transactionReceiptString.length<=0) {
        [JRToast showWithText:@"支付程序错误"];
        return;
    }else{
        //这里吊用接口  来验证支付成功与否  并成功之后给他充钱
        
//        [self verifyMoneySuccessInterface:transactionReceiptString];
        
        
        
    }
    
    // Remove the transaction from the payment queue.
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    
    
//    NSLog(@"-----completeTransaction--------");
//    // Your application should implement these two methods.
//    NSString *product = transaction.payment.productIdentifier;
//    if ([product length] > 0) {
//        //向自己的服务器验证购买凭证
//
//        NSArray *tt = [product componentsSeparatedByString:@"."];
//        NSString *bookid = [tt lastObject];
//        if ([bookid length] > 0) {
//            [self recordTransaction:bookid];
//            [self provideContent:bookid];
//        }
//    }
//
//    // Remove the transaction from the payment queue.
//
//    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

}

//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}


- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {

    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

}
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{

}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@" 交易恢复处理");

}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch([(NSHTTPURLResponse *)response statusCode]) {
        case 200:
        case 206:
            break;
        case 304:
            break;
        case 400:
            break;
        case 404:
            break;
        case 416:
            break;
        case 403:
            break;
        case 401:
        case 500:
            break;
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"test");
}

-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听

}


@end
