--创建表空间：
create tablespace TS_AML datafile 'D:\app\TS_AML.dbf' size 1000m;


--创建用户
create user amlyx2
identified by amlyx2
default tablespace TS_AML
temporary tablespace TEMP
profile DEFAULT
quota unlimited on TS_AML;
  
--赋权限
grant dba to amlyx2;


alter user mdc default tablespace TS_AML;


--导入.dmp文件 .cmd命令窗口执行 .sql文件改为.pdc文件sql window 执行
imp amlhx2/amlhx2@ORCL file=D:\workFile\s数据库\amlhx2data_接口_20180319.dmp  fromuser=amlhx2 touser=amlhx2 ignore=y;
tables=aml_dubitably_trade_report

imp amlst2/amlst2@ORCL file=D:\workFile\上投库20180410\data20180410.dmp  fromuser=aml touser=amlst2 ignore=y;

--导出
imp amlxy1/amlxy1@ORCL file=C:\Users\user\Desktop\鑫元基金\导出\xyaml.dmp  fromuser=amlxy2 touser=amlxy1 ignore=y;
tables=UM_USERINFO

