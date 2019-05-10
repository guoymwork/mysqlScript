/*G101-1指标03中选择2511、2519、2521、2522、2619、2621、2631、2652、2523、2614、2653、2710的，有有机液体储罐/装载 必选，重点审核是否应选择1*/
select * from T_BAS_G101_1
where 
(
HYLBDM='2511' or HYLBDM_2='2511' or HYLBDM_3='2511' or
HYLBDM='2519' or HYLBDM_2='2519' or HYLBDM_3='2519' or
HYLBDM='2521' or HYLBDM_2='2521' or HYLBDM_3='2521'  or
HYLBDM='2522' or HYLBDM_2='2522' or HYLBDM_3='2522'  or
HYLBDM='2619' or HYLBDM_2='2619' or HYLBDM_3='2619'  or
HYLBDM='2621' or HYLBDM_2='2621' or HYLBDM_3='2621'  or
HYLBDM='2631' or HYLBDM_2='2631' or HYLBDM_3='2631'  or
HYLBDM='2652' or HYLBDM_2='2652' or HYLBDM_3='2652'  or
HYLBDM='2523' or HYLBDM_2='2523' or HYLBDM_3='2523'  or
HYLBDM='2614' or HYLBDM_2='2614' or HYLBDM_3='2614'  or
HYLBDM='2653' or HYLBDM_2='2653' or HYLBDM_3='2653'  or
HYLBDM='2710' or HYLBDM_2='2710' or HYLBDM_3='2710' )
and 
(YYJYTCGZZ <>'1');
-- G101-1表指标03中选择1713、1723、1733、1743、1752、1762、1951、1952、1953、1954、1959、2021、2022、2023、2029、211 0、2631、2632、2710、2720、2730、2740、2750、2761、3130、3311、3331、3511、3512、3513、3514、3515、3516、3517、3611、3612、3630、3640、3650、3660、3670、3731、3732、3733、3734、3735及开头两位为22、23、38、39、40的，含挥发性有机物原辅材料使用必选，重点审核是否应选择1
select * from T_BAS_G101_1
where (
(HYLBDM like '22%' or HYLBDM like '23%' or HYLBDM like '38%' or HYLBDM like '39%' or HYLBDM like '40%')
or
(HYLBDM_2 like '22%' or HYLBDM_2 like '23%' or HYLBDM_2 like '38%' or HYLBDM_2 like '39%' or HYLBDM_2 like '40%')
or 
(HYLBDM_3 like '22%' or HYLBDM_3 like '23%' or HYLBDM_3 like '38%' or HYLBDM_3 like '39%' or  HYLBDM_3 like '40%')
or
HYLBDM 
in(
'1713','1723','1733','1743','1752','1762','1951','1952','1953','1954','1959','2021','2022','2023','2029','211 0','2631','2632','2710','2720','2730','2740','2750','2761','3130','3311','3331','3511','3512','3513','3514','3515','3516','3517','3611','3612','3630','3640','3650','3660','3670','3731','3732','3733','3734','3735'
)
or HYLBDM_2
in(
'1713','1723','1733','1743','1752','1762','1951','1952','1953','1954','1959','2021','2022','2023','2029','211 0','2631','2632','2710','2720','2730','2740','2750','2761','3130','3311','3331','3511','3512','3513','3514','3515','3516','3517','3611','3612','3630','3640','3650','3660','3670','3731','3732','3733','3734','3735'
)
or 
HYLBDM_3
in(
'1713','1723','1733','1743','1752','1762','1951','1952','1953','1954','1959','2021','2022','2023','2029','211 0','2631','2632','2710','2720','2730','2740','2750','2761','3130','3311','3331','3511','3512','3513','3514','3515','3516','3517','3611','3612','3630','3640','3650','3660','3670','3731','3732','3733','3734','3735'
))
and YHHFXYJWYFCLSY<>'1'
-- G101-1表指标16-31，是、否的选项必须与后面的报表填报完整性保持一致。指标16选“1”的，须填报G102表；指标17选“1”的，须填报G103-1表；指标18选“1”的，须填报G103-2表，等，以此类推直到指标31。


