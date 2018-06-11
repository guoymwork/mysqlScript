/****************/
--保留两位小数
select Convert(decimal(18,2),2.176544)
--/=> 2.18
select Round(2.176544,2)　　--/ => 2.180000


--区域声环境监测记录
SELECT *
FROM dbo.Work_Noise_Data data
WHERE data.soundclasscode='10'
--功能区声环境监测记录
SELECT *
FROM dbo.Work_Noise_Data data
WHERE data.soundclasscode LIKE '3_'
ORDER BY data.pointCode, data.monitorDate;
--道路声环境监测记录
SELECT *
FROM
    dbo.Work_Noise_Data data
WHERE data.soundclasscode='20'
--
SELECT *
FROM dbo.Work_Noise_Data data
WHERE data.soundclasscode LIKE '3_'
ORDER BY data.pointCode, data.monitorDate;
--夜间区域监测数据
SELECT cityCode, AVG(CAST(data.Leq AS FLOAT)) AS nt
FROM dbo.Work_Noise_Data data
WHERE data.soundclasscode='10'
    AND CAST(data.monitorDate AS DATETIME	)BETWEEN '2017'AND '2018'
    AND DATEPART(HOUR,CAST(data.monitorDate AS DATETIME)) NOT BETWEEN '6' AND '22'
GROUP BY data.cityCode

SELECT cityCode ,
    AVG(CASE WHEN 1=1--data.soundclasscode = '10'
        AND CAST(data.monitorDate AS DATETIME) BETWEEN '2017' AND '2018'
        AND DATEPART(HOUR, CAST(data.monitorDate AS DATETIME)) BETWEEN '6' AND '22'
                 THEN CAST(Leq AS FLOAT)
                 ELSE 0
            END) AS dt ,
    AVG(CASE WHEN 1=1--data.soundclasscode = '10'
        AND CAST(data.monitorDate AS DATETIME) BETWEEN '2017' AND  '2018'
        AND DATEPART(HOUR, CAST(data.monitorDate AS DATETIME)) NOT BETWEEN '6' AND '22'
                 THEN CAST(Leq AS FLOAT)
                 ELSE 0
            END) AS nt
FROM dbo.Work_Noise_Data data

GROUP BY data.cityCode;


SELECT cityCode ,
    (CASE WHEN 1=1 then (SELECT avg(cast(data.leq as float))
    from dbo.Work_Noise_Data data
    WHERE data.soundclasscode='10'
        AND CAST(data.monitorDate AS DATETIME	)BETWEEN '2017'AND '2018'
        AND DATEPART(HOUR,CAST(data.monitorDate AS DATETIME)) NOT BETWEEN '6' AND '22' ) else 0 end) AS dt ,
    AVG(CASE WHEN 1=1--data.soundclasscode = '10'
        AND CAST(data.monitorDate AS DATETIME) BETWEEN '2017' AND  '2018'
        AND DATEPART(HOUR, CAST(data.monitorDate AS DATETIME)) NOT BETWEEN '6' AND '22'
                 THEN CAST(Leq AS FLOAT)
                 ELSE 0
            END) AS nt
FROM dbo.Work_Noise_Data data

GROUP BY data.cityCode;


SELECT avg(cast(data.leq as float))
from Work_Noise_Data data



SELECT cityCode ,
    (SELECT avg(cast(data.leq as float))
    from dbo.Work_Noise_Data data
    WHERE data.soundclasscode='10'
        AND CAST(data.monitorDate AS DATETIME	)BETWEEN '2017'AND '2018'
        AND DATEPART(HOUR,CAST(data.monitorDate AS DATETIME))  BETWEEN '6' AND '22'
    GROUP BY cityCode
         ) AS dt ,
    (SELECT avg(cast(data.leq as float))
    from dbo.Work_Noise_Data data
    WHERE data.soundclasscode='10'
        AND CAST(data.monitorDate AS DATETIME	)BETWEEN '2017'AND '2018'
        AND DATEPART(HOUR,CAST(data.monitorDate AS DATETIME)) NOT BETWEEN '6' AND '22' ) AS nt

FROM dbo.Work_Noise_Data data

GROUP BY data.cityCode;
/****************************************************************************************************************/
--1.1(用临时表操作)
/*昼间监测leq*/
SELECT convert(varchar(10),data.monitorDate,120) tdate, cityCode, AVG(CAST(data.Leq AS FLOAT)) AS monitordt
INTO #A
FROM dbo.Work_Noise_Data data
WHERE 1=1 /*AND data.soundclasscode='10'*/
    AND CAST(data.monitorDate AS DATETIME)BETWEEN '2017'AND '2018'
    AND DATEPART(HOUR,CAST(data.monitorDate AS DATETIME))  BETWEEN '6' AND '22'
