/*
*  left-join 
*/

SELECT E1.EMPNO
	, E1.ENAME
	, E1.MGR 
	, E2.EMPNO AS MGR_EMPNO
	, E2.ENAME AS MGR_ENAME
FROM EMP E1 LEFT JOIN EMP E2
	ON E1.MGR = E2.EMPNO
ORDER BY E1.EMPNO
;

/*
* right-join : 직원 사번과 상사 사번의 관계를 계층적으로 확인할 수 있는 방법
*/

SELECT E1.EMPNO
	, E1.ENAME
	, E1.MGR 
	, E2.EMPNO AS MGR_EMPNO
	, E2.ENAME AS MGR_ENAME
FROM EMP E1 right JOIN EMP E2
	ON E1.MGR = E2.EMPNO
ORDER BY E1.EMPNO
;


/*
* join 발전
*/

SELECT *
FROM EMP e1 RIGHT JOIN DEPT d 
		ON E1.DEPTNO = D.DEPTNO 	
	LEFT JOIN SALGRADE s 
		ON E1.SAL BETWEEN S.LOSAL AND S.HISAL 
	LEFT JOIN EMP e2 
		ON E1.MGR = E2.EMPNO
;

/*
* sub-query 서브 쿼리 ( 쿼리 문에 사용되는 쿼리)
* 
* 서브쿼리 결과 : 단일 값 출력
* 			, 다중행( 하나의 컬럼에 행 배열)   -- 그나마 단순
* 			, 다중열 ( 두 개 이상의 컬럼별 행 배열)  	-- 이게 어렵 
*/


SELECT *
FROM EMP e 
WHERE (DEPTNO, SAL) IN ( SELECT DEPTNO, MAX(SAL)
							FROM EMP e2 
							GROUP BY (DEPTNO)
						); -- IN 안에 있는 두 개의 칼럼이 모두 일치하는 값을 추출 --> 부서별 SAL이 최대인 사람을 추출할 수 있음
						
						
SELECT *
FROM EMP e 
WHERE (JOB, SAL) IN ( SELECT JOB, MAX(SAL)
							FROM EMP e2 
							GROUP BY (JOB)
						); -- 이런 식이 되면 JOB별 SAL이 최대인 사람을 추출
						
						
/*
 * CREATE TABLE : 테이블 구조 / 형태를 신규로 생성
 * 
 * 기존 동일한 테이블이 있는 경우, 에러 발생
 * DROP TABLE.... 을 통해 삭제 후 재생성 필요
 * 
 * CREATE문은 줄 맞추기가 중요!
 */
		
DROP TABLE EMP_NEW;		

CREATE TABLE EMP_NEW 
 ( 
 	EMPNO 		NUMBER(4) 		--기본 4자리 정수
 	,ENAME		VARCHAR2(10) 	-- 기본 문자열 10자리
 	,JOB		VARCHAR2(9)
 	,MGR		NUMBER(4) 		-- EMPNO와 동일한 사번
 	,HIREDATE 	DATE			-- 계산이 가능한 날짜
 	,SAL 	    NUMBER(7,2)		-- 전체 자릿수가 7자리 까지 인데 소수점 2자리 포함?
 	,COMM 	    NUMBER(7,2)
 	,DEPTNO		NUMBER(2)
 );
					
 
ALTER TABLE EMP_NEW 	
	ADD TEL VARCHAR(20)
;

COMMIT;

ALTER TABLE EMP_NEW
	MODIFY EMPNO NUMBER(5)  	-- 기존 4자리 정수에서 5자리로 확대 
;

COMMIT;


ALTER TABLE EMP_NEW 
	DROP COLUMN TEL;


COMMIT;

SELECT *
FROM EMP_NEW;



/*
 * 테이블명 변경
 */

ALTER TABLE EMP_NEW 
RENAME TO EMP_NEW_RENAMED
;



/*
* Sequence 생성 
* 
* 일련번호로 사용하거나, 일련번호를 pk로 사용하는 경우에 사용
*/

CREATE SEQUENCE SEQ_DEPT
	INCREMENT BY 1
	MAXVALUE 99999999999
	MINVALUE 1
	NOCYCLE
	NOCACHE
	;


SELECT *
FROM DEPT_TEMP2 dt ;

INSERT INTO DEPT_TEMP2 
VALUES( SEQ_DEPT.NEXTVAL, 'DB','BUSAN');





