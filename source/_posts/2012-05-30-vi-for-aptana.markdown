---
layout: post
title: "Vi for Aptana"
date: 2012-05-30 10:38
comments: true
categories: 
- 神器
---

近日学习vi，但我又习惯windows下的输入法。后来一想我看中的vi也是它的编辑性能，目录树等能力还真的不如
IDE好用。于是想想可能aptana也能装vi的插件。毕竟这和eclipse是通用的，而eclipse下安装vi应该是存在这种需求的。

参照[[1](http://blog.csdn.net/dadoneo/article/details/6077435)]，并在[[2]](http://duduhehe.iteye.com/blog/473999)
下载配置好后，算是跑了起来。

用用的感觉还不错。至少有了`CommandMode` `InsertMode`.

```
                              Lesson 1 SUMMARY


  1. The cursor is moved using either the arrow keys or the hjkl keys.
         h (left)       j (down)       k (up)       l (right)

  2. To start Vim from the shell prompt type:  vim FILENAME <ENTER>

  3. To exit Vim type:     <ESC>   :q!   <ENTER>  to trash all changes.
             OR type:      <ESC>   :wq   <ENTER>  to save the changes.

  4. To delete the character at the cursor type:  x

  5. To insert or append text type:
         i   type inserted text   <ESC>         insert before the cursor
         A   type appended text   <ESC>         append after the line

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                               Lesson 2 SUMMARY


  1. To delete from the cursor up to the next word type:    dw
  2. To delete from the cursor to the end of a line type:    d$
  3. To delete a whole line type:    dd

  4. To repeat a motion prepend it with a number:   2w
  5. The format for a change command is:
               operator   [number]   motion
     where:
       operator - is what to do, such as  d  for delete
       [number] - is an optional count to repeat the motion
       motion   - moves over the text to operate on, such as  w (word),
                  $ (to the end of line), etc.

  6. To move to the start of the line use a zero:  0

  7. To undo previous actions, type:           u  (lowercase u)
     To undo all the changes on a line, type:  U  (capital U)
     To undo the undo's, type:                 CTRL-R
```