---
layout: post
title: "Mybatis-plus的字段为复杂对象的读取和装载"
date: 2021-01-14 21:19
comments: true
categories: 
- 技术
- java
---

如果核心代码写的非常OO，那么Entity中自然会出现很多Value Object。一旦这些VO需要存入数据库，则会牵涉到一个数据库字段转换到Java类型的ORM问题。  
比如有下面的代码：

```java
@Data
// @TableName(autoResultMap = true)
public class Validator {
    private Long id;

    // @TableField(typeHandler = CommissionTypeHandler.class)
    private Commission commission;
}

public class Commission {
    final private BigDecimal commission;
}
```

Commission作为一个VO，也需要保存到Validator的表格中。Mybatis通过typeHandler的方式来实现这种钩子，完成这种转换。具体做法为先定义相应的handler, 即`TypeHandler<T>`接口的实现类

```java
import com.walletguard.polkadotprx.entity.Commission;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.MappedJdbcTypes;
import org.apache.ibatis.type.MappedTypes;
import org.apache.ibatis.type.TypeHandler;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@MappedJdbcTypes(JdbcType.DECIMAL)  //数据库类型
@MappedTypes(Commission.class)
public class CommissionTypeHandler implements TypeHandler<Commission> {

    @Override
    public void setParameter(PreparedStatement ps, int i, Commission parameter, JdbcType jdbcType) throws SQLException {
        ps.setBigDecimal(i, parameter.getCommission());
    }

    @Override
    public Commission getResult(ResultSet rs, String columnName) throws SQLException {
        BigDecimal co = rs.getBigDecimal(columnName);
        return new Commission(co);
    }

    @Override
    public Commission getResult(ResultSet rs, int columnIndex) throws SQLException {
        BigDecimal co = rs.getBigDecimal(columnIndex);
        return new Commission(co);
    }

    @Override
    public Commission getResult(CallableStatement cs, int columnIndex) throws SQLException {
        BigDecimal co = cs.getBigDecimal(columnIndex);
        return new Commission(co);
    }
}

```

该接口有4个需要实现的method，其中3个是读取，1个是写入，这里又用到了很传统的JdbcTemplate的方式类设置和读取相应的值，读出后转换成自己需要的对象。
`MappedJdbcTypes`指明了Jdbc中的类型， `MappedTypes`指明了OO中的对象类型，也就是接口`TypeHandler<T>`中的T。

然后，在上面类型的对象中，作` @TableField(typeHandler = CommissionTypeHandler.class)`声明，即意味着该字段用这个typeHandler来进行处理。  
但是，这只是确保可以写入，如果要支持读取，还需要在Class的开头，加上`@TableName(autoResultMap = true)`，这样这个ORM就实现了。
