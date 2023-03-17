-- 실습
ALTER USER SCOTT IDENTIFIED BY TIGER
ACCOUNT UNLOCK; -- system account 

SELECT * 
FROM emp;

SELECT *
FROM DEPT;

SELECT ENAME, b.DEPTNO 
FROM emp a
	,dept b
WHERE A.DEPTNO =B.DEPTNO
;-- TABLE alias A


SELECT ENAME, LOC
FROM emp a
	,dept b 
;-- TABLE alias A

SELECT ENAME, LOC
FROM EMP A
INNER JOIN DEPT B
ON A.DEPTNO = B.DEPTNO;


SELECT EMPNO
,ENAME
,DEPTNO
FROM EMP;

SELECT ENAME, SAL*3, COMM FROM EMP;
SELECT ENAME, SAL+COMM FROM EMP;

SELECT ENAME AS "emp_name", COMM AS commission, SAL*3 AS "SAL3M" FROM EMP;


SELECT 100 + 5, 10 -3, 30*2 , 10/3
FROM dual;


SELECT *FROM NLS_DATABASE_PARAMETERS ;

SELECT *FROM NLS_DATABASE_PARAMETERS 
WHERE PARAMETER = 'NLS_CHARACTERSET';

SELECT *FROM NLS_DATABASE_PARAMETERS 
WHERE PARAMETER LIKE '&LANGUAGE';





