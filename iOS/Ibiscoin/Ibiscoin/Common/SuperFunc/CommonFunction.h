//
//  CommonFunction.h
//  Action
//
//  Created by cooerson on 15/6/11.
//  Copyright (c) 2015年 xingdongpai. All rights reserved.
//

//screen size
#define screenBounds [UIScreen mainScreen].bounds
#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
//不包括status的app size
#define appFrame [UIScreen mainScreen].applicationFrame
#define appWidth [UIScreen mainScreen].applicationFrame.size.width
#define appHeight [UIScreen mainScreen].applicationFrame.size.height

//machine
#define iPhone5Device [CommonFunction isIPhone5Device]
#define iPhone5sDevice [CommonFunction isIPhone5sDevice]
#define iPhone6Or6pDevice [CommonFunction isIPhone6Or6pDevice]
#define iPhone6sOr6spDevice [CommonFunction isIPhone6sOr6spDevice]

//screen size
#define iPhone6Or6PScreen screenHeight>=667
#define iPhone6pScreen screenHeight==736
#define iPhone6Screen screenHeight==667
#define iPhone5Screen screenHeight==568
#define iPhone4Screen screenHeight==480

//判断null
#define isNull(...) [CommonFunction isNull:__VA_ARGS__]
#define isNullString(...) [CommonFunction isNullString:__VA_ARGS__]
#define isPureIntString(...) [CommonFunction isPureIntString:__VA_ARGS__]
#define isChineseString(...) [CommonFunction isChineseFontString:__VA_ARGS__]

#define get_trim(...) [__VA_ARGS__ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define set_to(TARGET, VAL) if(isNull(VAL) == NO) { TARGET = VAL; }
#define set_to_var(TARGET, VAL, ...) if(isNull(VAL) == NO) { TARGET = __VA_ARGS__; }
#define set_to_int(TARGET, VAL) if(isNull(VAL) == NO) { TARGET = [VAL intValue]; }
#define set_to_bool(TARGET, VAL) if(isNull(VAL) == NO) { TARGET = [VAL boolValue]; }

@interface CommonFunction : NSObject

+ (NSString *)deviceString;
+ (BOOL)isIPhone5Device;
+ (BOOL)isIPhone5sDevice;
+ (BOOL)isIPhone6Or6pDevice;
+ (BOOL)isIPhone6sOr6spDevice;

+ (BOOL)isNull:(id)obj;
+ (BOOL)isNullString:(NSString *)text;
+ (BOOL)isPureIntString:(NSString *)text;
+ (BOOL)isChineseFontString:(NSString *)text;
+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (BOOL)includeSpecialCharact:(NSString *)str;

+ (int)getChineseCount:(NSString*)s;
+ (NSString *)getFirstParagragh:(NSString *)s;
+ (NSString *)removeSpaceAndNewline:(NSString *)str;
+ (NSString *)removeNewline:(NSString *)str;

+ (void)runAfterTime:(int64_t)t run:(void (^)(void))run;

+ (NSString *)getUTCFormateLocalDate:(NSString *)localDate;
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate;

+ (double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2;

+ (NSString*)base64forData:(NSData*)theData;

+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time ;

+ (CGFloat)measureHeightOfUITextView:(UITextView *)textView lineHeight:(CGFloat)lineHeight;

@end

@interface UITextView (UITextViewAdditions)
- (void)setText:(NSString *)text lineHeight:(CGFloat)lineHeight;
@end
@interface UILabel (Extensions)
- (void)setLineHeight:(float)lineHeight;
@end

@interface UIImage (Orientation)

- (UIImage*)imageByNormalizingOrientation;

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/** Resize the image to be the required size, stretching it as needed.
 *
 * @param newSize      The new size of the image.
 * @param contentMode  The `UIViewContentMode` to be applied when resizing image.
 *                     Either `UIViewContentModeScaleToFill`, `UIViewContentModeScaleAspectFill`, or
 *                     `UIViewContentModeScaleAspectFit`.
 *
 * @return             Return `UIImage` of resized image.
 */

- (UIImage*)imageByScalingToSize:(CGSize)newSize contentMode:(UIViewContentMode)contentMode;
@end


/**
iPhone1,1	iPhone
iPhone1,2	iPhone 3G
iPhone2,1	iPhone 3GS
iPhone3,1	iPhone 4 (GSM)
iPhone3,3	iPhone 4 (CDMA)
iPhone4,1	iPhone 4S
iPhone5,1	iPhone 5 (A1428)
iPhone5,2	iPhone 5 (A1429)
iPhone5,3	iPhone 5c (A1456/A1532)
iPhone5,4	iPhone 5c (A1507/A1516/A1529)
iPhone6,1	iPhone 5s (A1433/A1453)
iPhone6,2	iPhone 5s (A1457/A1518/A1530)
iPhone7,1	iPhone 6 Plus
iPhone7,2	iPhone 6
iPad1,1	iPad
iPad2,1	iPad 2 (Wi-Fi)
iPad2,2	iPad 2 (GSM)
iPad2,3	iPad 2 (CDMA)
iPad2,4	iPad 2 (Wi-Fi, revised)
iPad2,5	iPad mini (Wi-Fi)
iPad2,6	iPad mini (A1454)
iPad2,7	iPad mini (A1455)
iPad3,1	iPad (3rd gen, Wi-Fi)
iPad3,2	iPad (3rd gen, Wi-Fi+LTE Verizon)
iPad3,3	iPad (3rd gen, Wi-Fi+LTE AT&T)
iPad3,4	iPad (4th gen, Wi-Fi)
iPad3,5	iPad (4th gen, A1459)
iPad3,6	iPad (4th gen, A1460)
iPad4,1	iPad Air (Wi-Fi)
iPad4,2	iPad Air (Wi-Fi+LTE)
iPad4,3	iPad Air (Rev)
iPad4,4	iPad mini 2 (Wi-Fi)
iPad4,5	iPad mini 2 (Wi-Fi+LTE)
iPad4,6	iPad mini 2 (Rev)
iPad4,7	iPad mini 3 (Wi-Fi)
iPad4,8	iPad mini 3 (A1600)
iPad4,9	iPad mini 3 (A1601)
iPad5,3	iPad Air 2 (Wi-Fi)
iPad5,4	iPad Air 2 (Wi-Fi+LTE)
iPod1,1	iPod touch
iPod2,1	iPod touch (2nd gen)
iPod3,1	iPod touch (3rd gen)
iPod4,1	iPod touch (4th gen)
iPod5,1	iPod touch (5th gen)
*/


