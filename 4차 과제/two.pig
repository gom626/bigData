-- 데이터 읽어오기
uitem = LOAD 'G2017.csv' USING PigStorage(',') AS(year:int, id:int, sex:int ,old:int, local:int, tall:int , weight: int, huri:float,cig:int,time:chararray);

name = FOREACH uitem GENERATE local, tall, weight;

-- 지역으로 뮦기
localgroup = GROUP name BY local;

localgroupavg = FOREACH localgroup GENERATE group AS local,AVG(name.tall) as avgtall , AVG(name.weight) as avgwe;

result= FOREACH localgroupavg GENERATE local , (float)(avgwe/(avgtall*avgtall))*10000 as bmi;

mitem = LOAD 'mm.csv' USING PigStorage(',') AS(nam:chararray, code :int , six : int , seven : int , eight : int );

mselect = FOREACH mitem GENERATE nam,code,seven;

-- 테이블 조인
combin = JOIN result BY local , mselect BY code;

jresult = FOREACH combin GENERATE mselect::nam AS local_name, mselect::seven as earn , result::bmi as BMIR;

-- 저장
STORE jresult INTO 'PigResultstwo' USING PigStorage(',');
