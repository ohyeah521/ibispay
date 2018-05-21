
# 鸟币(NB)——开源技能货币 
## Ibiscoin -  A skill-based currency network

Ibiscoin is a open-source, skill-based currency network. A decentralized solution to current currency system, it avoids the risks of a single bank monopolizing your world. Anyone can run ibiscoin and participate in the skill-based currency network seamlessly.

- 基于**技能白条**、**自助信用**的虚拟货币系统
- 只要有网的地方，就能用鸟币建立自由交易链
- 源代码友好开放，任何人都可以部署鸟币服务

### 官方APP [https://niaobi.net](https://niaobi.net)   

### 核心概念

#### 技能（指自身天赋和任何对他人有用的东西）是鸟币所信仰的交易根本价值。
- **技能就是钱，钱就是技能！技能可以直接当钱花**！  

- **人的技能才是货币的根本价值**！而非负债、黄金和外汇。

- **开源的自助信用程序比人靠谱**。单方面信用 ≠ 互相信任！！印钱的人也是放贷的人也是掌权的人也是制定法规的人，这种情况下，互相信任是一种幻想。所以鸟币使用自助信用系统（公开算法的信用计算程序）就解决了这个问题。   

- **彻底去中介的货币发行系统**。人人都能发行自己的虚拟货币——鸟币！自己鸟币的技能价值，取决于别人对自己技能的认可。

- **开源的自助信用**是货币中介的终极形态！并且中介是永远存在的。

### 目标

地球上有两百多个国家，有五颜六色的肤色，有各种各样的信仰，有五花八门的政体。但其实世界已经“大同”了——中央银行系统都"长的"一模一样！国家货币，能满足贪欲却先创造了空虚、能保障安全的却先植入了恐惧。**对于想要一点点拿回自己生活的主动权的人**，请开始关注鸟币！**每个人都想摆脱被收割的命运，以前没得选，现在可以选了！今天，让爱念实现。**

### 背景：
经济是由数个交易组成的，每个交易的根本在于人和人之间的**信任**，也就是“一手交钱 一手交货”。而现在主流的经济系统都是以**不信任**为假设前提的，所以看起来交易双方就需要第三方的**监督**、**强制**、**保护**等等。但是第三方自己呢，是**自我监管**的。  

