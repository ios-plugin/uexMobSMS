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
    NSString *jsonStr = nil;
    if (inArguments.count > 0) {
        jsonStr = [inArguments objectAtIndex:0];
        self.json1Dict = [jsonStr ac_JSONValue];//将JSON类型的字符串转化为可变字典
        
    }else{
        return;
    }
    NSString* appKey = [self.json1Dict objectForKey:@"uexMobSMS_APPKey"];
    NSString *appSecret = [self.json1Dict objectForKey:@"uexMobSMS_APPSecret"];
    [SMSSDK registerApp:appKey withSecret:appSecret];
}



-(void)sendCode:(NSMutableArray *)inArguments {
    NSString *jsonStr = nil;
    ACJSFunctionRef *func = nil;
    if (inArguments.count > 0) {
        
        jsonStr = [inArguments objectAtIndex:0];
        self.jsonDict = [jsonStr ac_JSONValue];//将JSON类型的字符串转化为可变字典
        func = JSFunctionArg(inArguments.lastObject);
        
    }else{
        return;
    }
    
    NSString *phone = [self.jsonDict objectForKey:@"phoneNum"];
    NSString *countryCode = [self.jsonDict objectForKey:@"countryCode"];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:countryCode customIdentifier:nil result:^(NSError *error) {
        if (error) {
            NSLog(@"getVerificationCode:%@", error);
            NSString *status = @"1";
            NSDictionary *dic = @{@"status":status,@"errorCode":@(error.code),@"msg":error.userInfo[@"getVerificationCode"]};
            //NSString *dicStr = [dic ac_JSONFragment];
            //NSString *jsString = [NSString stringWithFormat:@"uexMobSMS.cbSendClick(%@);",dicStr];
            //[EUtility brwView:meBrwView evaluateScript:jsString];
            [self.webViewEngine callbackWithFunctionKeyPath:@"uexMobSMS.cbSendClick" arguments:ACArgsPack(dic)];
            [func executeWithArguments:ACArgsPack(dic)];
        }else{
            //NSString *msg = @"获取验证码成功";
            NSString *status = @"0";
            NSDictionary *dic = @{@"status":status};
            //NSString *dicStr = [dic ac_JSONFragment];
            //NSString *jsString = [NSString stringWithFormat:@"uexMobSMS.cbSendClick(%@);",dicStr];
            //[EUtility brwView:meBrwView evaluateScript:jsString];
             [self.webViewEngine callbackWithFunctionKeyPath:@"uexMobSMS.cbSendClick" arguments:ACArgsPack(dic)];
             [func executeWithArguments:ACArgsPack(dic)];
        }
    }];
}
- (void)commitCode:(NSMutableArray *)inArguments{
    NSString *jsonStr = nil;
    ACJSFunctionRef *func = nil;
    if (inArguments.count > 0) {
        jsonStr = [inArguments objectAtIndex:0];
        self.jsonDict = [jsonStr ac_JSONValue];
        func = JSFunctionArg(inArguments.lastObject);
    }else{
        return;
    }
    
    NSString *phone = [self.jsonDict objectForKey:@"phoneNum"];
    NSString *countryCode = [self.jsonDict objectForKey:@"countryCode"];
    NSString *validCode = [self.jsonDict objectForKey:@"validCode"];

    [SMSSDK commitVerificationCode:validCode phoneNumber:phone zone:countryCode result:^(NSError *error) {
        if (error) {
            NSLog(@"commitVerificationCode:%@", error);
            NSDictionary *dic = @{@"status":@1,@"errorCode":@(error.code),@"msg":error.userInfo[@"commitVerificationCode"]};
            //NSString *dicStr = [dic ac_JSONFragment];
            //NSString *jsString = [NSString stringWithFormat:@"uexMobSMS.cbCommitClick(%@);",dicStr];
            //[EUtility brwView:meBrwView evaluateScript:jsString];
             [self.webViewEngine callbackWithFunctionKeyPath:@"uexMobSMS.cbCommitClick" arguments:ACArgsPack(dic)];
            [func executeWithArguments:ACArgsPack(dic)];
        }else{
            //NSString *msg = @"验证成功";
            NSDictionary *dic = @{@"status":@"0"};
            //NSString *dicStr = [dic ac_JSONFragment];
            //NSString *jsString = [NSString stringWithFormat:@"uexMobSMS.cbCommitClick(%@);",dicStr];
            //[EUtility brwView:meBrwView evaluateScript:jsString];
            [self.webViewEngine callbackWithFunctionKeyPath:@"uexMobSMS.cbCommitClick" arguments:ACArgsPack(dic)];
            [func executeWithArguments:ACArgsPack(dic)];
            
        }
    }];
}
@end
