# sql中索引不会被用到的几种情况

1. 如果MySQL估计使用索引比全表扫描更慢，则不使用索引。例如，如果列key均匀分布在1和100之间，下面的查询使用索引就不是很好：select * from table_name where key>1 and key<90;
2. 如果使用MEMORY/HEAP表，并且where条件中不使用“=”进行索引列，那么不会用到索引，head表只有在“=”的条件下才会使用索引