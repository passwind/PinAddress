//
//  tools.h
//  MKTime
//
//  Created by MaYan on 13-11-8.
//  Copyright (c) 2013年 MakeTime Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface tools : NSObject {	
	


}
+ (NSString *)Date2StrV:(NSDate *)indate;
+ (NSString *)Date2Str:(NSDate *)indate;
+ (void)MsgBox:(NSString *)msg;

+ (NSDateComponents *)DateInfo:(NSDate *)indate;

+ (NSString *)compareCreateTime:(NSDate*)compareDate;

+ (NSString *)compareCreateTime2:(NSDate*)compareDate;

+ (int)convertToInt:(NSString*)strtemp;

+ (void)OpenUrl:(NSString *)inUrl;

+ (BOOL)isPureInt:(NSString *)string;

+(NSString *)calculateNumber:(NSString *)number;

//得到星座
+(NSString *)getAstroWithMonth:(int)m day:(int)d;

+ (NSString*)GetCurrntNet;
+ (BOOL)isConnectNet;

+ (void)showHUD:(NSString *)msg;
+ (void)showWithLabelDeterminateHorizontalBar:(NSString *)msg percent:(float)percent;
+ (void)removeHUD;
+ (void)showTextOnly:(UIViewController *)controller text:(NSString *)showText;
+ (void)alertText:(UIView *)tempView text:(NSString *)showText;

@end
