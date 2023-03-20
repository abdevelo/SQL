SELECT * 
FROM emp;


SELECT E.ENAME 
	,E.SAL
	,E.EMPNO 
FROM EMP e 
WHERE mgr IS NULL AND comm IS NULL
;

--1. 
SELECT * FROM EMP
WHERE ENAME LIKE '%S';

--3. 
SELECT EMPNO, ENAME, JOB, SAL, DEPTNO
FROM EMP
WHERE DEPTNO IN (20,30) AND SAL > 2000;

/*
 * In 내에 속하는 값을 DB에서 뽑아죠
 * 하고 유용하게 쓰임 
 * 
 * Union 은 쿼리를 하나 만들어 놓고 
 * 또 다른 쿼리를 만들어서 엮을 때 
 * = 시차를 두고 합칠 때 
 */

--4.
SELECT EMPNO, ENAME, JOB, SAL, DEPTNO
FROM EMP
WHERE DEPTNO = '20' AND SAL > 2000
UNION 
SELECT EMPNO, ENAME, JOB, SAL, DEPTNO
FROM EMP
WHERE DEPTNO = '30' AND SAL > 2000
;

/*
 * SELECT 문 : 원하는 레코드 (행)만 가져오는 명령어 
 * FROM 테이블명 : 데이터 장소
 * */
SELECT *
FROM v$sqlfn_metadata v
WHERE v.name = 'NVL';

/*
 * 문자열 함수
 * UPPER() 대문자변환
 * LOWER() 소문자변환
 * LENGTH() 무자열 길이
 * 
 * Sample 
 * upper(myColumn) as to _upper_str
 * 
 * */


SELECT ENAME 
	, UPPER(ENAME) AS to_upper_name
	, LOWER(ENAME) AS to_lower_name
FROM EMP
;

SELECT * 
FROM EMP
WHERE UPPER(ENAME) = UPPER('Scott')
;


/*
 * Scott____ 과 같이 공란으로 데이터가 입력된 경우 ?
 * 
 * TRIM : 공란 제거 
 * 
 * */


SELECT '['||TRIM ('______ORACLE_ _ _     ')||']' AS TRIM
FROM DUAL
; 
-- 여기서는 임의로 ____ORACLE_ _ _ 이라는 값을 넣어주면서 TRIM을 같이하기 위해 '[' || TRIM(값) || ']'을 넣어주었지만 
-- 데이터의 원자성을 갖기위해선 그냥 TRIM(col_name) 하기로

/*
 * 문자열 연결
 * */

SELECT EMPNO
	, ENAME 
	, CONCAT(EMPNO, ENAME)
	, CONCAT(EMPNO, '  ')
FROM EMP
WHERE ENAME = 'SMITH'
;


/*
 * REPLACE 문자열 교체
 * 주요 예시 : 전화번호, 이메일, 집주소 등등 
 * */

SELECT '010-1234-5678' AS mobile_phone
	, REPLACE ('010-1234-5678','-','')AS replaced_phone
FROM DUAL;

/*
 * LPAD, RPAD 문자열을 채우기하는 함수
 * 
 * 문자열 고정시키는 것은 CHAR --> 자릿수를 딱 맞춤
 * 자릿수가 맘대로인 데이터를 가져와서 CHAR로 바꿀때 무결성을 맞출 수 있다..?
 * 
 * 이 상황에서 LPAD,RPAD활용..?
 * */


SELECT LPAD('ORA_123_XE',20) AS lpad_20
	,RPAD('ORA_123_XE',20 ) AS rpad_20
FROM dual
;

SELECT RPAD('971225-',14,'0') AS RPAD_JMNO
	,RPAD('010-1234-',13,'*') AS RPAD_PHONE
FROM DUAL;


/*
 * 꿀팁
 * [host varialbe] : 실행 시 직접 입력해서 값을 sort하는 방법 
 * */
SELECT *
FROM EMP e 
WHERE E.EMPNO >= :INPUT_no --[ host variable ]
;

/*
 * 숫자 함수
 * 
 * 함수(INTEGER), 부동소수(FLOAT)  - 소수점이 있는 숫자
 * 부동소수의 경우, 소수점 이하 정밀도(precision)차이가 발생 
 * pi ~ 3.142457 ..... (15자리 이하 소수 버림)
 * */

