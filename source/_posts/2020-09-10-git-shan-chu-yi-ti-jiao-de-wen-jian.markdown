---
layout: post
title: "git 删除已提交的文件"
date: 2020-09-10 17:41
comments: true
categories: 
- 技术
- git
---

按台湾人的说法，git属于一旦有东西加入，就像把方丈请到了庙里，是很难再请出去的。
不过也不是完全不可能，但确实比较辛苦会。核心思想是通过`filter-branch` 
来强制删除有关的文件，过程中类似`rebase`。在全部的分支、tag、heads、replace的
连接取消之后，再次gc，即可实际清除

```
# 找出体积比较大的文件
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -5 | awk '{print$1}' )"

# 进行删除
git filter-branch --force --index-filter 'git rm -rf --cached --ignore-unmatch .gradle' --prune-empty --tag-name-filter cat -- --all

# 实际删除
rm -rf .git/refs/original
git reflog expire --expire=now --all
git gc --prune=now
```

不过上述只是完成了本地的内容清理，远端的gitlab还有其他工作要做：

```
git push origin --force 'refs/heads/*'
git push origin --force 'refs/tags/*'
git push origin --force 'refs/replace/*'
```

最后，再去gitlab的settings里面手工执行一下Housekeeping，再次clone的话体积就小了。