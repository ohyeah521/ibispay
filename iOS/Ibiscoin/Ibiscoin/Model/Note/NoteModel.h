//Created by niaoshenhao.com

//Note 对应note表
@interface NoteModel : NSObject

@property (nonatomic, strong) NSString *noteID; //热情笔记ID
@property (nonatomic, strong) NSString *userID; //用户ID，必填
@property (nonatomic, strong) NSString *roleID; //角色ID，必填

@property (nonatomic, assign) BOOL md; //是否是markdown编辑器
@property (nonatomic, strong) NSString *title; //标题
@property (nonatomic, strong) NSString *desc; //缩略内容，不超过128字
@property (nonatomic, strong) NSString *descText; //纯文字全文，不超过5000字，可用于搜索
@property (nonatomic, strong) NSString *descHTML; //html格式原文全文，不超过5000字
@property (nonatomic, strong) NSString *descMD; //markdown格式全文，不超过5000字
@property (nonatomic, strong) NSString *descRich; //富文本格式全文，不超过5000字

@property (nonatomic, assign) BOOL free; //是否可免费浏览，默认NO(仅赞助者可见)
@property (nonatomic, assign) NSInteger views; //浏览次数
@property (nonatomic, assign) BOOL deleted; //是否已删除
@property (nonatomic, assign) NSInteger updatedAt; //更新时间
@property (nonatomic, strong) NSString *createdAt; //创建时间

//=====for client=====
@property (nonatomic, strong) NSString *updateTimeAgo;

@end

