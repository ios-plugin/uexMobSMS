//
//  EUExMobSMS.m
//  EUExMobSMS
//
//  Created by 杨广 on 16/1/8.
//  Copyright © 2016年 杨广. All rights reserved.
//

#import "EUExMobSMS.h"
#import <UIKit/UIKit.h>
#import "EUtility.h"
#import "SMS_SDK/SMSSDK.h"

@implementation EUExMobSMS
//+ (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
////    //      测试Key
////    //NSString* appKey =@"e5c90ea53640";
////    //NSString *appSecret = @"d2ec92c2e5de325c52fc53bdb63374fc";
////    //    <config desc="uexMobSMS" type="KEY">
////    //    <param platform="iOS" name="$uexMobSMS_APPKey$"        value="e5c90ea53640"/>
////    //    <param platform="iOS" name="$uexMobSMS_APPSecret$" value="d2ec92c2e5de325c52fc53bdb63374fc"/>
////    //    </config>
////    NSString *appKey=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"uexMobSMS_APPKey"];
////    NSString *appSecret=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"uexMobSMS_APPSecret"];
////    [SMSSDK registerApp:appKey withSecret:appSecret];
//    return YES;
//}
//-(id)initWithBrwView:(EBrowserView *) eInBrwView {
//    if (self = [super initWithBrwView:eInBrwView]) {
//        
//    }
//    return self;
//}
-(void)init:(NSMutableArray *)inArguments{
    
    if (inArguments.count > 0) {
        ACArgsUnpack(NSDictionary*dic) = inArguments;
        NSString* appKey = [dic objectForKey:@"uexMobSMS_APPKey"];
        NSString *appSecret = [dic objectForKey:@"uexMobSMS_APPSecret"];
        [SMSSDK registerApp:appKey withSecret:appSecret];
        
    }else{
        return;
    }
    
}



-(void)sendCode:(NSMutableArray *)inArguments {
    NSString *phone = nil;
    NSString *countryCode = nil;
    ACJSFunctionRef *func = nil;
    if (inArguments.count > 0) {
        ACArgsUnpack(NSDictionary*dic) = inArguments;
        phone = [NSString stringWithFormat:@"%@",[dic objectForKey:@"phoneNum"]];
        countryCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"countryCode"]];
        func = JSFunctionArg(inArguments.lastObject);
        
    }else{
        return;
    }
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:countryCode customIdentifier:nil result:^(NSError *error) {
        if (error) {
            NSLog(@"getVerificationCode:%@", error);
            NSString *status = @"1";
            NSDictionary *dic = @{@"status":status,@"errorCode":@(error.code),@"msg":error.userInfo[@"getVerificationCode"]};
            [self.webViewEngine callbackWithFunctionKeyPath:@"uexMobSMS.cbSendClick" arguments:ACArgsPack(dic)];
            [func executeWithArguments:ACArgsPack(@(error.code),@{@"msg":error.userInfo[@"getVerificationCode"]})];
        }else{
            NSString *status = @"0";
            NSDictionary *dic = @{@"status":status};
             [self.webViewEngine callbackWithFunctionKeyPath:@"uexMobSMS.cbSendClick" arguments:ACArgsPack(dic)];
             [func executeWithArguments:ACArgsPack(@(0))];
        }
    }];
}
- (void)commitCode:(NSMutableArray *)inArguments{
    NSString *countryCode = nil;
    NSString *phone = nil;
    NSString *validCode = nil;
    ACJSFunctionRef *func = nil;
    if (inArguments.count > 0) {
        ACArgsUnpack(NSDictionary*dic) = inArguments;
        phone = [NSString stringWithFormat:@"%@",[dic objectForKey:@"phoneNum"]];
        countryCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"countryCode"]];
        validCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"validCode"]];
        func = JSFunctionArg(inArguments.lastObject);
    }else{
        return;
    }
    [SMSSDK commitVerificationCode:validCode phoneNumber:phone zone:countryCode result:^(SMSSDKUserInfo *userInfo,NSError *error) {
        if (error) {
            NSLog(@"commitVerificationCode:%@", error);
            NSDictionary *dic = @{@"status":@1,@"errorCode":@(error.code),@"msg":error.userInfo[@"commitVerificationCode"]};
            [self.webViewEngine callbackWithFunctionKeyPath:@"uexMobSMS.cbCommitClick" arguments:ACArgsPack(dic)];
            [func executeWithArguments:ACArgsPack(@(error.code),@{@"msg":error.userInfo[@"commitVerificationCode"]})];
        }else{
            NSDictionary *dic = @{@"status":@"0"};
            [self.webViewEngine callbackWithFunctionKeyPath:@"uexMobSMS.cbCommitClick" arguments:ACArgsPack(dic)];
            [func executeWithArguments:ACArgsPack(@(0))];
            
        }
    }];
}
@end
