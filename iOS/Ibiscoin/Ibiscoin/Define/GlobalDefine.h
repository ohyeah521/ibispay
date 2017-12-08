//
//  GlobalDefine.h
//  Ibis
//
//  Created by 鸟神 on 2017/6/12.
//  Copyright © 2017年 xingdongpai.com. All rights reserved.
//

//===APP基本环境===
#define isDebugMode YES //~~~~~~~每次release时修改为NO！！！
#define kApiVersion @"1.0" //~~~~~~~每次更新App时修改+0.1！！！
#define kAppService @"niaobi.net"
#define kHttpsCerName @"https-niaobi-net" //https证书名称
#define kMainSB [UIStoryboard storyboardWithName:@"Main" bundle:nil]
//模拟器 or 真机
#if TARGET_IPHONE_SIMULATOR
#define kApiUrl @"https://niaobi.net"
#define kApiUrl_static @"http://niaobi.net" //静态资源使用http
#else
#define kApiUrl isDebugMode?@"https://192.168.199.203":@"https://niaobi.net"
#define kApiUrl_static isDebugMode?@"http://192.168.199.203":@"http://niaobi.net" //静态资源使用http
#endif
#define rootDelegate (AppDelegate *)[UIApplication sharedApplication].delegate

//===用户相关===
//账号
#define kUserId @"kUserId"
#define kUserPhoneCC @"kUserPhoneCC"
#define kUserPhoneNum @"kUserPhoneNum"
#define kUserName @"kUserName"
#define kUserAvatar @"kUserAvatar"
#define getUserId [[NSUserDefaults standardUserDefaults] stringForKey:kUserId]
#define getUserPhoneCC [[NSUserDefaults standardUserDefaults] stringForKey:kUserPhoneCC]
#define getUserPhoneNum [[NSUserDefaults standardUserDefaults] stringForKey:kUserPhoneNum]
#define getUserPassword [SAMKeychain passwordForService:kAppService account:kUserId]
#define getUserName [[NSUserDefaults standardUserDefaults] stringForKey:kUserName]
#define getUserAvatar [[NSUserDefaults standardUserDefaults] stringForKey:kUserAvatar]
//认证
#define kAuth @"Authorization"
#define getAuthString [NSString stringWithFormat:@"Bearer %@",getUserToken]
//登录
#define kUserToken @"kUserToken"
#define getUserToken [[NSUserDefaults standardUserDefaults] stringForKey:kUserToken]
#define kUserTokenExpire @"kUserTokenExpire"
#define getUserTokenExpire [[NSUserDefaults standardUserDefaults] stringForKey:kUserTokenExpire]
//状态
#define isUserLogin (isNull(getUserToken) == NO)
//数据
#define kUserData @"kUserData"  //用户所有资料
#define kUserActivityData @"kUserActivityData" //用户动态
//图片
#define getUserImageSuffix(VAL,...) [NSString stringWithFormat:@"%@.%@",VAL,__VA_ARGS__] //获取图片链接的结尾
#define getUserImageURL(VAL,...) [NSURL URLWithString:[kApiUrl_static stringByAppendingFormat:@"/data/pic/%@/%@",VAL,__VA_ARGS__]] //获取图片链接
//笔记
#define getNoteUrl(VAL) [NSURL URLWithString:[NSString stringWithFormat:@"%@/note/html/%@",kApiUrl,VAL]] //获取热情笔记链接
//我的位置
#define kMyCity @"myCity"
#define getMyCity [[NSUserDefaults standardUserDefaults] stringForKey:kMyCity]
#define kMyAddresses @"myAddresses"
#define getMyAddresses [[NSUserDefaults standardUserDefaults] stringForKey:kMyAddresses]

//用户类型选项
typedef NS_OPTIONS(NSUInteger, UserType){
    UserTypeNormal = 0,         //普通用户
    UserTypeTruePhoto = 1 << 0, //有真人照片
    UserTypeSponsor = 1 << 1,   //赞助者
    UserTypeFounder = 1 << 2    //发起人
};

//===sound===
#define kTabPressSoundFileName @"tab_press.m4a"
#define kNewPostSoundFileName @"new_post.m4a"
#define kRefreshPullSoundFileName @"refresh_pull.caf"
#define kRefreshReleaseSoundFileName @"refresh_release.caf"
#define kNewItemSoundFileName @"new_item.caf"
#define kNewMsgSoundFileName @"new_msg.caf"

