
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
where 	LakeName='大屯水库'
--删除大屯庄水库数据
DELETE FROM [dbo].[Work_Data_Hydrology]
WHERE LakeCode in (SELECT LakeCode
FROM Work_Algae_LakeLibrary where LakeName='大屯水库')
--加前缀，后缀方法
update [东平湖-水质3] set [监测点]=('东平湖-'+[监测点])

--ISNUMERIC   
--当输入表达式得数为一个有效的整数、浮点数、money   或   decimal   类型，那么   ISNUMERIC   返回   1；否则返回   0。返回值为   1   确保可以将   expression   转换为上述数字类型中的一种。


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
                              ELSE 0
                               
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






