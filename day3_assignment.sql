-- 이론과제 

/*
*
* Q3-1
* (1) 원자성
* (2) 완전 함수적 종속
* (3) 이행적 종속 제거
* 
* Q3-2
* (1) 제3정규화
* (2) 제2정규화
* 
* Q3-3 
* (1) Inner join 
* (2) Left join
* (3) Right join
* (4) Outer join
* 
* Q3-4
* (1) 반정규화
* 
* Q3-5
* (1) 인덱스 (Index)
* (2) 인덱스 
* (3) 인덱스
* (4) 인덱스
* 
* Q3-6
* (1) 트랜잭션
* (2) Atomicity(원자성)
* (3) Consistency(일관성)
*/

-- 실습과제 첫페이지 1. 

CREATE TABLE DEPT_TEST
AS (SELECT * FROM DEPT );


INSERT INTO DEPT_TEST 
VALUES ( 50, 'ORACLE','BUSAN');

INSERT INTO DEPT_TEST 
VALUES ( 60, 'SQL','ILSAN');

INSERT INTO DEPT_TEST 
VALUES ( 70, 'SELECT','INCHEON');

INSERT INTO DEPT_TEST 
VALUES ( 80, 'DML','BUNDANG');

SELECT * FROM DEPT_TEST;

-- 실습과제 첫번째 페이지 2.

DROP TABLE EMP_TEST;

CREATE TABLE EMP_TEST
AS SELECT * FROM EMP WHERE 1=0; -- 틀만 가져오기 값 말고 

ALTER TABLE EMP_TEST 
DROP COLUMN COMM,
DROP COLUMN DEPTNO;

INSERT INTO DEPT_TEST 
VALUES ( 7201 , 'ORACLE','BUSAN');

SELECT * FROM EMP_TEST;


-- 실습과제 첫번째 페이지 3.

UPDATE EMP_TEST
SET DEPTNO = 70
WHERE SAL > (SELECT AVG(SAL)
             FROM EMP_TEST
             WHERE DEPTNO = 50)
;     

-- 실습과제 첫번째 페이지 4.


UPDATE EMP_TEST
SET DEPTNO = 80,
    SAL = SAL*1.2
WHERE HIREDATE > (SELECT MIN(HIREDATE)
                  FROM EMP_TEST
                  WHERE DEPTNO = 60)
;             


-- 실습과제 두번째 페이지 1.


CREATE TABLE EMP_NEW(
 EMPNO 		NUMBER(5),
 ENAME 		VARCHAR2(20),
 JOB		VARCHAR2(10),
 MGR 		NUMBER(5),
 HIREDATE	DATE,
 SAL  		NUMBER(7,2),
 DEPTNO 	NUMBER(2)
);

-- 실습과제 두번째 페이지 2.

ALTER TABLE EMP_NEW
ADD RESIGN_DATE DATE
;

-- 실습과제 두번째 페이지 3.

ALTER TABLE EMP_NEW
ADD SUR_NAME VARCHAR2(5)
;

-- 실습과제 두번째 페이지 4.


ALTER TABLE EMP_NEW
MODIFY SUR_NAME VARCHAR2(10)
;

-- 실습과제 두번째 페이지 5.

ALTER TABLE EMP_NEW
RENAME COLUMN ENAME TO FULL_NAME
;


-- 실습과제 세번째 페이지 1.

CREATE TABLE EMP_IDX AS
SELECT *
FROM EMP
;

CREATE INDEX EMP_EMPNO_IDX ON EMP_IDX(EMPNO);

-- 실습과제 세번째 페이지 2.

SELECT *
FROM USER_INDEXES
WHERE INDEX_NAME LIKE 'EMP_EMPNO_IDX'
;

-- 실습과제 세번째 페이지 3.

CREATE VIEW EMP_VIEW AS
SELECT EMPNO
      ,ENAME
      ,JOB
      ,DEPTNO
      ,SAL
      ,NVL2(COMM,'Y','N') AS COMM
FROM EMP_IDX
WHERE SAL >= 2000
;


-- 네 번째 페이지 
/*
 * (1) CONSTRAINTS
 * (2) UNIQUE
 * (3) NOT NULL
 * (4) PRIMARY KEY
 * (5) FOREIGN KEY
 */


