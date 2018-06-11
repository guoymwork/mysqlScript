/**********************************************************************************/
/*6-11*/
SELECT * FROM [dbo].[Work_Data_Water]
where SectionCode in (

SELECT SectionCode
FROM Work_Algea_Section
where SectionName in ('大屯进水','大屯出水','东湖进水','东湖出水','双王城进水','双王城出水')

)
and OptTime is NULL
ORDER BY SectionCode, MonitorDate


SELECT *
FROM Work_Algea_Section

SELECT 548/2

--
SELECT * FROM [dbo].[Work_Data_Water]
where SectionCode in (

SELECT SectionCode
FROM Work_Algea_Section
where SectionName in ('大屯进水','大屯出水','东湖进水','东湖出水','双王城进水','双王城出水','双王城新口','东湖新口','大屯新口','大屯武城供水洞')

)
and OptTime is  NULL
ORDER BY SectionCode, MonitorDate

/**********************************************************************************/
/*删除第一次，第三次导入的数据*/
SELECT * FROM [dbo].[Work_Data_Water]
where SectionCode in (

SELECT SectionCode
FROM Work_Algea_Section
where SectionName in ('大屯进水','大屯出水','东湖进水','东湖出水','双王城进水','双王城出水','双王城新口','东湖新口','大屯新口','大屯武城供水洞')

)
and OptTime is not  NULL
ORDER BY SectionCode, MonitorDate
--285







