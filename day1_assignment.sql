/*
 * Q1-1 
 * (1) 논리설계
 * (2) 데이터 모델링 
 * Q1-2
 * (1) E-R모델
 * (2) E-R모델
 * (3) Entity
 * Q1-3
 * (1) E-R Diagram
 * (2) 관계
 * Q1-4
 * (1) 카디널리티(Cardinality)
 * (2) 옵셔널리티(Optionality)
 * Q1-5
 * (1) 스키마
 * (2) 테이블
 * Q1-6
 * (1) Table
 * (2) Index
 * (3) Sequence
 */

SELECT EMPNO AS "EMPLOYEE_NO", ENAME AS "EMPLOYEE_NAME", JOB , MGR AS "MANAGER",
HIREDATE , SAL AS "SALARY", COMM AS "COMMISSION", DEPTNO AS "DEPARTMENT_NO"
FROM EMP
ORDER BY DEPTNO DESC, ENAME ASC; 

--COMM IS NULL이고 SAL>NULL보다 큰 경우는? (다시보자)
SELECT EMPNO ,ENAME ,JOB ,MGR ,HIREDATE ,SAL ,COMM ,DEPTNO 
FROM EMP
WHERE COMM IS NULL 
AND ( SAL > NULL) ;

-- MGR과 COMM모두가 NULLDL인 직원의 EMPNO은 '7839', ENAME은 'KING'
SELECT EMPNO ,ENAME ,JOB ,MGR ,HIREDATE ,SAL ,COMM ,DEPTNO 
FROM EMP
WHERE MGR IS NULL AND COMM IS NULL;


-- 1.사원명이 S로 끝나는 직원
SELECT EMPNO ,ENAME ,JOB ,MGR ,HIREDATE ,SAL ,COMM ,DEPTNO 
FROM EMP
WHERE ENAME LIKE '%S';

-- 2.JOB이 SALESMAN이고 부서번호가 30인 경우
SELECT EMPNO ,ENAME ,JOB ,MGR ,HIREDATE ,SAL ,COMM ,DEPTNO 
FROM EMP
WHERE JOB = 'SALESMAN'
AND DEPTNO = '30';

-- 3. 부서번호(DEPTNO)가 20 또는 30 이고 월급(SAL)이 2000 초과하는 경우
SELECT EMPNO ,ENAME ,JOB ,MGR ,HIREDATE ,SAL ,COMM ,DEPTNO 
FROM EMP
WHERE (DEPTNO ='20' OR DEPTNO ='30')
AND SAL > '2000'; 

-- 4. 앞의 3번을 UNION 키워드를 사용하는 경우(DEPTNO 20인 경우와 30인 경우를 UNION)
SELECT EMPNO ,ENAME ,JOB ,MGR ,HIREDATE ,SAL ,COMM ,DEPTNO 
FROM EMP
WHERE DEPTNO ='20' AND SAL > '2000'
UNION 
SELECT EMPNO ,ENAME ,JOB ,MGR ,HIREDATE ,SAL ,COMM ,DEPTNO 
FROM EMP
WHERE  DEPTNO ='30' AND SAL > '2000'; 

-- 5. COMM이 없고 매니저가 아닌 상급자가 있는 직원 중에서 직책이 MANAGER,CLEAK이고 이름의 두번째 글자가 L이 아닌 경우

SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO 
FROM EMP
WHERE ENAME NOT LIKE '_L%'
AND COMM IS NULL
AND MGR IS NOT NULL 
AND (JOB = 'CLERK' OR JOB = 'MANAGER');

-- 1. 사원명이 6글자 이상인 경우 사원번호와 직원명을 마스킹

SELECT EMPNO
	, ENAME
	, RPAD(SUBSTR(EMPNO,1,2),6,'*') AS "EMPNO 마스킹하기"
	, RPAD(SUBSTR(ENAME,1,1),6,'*') AS "ENAME 마스킹하기"
FROM EMP
WHERE LENGTH(ENAME) >= 6 ;


/*
 * 2. JOB이 SALESMAN, CLEAR에 해당하면,
 * 매월 평균적으로 20일 근무하고,
 * 일 평균 근무시간이 8시간인 경우
 * 일 평균 급여와 시급 기준 급여를 계산한 후 
 * 월급을 기준으로 오름차순으로 정렬 */

SELECT EMPNO
	, ENAME
	, JOB
	, SAL 
	, (SAL/20) AS "DAY_PER_SAL"
	, (SAL/(20*8))AS "HOUR_PER_SAL"
FROM EMP
WHERE JOB = 'SALESMAN' OR JOB = 'CLERK'
ORDER BY SAL ASC;


/* 3. 입사일 기준으로 3개월이 지난 후 
 * 첫 월요일에 정직원이 되는 날짜 YYYY-MM-DD
 * COMM이없는 경우, 'N/A'로 출력
 */

SELECT EMPNO
	, ENAME
	, ADD_MONTHS(HIREDATE,3) AS HIREDATE 
	, NVL(TO_CHAR(COMM),'N/A') AS COMM 
FROM EMP;


/*
 * 4. 직속상관이 없는 경우 0000,
 * 앞 두 자리가 75인 경우 5555, 
 * 앞 두 자리가 76인 경우 6666, 
 * 앞 두 자리가 77인 경우 7777, 
 * 기타의 경우 9999를 출력 */

SELECT EMPNO 
	, ENAME
	, MGR 
	, CASE
		WHEN MGR IS NULL THEN '0000'
		WHEN SUBSTR(MGR,1,2) = '75' THEN '5555'
		WHEN SUBSTR(MGR,1,2) = '76' THEN '6666'
		WHEN SUBSTR(MGR,1,2) = '77' THEN '7777'
		WHEN SUBSTR(MGR,1,2) = '78' THEN '8888'
		ELSE '9999'
		END AS CHG_MGR
FROM EMP;
