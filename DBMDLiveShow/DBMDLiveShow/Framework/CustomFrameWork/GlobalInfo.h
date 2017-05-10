//
//  GlobalInfo.h
//  GKAPP
//
//  Created by 黄佳峰 on 15/11/2.
//  Copyright © 2015年 黄佳峰. All rights reserved.
//

#ifndef GlobalInfo_h
#define GlobalInfo_h


#define HTTP_ADDRESS     @"http://api.zhiboquan.net"    //地址

#define HTTP_register    @"/api.php/Login/reg/"   //第三方注册账号
#define HTTP_RegisterCode   @"/api.php/Login/getRegisterCode/"  //获得短信验证码
#define HTTP_getPhoneOpenID    @"/api.php/Login/phoneReg/"   //得到phone的openID
#define HTTP_login       @"/api.php/Login/login/"  //登录
#define HTTP_advertiseStart   @"/api.php/Index/getAdCover/"  //开机启动时候的广告





#define HTTP_HomePage    @"/api.php/Zhibo/index/"  //首页
#define HTTP_TwoMainInfo  @"/api.php/Zhibo/getMyRoomInfo/"   //获取指定ID的所有信息和关系   最主要的接口
#define HTTP_Vedio       @"/api.php/Zhibo/getAnchorVideo/"  //获取录像的接口
#define HTTP_Advertisement    @"/api.php/Index/getAd/"   //得到广告
#define HTTP_Search      @"/api.php/User/search/"      //搜索
#define HTTP_SearchTitle   @"/api.php/Index/getKeyword/"  //搜索获取推荐的关键字


#define HTTP_UserAndAnchorRelation  @"/api.php/User/getIsFollowAnchor" //用户是否关注主播
#define HTTP_GetGift     @"/api.php/User/getGiftList/"   //得到礼物列表
#define HTTP_sendGift    @"/api.php/User/sendGift/"   //送礼物
#define HTTP_SignTo      @"/api.php/User/signShare/"   //每日签到和分享得到马币
#define HTTP_ShareInfo   @"/api.php/zhibo/share/"   //得到分享的信息
#define HTTP_watcherList @"/api.php/Zhibo/getSpectatorList/"  //top上的每隔30秒吊用一次
#define HTTP_intoRoom    @"/api.php/Zhibo/playRoom/"    //进入直播间
#define HTTP_leaveRoom   @"/api.php/Zhibo/leavePlayRoom/"  //离开某个直播间
#define HTTP_ChatRoomToken   @"/api.php/User/getRongToken"  //得到聊天室的token
#define HTTP_Report      @"/api.php/User/reportAnchor/"    //举报


#define HTTP_PullAddress    @"/api.php/Zhibo/beginAnchor/"   //推流
#define HTTP_RoomNameCity    @"/api.php/Zhibo/readyAnchor/"  //改变房间名和城市
#define HTTP_endLive        @"/api.php/Zhibo/endAnchor/"   //主播结束直播
#define HTTP_RealName       @"/api.php/User/idenAnchorInfo/"  //实名认证



#define HTTP_richmanList   @"/api.php/User/topConsume/"   //土豪榜
#define HTTP_BGList        @"/api.php/User/topAnchor/"   //主播榜



#define HTTP_personCenter  @"/api.php/User/myBaseInfo/"   //个人中心
#define HTTP_appPurchase   @"/api.php/User/iosAppBuy/"   //苹果内购
#define HTTP_PayRecords    @"/api.php/user/getIosPayLists"   //得到支付列表的接口  充值记录
#define HTTP_MyVideo       @"/api.php/index/getAnchorVideo"   //我自己的录像的接口
#define HTTP_PostImage     @"/api.php/Index/uploadImg/"   //上传图片
#define HTTP_ChangePersonInfo    @"/api.php/User/setMyBaseInfo/"  //更改个人资料
#define HTTP_Feedback          @"/api.php/User/suggest/"    //反馈
#define HTTP_AboutOur          @"/api.php/Index/aboutUs/"   //关于我们接口
#define HTTP_Level             @"/api.php/User/userLevel/"   //等级接口
#define HTTP_PayMoney         @"/api.php/User/payToMoney/"   //充值  (这个接口 已经没用了)
#define HTTP_PayRecord      @"/api.php/User/myConsumeLists/"   //消费记录
#define HTTP_GetMoneyRecord      @"/api.php/User/myZhiBoLists/"  //主播收益
#define HTTP_Follow          @"/api.php/User/myLikes/"   //我的关注
#define HTTP_Fans           @"/api.php/User/myFans/"     // 我的粉丝
#define HTTP_FOllowOrCancelFollow    @"/api.php/User/beFans/"   //添加关注 或者取消关注




#endif /* GlobalInfo_h */
