---
layout: post
title: "mysql的库表容量查询"
date: 2021-08-09 17:52
comments: true
categories: 
- 技术
---

```
select  
table_schema as '数据库',  
table_name as '表名',  
table_rows as '记录数',  
truncate(data_length/1024/1024, 2) as '数据容量(MB)',  
truncate(index_length/1024/1024, 2) as '索引容量(MB)'  
from information_schema.tables  
order by data_length desc, index_length desc; 
```

可以查询库里的表名、数据容量和索引容量。