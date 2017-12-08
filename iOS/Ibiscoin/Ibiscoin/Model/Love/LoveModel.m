#import "LoveModel.h"


@implementation LoveModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    //    NSString *createdAt = dic[@"createdAt"];
    //    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    //    NSString *strCreateAt = [CommonFunction getLocalDateFormateUTCDate:createdAt];
    //    NSDate *createDate = [formatter dateFromString:strCreateAt];
    //    _timeAgo = [[NSDate date] shortTimeAgoSinceDate:createDate];

    double updateAt = [dic[@"updatedAt"] doubleValue];
    NSDate *updateDate = [NSDate dateWithTimeIntervalSince1970:updateAt];
    _updateTimeAgo = [updateDate shortTimeAgoSinceNow];
    
    return YES;
}

@end

