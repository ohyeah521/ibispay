
//
//  CoinModel.m
//  Action
//
//  Created by 鸟神 on 2017/1/17.
//  Copyright © 2017年 xingdongpai. All rights reserved.
//

#import "CoinModel.h"

@implementation CoinModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    if(_credit == 0.0){
        _creditLevel = @"新加入";
    }else if (_credit >= 0.763932) {
        _creditLevel = @"安全型";
    }else if (_credit >= 0.618034){
        _creditLevel = @"优秀型";
    }else if (_credit >= 0.5){
        _creditLevel = @"良好型";
    }else if (_credit >= 0.236068){
        _creditLevel = @"进击型";
    }else{
        _creditLevel = @"冒险型";
    }
    
    Pic *pic = _qrCode;
    pic.thumbnail.url = getUserImageURL(_userID,pic.thumbnail.urlSuffix);
    pic.middle.url = getUserImageURL(_userID,pic.middle.urlSuffix);
    pic.large.url = getUserImageURL(_userID,pic.large.urlSuffix);
    pic.largest.url = getUserImageURL(_userID,pic.largest.urlSuffix);
    
    return YES;
}

@end

