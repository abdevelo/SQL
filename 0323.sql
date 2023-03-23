SELECT * FROM v$version;

SELECT * FROM v$option;

SELECT * FROM v$database;

SELECT * FROM v$instance; 

SELECT * FROM v$session; --인스턴스가 만들어지고 사용하는 기간 ?

SELECT * FROM v$parameter; --  통계에서 찾으려는 값 모수

/*
* 	트랜잭션 
* 
*  DBMS 작업 수행의 기본(최소) 단위
* 
*  작업 완료 or 실패 로 binary하게
*  작업이 수행되고 아니고로 나뉨.
* 
*  Atomicity , Consistency(일관성)
* 
* 
*  SAVEPOINT를 계속 잡는 것은 
*  목적이 분명할 때 사용 ( 메모리에 올려보고 , 연관된 과정 중 일부까지만 완료했을 때 )

*
* create -> insert-> update -> delete
**/

CREATE TABLE dept_tcl
AS ( SELECT * FROM dept )
;

SELECT * FROM dept_tcl;

INSERT INTO DEPT_TCL 
VALUES ( 50, 'DATABASE', 'SEOUL')
;

UPDATE DEPT_TCL 
SET loc = 'BUSAN'
WHERE DEPTNO = 40;

SELECT * FROM DEPT_TCL;

DELETE FROM DEPT_TCL
WHERE DNAME = 'RESEARCH'
; --DNAME인RESEARCH 행 전체를 날림 

SELECT * FROM DEPT_TCL; 

ROLLBACK;


-- COMMIT 실행하는 경우 ( ROLLBACK 불가 )

INSERT INTO DEPT_TCL VALUES( 50,'NETWORK','SEOUL');

UPDATE DEPT_TCL SET LOC='BUSAN' WHERE DEPTNO=20;

DELETE FROM DEPT_TCL WHERE DEPTNO=40;

SELECT * FROM DEPT_TCL;

COMMIT;

SELECT * FROM DEPT_TCL;

DELETE FROM DEPT_TCL WHERE DEPTNO=50;

SELECT * FROM DEPT_TCL;

COMMIT;


/*
 *  LOCK 테스트 
 * 
 * 동일한 계정으로 DBeaver 세션과 SQL*PLUS 세션을 열어
 * 데이터를 수정하는 동시 작업을 수행
 * 
 */

SELECT * FROM DEPT_TCL;

UPDATE DEPT_TCL
SET LOC = 'DAEGU'
WHERE DEPTNO = 30
; -- SQL*PLUS 세션에서 실행 중인 직원의 UPDATE시도를 막고 있는 상황을 모르고 있을 수도 있음.

COMMIT; -- 이것을 통해서 가능케함

INSERT INTO DEPT_TCL
VALUES ( 40, 'ALBUS','SEOUL');

SELECT * FROM DEPT_TCL
;--여기서도 커밋하지 않으면 sql*plus세션에서는 보이지 않음

COMMIT;



/*
 * Tuning 기초
 * DB처리 속도(우선)의 안정성 제고 목적의 경우가 대부분
 */

-- 튜닝 전과 후 비교

SELECT * FROM EMP 
WHERE SUBSTR(EMPNO,1,2) = '75' -- SUBSTRING 인데 75로 놔두면 형변환이 일어나기에 꼭 콤마에 담아주기
AND LENGTH(EMPNO) = 4 -- 불필요한 비교
;

SELECT * FROM EMP e
WHERE EMPNO > 7499 AND EMPNO < 7600
; -- 튜닝후


SELECT * FROM EMP WHERE ENAME||''||JOB = 'WARD SALESMAN'; --값도 안나옴

SELECT * FROM EMP WHERE ENAME = 'WARD' AND JOB = 'SALESMAN';


SELECT DISTINCT E.EMPNO, E.ENAME, D.DEPTNO
FROM EMP e JOIN DEPT d 
ON (E.DEPTNO= D.DEPTNO);


SELECT E.EMPNO, E.ENAME, D.DEPTNO
FROM EMP e JOIN DEPT d 
ON (E.DEPTNO= D.DEPTNO); --튜닝 


SELECT * FROM EMP WHERE DEPTNO = '10'
UNION 
SELECT * FROM EMP WHERE DEPTNO = '20'
; -- UNION을 적용시에 자동으로 EMPNO로 ORDER BY되는 줄 알았는데
-- 알고보니 그렇지 않고 
-- 데이터엔진 쿼리 옵티마이저가 인덱스 스캔 등의 기술을 이용해서 나온 결과일 듯

SELECT * FROM EMP WHERE DEPTNO = 10
UNION ALL
SELECT * FROM EMP WHERE DEPTNO = 20
; --튜닝


SELECT ENAME, EMPNO, SUM(SAL) FROM EMP e 
GROUP BY ENAME, EMPNO; 

SELECT ENAME, EMPNO, SUM(SAL) FROM EMP e 
GROUP BY EMPNO , ENAME; -- 튜닝 
-- 인덱스로 설정된 EMPNO가 우선오도록  
-- PK이자 인덱스가 EMPNO라서 EMPNO가왔지만
-- PK보다 인덱스가 더 우선적으로 오는게 순서가 빠르다(?)
 
SELECT EMPNO, ENAME FROM EMP e  
WHERE TO_CHAR(HIREDATE, 'YYYYMMDD') LIKE '1981%' --동일한 데이터타입
AND EMPNO > 7700;



SELECT EMPNO, ENAME FROM EMP e 
WHERE EXTRACT( YEAR FROM HIREDATE) = 1981 -- 동일한 DataType 
AND EMPNO > 7700; -- LIKE연산자보다는 부등호로 값 비교 



/*
 *
 *  
 *  
 */



