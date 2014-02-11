//
//  tools.m
//  MKTime
//
//  Created by MaYan on 13-11-8.
//  Copyright (c) 2013年 MakeTime Inc. All rights reserved.
//

#import "tools.h"

#define MsgBox(msg) [self MsgBox:msg]

@implementation tools

static MBProgressHUD *HUD;

+  (void)setNavigationBar:(UINavigationBar *)navigationBar {
    
    //设置navigationBar背景
    UIImage *gradientImage44 = [[UIImage imageNamed:@"bg_nav"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [navigationBar setBackgroundImage:gradientImage44 forBarMetrics:UIBarMetricsDefault];
    
    //设置titleView
    UIColor * cc = [UIColor whiteColor];
    UIColor * bb = [UIColor clearColor];
    NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:cc,UITextAttributeTextColor,bb,UITextAttributeTextShadowColor, nil];
    navigationBar.titleTextAttributes = tempDic;
    
}


//程序中使用的，将日期显示成  2014年1月17日 星期五
+ (NSString *) Date2StrV:(NSDate *)indate{

	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]]; //setLocale 方法将其转为中文的日期表达
	dateFormatter.dateFormat = @"yyyy '-' MM '-' dd ' ' EEEE";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;
}

//程序中使用的，提交日期的格式
+ (NSString *) Date2Str:(NSDate *)indate{
	
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
	dateFormatter.dateFormat = @"yyyyMMdd";
	NSString *tempstr = [dateFormatter stringFromDate:indate];
	return tempstr;	
}

//提示窗口
+ (void)MsgBox:(NSString *)msg{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg
												   delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
	[alert show];
}

//获得日期的具体信息，本程序是为获得星期，注意！返回星期是 int 型，但是和中国传统星期有差异
+ (NSDateComponents *) DateInfo:(NSDate *)indate{

	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = nil;//[[[NSDateComponents alloc] init] autorelease];
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | 
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

	comps = [calendar components:unitFlags fromDate:indate];
	
	return comps;

//	week = [comps weekday];    
//	month = [comps month];
//	day = [comps day];
//	hour = [comps hour];
//	min = [comps minute];
//	sec = [comps second];

}

//时间转换函数，计算指定时间与当前的时间差 by MaYan 2012.10.03
/**
 * @param compareDate   某一指定时间  
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *)compareCreateTime:(NSDate*) compareDate
//
{
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"%@",@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

+(NSString *)compareCreateTime2:(NSDate*) compareDate
//
{

    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"%@",@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        result = [dateFormatter stringFromDate:compareDate];
    }
    
    return  result;
}


//打开一个网址
+ (void) OpenUrl:(NSString *)inUrl{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:inUrl]];
}

//判断String为空函数
+ (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        
        return YES;
        
    }
    
    if (string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        return YES;
        
    } 
    
    return NO; 
    
}

//返回字符串长度
+  (int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
    
}
//控制数字显示为**k
+(NSString *)calculateNumber:(NSString *)number{
    int a = [number intValue];
    float b;
    NSString *showText;
    if (a<1000) {
        showText = [NSString stringWithFormat:@"%@",number];
        return showText;
    }else if(a>=1000&&a<10000){
        if (a%1000==0) {
            a=a/1000;
            showText = [NSString stringWithFormat:@"%dk",a];
            return showText;
        }else if(a%100==0){
            a=a/100;
            b=a;
            b=b/10;
            int c  = b*100;
            b=(float)c/100;
            showText = [NSString stringWithFormat:@"%0.1fk", b];
            return showText;
        }else{
            b = a;
            b=b/1000;
            int c  = b*100;
            b=(float)c/100;
            showText = [NSString stringWithFormat:@"%.2fk",b];
            return showText;
        }
    }else{
        a = a/1000;
        showText = [NSString stringWithFormat:@"%dk",a];
        return showText;
    }
    
}

//判断是否为纯数字
+ (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//得到星座
+(NSString *)getAstroWithMonth:(int)m day:(int)d{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    if(m==2 && d>29)
    {
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    return result;
}

//判断当前的网络是3g还是wifi
+(NSString*)GetCurrntNet
{
    NSString* result;
    Reachability *r = [Reachability reachabilityWithHostName: [[NSURL URLWithString: @"www.sina.com.cn"] host ]];
    switch (r.currentReachabilityStatus) {
        case NotReachable:// 没有网络连接
            result=nil;
            break;
        case ReachableViaWWAN:// 使用3G网络
            result=@"3g";
            break;
        case ReachableViaWiFi:// 使用WiFi网络
            result=@"wifi";
            break;
    }
    return result;
}

//判断当前网络连通性
+ (BOOL)isConnectNet
{

    NSURL *url1 =  [NSURL URLWithString: @"www.sina.com.cn"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil];
    if (response == nil) {
        
        return NO;
    }
    else{
        
        return YES;
    }

}

//提示信息，逐渐消失
+ (void)showTextOnly:(UIViewController *)controller text:(NSString *)showText{
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.navigationController.view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = showText;
	hud.margin = 10.f;
	hud.yOffset = 10.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:1.5f];
}

//提示信息，逐渐消失
+ (void)alertText:(UIView *)tempView text:(NSString *)showText{
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:tempView animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = showText;
	hud.margin = 10.f;
	hud.yOffset = 10.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:1.5f];
}

+ (void)showHUD:(NSString *)msg{
	
    if (HUD == Nil) {
        HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    }
	HUD.labelText = msg;
    
	[HUD show:YES];
}


+ (void)removeHUD{
	
	[HUD hide:YES];
	[HUD removeFromSuperViewOnHide];
}

+ (void)showWithLabelDeterminateHorizontalBar:(NSString *)msg percent:(float)percent {
	
    if (HUD == Nil) {
        HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    }
    
	HUD.labelText = msg;
	// Set determinate bar mode
	HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
	
	HUD.progress = percent;
    
    [HUD show:YES];
}

@end