GROUP BY data.cityCode,convert(varchar(10),data.monitorDate,120);
/*夜间监测leq*/
SELECT convert(varchar(10),data.monitorDate,120) tdate, cityCode, AVG(CAST(data.Leq AS FLOAT)) AS monitornt
INTO #B
FROM dbo.Work_Noise_Data data
WHERE 1=1 /*AND data.soundclasscode='10'*/
    AND CAST(data.monitorDate AS DATETIME)BETWEEN '2017'AND '2018'
    AND DATEPART(HOUR,CAST(data.monitorDate AS DATETIME)) NOT BETWEEN '6' AND '22'
GROUP BY data.cityCode,convert(varchar(10),data.monitorDate,120);
/*最终结果*/
SELECT area.AreaName, A.tdate, ISNULL(A.monitordt,0) as monitordt , isnull(b.monitornt,0) as monitornt
FROM #A A left join #B B on A.cityCode=B.cityCode and A.tdate=B.tdate
    LEFT JOIN Work_AreaInfo area on area.AreaCode=A.cityCode
order BY A.tdate DESC

DROP TABLE #A
drop TABLE #B;
/****************************************************************************************************************/
--1.1
SELECT b.tdate, area.AreaName,

    b.monitorsd, b.monitorsn
from(
SELECT a.tdate, a.citycode,
        max(CASE a.flag WHEN '1' THEN avgLeq ELSE 0 end) monitorsd ,
        max(CASE a.flag WHEN '0' THEN avgLeq ELSE 0 end) monitorsn
    FROM(
SELECT CONVERT(VARCHAR(10), data.monitorDate, 120) tdate, cityCode ,
            CAST( AVG( CAST(data.Leq AS FLOAT) ) as decimal(18,2)) AS avgLeq ,
            CASE WHEN DATEPART(HOUR, CAST(data.monitorDate AS DATETIME)) BETWEEN '6' AND '22' THEN '1' ELSE '0' END AS flag
        FROM dbo.Work_Noise_Data data
        WHERE   1 = 1
            AND CAST(data.monitorDate AS DATETIME) BETWEEN '2017' AND '2018'
        GROUP BY data.cityCode ,monitorDate
       
) a
    GROUP BY a.tdate,a.citycode
) as b
    LEFT join Work_AreaInfo area on area.AreaCode=b.cityCode

SELECT count(1) as 总记录数
FROM Work_Noise_Data

/*****************************************************************************************************************/
--昼夜标准，value1~value2
SELECT value1, value2
FROM Work_Noise_Dic dic
where code='daypart'
/******************城市信息**************************************************************************************/
SELECT *
FROM Work_AreaInfo
/****************************************************************************************************************/

SELECT distinct citycode
FROM Work_Noise_Data data
WHERE data.soundclasscode='10'
    AND CAST(data.monitorDate AS DATETIME)BETWEEN '2017'AND '2018'
    AND DATEPART(HOUR,CAST(data.monitorDate AS DATETIME))  BETWEEN '6' AND '22'

/****************************************************************************************************************/


/****************************************************************************************************************/
--批量更新
SELECT pointcode, SUBSTRING (pointcode,7,2) sub
into #C
FROM Work_Noise_Point
update Work_Noise_Point   set pointTypeCode=sub FROM #C C
where Work_Noise_Point.pointCode=c.pointcode
drop table #C;
/****************************************************************************************************************/
select AreaCode, area.AreaName as cityName, effNum, sd, sn
FROM
    (select data.cityCode, count(point.pointCode) as effNum,
        sum( cast(monitorDT as FLOAT))*1/count(data.citycode) as sd, sum( cast(monitorNT as FLOAT))*1/count(data.citycode) as sn
    from
        Work_Noise_Point point
        left join
        Work_Noise_Data data on data.pointCode=point.pointCode and pointTypeCode='10'--区域噪声
    where 1=1
    GROUP BY data.cityCode) a
    left join Work_AreaInfo area on area.AreaCode=a.cityCode


/****************************************************************************************************************/
---1.1 final
SELECT tdate, citycode , area.AreaName,
    max( case flag WHEN '1' then avgLeq else 0 end ) as monitorsd,
    max( case flag WHEN '0' then avgLeq else 0 end ) as monitorsn
