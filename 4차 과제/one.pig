-- 데이터 읽어 오기
uitem = LOAD 'G2016.csv' USING PigStorage(',') AS(year:int, id:int, sex:int ,old:int, local:int, tall:int , weight: int, huri:float,cig:int,time:chararray);

-- 필요 데이터만 select
name = FOREACH uitem GENERATE local, tall, weight;

-- 지역으로 묶기
localgroup = GROUP name BY local;

localgroupavg = FOREACH localgroup GENERATE group AS local,AVG(name.tall) as avgtall , AVG(name.weight) as avgwe;

-- BMI구하기
result= FOREACH localgroupavg GENERATE local , (float)(avgwe/(avgtall*avgtall))*10000 as bmi;

mitem = LOAD 'mm.csv' USING PigStorage(',') AS(nam:chararray, code :int , six : int , seven : int , eight : int );

mselect = FOREACH mitem GENERATE nam,code,six;
-- table 조인
combin = JOIN result BY local , mselect BY code;

jresult = FOREACH combin GENERATE mselect::nam AS local_name, mselect::six as earn , result::bmi as BMIR;

STORE jresult INTO 'PigResultsone' USING PigStorage(',');