//===font===
#define kFontTisaPro @"TisaMobiPro"
#define set_font_tisa(...) [UIFont fontWithName:kFontTisaPro size:__VA_ARGS__]

//===storyboard ID===
#define kSBNewGoalNavID @"NewGoalListNav"

//===后台API接口===
#define kRmbExrUri @"/rmbExr"
#define kRmbExrUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kRmbExrUri]
#define kRegisterUri @"/user/register"
#define kRegisterUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kRegisterUri]
#define kLoginUri @"/user/login"
#define kLoginUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kLoginUri]
#define kRefreshTokenUri @"/user/refreshToken"
#define kRefreshTokenUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kRefreshTokenUri]
#define kUserActivityUri @"/user/activity"
#define kUserActivityUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kUserActivityUri]
#define kUserProfileUri @"/user/profile"
#define kUserProfileUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kUserProfileUri]
#define kUpdateProfileUri @"/user/updateProfile"
#define kUpdateProfileUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kUpdateProfileUri]
#define kUpdateAvatarUri @"/user/updateAvatar"
#define kUpdateAvatarUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kUpdateAvatarUri]
#define kNewRoleUri @"/role/new"
#define kNewRoleUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kNewRoleUri]
#define kGetRoleRandomListUri @"/role/randomList"
#define kGetRoleRandomListUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kGetRoleRandomListUri]
#define kGetMySimpleRoleListUri @"/role/mySimpleList"
#define kGetMySimpleRoleListUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kGetMySimpleRoleListUri]
#define kGetMyRoleListUri @"/role/myList"
#define kGetMyRoleListUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kGetMyRoleListUri]
#define kNewSkillUri @"/skill/new"
#define kNewSkillUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kNewSkillUri]
#define kNewSkillPicsUri @"/skill/newPics"
#define kNewSkillPicsUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kNewSkillPicsUri]
#define kGetSkillListUri @"/skill/listByUID"
#define kGetSkillListUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kGetSkillListUri]
#define kNewLoveUri @"/love/new"
#define kNewLoveUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kNewLoveUri]
#define kNewLovePicUri @"/love/newPic"
#define kNewLovePicUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kNewLovePicUri]
#define kUpdateLoveUri @"/love/update"
#define kUpdateLoveUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kUpdateLoveUri]
#define kUpdateLoveLogUri @"/love/updateLog"
#define kUpdateLoveLogUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kUpdateLoveLogUri]
#define kGetLoveLogUri @"/love/logByLID"
#define kGetLoveLogUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kGetLoveLogUri]
#define kNewNoteUri @"/note/new"
#define kNewNoteUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kNewNoteUri]
#define kGetLoveListUri @"/love/listByUID"
#define kGetLoveListUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kGetLoveListUri]
#define kUpdateNoteUri @"/note/update"
#define kUpdateNoteUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kUpdateNoteUri]
#define kUpdateNoteConfigUri @"/note/updateConfig"
#define kUpdateNoteConfigUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kUpdateNoteConfigUri]
#define kGetNoteListUri @"/note/listByUID"
#define kGetNoteListUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kGetNoteListUri]
#define kGetNoteBasicUri @"/note/basicByID"
#define kGetNoteBasicUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kGetNoteBasicUri]
#define kNewDreamUri @"/dream/new"
#define kNewDreamUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kNewDreamUri]
#define kNewDreamPicUri @"/dream/newPic"
#define kNewDreamPicUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kNewDreamPicUri]
#define kAddDreamSkillUri @"/dream/addSkill"
#define kAddDreamSkillUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kAddDreamSkillUri]
#define kRemoveDreamSkillUri @"/dream/removeSkill"
#define kRemoveDreamSkillUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kRemoveDreamSkillUrl]
#define kGetDreamSkillListUri @"/dream/skillList"
#define kGetDreamSkillListUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kGetDreamSkillListUri]
#define kGetFeedRecommendedListUri @"/feed/recommendedList"
#define kGetFeedRecommendedListUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kGetFeedRecommendedListUri]
#define kGetFeedlatestListUri @"/feed/latestList"
#define kGetFeedlatestListUrl [NSString stringWithFormat:@"%@%@",kApiUrl,kGetFeedlatestListUri]

@interface GlobalDefine : NSObject

+ (NSArray *)CCArray;
    
@end
