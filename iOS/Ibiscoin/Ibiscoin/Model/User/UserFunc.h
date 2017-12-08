//
//  UserFunc.h
//  Action
//
//  Created by caokun on 16/9/3.
//  Copyright © 2016年 xingdongpai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAMKeychain.h"
#import "UserModel.h"

@interface UserModel(Functions)

+ (UserModel *)CacheUserData:(id)obj;
+ (UserModel *)GetUserData;
+ (void)RemoveUserBasic;
+ (void)RemoveUserBasicWithOutPhone;

@end


@interface UserActivityModel (Functions)


@end


@interface UserTokenModel (Functions)

+ (void)CacheUserToken:(UserTokenModel *)tokenModel;
+ (void)RemoveUserToken;

@end

