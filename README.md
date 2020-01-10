# The work is approaching completion !  

---  
以下暂未整理。  

# 部署注意事项

- 部署时 安装golang
- 部署时 安装beanstalkd https://github.com/beanstalkd/beanstalkd
- 部署时 修改配置文件:config.toml和private.go

- 更新鸟币汇率，每月定时
- 更新任何接口后，更新kApiVersion，避免客户端缓存问题
- 更新网站资源文件后，如js、css、图片等，可以改变资源文件的文件名版本后缀，防止缓存问题（配合nginx设置）
- 更新服务器ssl证书的时候，记得同时更新本地开发环境


# linux  
sudo apt-get install beanstalkd  
#后台运行  
beanstalkd & 

# mac  
brew install beanstalk  
beanstalkd  
### gui https://github.com/xuri/aurora  


#安装运行postgres
### mac下开发  
安装postgres.app 一键启动  
安装postico(创建索引功能方便)和navicat premium（创建字段功能和导出sql功能完善），  

1. 使用gui创建表，使用xorm 生成model  
xorm reverse postgres "user=postgres password='' dbname=ibispay host=127.0.0.1 port=5432 sslmode=disable"   /Users/cooerson/Documents/go/src/github.com/go-xorm/cmd/xorm/templates/goxorm  /Users/cooerson/Desktop  
2. 修改需要修改的字段，使用 xorm再次sync数据库，修正所有warming  
3. 使用navicat premium导出sql，供部署时使用，也可生成Diagram备份。  

### 部署
1.新建ibispay数据库，然后执行ibispay.sql生成数据库