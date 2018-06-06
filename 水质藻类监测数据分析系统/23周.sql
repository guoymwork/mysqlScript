
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