SELECT round(3.1428, 3) AS round0
	, round(123.456789, 3) AS round1
	, TRUNC(123.4567 ,2) AS trunc0
	, trunc(-123.4567, 2) AS trunc1
FROM dual
;


SELECT ceil(3.14) AS ceil0 -- CEIL과  FLOOR () 값에는 부동소수를 입력해야 함
	, floor(3.14) AS floor0
	, MOD(15, 6) AS mod0
	, MOD(11, 1) AS mod1
FROM dual 
; -- 이 구문 마무리에 주석 달기 


SELECT REMAINDER(15, 2) AS R1
	, REMAINDER(-11, 4) AS R2
FROM DUAL; --remainder 잘 안씀 -- 근데 계산식 이해가 ...



/*
 * DATE 함수 
 * - 날짜를 표현하는 일련번호 숫자가 존재
 * - 국가별 휴일이 다른 경우 등을 데이터로 가지고 있어야 함. ex)중동의 휴일
 * - 국가별로 날짜를 표기하는 방법이 다름. 
 * 
 * 2023-04-01 minus 1 day --> ??
 * MARCH, 01, 2023 
 * */

SELECT sysdate AS now
	, sysdate - 1 AS yested
	, sysdate + 10 AS ten_days_from_now
FROM dual 
;

-- :month : 입력 변수를 받아 월수 계산
SELECT add_months(SYSDATE, :MONTH)
FROM DUAL 
;

SELECT EMPNO, ENAME, HIREDATE
	,ADD_MONTHS(HIREDATE, 12*20) AS WORK10YEAR 
FROM EMP;


-- month_between 으로 나온 값이 소수점일 때 무조건 ROUND를 적용해도 될까? NO
-- 10년 근속 등 만기를 채워야 해당되는 경우가 많기에 함부로 ROUND를 할 수 없다. 
-- 보통 날짜 값을 버리는 경우가 더 많다 
SELECT ENAME, HIREDATE, SYSDATE
	, MONTHS_BETWEEN(HIREDATE, SYSDATE)/12 AS Year1
	, MONTHS_BETWEEN(SYSDATE, HIREDATE)/12 AS Year2 --앞쪽 DATE를 더 최근 날짜로 넣어주어야 (-)값이 나오지 않는다
	, TRUNC(MONTHS_BETWEEN(SYSDATE,HIREDATE)/12) AS Year3
FROM emp;

SELECT SYSDATE, ROUND(SYSDATE,'CC') AS FORMAT_CC
	,ROUND(SYSDATE,'DDD') AS FORMAT_DDD
FROM DUAL;

SELECT SYSDATE
	, NEXT_DAY(SYSDATE,'monday') AS next_monday --다음 월요일 구하기
	, LAST_DAY(SYSDATE) AS last_day_of_this_month-- 속한 달의 마지막 날
FROM DUAL;


SELECT ENAME
	, EXTRACT (YEAR FROM HIREDATE) AS y
	, EXTRACT (MONTH FROM HIREDATE) AS m
	, EXTRACT (DAY FROM HIREDATE) AS d
FROM emp;

/*
 * 형 변환 (Cast,Up-cast,Down-cast)
 * 형 변환 함수 (Conversion Function)
 * 
 * down-cast : 큰수를 담는 데이터 형에서 작은 수를 담는 데이터 형으로 명시적 변화
 * ex) 1234.3456 ---> 234.3(데이터가 짤릴 수 있음)
 * 
 * 
 * up-cast :  
 * */

--DEPTNO 의 데이터형은 숫자형임
--하지만 WHERE절에서 문자형으로 찾아도 검색이 됨.
--자동형변환 
--특히 :입력값 으로 값을 받는 경우는 문자로도 숫자로도 들어올 수 있음.
--이럴 경우 퍼포먼스가 감소한다. (숫자형들을 문자형으로 바꿔서 '20'과 비교하기 때문?? 아니면 반대로 '20'을 20으로 바꿔?)
SELECT EMPNO , DEPTNO 
FROM EMP
WHERE DEPTNO = '20'
;

