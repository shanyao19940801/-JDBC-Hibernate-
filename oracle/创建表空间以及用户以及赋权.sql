--������ռ䣺
create tablespace TS_AML datafile 'D:\app\TS_AML.dbf' size 1000m;


--�����û�
create user amlyx2
identified by amlyx2
default tablespace TS_AML
temporary tablespace TEMP
profile DEFAULT
quota unlimited on TS_AML;
  
--��Ȩ��
grant dba to amlyx2;


alter user mdc default tablespace TS_AML;


--����.dmp�ļ� .cmd�����ִ�� .sql�ļ���Ϊ.pdc�ļ�sql window ִ��
imp amlhx2/amlhx2@ORCL file=D:\workFile\s���ݿ�\amlhx2data_�ӿ�_20180319.dmp  fromuser=amlhx2 touser=amlhx2 ignore=y;
tables=aml_dubitably_trade_report

imp amlst2/amlst2@ORCL file=D:\workFile\��Ͷ��20180410\data20180410.dmp  fromuser=aml touser=amlst2 ignore=y;

--����
imp amlxy1/amlxy1@ORCL file=C:\Users\user\Desktop\��Ԫ����\����\xyaml.dmp  fromuser=amlxy2 touser=amlxy1 ignore=y;
tables=UM_USERINFO