1. [货币的秘密](https://github.com/ibiscoin/ibiscoin/blob/master/SECRET.md)（推荐）     
2. [如何通过货币奴役人民?](https://github.com/ibiscoin/ibiscoin/blob/master/SECRET2.md)（推荐）
 
## 部分定义，实现见代码
符号和缩写定义：

	鸟币 缩写：NB
	超级鸟币 缩写：IBIS
	每个人发行的鸟币都唯一且不同，例如某用户发行了咖啡币(缩写KF):
		唯一名称（不含'币'字）：咖啡
		咖啡币(KF) 完整缩写为：KF-NB
		超级咖啡币(KF) 完整缩写为：KF-IBIS
	鸟币符号待定
	
鸟币转账精分：
	
	a1发行 a2转手  
	b1普通鸟币 b2超级鸟币  
	c1支付(付费、买) c2出售(收费、卖) c3赠送(免费)  
	d1一人/次 d2多人/次  
	e1已知对象 e2未知对象  
	f1担保交易 f2博弈交易

	博弈（当下的未来价值） 可能得到资产、可能达成的目标  
	交易（当下价值） 达成合约、兑现承诺  
	担保（当下的过去价值） 已经有的信用资产、技能资产、实物资产、人民币资金等  

App中的名词定义和10种转账类型：  

	一键发币    = a1  +b1|b2 +c1|c2|c3  +d1     +e1     +f1           ——①技能合约  ——②口头承诺(剧情合约) ——③鸟币红包      
	一键ICO    = a1  +b1    +c2|c3     +d2     +e2     +f2|(f1&f2)   ——④投资合约(有风险)  ——⑤对赌合约（能保底的投资）    
	
	鸟币转手    = a2  +b1    +c1|c2|c3  +d1     +e1     +f1           ——⑥转卖①|③  ——⑦赠送①|③  注：1.转手普通鸟币需要对方已经注册，发行则不必。2.适用于>=3星的普通鸟币  
	ICO转手    = a2  +b1    +c1|c2|c3  +d1     +e1     +f2			 ——⑧转卖④|⑤  ——⑨赠送④|⑤  
	转赠超级鸟币 = a2  +b2    +c3        +d1     +e1     +f1           ——⑩赠送② 注：1.超级鸟币一次交易一个 2.不支持买卖（包括出售、转卖和提现）  

	鸟币交易所可如下表：
	公开的鸟币转手服务 = a2  +b1  +c1|c2|c3  +d1|d2  +e1|e2  +f1         ——转卖①|③ 
	公开的ICO转手服务 = a2  +b1  +c1|c2|c3  +d1|d2   +e1|e2  +f2	    ——转卖④|⑤  

4种接收方式  

	1.通过手机号来获取WalletKey转账 
	2.通过扫描由WalletKey生成的唯一WalletQRC二维码来转账 
	3.通过唯一的角色名获取用户的WalletKey称来转账 
	4.通过唯一的用户名获取WalletKey来转账

### 自助信用

	一、鸟币信用算法和等级定义：

		首先，定义发行出去的鸟币拥有3种状态：
		状态A：已回收 信用权重：1=100%
		状态B：未回收 信用权重：φ=61.8034% 
			B说明：
			未回收状态说明双方信任存在，鸟币信用良好
		状态C：拒绝回收 信用权重：((1-φ)/(1+φ))²= 5.5728% 
			C说明：
			1.信用收缩和信用扩张未达成一致，协商延后也失败的状态 
			2.鸟币回流被拒绝后，发行者信用值会降低；若主动向债主提供服务，则可以立刻恢复正常信用值，即使债主拒绝

		定义计算方法：
		1.如果存在状态C: 鸟币信用 = (B*B数量＋C*C数量) / (B数量+C数量)
		2.如果不存在状态C: 鸟币信用 = (A*A数量+B*B数量) / (A数量+B数量)

		定义评级：
		φ=61.8034%
		x=(1-φ)/(1+φ)=23.6068%
		y=1-x=76.3932%

		新用户无交易数据：鸟币信用 = 0
		冒险型：0.0% < 鸟币信用 < 23.6068%
		进击型：23.6068% <= 鸟币信用 < 50.0%
		良好型：50.0% <= 鸟币信用 < 61.8034%
		优秀型：61.8034% <= 鸟币信用 < 76.3932%
		安全型：76.3932% <= 鸟币信用 <= 100.0%

		说明：
		1.只要有1次状态C出现，则角色的鸟币信用为良
		2.若有大于2次拒绝回收鸟币，则鸟币信用必然为冒险型信用
	
	二、超级鸟币不计入鸟币信用的计算，仅展示已兑现和已拒绝的次数
		因为真爱是难以衡量和比较的。  
		
### 鸟币等级
	3大类交易行为：发行(可以是支付、赠送、出售)、转手(可以是支付、转赠、转卖)、兑现(包括兑现技能、提现现金、超级鸟币)，其中超级鸟币不支持出售、转卖和提现
	默认发行后即可'兑现技能'，默认占1星（鸟币等级一共5星）
	1. 是否可以'转赠'鸟币，占普通鸟币一颗星
	2. 是否可以'转卖'鸟币，占普通鸟币一颗星
	3. 是否可以'提现（RMB）'，占普通鸟币一颗星
	4. 是否可以'立即提现（RMB）'，占普通鸟币一颗星
		
### 鸟币转账
	1. 超级鸟币一次交易一个 
	2. 超级鸟币不支持买卖（包括出售、转卖和提现）
	3. 转手普通鸟币需要对方已经注册，发行则不必
		
### 鸟币兑现
	1. 兑现鸟币(包括兑现技能、提现现金、履行超级鸟币的承诺)
	2. 鸟币回收接受时间未24小时，超时未接受将自动视为拒绝回收
	3. 如果单一版本的数量不够兑现某个技能，但加上其他版本的此类型鸟币却够兑换时，拒绝回收不影响鸟币信用
	4. 拒绝兑现超级鸟币不影响鸟币信用

### 最小化信任点
	唯一不存在的就是不存在本身，所以但凡交易系统，就必有信任之处！
	“程序内部”并不能解决所有信用问题，比如怀疑、否定，都是人的大脑的功能的一部分，区块链也解决不了。
	对于鸟币系统来说，建立一个最小化的信任点的程序就是鸟币的做到的极致，只需要相信正在使用的鸟币实例部署者一个人，就可以让整个系统成立。部署鸟币的开发者越多，用户能选择的服务点就越多。    

### 技能版本和鸟币版本关系

![](http://ww1.sinaimg.cn/large/5d92cda0ly1freh0wlnujj21qx0ze1ds.jpg)

### more

1. 鸟币白皮书(过时待更)：[niaobi.win](http://niaobi.win)
2. 鸟币黄皮书(过时待更)：[niaobi.win-yellow-paper](http://niaobi.win)
3. 鸟神微信：cooerosn1  
4. telegram：[cooerson](https://t.me/cooerson)  


## 部署引导（development）

欢迎所有开发者部署此项目为大家提供鸟币服务。需要注意：

1. 请让用户知道是非官方出品的鸟币应用
2. 请稍微修改官方Logo（蓝色的小鸟在一朵云中间的那个）
3. 请按照开源协议公开你的代码
 
 
### 部署前

1. 部署时 安装nginx
2. 部署时 安装mongodb,添加用户名和密码 
3. 部署时 安装golang
4. 部署时 安装图片处理库 https://github.com/DAddYE/vips
5. 部署时 在FontDir放置字体文件
6. 在PublicDir放置web网站
7. 部署时 在/etc/nginx/ssl/cert放置https证书xxx.key和xxx.pem,在PublicDir放置放置fileauth.htm
8. 部署时 在HtmlDir放置隐私协议等单网页
9. 二进制部署时 记得把config.toml文件和files文件夹放到同级目录
10. 部署时 config.toml设置Debug为false
11. 定时更新鸟币汇率
12. 更新任何接口后，更新kApiVersion


### 部署详情

#### 本地配置 ~/.ssh/config
	Host ibis  
	HostName x.x.x.x #改成你自己的服务器地址   
	User xxx #改成你的服务器用户名称  

#### 服务器挂载数据盘
https://www.qcloud.com/document/product/362/6735

#### 使用dnspod修改域名服务商的鸟币域名的解析


#### ubuntu部署https,使用阿里云https证书,手动版
1. 安装nginx  
    https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-14-04-lts  
    https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-16-04  
2. 修改nginx配置  参考https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-virtual-hosts-on-ubuntu-14-04-lts
    1. sudo mkdir -p /ibis/public/.well-known/pki-validation （第一次获取证书需要）
    2. sudo chmod -R 755 /ibis/public/
    3. 上传验证文件（第一次获取证书需要）  
    
	        scp fileauth.txt ibis:/ibis/public/.well-known/pki-validation

    4. 新建nginx配置文件目录 
    
	        sudo mkdir -p /var/www/niaobi.org/html
	        sudo chown -R $USER:$USER /var/www/niaobi.org/html
	        sudo chmod -R 755 /var/www
	        sudo vi /etc/nginx/sites-available/niaobi.org
	        粘贴nginx_ca的内容 （第一次获取证书需要）
	        sudo ln -s /etc/nginx/sites-available/niaobi.org /etc/nginx/sites-enabled/
	        sudo service nginx restart
	        测试访问web http://niaobi.org 显示nginx欢迎页 （第一次获取证书需要）
	        下载证书（第一次获取证书需要）
        
    5. 复制ssl证书到服务器 
     
			sudo mkdir -p /etc/nginx/ssl/cert  
			sudo chmod -R 777 /etc/nginx/ssl/cert  
			scp xxx.key xxx.pem ibis:/etc/nginx/ssl/cert 
	        
    6. 粘贴nginx的内容到/etc/nginx/sites-available/niaobi.org  
        sudo service nginx restart  
        测试访问本机（hosts中把niaobi.org设为127.0.0.01）  
        可以看到 https://niaobi.org/ 带有小绿锁  

#### 使用腾讯云和dnspod，配置https证书，自动版；再上传nginx配置文件和下载的证书
1.类似阿里云，参考niaobi.net的nginx文件  
https://www.qcloud.com/document/product/400/4143

#### 记得下载在浏览器访问后下载.cer文件放到iOS客户端里
    
#### 安装mongodb
#### mongodb添加密码、修改端口等安全加固
https://help.aliyun.com/knowledge_detail/37451.html  
https://medium.com/@matteocontrini/how-to-setup-auth-in-mongodb-3-0-properly-86b60aeef7e8  

	> mongo
	> use admin
	> db.createUser({ user: "超级管理员名称", pwd: "超级管理员密码", roles: ["root"] })
	测试 > db.auth("超级管理员名称","超级管理员密码")
	返回1，则为成功。
	> use ibis
	> db.createUser({ user: "数据库管理员名称", pwd: "数据库管理员密码", roles: [{ role: "dbOwner", db: "数据库名称" }] })
	> db.auth("数据库管理员名称","数据库管理员密码")
	返回1，则为成功。

设置config的auth参数为true！重启mongodb服务

通过以下字符串进行连接  
mongodb://youruser:yourpassword@localhost/yourdatabase


其他：
网站根目录放置图标  
/apple-touch-icon-precomposed.png  
/apple-touch-icon.png  
/apple-touch-icon.png   
 
 
todo..
 
## 一键快速部署（service提供者）


todo..