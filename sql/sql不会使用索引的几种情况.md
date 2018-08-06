# sql中索引不会被用到的几种情况

1. 如果MySQL估计使用索引比全表扫描更慢，则不使用索引。例如，如果列key均匀分布在1和100之间，下面的查询使用索引就不是很好：select * from table_name where key>1 and key<90;
2. 如果使用MEMORY/HEAP表，并且where条件中不使用“=”进行索引列，那么不会用到索引，head表只有在“=”的条件下才会使用索引
3. 用or分隔开的条件，如果or前的条件中的列有索引，而后面的列没有索引，那么涉及到的索引都不会被用到，例如：select * from table_name where key1='a' or key2='b';如果在key1上有索引而在key2上没有索引，则该查询也不会走索引
4. 复合索引，如果索引列不是复合索引的第一部分，则不使用索引（即不符合最左前缀），例如，复合索引为(key1,key2),则查询select * from table_name where key2='b';将不会使用索引
5. 如果like是以‘%’开始的，则该列上的索引不会被使用。例如select * from table_name where key1 like '%a'；该查询即使key1上存在索引，也不会被使用
6. 如果列为字符串，则where条件中必须将字符常量值加引号，否则即使该列上存在索引，也不会被使用。例如,select * from table_name where key1=1;如果key1列保存的是字符串，即使key1上有索引，也不会被使用。