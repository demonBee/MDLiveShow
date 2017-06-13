//
//  StoreBuyViewController.h
//  DBMDLiveShow
//
//  Created by 黄佳峰 on 2017/4/27.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>


typedef NS_ENUM(NSInteger,purchaseType){
    purchaseTypeIAP6=0,
    purchaseTypeIAP30,
    purchaseTypeIAP50,
    purchaseTypeIAP98,
    purchaseTypeIAP388,
    
};

@interface StoreBuyViewController : UIViewController<SKPaymentTransactionObserver,SKProductsRequestDelegate >


@property(nonatomic,assign)purchaseType ToBuyType;   //这个点击的是哪种购买
@property(nonatomic,strong)NSString*buyTypeID;  //该种购买对应的ID
@property(nonatomic,strong)SKProduct *currentPro; //当前的产品



//点击 充值的金额
-(void)buyWithType:(purchaseType)type;

- (void) requestProUpgradeProductData;

-(void)RequestProductData;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction;

- (void) completeTransaction: (SKPaymentTransaction *)transaction;

- (void) failedTransaction: (SKPaymentTransaction *)transaction;

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction;

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error;

//- (void) restoreTransaction: (SKPaymentTransaction *)transaction;

-(void)provideContent:(NSString *)product;

-(void)recordTransaction:(NSString *)product;


@end
