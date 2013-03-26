---
layout: post
title: "ubuntu1104安装手记"
date: 2011-06-16 14:52
comments: true
categories:
- 技术
- 安装
---


前提：拥有虚拟机并已经安装好ubuntu1104

###1. 默认没有ssh server，所以需要安装.安装完成后，会自动打开每次启动的选项。

        $ sudo apt-get install openssh-server


###2. 安装一堆可能会用到的包，包括git需要的curl ， zlib等

    sudo apt-get install curl libcurl3 libcurl3-dev
    apt-get install zlib1g-dev #安装git需要
    apt-get install bison
    /usr/bin/apt-get install build-essential bison openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev


###3. 设置时区，及设置ntpdate定期更新例程
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    ntpdate ntp.fudan.edu.cn


###4. 安装rvm及ruby环境

    $ bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
    $ echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" >>  ~/.bash_profile
    $ source ~/.bash_profile


rvm基本指令

    rvm list known
    rvm install 1.9.2
    rvm use 1.9.2
    rvm gemset list
    rvm gemset create r310
    rvm gemset use r310
    rvm use 1.9.2@r310


###5. 安装mysql

    $wget http://unmp.googlecode.com/files/mysql-5.1.57.tar.gz
    $tar -zxvf mysql-5.1.57.tar.gz
    $ sudo groupadd mysql
    $ sudo useradd -g mysql mysql
    $ ./configure --prefix=/opt/mysql --with-charset=utf8 --with-extra-charsets="gbk,gb2312,big5" --with-plugins=innobase
    $ make && make install

    cp support-files/my-huge.cnf /etc/my.cnf
    cp support-files/mysql.server /etc/init.d/mysqld
    chmod 755 /etc/init.d/mysqld
    cd /etc/init.d/
    who -r
    cd /ect/rc5.d/
    ln -s ../init.d/mysqld S85mysqld
    ln -s ../init.d/mysqld K85mysqld
    vi /etc/my.cnf
		 在/etc/my.cnf中设置innodb成为默认的数据库引擎
		default-storage-engine=INNODB
		transaction-isolation=READ-COMMITTED #将innodb的事务隔离级别调整,以保证提交的数据必定被读取
        grant all on *.* to 'user'@'%' identified by 'password';
    cd /opt/mysql/
    ./bin/mysql_install_db
    chown -R root .
    chown -R mysql var
    /etc/init.d/mysqld start


###6. 更新rubygem

    gem install update-system
    update_rubygems
    update_rubygems


###7. 安装rails
    gem install rails
    gem install mysql2


### 附录secure crt相关
SecureCRT设置彩色和显示中文
设置Options->SessionOptions ->Emulation,然后把Terminal类型改成xterm，并点中ANSI Color复选框。
字体设置：Options->SessionOptions->Appearance->font然后改成你想要的字体就可以了。
注意：
1：字符集选择utf8，这样可以避免显示汉字乱码
2：选择字体的时候，需要选择ture type的字体(如新宋体)，不然会出现汉字乱码
3：scrollback buffer 调大(5000)，这样你就可以看到以前显示内容，这样方便很多
4：terminal要选择xtem，这样你ssh到服务器上才能显示颜色，并把ANSI Color打上勾
5：我选择的颜色方案Windows或Traditional。
