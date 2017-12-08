//
//  RoleModel.m
//  Action
//
//  Created by 鸟神 on 2017/4/23.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "RoleModel.h"

#define kMaxTextLength (iPhone6Screen?17*12:14*12)

@implementation RoleModel
    
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    double updateAt = [dic[@"updatedAt"] doubleValue];
    NSDate *updateDate = [NSDate dateWithTimeIntervalSince1970:updateAt];
    _updateTimeAgo = [NSString stringWithFormat:@"%@",[updateDate timeAgoSinceNow]];
    
    _avatar.thumbnail.url = getUserImageURL(_userID,_avatar.thumbnail.urlSuffix);
    _avatar.middle.url = getUserImageURL(_userID,_avatar.middle.urlSuffix);
    _avatar.large.url = getUserImageURL(_userID,_avatar.large.urlSuffix);
    _avatar.largest.url = getUserImageURL(_userID,_avatar.largest.urlSuffix);
    
    _image.thumbnail.url = getUserImageURL(_userID,_image.thumbnail.urlSuffix);
    _image.middle.url = getUserImageURL(_userID,_image.middle.urlSuffix);
    _image.large.url = getUserImageURL(_userID,_image.large.urlSuffix);
    _image.largest.url = getUserImageURL(_userID,_image.largest.urlSuffix);
    
    //匹配第一个自然段
    NSString *first = [CommonFunction getFirstParagragh:_desc];
    if (isNullString(first)) {
        first = _desc;
    }
    _descCutoff = [CommonFunction getChineseCount:first]>kMaxTextLength?[CommonFunction removeSpaceAndNewline:[first substringToIndex:kMaxTextLength]]:[CommonFunction removeNewline:first];
    
    
    return YES;
}
    
@end