from
    (
SELECT tdate, citycode, flag,
        cast( avg(Leq) as  decimal(18,2)) as avgLeq
    from(
    SELECT CONVERT(VARCHAR(10), data.monitorDate, 120)  tdate, cityCode ,
            avg( CAST(data.Leq AS FLOAT) ) AS Leq ,
            CASE WHEN DATEPART(HOUR, CAST(data.monitorDate AS DATETIME)) BETWEEN '6' AND '22' THEN '1' ELSE '0' END AS flag
        FROM dbo.Work_Noise_Data data
        WHERE   1 = 1
            AND CAST(data.monitorDate AS DATETIME) BETWEEN '2017' AND '2018'
        GROUP BY data.cityCode ,monitorDate
) a
    where 1=1
    group by tdate,cityCode,flag
) b
    LEFT join Work_AreaInfo area on area.AreaCode=b.cityCode
GROUP by tdate,cityCode,AreaName
/****************************************************************************************************************/
--2.1final
--有效点位数
select cityCode, count(*) effPointNum
FROM Work_Noise_Point point
WHERE point.pointTypeCode='10'
GROUP by cityCode
---截取字符串查询
SELECT area.AreaName
from(
SELECT a.citycode, count(*) effPointNum
    FROM(


    SELECT cityCode , CONVERT(VARCHAR(10), monitorDate, 120)  tdate, pointcode,
            avg( CAST(Leq AS FLOAT) ) AS Leq ,
            CASE WHEN DATEPART(HOUR, CAST(monitorDate AS DATETIME)) BETWEEN '6' AND '22' THEN '1' ELSE '0' END AS flag
        FROM dbo.Work_Noise_Data
        WHERE   1 = 1
            AND SUBSTRING(pointCode,7,2)='10'/*区域噪声编码10*/
            AND CAST(monitorDate AS DATETIME) BETWEEN '2017' AND '2018'
        GROUP BY cityCode,monitorDate,pointcode
) a
    GROUP BY a.citycode
) as b
    LEFT join Work_AreaInfo area on area.AreaCode=b.cityCode;
---链接point表查询
SELECT area.AreaName, b.sd, b.sn
from(
SELECT a.citycode,
        max(CASE a.flag WHEN '1' THEN avgLeq ELSE 0 end) sd ,
        max(CASE a.flag WHEN '0' THEN avgLeq ELSE 0 end) sn
    FROM(
SELECT data.cityCode ,
            cast( AVG( CAST(data.Leq AS FLOAT) ) as decimal(18,2)) AS avgLeq ,
            CASE WHEN DATEPART(HOUR, CAST(data.monitorDate AS DATETIME)) BETWEEN '6' AND '22' THEN '1' ELSE '0' END AS flag
        FROM dbo.Work_Noise_Data data left join Work_Noise_Point point on point.pointCode=data.pointCode
        WHERE   1 = 1
            AND point.pointTypeCode='10'
            AND CAST(data.monitorDate AS DATETIME) BETWEEN '2017' AND '2018'
        GROUP BY data.cityCode,data.monitorDate
) a
    GROUP BY a.citycode
) as b
    LEFT join Work_AreaInfo area on area.AreaCode=b.cityCode;
/****************************************************************************************************************/
--城市，监测点总数
SELECT citycode, count(pointCode) AS effPointNum
FROM Work_Noise_Data
where SUBSTRING(pointCode,7,2)='10'
GROUP by cityCode;
-----2.1
SELECT cityCode, area.AreaName,
    cast (sum(monitorsd)/sum(case flag when '1' then 1 else 0 end) as DECIMAL(13,2)) as avgsd,
    cast (sum(monitorsn)/sum(case flag when '0' then 1 else 0 end) as DECIMAL(13,2)) as avgsn
from(
SELECT tdate, citycode,
        max( case flag WHEN '1' then avgLeq else 0 end ) as monitorsd,
        max( case flag WHEN '0' then avgLeq else 0 end ) as monitorsn,
        flag
    from
        (
SELECT tdate, citycode, flag,
            cast( avg(Leq) as  decimal(18,2)) as avgLeq
        from(
    SELECT CONVERT(VARCHAR(10), data.monitorDate, 120)  tdate, cityCode ,
                avg( CAST(data.Leq AS FLOAT) ) AS Leq ,
                CASE WHEN DATEPART(HOUR, CAST(data.monitorDate AS DATETIME)) BETWEEN '6' AND '22' THEN '1' ELSE '0' END AS flag
            FROM dbo.Work_Noise_Data data
            WHERE   1 = 1
                AND SUBSTRING(pointCode,7,2)='10'
                AND CAST(data.monitorDate AS DATETIME) BETWEEN '2017' AND '2018'
            GROUP BY data.cityCode ,monitorDate
) a
        where 1=1
        group by tdate,cityCode,flag
) b
    GROUP by tdate,cityCode,flag
) c
    left join Work_AreaInfo area on cityCode=area.AreaCode
