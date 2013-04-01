## 命令备忘




### 插入命令
    a 当前光标后面
    i 当前光标前面
    o 当前光标下面一行
    O 插入当前行，当前行下移

### 保存命令

    wq
    x



### 返回命令行

    ctrl + [
    ESC



### 移动命令

   ^$  一行的开头和结尾
   hjkl
   G   最后一行
   2G  第3行


### 复制黏贴

    yy  复制
    p   黏贴到上一行
    P   黏贴到下一行
    u   撤销
    ctrl + y 恢复
    / 查找， n 下一个
    %s/a/b/g   %表示所有行，a表示寻找内容，b表示替换内容，g表示正行都需要
    r 替换单个字符
    R 替换多个字符，连续按



### 末行模式
    ！ 执行shell脚本
    r! 脚本结果写入文档
    w 保存
    w other 另存为

### 末行模式操作技巧


    1,8s/^/#/g 第一道第八行前面加#号
    1,8 >> 右移两个tab
    1,8 << 左移


### 几种编码
    :set fileencoding=utf-8  文件编码
    fileencodings  支持文件编码
    encoding  vim内部编码
    let &termencoding=&encoding 设置终端编码与vim编码一样
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim   解决菜单乱码





看到39'49