--G101-1表受纳水体指标，当G102表指标16(废水总排放口编号)非空的，此项必填。
select FK_ID from
(SELECT a.FK_ID,a.SNSTDM,b.CID from T_BAS_G101_1 a left join T_BAS_SOURCE_EXT b on b.FORMID = a.FK_ID) G101_1
left join
(SELECT a.FK_ID as G102_FK_ID,b.FORMID,b.CID from T_BAS_G102 a left join T_BAS_SOURCE_EXT b on b.FORMID = a.FK_ID)G102
on G101_1.CID = G102.CID
where (SNSTDM is null or SNSTDM = '' )
and EXISTS 
(select T_BAS_G102_EXT_2.FK_ID from T_BAS_G102_EXT_2 where G102.G102_FK_ID =T_BAS_G102_EXT_2.FK_ID 
and T_BAS_G102_EXT_2.FSZPFKBH IS NOT NULL);
-- G102表排入污水处理厂名称填报应与J101-1表一致
SELECT * FROM  T_BAS_G102_EXT_2 a
where a.PRWSCLCQYMC
not in (SELECT DWXXMC FROM T_BAS_J101_1)
--G101-2表实际产量，全厂G103-1至G103-13同代码的产品产量加和应小于该指标值


-- G101-3表作为原料消耗的能源，如：煤、油等，在主要能源消耗部分填报，名称应与指标解释中的《燃料类型及代码表》中的名称保持一致。

-- G101-3原辅材料使用量，全厂G103-1~G103-13同代码的原辅材料/能源加和应小于等于？该指标值。

-- G101-3主要能源消耗使用量，全厂G103-1-G103-13同代码的原辅材料/能源加和应小于等于？该指标值。

-- G101-3表能源名称、能源代码、计量单位必须与普查助手保持完全一致


-- G102表废水排放口经纬度，秒指标最多保留2位小数。
SELECT FK_ID FROM T_BAS_G102_EXT_2 a
where a.ZPFK_JD_MIAO like '%.___%' or a.ZPFK_WD_MIAO like '%.___%'

-- G103-1排放口高度应大于15米，小于300米
SELECT distinct FK_ID,PFKGD
FROM 
T_BAS_G103_1_EXT a
where a.PFKGD<15
or PFKGD>300

--G106-1表 产品产量不得为0
SELECT distinct FK_ID FROM T_BAS_G106_1_EXT a
where a.CPCL=0
--G106-1表 原料用量不得为0
SELECT distinct FK_ID FROM T_BAS_G106_1_EXT a
where a.YLRLYL=0

-- G102表废水排放口经纬度，秒指标最多保留2位小数。
SELECT FK_ID FROM T_BAS_G102_EXT_2 a
where a.ZPFK_JD_MIAO like '%.___%' or a.ZPFK_WD_MIAO like '%.___%'

--G101-2表生产能力原则上应≥实际产量
SELECT * FROM T_BAS_G101_2_EXT  a
where 
a.SCNL<a.SJCL

