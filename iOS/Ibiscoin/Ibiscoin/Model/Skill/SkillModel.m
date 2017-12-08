#import "SkillModel.h"

#define kMaxTextLengthWithImg (iPhone6Screen?17*4:14*4) //只在小于4排时显示图片
#define kMaxTextLengthWithoutImg (iPhone6Screen?17*9:14*9) //最多显示，大于4排字后不显示图片

@implementation SkillModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pics" : [Pic class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
//    NSString *createdAt = dic[@"createdAt"];
//    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
//    NSString *strCreateAt = [CommonFunction getLocalDateFormateUTCDate:createdAt];
//    NSDate *createDate = [formatter dateFromString:strCreateAt];
//    _timeAgo = [[NSDate date] shortTimeAgoSinceDate:createDate];
    
    
    //匹配第一个自然段
    if (_desc != nil) {
        NSString *first = [CommonFunction getFirstParagragh:_desc];
        if (isNullString(first)) {
            first = _desc;
        }
        _descCutoff = [CommonFunction getChineseCount:[CommonFunction removeNewline:first]]>kMaxTextLengthWithoutImg?[CommonFunction removeSpaceAndNewline:[first substringToIndex:kMaxTextLengthWithoutImg]]:[CommonFunction removeNewline:first];
        if ([CommonFunction getChineseCount:[CommonFunction removeNewline:first]]<kMaxTextLengthWithImg) {
            _showPicInFeed = YES;
        }
    }
    
    for (int i = 0; i < _pics.count; i++) {
        Pic *pic = _pics[i];
        pic.thumbnail.url = getUserImageURL(_userID,pic.thumbnail.urlSuffix);
        pic.middle.url = getUserImageURL(_userID,pic.middle.urlSuffix);
        pic.large.url = getUserImageURL(_userID,pic.large.urlSuffix);
        pic.largest.url = getUserImageURL(_userID,pic.largest.urlSuffix);
    }
    
    double updateAt = [dic[@"updatedAt"] doubleValue];
    NSDate *updateDate = [NSDate dateWithTimeIntervalSince1970:updateAt];
    _updateTimeAgo = [updateDate shortTimeAgoSinceNow];
    
    return YES;
}

@end
