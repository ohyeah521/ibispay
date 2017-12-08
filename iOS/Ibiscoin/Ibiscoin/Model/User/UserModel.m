#import "UserModel.h"

@implementation UserModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    _avatar.thumbnail.url = getUserImageURL(_userID,_avatar.thumbnail.urlSuffix);
    _avatar.middle.url = getUserImageURL(_userID,_avatar.middle.urlSuffix);
    _avatar.large.url = getUserImageURL(_userID,_avatar.large.urlSuffix);
    _avatar.largest.url = getUserImageURL(_userID,_avatar.largest.urlSuffix);
    _realPhoto.thumbnail.url = getUserImageURL(_userID,_realPhoto.thumbnail.urlSuffix);
    _realPhoto.middle.url = getUserImageURL(_userID,_realPhoto.middle.urlSuffix);
    _realPhoto.large.url = getUserImageURL(_userID,_realPhoto.large.urlSuffix);
    _realPhoto.largest.url = getUserImageURL(_userID,_realPhoto.largest.urlSuffix);
    
    //性别字符串
    if (_sex == 0) {
        _strSex = @"女";
    }else{
        _strSex = @"男";
    }
    
    //加入时间字符串
    NSString *createdAt = dic[@"createdAt"];
    NSString *strCreateAt = [CommonFunction getLocalDateFormateUTCDate:createdAt];
    _createdAt = strCreateAt;
    
    //生日日期字符串
    NSDate *birthDate = [NSDate dateWithTimeIntervalSince1970:_birthday];
    _strBirthday = [[NSString stringWithFormat:@"%@",birthDate] substringToIndex:10];
    
    //年龄
    _age = [birthDate yearsAgo];
    return YES;
}
@end

@implementation UserActivityModel
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    //最后活跃时间
    NSDate *updateDate = [NSDate dateWithTimeIntervalSince1970:_updatedAt];
    if ([[updateDate dateByAddingSeconds:30] isLaterThan:[NSDate date]]) {
        _strUpdatedAt = @"现在活跃";
    }else{
        _strUpdatedAt = [updateDate shortTimeAgoSinceNow];
    }
    
    return YES;
}
@end

@implementation UserTokenModel

@end

