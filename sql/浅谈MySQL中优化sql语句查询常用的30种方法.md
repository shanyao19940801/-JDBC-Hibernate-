# 浅谈MySQL中优化sql语句查询常用的30种方法



1. 对查询进行优化，应尽量避免全表扫描，首先应考虑在 where 及 order by 涉及的列上建立索引。
2. 应尽量避免在 where 子句中使用!=或<>操作符，否则将引擎放弃使用索引而进行全表扫描。
3. 应尽量避免在 where 子句中对字段进行 null 值判断，否则将导致引擎放弃使用索引而进行全表扫描,如： 
<br>select id from t where num is null<br> 
可以在num上设置默认值0，确保表中num列没有null值，然后这样查询：<br> 
select id from t where num=0 


4. 应尽量避免在 where 子句中使用 or 来连接条件，否则将导致引擎放弃使用索引而进行全表扫描，如：<br> 
select id from t where num=10 or num=20<br> 
可以这样查询： <br>
select id from t where num=10<br> 
union all <br>
select id from t where num=20



1. 下面的查询也将导致全表扫描：<br> 
select id from t where name like '%abc%'<br> 
若要提高效率，可以考虑全文检索。 



1. in 和 not in 也要慎用，否则会导致全表扫描，如： 
<br>select id from t where num in(1,2,3) <br>
对于连续的数值，能用 between 就不要用 in 了： <br>
select id from t where num between 1 and 3 



1. 如果在 where 子句中使用参数，也会导致全表扫描。**因为SQL只有在运行时才会解析局部变量，但优化程序不能将访问计划的选择推迟到运行时；它必须在编译时进行选择**。然而，如果在编译时建立访问计划，变量的值还是未知的，因而无法作为索引选择的输入项。如下面语句将进行全表扫描： <br>
select id from t where num=@num <br>
可以改为强制查询使用索引： <br>
select id from t with(index(索引名)) where num=@num



1. 应尽量避免在 where 子句中对字段进行表达式操作，这将导致引擎放弃使用索引而进行全表扫描。如： 
select id from t where num/2=100 
应改为: 
select id from t where num=100*2 



1. 应尽量避免在where子句中对字段进行函数操作，这将导致引擎放弃使用索引而进行全表扫描。如： 
<br>select id from t where substring(name,1,3)='abc'--name以abc开头的id 
<br>select id from t where datediff(day,createdate,'2005-11-30')=0--'2005-11-30'生成的id 
<br>应改为: 
<br>select id from t where name like 'abc%' 
<br>select id from t where createdate>='2005-11-30' and createdate<'2005-12-1' 



1. 不要在 where 子句中的“=”左边进行函数、算术运算或其他表达式运算，否则系统将可能无法正确使用索引。 
2. 在使用索引字段作为条件时，如果该索引是复合索引，那么必须使用到该索引中的第一个字段作为条件时才能保证系统使用该索引，否则该索引将不会被使用，并且应尽可能的让字段顺序与索引顺序相一致。 
3. 很多时候用 exists 代替 in 是一个好的选择： 
<br>select num from a where num in(select num from b) 
<br>用下面的语句替换： 
<br>select num from a where exists(select 1 from b where num=a.num)



1. 尽量使用数字型字段，若只含数值信息的字段尽量不要设计为字符型，这会降低查询和连接的性能，并会增加存储开销。这是因为引擎在处理查询和连接时会逐个比较字符串中每一个字符，而对于数字型而言只需要比较一次就够了。  
2. 尽可能的使用 varchar/nvarchar 代替 char/nchar ，因为首先变长字段存储空间小，可以节省存储空间，其次对于查询来说，在一个相对较小的字段内搜索效率显然要高些。 
3. 任何地方都不要使用 select * from t ，用具体的字段列表代替“*”，不要返回用不到的任何字段。 
4. 