GROUP by cityCode,area.AreaName
--2.1-2
/****************************************************************************************************************/
--城市，监测点总数
SELECT citycode, count(pointCode) AS effPointNum
--into #A
FROM Work_Noise_Data
where SUBSTRING(pointCode,7,2)='10'
GROUP by cityCode;
--统计
SELECT cityCode, area.AreaName,
    CAST(AVG(CASE c.monitorsd  when 0 then NULL else monitorsd end ) AS DECIMAL(10,2)) as avgsd,
    CAST(AVG(CASE c.monitorsn  when 0 then NULL else monitorsn end ) AS DECIMAL(10,2)) as avgsn
--INTO #B
from(
SELECT tdate, citycode,
        max( case flag WHEN '1' then avgLeq else 0 end ) as monitorsd,
        max( case flag WHEN '0' then avgLeq else 0 end ) as monitorsn,
        flag
    from
        ( 
SELECT tdate, citycode, flag,
            CAST( avg(Leq) as  decimal(18,2)) as avgLeq
        from(
    SELECT CONVERT(VARCHAR(10), data.monitorDate, 120)  tdate, cityCode ,
                avg( CAST(data.Leq AS FLOAT) ) AS Leq ,
                CASE WHEN DATEPART(HOUR, CAST(data.monitorDate AS DATETIME)) BETWEEN '6' AND '22' THEN '1' ELSE '0' END AS flag
            FROM dbo.Work_Noise_Data data
            WHERE   1 = 1
                AND SUBSTRING(pointCode,7,2)='10'
                AND CAST(data.monitorDate AS DATETIME) BETWEEN '2017' AND '2018'
            GROUP BY data.cityCode ,monitorDate
) a
        where 1=1
        group by tdate,cityCode,flag
) b
    GROUP by tdate,cityCode,flag
) c
    left join Work_AreaInfo area on cityCode=area.AreaCode
GROUP by cityCode,area.AreaName
/****************************************************************************************************************/


select citycode, avg(昼间) as SD
from
(
select citycode,昼间,夜间 from(
select 
citycode,monitorDate,cast(Leq as [float]) as leq,
case when DATEPART(HOUR,monitorDate)  between '6' and '22' then '昼间' else '夜间' end as flag
from Work_Noise_Data

) a pivot
(
    max(leq) for a.flag in ([昼间],[夜间])
) b

) c
group by citycode
--//
SELECT leq
FROM Work_Noise_Data
where cityCode='540300'
and  leq>200

/****************************************************************************************************************/

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Id]
      ,[LakeCode]
      ,[MonitorDate]
      ,[SectionCode]
      ,[WindDirection]
      ,[WindPower]
      ,[WaterDepth]
      ,[WaterLevel]
  FROM [AlgaeDB].[dbo].[Work_Data_Hydrology]

--查询 导入洪泽湖
  SELECT 
  *
  FROM  dbo.Work_Data_Hydrology
  WHERE 
  LakeCode='104'
  ORDER BY MonitorDate,SectionCode;

--删除 洪泽湖
 DELETE
  FROM  dbo.Work_Data_Hydrology
  WHERE 
  LakeCode='104'  ORDER BY MonitorDate,SectionCode;
/****************************************************************************************************************/
 AND sec.SectionCode IN ('192','932','205','1921','10039259')
 AND sec.SectionType IN ('1')  
 AND ( sec.IfState=1 OR sec.IfCityControl=1 OR sec.IfStateControl=1 OR sec.IfCity=1 )  
 AND  sec.River IN ('白马河')   
 AND  sec.WaterBody IN ('潮河1') 
 AND  sec.WaterRiver IN ('黄河流域') 
--时间、数据类型
 AND YEAR(A.MonitorDate) IN (2018) AND MONTH(A.MonitorDate) IN (2,4,5,6)  AND A.DataType IN (1) 
--分组类型：1河流，2湖库，3饮用水河流，4饮用水湖库，5地下饮用水，6河流采测，7湖库采测，8饮用水地表（Item_Zonglin）
 SELECT MonitorItemCode FROM [dbo].[Work_WaterMonitorItem] WHERE GroupID=1 ORDER BY Sort 
 
/****************************************************************************************************************/


