# SQL 进阶教程

## 1.SQL
### 1.1 CASE 表达式
#### CASE 表达式

使用场景
 - 降维
 - 分类


CASE 表达式分为简单 CASE 表达式 和 搜索 CASE 表达式
```sql
-- 简单
CASE sex
    WHEN '1' THEN '男'      -- when 后面的为 条件，then 后面的为 结果
    WHEN '2' THEN '女'
ELSE '其它' END

-- 搜索
CASE WHEN sex = '1' THEN '男'
     WHEN sex = '2' THEN '女'
ELSE '其它' END

-- 统计结果
select case when `verify_status`='2' then '成功'
	when `verify_status`='5' then '失败'
    else '其它' END as result,
    count(*) as num
from `advertiser_verify`
group by result     -- group by 字句里引用了 select 自居中定义的别名
```
注意点:
 - 发现为真的 when 字句时，case 表达式的真假判断就会中止
 - 编写 when 字句时要注意排他性，即同一种情况不应该出现在两个字句中
 - 不要忘记写 end 和 else

```sql
select pref_name,
       SUM(population)
FROM pop
WHERE sex = '1'

select pref_name,
       SUM(population)
FROM pop
WHERE sex = '2'

-- 该 sql 可以实现上面两条 sql 的功能
SELECT pref_name,
       SUM( CASE WHEN sex = '1' THEN popolation ELSE 0 END ) as cnt_m,
       SUM( CASE WHEN sex = '2' THEN popolation ELSE 0 END ) as cnt_f
FROM pop
GROUP BY pref_name;
```
 - 新手用 where 字句进行条件分支，高手用 select 字句进行条件分支

#### check约束
在创建表的时候添加某种条件约束
```sql
create table test(
    ...
    CONSTRAINT check_salary CHECK (sex='2' and salary <= 2000)  -- check_salary 为约束名，() 内为约束内容，即表中数据应该满足括号内的条件
)
```

#### update 语句里添加条件约束
```sql
UPDATE salary
    SET salary = CASE WHEN salary = 100 THEN salary*10
                      WHEN salary = 900 THEN salary*9;
```