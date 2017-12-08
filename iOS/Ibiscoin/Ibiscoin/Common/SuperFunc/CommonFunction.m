//
//  CommonFunction.m
//  Action
//
//  Created by cooerson on 15/6/11.
//  Copyright (c) 2015年 xingdongpai. All rights reserved.
//

#import "CommonFunction.h"
#import "sys/utsname.h"

@implementation CommonFunction

+ (NSString*)deviceString{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}

+ (BOOL)isIPhone5Device{
    return [[[CommonFunction deviceString] substringToIndex:7] isEqualToString:@"iPhone5"];
}
+ (BOOL)isIPhone5sDevice{
    return [[[CommonFunction deviceString] substringToIndex:7] isEqualToString:@"iPhone6"];
}
+ (BOOL)isIPhone6Or6pDevice{
    return [[[CommonFunction deviceString] substringToIndex:7] isEqualToString:@"iPhone7"];
}
+ (BOOL)isIPhone6sOr6spDevice{
    return [[[CommonFunction deviceString] substringToIndex:7] isEqualToString:@"iPhone8"];
}

+ (BOOL)isNull:(id)obj{
    if (obj == [NSNull null] || obj == nil || obj == NULL || obj == Nil || [obj isKindOfClass:[NSNull class]]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isNullString:(NSString *)text{
    if ((id)text == [NSNull null] || text == nil || text == NULL || text == Nil || [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [text isEqualToString:@"<null>"] || [text isEqualToString:@"(null)"]) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isPureIntString:(NSString *)text{
    NSScanner* scan = [NSScanner scannerWithString:text];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isChineseFontString:(NSString *)text{
    BOOL returnValue = NO;
    
    if (isNullString(text) == NO) {
        CFStringRef sf = CFStringTokenizerCopyBestStringLanguage((CFStringRef)text, CFRangeMake(0, text.length));
        NSString *str = (__bridge NSString *)sf;
        if ([str isEqualToString:@"zh-Hans"] || [str isEqualToString:@"zh-Hant"]) {
            returnValue = YES;
        }
        if (sf != NULL)
            CFRelease(sf);
    }
    
    return returnValue;
}

+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}
+ (BOOL)includeSpecialCharact: (NSString *)str {
    BOOL isRight = [str isMatch:RX(@"[\u4e00-\u9fa5a-zA-Z0-9]+")];//中文字母数字
    
    BOOL isFound = NO;
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥¥&（）——+$_€！!％%＊*-－：:；;\\,，.。?？｀`~～"]];
    if (urgentRange.location != NSNotFound)
    {
        isFound = YES;
    }
    return !isRight || isFound;
}

+ (int)getChineseCount:(NSString*)s
{
    int i,n=(int)[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

+ (NSString *)getFirstParagragh:(NSString *)s{
    return [RX(@"((.*?[\\n\\r\\v]){1})") firstMatch:s];
}

+ (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    temp = [temp stringByAppendingString:@"..."];
    return temp;
}

+ (NSString *)removeNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}


+ (void)runAfterTime:(int64_t)t run:(void (^)(void))run{
    int64_t delayInSeconds = t;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (isNull(run) == NO) run();
    });
}



//将本地日期字符串转为UTC日期字符串
//本地日期格式:2013-08-03 12:53:51
//可自行指定输入输出格式
+ (NSString *)getUTCFormateLocalDate:(NSString *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式为 RFC3339
//参考 http://momentjs.com/docs/#/parsing/string-format/
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *dateFormatted = [utcDate dateFromRFC3339String];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

// From: http://www.cocoadev.com/index.pl?BaseSixtyFour
+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (double)distanceBetweenOrderBy:(double)lat1 :(double)lat2 :(double)lng1 :(double)lng2{
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    double distance  = [curLocation distanceFromLocation:otherLocation];
    return distance;
}

+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeCleanAperture;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 30) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    if (thumbnailImageRef) {
        CFRelease(thumbnailImageRef);
    }
    
    return thumbnailImage;
}

+ (CGFloat)measureHeightOfUITextView:(UITextView *)textView lineHeight:(CGFloat)lineHeight{
    // This is the code for iOS 7. contentSize no longer returns the correct value, so
    // we have to calculate it.
    //
    // This is partly borrowed from HPGrowingTextView, but I've replaced the
    // magic fudge factors with the calculated values (having worked out where
    // they came from)
    
    CGRect frame = textView.bounds;
    
    // Take account of the padding added around the text.
    
    UIEdgeInsets textContainerInsets = textView.textContainerInset;
    UIEdgeInsets contentInsets = textView.contentInset;
    
    CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
    CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
    
    frame.size.width -= leftRightPadding;
    frame.size.height -= topBottomPadding;
    
    NSString *textToMeasure = textView.text;
    if ([textToMeasure hasSuffix:@"\n"])
    {
        textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
    }
    
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    if (lineHeight > 0) {
        paragraphStyle.minimumLineHeight = lineHeight;
        paragraphStyle.maximumLineHeight = lineHeight;
        paragraphStyle.lineHeightMultiple = lineHeight;
    }
    
    NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
    
    CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    
    CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
    return measuredHeight;
}

@end

@implementation UITextView (UITextViewAdditions)

- (void)setText:(NSString *)text lineHeight:(CGFloat)lineHeight{
    // adjust lineSpacing
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    float mylineSpacing = (lineHeight>0 ? lineHeight : 25.0);
    
    style.minimumLineHeight = mylineSpacing;
    style.maximumLineHeight = mylineSpacing;
    style.lineHeightMultiple = mylineSpacing;
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName :style};
    
    [self setAttributedText:[[NSAttributedString alloc] initWithString:text attributes:attributes]];
}

@end

@implementation UILabel (Extensions)
- (void)setLineHeight:(float)lineHeight
{
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    paragrahStyle.minimumLineHeight = lineHeight;
    paragrahStyle.maximumLineHeight = lineHeight;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]
                                                 initWithString:self.text];
    [attributedText addAttribute:NSParagraphStyleAttributeName
                           value:paragrahStyle
                           range:NSMakeRange(0, attributedText.length)];
    self.text = nil;
    self.attributedText = attributedText;
}
@end


@implementation UIImage (Orientation)

- (UIImage*)imageByNormalizingOrientation {
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    CGSize size = self.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:(CGRect){{0, 0}, size}];
    UIImage* normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return normalizedImage;
}


CGFloat degreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
};

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width / 2, rotatedSize.height / 2);
    
    CGContextRotateCTM(bitmap, degreesToRadians(degrees));
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (UIImage*)imageByScalingToSize:(CGSize)newSize contentMode:(UIViewContentMode)contentMode
{
    if (contentMode == UIViewContentModeScaleToFill)
    {
        return [self imageByScalingToFillSize:newSize];
    }
    else if ((contentMode == UIViewContentModeScaleAspectFill) ||
             (contentMode == UIViewContentModeScaleAspectFit))
    {
        CGFloat horizontalRatio   = self.size.width  / newSize.width;
        CGFloat verticalRatio     = self.size.height / newSize.height;
        CGFloat ratio;
        
        if (contentMode == UIViewContentModeScaleAspectFill)
            ratio = MIN(horizontalRatio, verticalRatio);
        else
            ratio = MAX(horizontalRatio, verticalRatio);
        
        CGSize  sizeForAspectScale = CGSizeMake(self.size.width / ratio, self.size.height / ratio);
        
        UIImage *image = [self imageByScalingToFillSize:sizeForAspectScale];
        
        // if we're doing aspect fill, then the image still needs to be cropped
        
        if (contentMode == UIViewContentModeScaleAspectFill)
        {
            CGRect  subRect = CGRectMake(floor((sizeForAspectScale.width - newSize.width) / 2.0),
                                         floor((sizeForAspectScale.height - newSize.height) / 2.0),
                                         newSize.width,
                                         newSize.height);
            image = [image imageByCroppingToBounds:subRect];
        }
        
        return image;
    }
    
    return nil;
}

- (UIImage *)imageByCroppingToBounds:(CGRect)bounds
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage*)imageByScalingToFillSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*)imageByScalingAspectFillSize:(CGSize)newSize
{
    return [self imageByScalingToSize:newSize contentMode:UIViewContentModeScaleAspectFill];
}

- (UIImage*)imageByScalingAspectFitSize:(CGSize)newSize
{
    return [self imageByScalingToSize:newSize contentMode:UIViewContentModeScaleAspectFit];
}


@end

/**
 iPhone1,1   iPhone 1G
 iPhone1,2   iPhone 3G
 iPhone2,1   iPhone 3GS
 iPhone3,1   iPhone 4
 iPhone3,3   Verizon iPhone 4
 iPhone4,1   iPhone 4S
 iPhone5,1   iPhone 5 (GSM)
 iPhone5,2   iPhone 5 (GSM+CDMA)
 iPhone5,3   iPhone 5c (GSM)
 iPhone5,4   iPhone 5c (GSM+CDMA)
 iPhone6,1   iPhone 5s (GSM)
 iPhone6,2   iPhone 5s (GSM+CDMA)
 iPhone7,1   iPhone 6 Plus
 iPhone7,2   iPhone 6
 iPhone8,1   iPhone 6s Plus
 iPhone8,2   iPhone 6s
 iPod1,1     iPod Touch 1G
 iPod2,1     iPod Touch 2G
 iPod3,1     iPod Touch 3G
 iPod4,1     iPod Touch 4G
 iPod5,1     iPod Touch 5G
 iPad1,1     iPad
 iPad2,1     iPad 2 (WiFi)
 iPad2,2     iPad 2 (GSM)
 iPad2,3     iPad 2 (CDMA)
 iPad2,4     iPad 2 (WiFi)
 iPad2,5     iPad Mini (WiFi)
 iPad2,6     iPad Mini (GSM)
 iPad2,7     iPad Mini (GSM+CDMA)
 iPad3,1     iPad 3 (WiFi)
 iPad3,2     iPad 3 (GSM+CDMA)
 iPad3,3     iPad 3 (GSM)
 iPad3,4     iPad 4 (WiFi)
 iPad3,5     iPad 4 (GSM)
 iPad3,6     iPad 4 (GSM+CDMA)
 iPad4,1     iPad Air (WiFi)
 iPad4,2     iPad Air (Cellular)
 iPad4,4     iPad mini 2G (WiFi)
 iPad4,5     iPad mini 2G (Cellular)
 i386        Simulator
 x86_64      Simulator
 */