-- 칼럼 중 값이 1억 초과인 값을 TO_NUMBER로 찾을 수 있을까 ?
-- TO_NUMBER ( A , B자릿수) 
-- B자리를 9가 9개 오도록 설정 시
-- 오류나는 값이 초과 값
-- 에러를 일부러 낼 수 있는 경우
SELECT TO_NUMBER('3,300','999,999')- TO_NUMBER ('1,100','999,999')
FROM DUAL; -- 자리수가 틀리면 오류


SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24')
FROM DUAL
; -- 24시간 표시까지


SELECT TO_CHAR(SYSDATE, 'DD HH24:MI:SS')
FROM DUAL
; --시,분,초까지 표시

SELECT SYSDATE 
	,TO_CHAR(SYSDATE, 'MM')
	,TO_CHAR(SYSDATE, 'MONTH','NLS_DATE_LANGUAGE = ENGLISH')
FROM DUAL
;

SELECT SYSDATE 
	, TO_CHAR(SYSDATE, 'HH24:MI:SS') AS HH24MISS
	, TO_CHAR(SYSDATE, 'HH12:MI:SS AM') AS HHMISS_AM
FROM DUAL;


/*
 * TO_DATE(입력날짜, 'RR-MM-DD')
 * TO_DATE(입력날짜, 'YY-MM-DD')
 * 날짜 포맷 RR과 YY값 비교
 * 
 * 잘 쓸일은 없음
 * 
 * 51년도 이후는 RR을 사용해서 표기해야 1900년대 값으로 나옴
 * */

SELECT TO_DATE('49/12/10','YY/MM/DD') AS YY_YEAR_49
	,TO_DATE('49/12/10', 'RR/MM/DD') AS RR_YEAR_49
	,TO_DATE('50/12/10', 'YY/MM/DD') AS YY_YEAR_49
	,TO_DATE('50/12/10', 'RR/MM/DD') AS RR_YEAR_49
	,TO_DATE('51/12/10', 'YY/MM/DD') AS YY_YEAR_49
	,TO_DATE('51/12/10', 'RR/MM/DD') AS RR_YEAR_49
FROM DUAL;




/*
 * NULL처리 함수
 * 
 * NULL 값 : 알 수 없는 값, 계산이 불가능한 값
 * NUL 값 비교는 IS NULL <> IS NOT NULL
 * 
 * NVL ( 입력값, NULL인 경우 대체할 값) <<-----매우 중요!!
 * NVL2 (입력값, NULL이 아닌 경우, NULL인 경우)
 *
 * 
 * SELECT NVL( STUDENT_NAME , FRISTNAME, 'UNKNOWN') 
 * FROM STUDENT STUDENT 1
 * WHERE 1=1;
 * 
 * URL주소 NVL관련해서 찾은 
 * 
 * 사실NVL2는 잘 안씀  
 * */


SELECT EMPNO
	, ENAME
	, SAL*12 + NVL(COMM,0) AS SAL12
	, JOB
	, TO_CHAR( HIREDATE ,'YYYY/MM/DD') AS HIRED_YEAR
FROM EMP
ORDER BY SAL12 DESC
;



/*
 * DECODE (입력 칼럼값
 * 				, '비교값1', 처리1
 * 				, '비교갑2', 처리2
 * 				, '....','....') AS 별칭
 * 
 * CASE 칼럼값
 * 			WHEN '값1' THEN  처리 1
 * 			WHEN '값2' THEN  처리 2
 * 			WHEN '...' THEN  ....
 * 			ELSE 처리 n
 * 			END AS 별칭 
 * 
 *  DECODE와 달리 CASE는 값의 범위를 줄 수 있음. 
 *	CASE는 CASE들이 다 해당안되면 ELSE~할 수 있음
 *	그런데 DECODE는 직관적으로 알 수 있는 장점이 있음. 
 * */


SELECT EMPNO, ENAME, JOB, SAL
		,DECODE(JOB,
					'MANAGER', SAL*0.8,
					'SALESMAN',SAL*0.2,
					'ANALYST',SAL*0.05,
					SAL*0.1) AS BONUS
FROM EMP;


SELECT EMPNO, ENAME, JOB, SAL
		,CASE JOB
				WHEN 'MANAGER' THEN SAL*0.2
				WHEN 'SALESMAN' THEN SAL*0.3
				WHEN 'ANALYST' THEN SAL*0.05
				ELSE SAL*0.1
				END AS BONUS
FROM EMP;