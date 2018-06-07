
/**********************************************************************************/
--导入水文数据
insert Work_Data_Hydrology
(
	 [Id]
      ,[MonitorDate]
      ,[LakeCode]
      ,[SectionCode]
      ,[WindDirection]
      ,[WindPower]
      ,[WaterDepth]
      ,[WaterLevel]
)
SELECT newid() as id
      ,[采样日期]
      ,lake.LakeCode
	,sec.SectionCode  
      ,[风向]
      ,[风力]
      ,[水深]
      ,[水位]
FROM [dbo].[importHZH] imp
left join Work_Algae_LakeLibrary lake on LakeName=imp.[湖库]
left join Work_Algea_Section sec on sec.SectionName=imp.[站名]
/**********************************************************************************/
--删除骆马湖水文气象数据
DELETE
FROM Work_Data_Hydrology 
where LakeCode='104'
/**********************************************************************************/
--导入大屯水库 6-6水文数据
insert Work_Data_Hydrology
(
	 [Id]
      ,[MonitorDate]
      ,[LakeCode]
      ,[SectionCode]
      ,[WindDirection]
      ,[WindPower]
      ,[WaterDepth]
      ,[WaterLevel]
)
SELECT newid() as id
      ,[采样日期]
      ,lake.LakeCode
	,sec.SectionCode  
      ,[风向]
      ,[风力]
      ,[水深]
      ,[水位]
FROM [dbo].[大屯水库-水文6-6] imp
left join Work_Algae_LakeLibrary lake on LakeName=imp.[湖泊]
left join Work_Algea_Section sec on sec.SectionName=imp.[站名]

--水库编号
SELECT *
FROM Work_Algae_LakeLibrary
where LakeName='大屯水库'
--删除大屯庄水库数据
DELETE FROM [dbo].[Work_Data_Hydrology]
WHERE LakeCode in (SELECT LakeCode
FROM Work_Algae_LakeLibrary where LakeName='大屯水库')
--加前缀，后缀
update [东平湖-水质3] set [监测点]=('东平湖-'+[监测点])

--ISNUMERIC   是否为数值型数据
--当输入表达式得数为一个有效的整数、浮点数、money或decimal 类型，那么ISNUMERIC 返回 1；否则返回 0。返回值为1确保可以将expression转换为上述数字类型中的一种。

--水质数据插入-触发器
USE [AlgaeDB]
GO
/****** Object:  Trigger [dbo].[Work_Data_Water_insert]    Script Date: 2018/6/6 12:08:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[Work_Data_Water_insert]
ON [dbo].[Work_Data_Water]
WITH EXECUTE AS CALLER
AFTER INSERT
AS
BEGIN
        INSERT  INTO dbo.Work_Data_Water_Item
                SELECT  NEWID() AS Id ,
                        [MonitorDataId] ,
                        [SectionCode] ,
                        [MonitorDate] ,
                        [MonitorItemCode] ,
                      --  BEGIN TRY
                      --1.是否有L 如果有，去掉后是否是数字，如果是就除以2，如果不是，是否有<,如果有去掉，是否是数字
                        CASE WHEN CHARINDEX('L', [MonitorValue]) > 0--存在L符号
                             THEN  
                                   case when ISNUMERIC( LEFT([MonitorValue],LEN([MonitorValue])-1))=1 then  cast ( LEFT([MonitorValue],LEN([MonitorValue])-1) /2 as FLOAT)
                                        when CHARINDEX('<',[MonitorValue]) > 0  then  
                                                                           case when ISNUMERIC(SUBSTRING([MonitorValue],2, LEN([MonitorValue])-2))=1 then  cast (  SUBSTRING([MonitorValue],2,LEN([MonitorValue])-2)/2  as FLOAT)
                                                                           else '0' end
                                        else '0' END   
                              WHEN CHARINDEX('<',[MonitorValue]) > 0--存在<符号
                              THEN CAST( RIGHT('<10', LEN('<10')-1) AS FLOAT)
                              ELSE ''
     
                              END as MonitorValue,

      
                        [MonitorValue] AS ValueString,
                        2 AS DataType
                FROM    ( SELECT    [MonitorDataId] ,
                                    [SectionCode] ,
                                    [MonitorDate] ,
                                    [MonitorItemCode] ,
                                    [MonitorValue],
						[State]
                          FROM      inserted UNPIVOT
	( [MonitorValue] FOR [MonitorItemCode] IN (   [Item_Swen], [Item_Swei],
                                                [Item_pH], [Item_Ddl],
                                                [Item_Toumingdu], [Item_Zdu],[Item_Rjy],
                                                [Item_Gmsyzs], [Item_Shxyl],
                                                [Item_Ad], [Item_Syl],
                                                [Item_Zdan], [Item_Zlhk],
                                                [Item_Yelvsu], [Item_Hff],
                                                [Item_Zgong], [Item_Zqian],
                                                [Item_Hxxyl], [Item_Ztong],
                                                [Item_Zxin], [Item_Fhw],
                                                [Item_Sjx], [Item_Zshen],
                                                [Item_Zge], [Item_Ljg],
                                                [Item_Zqhw], [Item_Ylz],
                                                [Item_Lhw], [Item_Fdc],
                                                [Item_Liusuanyan],
                                                [Item_Lvhuawu],
                                                [Item_Xiaosuanyan], [Item_Tie],
                                                [Item_Zongmeng],[Item_Xsyd],[Item_Yxsyd] ) )
	AS F
                        ) A
                WHERE   [MonitorValue] IS NOT NULL
                        AND [MonitorValue] <> '&nbsp;'
                        AND [MonitorValue] <> ''
                        AND [MonitorValue] <> '-1'
                        AND [MonitorValue] <> '未检出'
                        --AND [MonitorValue] <> '0'
						--AND [State]=1;

    END;

/**********************************************************************************/
--截取