--J101-1表填报，但J101-2表未填
SELECT a.* FROM T_BAS_J101_1 a
left join T_BAS_J101_2 b on (a.TYSHXYDM||a.TYSHXYDMSBM)=(b.TYSHXYDM||b.TYSHXYDMSBM)
where b.FK_ID is null
--J101-2表填报，但J101-1表未填
SELECT a.* FROM T_BAS_J101_2 a
left join T_BAS_J101_1 b on (a.TYSHXYDM||a.TYSHXYDMSBM)=(b.TYSHXYDM||b.TYSHXYDMSBM)
where b.FK_ID is null
--J101-1表填报，但J101-3表未填
SELECT a.* FROM T_BAS_J101_1 a
left join T_BAS_J101_3 b on (a.TYSHXYDM||a.TYSHXYDMSBM)=(b.TYSHXYDM||b.TYSHXYDMSBM)
where b.FK_ID is null
--J101-3表填报，但J101-1表未填
SELECT a.* FROM T_BAS_J101_3 a
left join T_BAS_J101_1 b on (a.TYSHXYDM||a.TYSHXYDMSBM)=(b.TYSHXYDM||b.TYSHXYDMSBM)
where b.FK_ID is null
--G103-1脱硫剂名称应统一规范化，之后均统一规范填报。如：石灰石、氧化镁、等
SELECT FK_ID,TLJMC FROM T_BAS_G103_1_EXT
where TLJMC
not in (
SELECT to_multi_byte(a.TLJMC)
FROM   T_BAS_G103_1_EXT a
WHERE  a.TLJMC = to_multi_byte(a.TLJMC)
GROUP BY TLJMC
)
--J101-2污水实际处理量存疑，实际处理水量应不大于设计处理能力
SELECT*  FROM T_BAS_J101_2
where 
(WSSJCLL*10000)>(WSSJCLNL*NYXTS)
--G102表年运行小时数应小于等于G101-1表指标14（正常生产时间(小时)）
SELECT * FROM 
T_BAS_G102_EXT_1 a
left join T_BAS_G101_1 b on a.FK_ID=b.FK_ID
where b.ZCSCSJ>a.NYXXS
--J101-3中排水量为0，但101-2填报了相关数据
SELECT * FROM T_BAS_J101_1 a
left join 	T_BAS_SOURCE_EXT b
on b.FORMID=a.FK_ID
where b.CID
in
(
select c.CID from
(SELECT a.FK_ID,b.FORMID,b.CID,PALLNPJZ,PALLZDRJZ,PALLZXRJZ from T_BAS_J101_3_EXT a left join T_BAS_SOURCE_EXT b on b.FORMID = a.FK_ID) c
left join
(SELECT a.FK_ID,a.WSSJCLL,b.FORMID,b.CID,NYXTS,WNYYXHZZCQL,WNYYXHZZCQLYFS from T_BAS_J101_2 a left join T_BAS_SOURCE_EXT b on b.FORMID = a.FK_ID)d
on c.CID = d.CID
where
(c.PALLNPJZ+c.PALLZDRJZ+c.PALLZXRJZ)=0
and  d.WSSJCLL>0
)
--J101-2中填报了实际处理水量不为0，则J101-3中排水量不得为0
SELECT * FROM T_BAS_J101_1 a
left join 	T_BAS_SOURCE_EXT b
on b.FORMID=a.FK_ID
where b.CID
in
(
select c.CID from
(SELECT a.FK_ID,a.WSSJCLL,b.FORMID,b.CID,NYXTS,WNYYXHZZCQL,WNYYXHZZCQLYFS from T_BAS_J101_2 a left join T_BAS_SOURCE_EXT b on b.FORMID = a.FK_ID)d
left join
(SELECT a.FK_ID,b.FORMID,b.CID,PALLNPJZ,PALLZDRJZ,PALLZXRJZ from T_BAS_J101_3_EXT a left join T_BAS_SOURCE_EXT b on b.FORMID = a.FK_ID) c
on c.CID = d.CID
where
 d.WSSJCLL>0 
 and
(c.PALLNPJZ+c.PALLZDRJZ+c.PALLZXRJZ)=0)
-- SELECT * FROM
-- (SELECT a.*,b.FORMID,b.CID from T_BAS_G106_2_EXT a left join T_BAS_SOURCE_EXT b on b.FORMID = a.FK_ID) c
-- left join
-- (SELECT a.*,b.FORMID,b.CID from T_BAS_G102_EXT_2 a left join T_BAS_SOURCE_EXT b on b.FORMID = a.FK_ID) d
-- on c.CID = d.CID
-- where c.ZBZ_CKSL<>d.FSPFL
--G106-2出口水量应于G102表废水排放量保持一致
SELECT DISTINCT c.* FROM
(SELECT a.*,b.FORMID,b.CID from T_BAS_G106_2_EXT a left join T_BAS_SOURCE_EXT b on b.FORMID = a.FK_ID) c
LEFT JOIN
(SELECT a.*,b.FORMID,b.CID from T_BAS_G101_1 a left join T_BAS_SOURCE_EXT b on b.FORMID = a.FK_ID) d
on c.CID=d.CID
where c.FK_ID
in
(
SELECT DISTINCT c.FK_ID FROM
(SELECT a.*,b.FORMID,b.CID from T_BAS_G106_2_EXT a left join T_BAS_SOURCE_EXT b on b.FORMID = a.FK_ID) c
left join
(SELECT a.*,b.FORMID,b.CID from T_BAS_G102_EXT_2 a left join T_BAS_SOURCE_EXT b on b.FORMID = a.FK_ID) d
on c.CID = d.CID
where c.ZBZ_CKSL<>d.FSPFL
)

