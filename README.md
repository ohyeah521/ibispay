# 部署注意事项

- 部署时 安装golang
- 部署时 安装beanstalkd https://github.com/beanstalkd/beanstalkd
- 部署时 修改配置文件:config.toml和private.go

- 更新鸟币汇率，每月定时
- 更新任何接口后，更新kApiVersion，避免客户端缓存问题
- 更新网站资源文件后，如js、css、图片等，可以改变资源文件的文件名版本后缀，防止缓存问题（配合nginx设置）
- 更新服务器ssl证书的时候，记得同时更新本地开发环境



# 部署详情

# ================本地ssh配置 ~/.ssh/config=======================
Host ibis
HostName x.x.x.x #改成你自己的服务器地址
User xxx #改成你的服务器用户名称
# ===========================================

# linux
sudo apt-get install beanstalkd
#后台运行
beanstalkd & 
# mac
brew install beanstalk
beanstalkd
# gui https://github.com/xuri/aurora

# ====== nginx配置 ===ubuntu16.04部署nginx1.17.3、openssl1.1.1===========

# 参考 https://www.c-rieger.de/ubuntu-debian-nginx-openssl-1-1-1/
#   sudo apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev unzip uuid-dev

    sudo -s
    cd /usr/local/src
    wget http://nginx.org/keys/nginx_signing.key && apt-key add nginx_signing.key


    vi /etc/apt/sources.list
#添加以下两行
UBUNTU:
    deb http://nginx.org/packages/mainline/ubuntu/ bionic nginx
    deb-src http://nginx.org/packages/mainline/ubuntu/ bionic nginx

## openssl
    apt update
    mkdir /usr/local/src/nginx && cd /usr/local/src/nginx/
    apt install dpkg-dev -y && apt source nginx
    cd /usr/local/src && apt install git -y
    git clone https://github.com/openssl/openssl.git
    cd openssl && git branch -a

    git checkout OpenSSL_1_1_1-stable

## nginx
    vi /usr/local/src/nginx/nginx-1.17.2/debian/rules
    在CFLAGS后，最后添加 
            --with-openssl=/usr/local/src/openssl，
        和其他模块 比如 添加缓存清理ngx_cache_purge和google的pagespeed模块编译
            --add-module=/usr/local/src/ngx_cache_purge-2.3 --add-module=/usr/local/src/incubator-pagespeed-ngx-1.13.35.2-stable
        debug块也要添加。
    把 dh_shlibdeps -a 修改为
        dh_shlibdeps -a --dpkg-shlibdeps-params=--ignore-missing-info
    打开 vi /usr/local/src/nginx/nginx-1.17.2/auto/cc/gcc
    注释掉 #CFLAGS="$CFLAGS -Werror" 避免编译警告退出
    切回路径 
        cd /usr/local/src/nginx/nginx-1.17.2/
    开始编译
        apt build-dep nginx -y && dpkg-buildpackage -b
    编译好后，删除现在可能有的nginx
        apt remove nginx nginx-common nginx-full -y --allow-change-held-packages
    安装最新的
        dpkg -i nginx_1.17.2*.deb
        systemctl unmask nginx
    重启
        service nginx restart
    防止自动升级
        apt-mark hold nginx
    最后查看信息
        nginx -V
# ===========================================



#=================把web网站部署到nginx======================
# 一、nginx通用配置修改
    #1.创建nginx防抓取名单，粘贴"bad_bot_通用.conf"（已除去了google、yahoo和baidu）的内容，数据来自于
    #https://github.com/JayBizzle/Crawler-Detect
    sudo vi /etc/nginx/bad_bot.conf

    #2.修改nginx配置，资源文件均防抓取，open文件夹中的资源除外。
    sudo vi /etc/nginx/nginx.conf
    #添加"通用nginx.conf"中的代码，reload后默认的nginx缓存文件夹在/data/nginx_cache/

# 二、部署web网站
1.申请腾讯免费ssl证书
2.复制ssl证书到服务器
    #新建目录
    sudo mkdir -p /etc/nginx/ssl/cert
    sudo chmod -R 777 /etc/nginx/ssl/cert
    #复制到服务器
    scp xxx.key xxx.crt ibis:/etc/nginx/ssl/cert
    #生成dhparam.pem
    sudo openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
3.新建相关配置文件 
    #pagespeed缓存文件夹是/data/pagespeed_cache和/data/ngx_pagespeed/，重启nginx的时候会自动生成
    #粘贴nginx配置
    sudo vi /etc/nginx/sites-available/xingdongpai.com
    #创建软链接
    sudo ln -s /etc/nginx/sites-available/xingdongpai.com /etc/nginx/sites-enabled/
    #平滑重启
    sudo nginx -s reload
