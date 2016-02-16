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
#import "JSON.h"
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
-(id)initWithBrwView:(EBrowserView *) eInBrwView {
    if (self = [super initWithBrwView:eInBrwView]) {
        
    }
    return self;
}
-(void)init:(NSMutableArray *)inArguments{
    NSLog(@"%d",self.initFirst);
    self.initFirst = YES;
    NSString *jsonStr = nil;
    if (inArguments.count > 0) {
        jsonStr = [inArguments objectAtIndex:0];
        self.json1Dict = [jsonStr JSONValue];//将JSON类型的字符串转化为可变字典
        
    }else{
        return;
    }
    NSString* appKey = [self.json1Dict objectForKey:@"uexMobSMS_APPKey"];
    NSString *appSecret = [self.json1Dict objectForKey:@"uexMobSMS_APPSecret"];
    [SMSSDK registerApp:appKey withSecret:appSecret];
}



-(void)sendCode:(NSMutableArray *)inArguments {
    if (!self.initFirst) {
        NSDictionary *dic = @{@"msg":@"uexMobSMS_APPKey or uexMobSMS_APPSecret is null !",@"status":@"1"};
        NSString *dicStr = [dic JSONFragment];
        NSString *jsString = [NSString stringWithFormat:@"uexMobSMS.cbSendClick('%@');",dicStr];
        [EUtility brwView:meBrwView evaluateScript:jsString];
        return;
    }
    NSString *jsonStr = nil;
    if (inArguments.count > 0) {
        
        jsonStr = [inArguments objectAtIndex:0];
        self.jsonDict = [jsonStr JSONValue];//将JSON类型的字符串转化为可变字典
        
    }else{
        return;
    }
    
    NSString *phone = [self.jsonDict objectForKey:@"phoneNum"];
    NSString *countryCode = [self.jsonDict objectForKey:@"countryCode"];
    if ([phone isEqualToString:@""] || [countryCode isEqualToString:@""]) {
        NSDictionary *dic = @{@"msg":@"phoneNum or countryCode is null !",@"status":@"1"};
        NSString *dicStr = [dic JSONFragment];
        NSString *jsString = [NSString stringWithFormat:@"uexMobSMS.cbSendClick('%@');",dicStr];
        [EUtility brwView:meBrwView evaluateScript:jsString];
        return;
        
    }
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:countryCode customIdentifier:nil result:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            NSString *msg = [NSString stringWithFormat:@"%@",error];
            NSString *status = @"1";
            NSDictionary *dic = @{@"msg":msg,@"status":status};
            NSString *dicStr = [dic JSONFragment];
            NSString *jsString = [NSString stringWithFormat:@"uexMobSMS.cbSendClick('%@');",dicStr];
            [EUtility brwView:meBrwView evaluateScript:jsString];
        }else{
            NSString *msg = @"获取验证码成功";
            NSString *status = @"0";
            NSDictionary *dic = @{@"msg":msg,@"status":status};
            NSString *dicStr = [dic JSONFragment];
            NSString *jsString = [NSString stringWithFormat:@"uexMobSMS.cbSendClick('%@');",dicStr];
            [EUtility brwView:meBrwView evaluateScript:jsString];
            
        }
    }];
}
- (void)commitCode:(NSMutableArray *)inArguments{
    if (!self.initFirst) {
        NSDictionary *dic = @{@"msg":@"uexMobSMS_APPKey or uexMobSMS_APPSecret is null !",@"status":@"1"};
        NSString *dicStr = [dic JSONFragment];
        NSString *jsString = [NSString stringWithFormat:@"uexMobSMS.cbCommitClick('%@');",dicStr];
        [EUtility brwView:meBrwView evaluateScript:jsString];
        return;
    }
    NSString *jsonStr = nil;
    if (inArguments.count > 0) {
        jsonStr = [inArguments objectAtIndex:0];
        self.jsonDict = [jsonStr JSONValue];
        
    }else{
        return;
    }
    
    NSString *phone = [self.jsonDict objectForKey:@"phoneNum"];
    NSString *countryCode = [self.jsonDict objectForKey:@"countryCode"];
    NSString *validCode = [self.jsonDict objectForKey:@"validCode"];
    if ([phone isEqualToString:@""] || [countryCode isEqualToString:@""] || [validCode isEqualToString:@""]) {
        NSDictionary *dic = @{@"msg":@"phoneNum, countryCode or validCode is null !",@"status":@"1"};
        NSString *dicStr = [dic JSONFragment];
        NSString *jsString1 = [NSString stringWithFormat:@"uexMobSMS.cbCommitClick('%@');",dicStr];
        [EUtility brwView:meBrwView evaluateScript:jsString1];
        return;
    }
    [SMSSDK commitVerificationCode:validCode phoneNumber:phone zone:countryCode result:^(NSError *error) {
        if (error) {
            NSString* msg = [NSString stringWithFormat:@"%@",error];
            NSDictionary *dic = @{@"msg":msg,@"status":@"1"};
            NSString *dicStr = [dic JSONFragment];
            NSString *jsString = [NSString stringWithFormat:@"uexMobSMS.cbCommitClick('%@');",dicStr];
            [EUtility brwView:meBrwView evaluateScript:jsString];
        }else{
            NSString *msg = @"验证成功";
            NSDictionary *dic = @{@"msg":msg,@"status":@"0"};
            NSString *dicStr = [dic JSONFragment];
            NSString *jsString = [NSString stringWithFormat:@"uexMobSMS.cbCommitClick('%@');",dicStr];
            [EUtility brwView:meBrwView evaluateScript:jsString];
            
        }
    }];
}
@end