SELECT LEN('123456789')--9
SELECT left('123456789',3)--123

select charindex('-','骆马湖-骆马湖区（东）')--7
select charindex('-','123456-8-9')--7

select SUBSTRING('123456789',-1,6)--1234
select SUBSTRING('123456789',-2,6)--123
select SUBSTRING('123456789',1,9)--123456

select SUBSTRING('骆马湖-骆马湖区（东）',charindex('-','骆马湖-骆马湖区（东）')+1,LEN('骆马湖-骆马湖区（东）') )--骆马湖区（东）
--导入东湖水库-水文3
insert Work_Data_Hydrology
(
	 [Id]
      ,[MonitorDate]
      ,[LakeCode]
      ,[SectionCode]
      ,[WindDirection]
      ,[WindPower]
      ,[WaterDepth]
      ,[WaterLevel]
)
SELECT newid() as id
      ,[采样日期]
      ,lake.LakeCode
	,sec.SectionCode  
      ,[风向]
      ,[风力]
      ,[水深]
      ,[水位]
FROM [dbo].[东湖水库-水文3] imp
left join Work_Algae_LakeLibrary lake on LakeName=imp.[湖库]
left join Work_Algea_Section sec on sec.SectionName=imp.[站名]
/**********************************************************************************/
SELECT *
FROM Work_Algae_LakeLibrary
WHERE LakeName='东湖水库'

--导入东湖水库-水文3
insert Work_Data_Hydrology
(
	 [Id]
      ,[MonitorDate]
      ,[LakeCode]
      ,[SectionCode]
      ,[WindDirection]
      ,[WindPower]
      ,[WaterDepth]
      ,[WaterLevel]
)
SELECT newid() as id
      ,[采样日期]
      ,lake.LakeCode
	,sec.SectionCode  
      ,[风向]
      ,[风力]
      ,[水深]
      ,[水位]
FROM [dbo].[骆马湖-水文3] imp
left join Work_Algae_LakeLibrary lake on LakeName=imp.[湖库]
left join Work_Algea_Section sec on sec.SectionName=imp.[站名]

SELECT *
FROM
水文模板
where [采样日期] is null

--删除空数据
DELETE
FROM
水文模板
where [采样日期] is null

--查询30分钟内插入的骆马湖数据
SELECT *
FROM Work_Data_Hydrology
WHERE LakeCode in (
SELECT LakeCode
FROM Work_Algae_LakeLibrary
where LakeName='大屯水库'
)
and OptTime BETWEEN DATEADD( minute,-360,GETDATE()) and getdate()
--删除十分钟内插入的骆马湖数据
DELETE
FROM Work_Data_Hydrology
WHERE LakeCode in (
SELECT LakeCode
FROM Work_Algae_LakeLibrary
where LakeName='骆马湖'
)
and OptTime BETWEEN DATEADD( minute,-30,GETDATE()) and getdate()

update 
[骆马湖-水文3]
set [站名]=('骆马湖-'+[站名])

SELECT *
FROM [骆马湖-水文3]

update 
[骆马湖-水文3]
set [湖库]='骆马湖'

--导入骆马湖水文数据
insert Work_Data_Hydrology
(
	 [Id]
      ,[MonitorDate]
      ,[LakeCode]
      ,[SectionCode]
      ,[WindDirection]
      ,[WindPower]
      ,[WaterDepth]
      ,[WaterLevel]
)
SELECT newid() as id
      ,[采样日期]
      ,lake.LakeCode
	,sec.SectionCode  
      ,[风向]
      ,[风力]
      ,[水深]
      ,[水位]
FROM [dbo].[骆马湖-水文3] imp
left join Work_Algae_LakeLibrary lake on LakeName=imp.[湖库]
left join Work_Algea_Section sec on sec.SectionName=imp.[站名]
--站名加前缀
update [洪泽湖-水文3]
set 站名=('洪泽湖-'+[站名])
--导入双王城水库水文数据
insert Work_Data_Hydrology
(
	 [Id]
      ,[MonitorDate]
      ,[LakeCode]
      ,[SectionCode]
      ,[WindDirection]
      ,[WindPower]
      ,[WaterDepth]
      ,[WaterLevel]
)
SELECT newid() as id
      ,[采样日期]
      ,lake.LakeCode
	,sec.SectionCode  
      ,[风向]
      ,[风力]
      ,[水深]
      ,[水位]
FROM [dbo].[双王城水库-水文3] imp
left join Work_Algae_LakeLibrary lake on LakeName=imp.[湖库]
left join Work_Algea_Section sec on sec.SectionName=imp.[站名]
/**********************************************************************************/
SELECT     [MonitorDataId],[SectionCode],[MonitorDate],
					[MonitorItemCode],[MonitorValue],[State]
FROM  Work_Data_Water  UNPIVOT
	( [MonitorValue] FOR [MonitorItemCode] 
	IN (
		[Item_Swen],[Item_Swei],[Item_pH],
		[Item_Ddl],[Item_Toumingdu],[Item_Zdu],
		[Item_Rjy],[Item_Gmsyzs],[Item_Shxyl],[Item_Ad],
		[Item_Yxsyd])
	) as F

