4.将web html文件放置在配置的路径 
    sudo mkdir -p /act/public
    sudo chmod -R 777 /act/public
    上传web文件
5.修改dnspod中的指向服务器ip
6.注意默认js、css、图片等资源文件缓存为30天，除了purge插件清除的方式外，最好每次更改文件名的版本。

# 其他：
//linux查看所有端口占用情况，卡死的nginx可以直接kill
    sudo netstat -ntpl

## mac开发环境下：
Docroot is: /usr/local/var/www

#测试端口8080
The default port has been set in /usr/local/etc/nginx/nginx.conf to 8080 so that
nginx can run without sudo.

#在server目录下粘贴nginx配置
nginx will load all files in /usr/local/etc/nginx/servers/.

To have launchd start nginx now and restart at login:
  brew services start nginx
Or, if you don't want/need a background service you can just run:
  nginx


//mac查看某个端口占用情况
  lsof -i tcp:8080
//查看错误日志
cat /usr/local/var/log/nginx/error.log
//常用命令
  nginx               启动nginx
  nginx -s stop       快速关闭Nginx，可能不保存相关信息，并迅速终止web服务。
  nginx -s quit       平稳关闭Nginx，保存相关信息，有安排的结束web服务。
  nginx -s reload     因改变了Nginx相关配置，需要重新加载配置而重载。
  nginx -s reopen     重新打开日志文件。
  nginx -c filename   为 Nginx 指定一个配置文件，来代替缺省的。
  nginx -t            不运行，而仅仅测试配置文件。nginx 将检查配置文件的语法的正确性，并尝试打开配置文件中所引用到的文件。
  nginx -v            显示 nginx 的版本。
  nginx -V            显示 nginx 的版本，编译器版本和配置参数。
# =======================================


# ==================== 安装部署golang ===============================
https://www.digitalocean.com/community/tutorials/how-to-install-go-1-6-on-ubuntu-16-04


1.项目用到了https://github.com/DAddYE/vips库，需要单独安装
    sudo apt-get install automake build-essential git gobject-introspection libglib2.0-dev libjpeg-turbo8-dev libpng12-dev gtk-doc-tools
    cd /usr/local/src
    git clone git://github.com/libvips/libvips.git
    cd libvips
    ./autogen.sh
    ./configure --enable-debug=no --without-python --without-fftw --without-libexif --without-libgf --without-little-cms --without-orc --without-pango --prefix=/usr
    make
    sudo make install
    sudo ldconfig
2.上传源码，在源码目录下执行：
    go get -v
    会自动下载依赖包
3.调试：go run main.go
#=================================================================


#========================安装运行postgres==========================
#-----------------mac下开发---------------
安装postgres.app 一键启动
安装postico(创建索引功能方便)和navicat premium（创建字段功能和导出sql功能完善），
1.使用gui创建表，使用xorm 生成model
xorm reverse postgres "user=postgres password='' dbname=ibispay host=127.0.0.1 port=5432 sslmode=disable" /Users/cooerson/Documents/go/src/github.com/go-xorm/cmd/xorm/templates/goxorm  /Users/cooerson/Desktop
2.修改需要修改的字段，使用 xorm再次sync数据库，修正所有warming
3.使用navicat premium导出sql，供部署时使用，也可生成Diagram备份。

---------------部署-------------------
1.新建ibispay数据库，然后执行ibispay.sql生成数据库



#====================预编译html模板======================================

hero -source=/Users/cooerson/Documents/go/src/ibis.love-go/templates/order

#=======================================================================



#---------------------使用endless运行release程序------------
linux:
查看占用的端口
sudo netstat -ntpl
kill 占用6180的端口

1.修改config中的debug为false
2.在go源码目录下执行
go build main.go
3.执行./main
得到 pid 如 21561
4.另外开一个终端
执行 kill -1 21561 即可

mac：
查看占用的端口
lsof -i tcp:6180
其余同linux

#=======================================







#========其他：apt卸载nginx方法===========
# apt卸载nginx方法
卸载方法1.
    ##删除nginx，保留配置文件
    sudo apt-get remove nginx
    #删除配置文件
    rm -rf /etc/nginx

卸载方法2.
    ##删除nginx连带配置文件
    sudo apt-get purge nginx # Removes everything.

    #卸载不再需要的nginx依赖程序
    sudo apt-get autoremove
# ======================================