//
//  UserFunc.m
//  Action
//
//  Created by caokun on 16/9/3.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import "UserFunc.h"

@implementation UserModel (Functions)

+ (UserModel *)CacheUserData:(id)obj{
    //缓存基本资料
    UserModel *user = [UserModel modelWithJSON:obj];
    [UserModel cacheUserBasic:user];
    //缓存所有资料
    [[PINCache sharedCache] setObject:obj forKey:kUserData];
    return user;
}

+ (UserModel *)GetUserData{
    id obj = [[PINCache sharedCache] objectForKey:kUserData];
    if (isNull(obj) == NO) {
        UserModel *user = [UserModel modelWithJSON:obj];
        return user;
    }
    return nil;
}

+ (void)cacheUserBasic:(UserModel *)user{
    //储存用户id 手机号 密码 昵称 头像 
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:user.userID forKey:kUserId];
    [ud setObject:user.phone forKey:kUserPhoneNum];
    [ud setObject:user.phoneCC forKey:kUserPhoneCC];
    [ud setObject:user.name forKey:kUserName];
    [ud setObject:user.avatar.largest.pid forKey:kUserAvatar];
    [ud synchronize];
}

+ (void)RemoveUserBasic{
    [SAMKeychain deletePasswordForService:kAppService account:getUserPhoneNum];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kUserId];
    [ud removeObjectForKey:kUserPhoneNum];
    [ud removeObjectForKey:kUserPhoneCC];
    [ud removeObjectForKey:kUserName];
    [ud removeObjectForKey:kUserAvatar];
    [ud synchronize];
}

+ (void)RemoveUserBasicWithOutPhone{
    [SAMKeychain deletePasswordForService:kAppService account:getUserPhoneNum];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kUserId];
    [ud removeObjectForKey:kUserName];
    [ud removeObjectForKey:kUserAvatar];
    [ud synchronize];
}

@end


@implementation UserActivityModel (Functions)


@end


@implementation UserTokenModel (Functions)

+ (void)CacheUserToken:(UserTokenModel *)tokenModel{
    //储存用户token
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:tokenModel.token forKey:kUserToken];
    [ud setObject:tokenModel.expire forKey:kUserTokenExpire];
    [ud synchronize];
}

+ (void)RemoveUserToken{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kUserToken];
    [ud removeObjectForKey:kUserTokenExpire];
    [ud synchronize];
}

@end









