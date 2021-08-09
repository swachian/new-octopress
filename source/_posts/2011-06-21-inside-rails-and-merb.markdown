---
layout: post
title: "[zz]Rails与Merb合并背后的故事"
date: 2011-06-21 16:48
comments: true
categories: 
- 技术
- rails
---

Rails的目标是减少cost并带来极大的方便，而yehuda提出的现代化框架虽然有架构之美，但对方便性却没什么意义，效益增收不明显，而且实践极难，所以rails团队一直没做。

    *
    * [閒聊] Rails 與 Merb 合併背後的故事 剛剛有感而發，在公司開發的 microblog上寫了一段 Rails 與 Merb 合併的故事，以作

1
2010-03-10 　　
发表:xdite

剛剛有感而發，在公司開發的 microblog上寫了一段 Rails 與 Merb 合併的故事，以作為一些事情的借鏡。後來覺得寫太長了，所以就乾脆整理一下貼過來…

====

Merb 當初是為了要解決 Rails 沒辦法解決的問題，比如說上傳檔案會造成整個網站 hang 住才開始開發的。在 Yehuda 當初設計的哲學之中，他認為 Framework 內部要能夠 modularity 。同時要能實現 ORM Agnosticism，甚至不只 ORM ，包括 javascript library 之類的也都必須要可以這麼做。最後幹出了一套 merb。於是在 2008 年逐漸形成了 Rails 與 Merb 之爭。

但 Merb 越來越開發到最後，core team 發現到一件事，”過於自由” 並不會帶來開發上的便利，反而形成 Merb 內部 component dependency 的 conflict。同時，對於寫出一套 Merb application，不像 Rails 一樣，大家並沒有很清楚的開發標準與 Best Practice，而光看教學文件，因為版本與寫法的關係，造成有心踏入 merb 的開發者一天到晚踩中難以解決的地雷。

更糟糕的是，跳槽來 Merb 的人都是前 Rails 開發者，雖然他們多半是不滿 Rails 的束縛過來的，但他們過來之後，對 Merb 最大的抱怨變成：Merb 並沒有 Rails 那麼便利。這個沒有，那個沒有 ….

剛開始，Merb 的核心團隊，對於這些抱怨，解決之道，就是你喊缺，我們就加！但寫到最後越來越不對勁。他們越來越接近在「重寫」一個 Rails 而已。但這些開發者並不會感激他們。開發者還是只會抱怨 Merb 相比起 Rails「還」缺了甚麼。

加功能，並不會讓 Merb 從此以後取代 Rails，只是永無止盡的追趕和重造輪子，但是開發者還是只是會繼續抱怨。而且，一個 Community 再大，力量也只撐的起一個「主流」Framework。Merb 與 Rails 之爭，相當的損害了社群的開發元氣。

Yehuda 覺得這樣發展下去並不是他的本意。於是找上了 Rails core team 談。一談之下，才達成了現在的合併共識。Rails Core Team 覺得 Yehuda 提的 modulity 與 API 是很好的提議，只是他們「不在乎」。這個不在乎並不是真的不在乎，而是 Rails 的 goal 是壓縮開發的 cost，讓 convention 達到最大化，在此目標之下，要做這件事並沒有太大的實質效益，而且他們這些人的力量與技術能力也不夠做這件事。

而 Yehuda 的原意是他要解決 Rails 沒有辦法達成的事，同時帶進他覺得 modern framework 應該要有的設計，這樣才能讓整個 framework scable，連帶 application 也 scable。而非玩到如今的局面 :「 硬是重造一個 Rails」。既然 Rails core team 也覺得 Yehuda 提的很好很重要，只是他們沒能力去做。而如今 Yehuda 也有能力有意願去做，那就讓他加入 Rails core team 做這件事吧。

所以才造就現在看到的偉大 framework : Rails 3。

====

apply 到一些場景，真是感觸良多啊 /_\