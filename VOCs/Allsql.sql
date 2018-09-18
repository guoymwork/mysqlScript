--按地区进行年度更新统计
SELECT
	city.c_name areaName,
	isnull( isjiandang, 0 ) yijiandang,
	isnull( isupdate, 0 ) isupdate,
	isnull( Round( CONVERT ( FLOAT, isupdate ) * 100 / CONVERT ( FLOAT, isjiandang ), 3 ), 0 ) AS zhanbi 
FROM
	( SELECT c_name,INDEXNO FROM EAP_SYS_UTIL_CODECLASS WHERE parent = '120000' ) city
	LEFT JOIN
(SELECT quxian,COUNT (1) AS isjiandang FROM work_enterprise WHERE delFlag !=1 AND jiandangState='已建档' GROUP BY quxian ) yijiandangT 
	ON city.c_name= yijiandangT.quxian
LEFT JOIN
(SELECT quxian,COUNT (1) AS isupdate FROM work_enterprise WHERE delFlag !=1 and  updateState='已变更' AND updateDate BETWEEN '2018' AND '2019' GROUP BY quxian ) 	updateT ON yijiandangT.quxian= updateT.quxian 

ORDER BY
	city.INDEXNO;
------------------------------------------------------------------------------------------------
--按乡镇进行年度更新统计
SELECT    
city.c_id,   
city.c_name areaName,   
isnull(isjiandang,0) yijiandang,
isnull(isupdate,0) isupdate,   
isnull(Round(CONVERT (FLOAT,isupdate)*100/CONVERT (FLOAT,isjiandang),3),0) AS zhanbi    
FROM (
SELECT c_name,INDEXNO FROM EAP_SYS_UTIL_CODECLASS WHERE parent=(SELECT TOP 1 c_id FROM EAP_SYS_UTIL_CODECLASS WHERE c_name='"+userArea+"')) city    
LEFT JOIN (
SELECT xiangzhen,COUNT (1) AS isjiandang FROM work_enterprise WHERE delFlag !=1 AND jiandangState='已建档' GROUP BY xiangzhen) jiandangT ON luruT.xiangzhen=jiandangT.xiangzhen 
LEFT JOIN (
SELECT xiangzhen,COUNT (1) AS isupdate FROM work_enterprise WHERE delFlag !=1 and updateState='已变更' AND updateDate BETWEEN '2018' AND '2019' GROUP BY xiangzhen) updateT ON city.c_name=updateT.xiangzhen 
ORDER BY city.INDEXNO  
