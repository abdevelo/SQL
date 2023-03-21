/*
 * 레코드 집계 함수 
 * 
 * - 집계 함수는 컬럼 단위 
 * 
 * 레코드 그룹별 집계 : GROUP BY
 * 집계 조건 : HAVING
 * */

SELECT sum(E.SAL) AS sum_of_sal --CFO 관심사
	,AVG(E.SAL) AS avg_of_sal --HR부장 
FROM EMP e 
;

SELECT DISTINCT DEPTNO
FROM EMP
;

SELECT DISTINCT DEPTNO  
	, SAL 
	, EMPNO -- PK는 UNIQUE하기 때문에 DISTINCT를 추가할 필요가 없다.
FROM EMP e 
;

SELECT SUM(DISTINCT e.SAL) AS sum_of_distinct
	,SUM(ALL e.SAL) AS sum_of_all
	,SUM(e.SAL) AS normal_sum 
FROM EMP e 
;


SELECT max(sal) AS max_sal
	, min(sal) AS min_sal
	, round ( max(sal) / min(sal) ,1) AS max_min_times
FROM emp
WHERE deptno = 30
;


/*
 * COUNT 집계 함수 
 */

SELECT COUNT(EMPNO) 
	, COUNT(COMM) -- NULL값은 카운트에서 제외한다
FROM EMP e 
;

SELECT COUNT(*)
FROM EMP e 
WHERE DEPTNO = 30
;

SELECT COUNT(DISTINCT SAL)
	, COUNT(ALL SAL)
	, COUNT(SAL)
FROM EMP e 
; -- 결과를 보면 중복되는 값이 있어 전체 값과 중복제외 값이 다르다 

SELECT COUNT(ENAME)
FROM EMP e 
WHERE COMM IS NOT NULL
; -- 커미션 자체의 정보가 있는 사람

SELECT COUNT(ENAME)
FROM EMP e 
WHERE NVL(COMM, 0) = 0  -- NVL ( 원래값, NULL이면 나올값)  
; -- 커미션 정보가 0인 사람

SELECT AVG(SAL), '10' AS DNO
FROM EMP e 
WHERE DEPTNO = 10
UNION ALL 
SELECT AVG(SAL), '20' AS DNO
FROM EMP e 
WHERE DEPTNO = 20
UNION ALL 
SELECT AVG(SAL), '30' AS DNO
FROM EMP e 
WHERE DEPTNO = 30
;  -- 그룹별 집계를 이렇게 하면 반복이 많으니 GROUP BY를 쓴다 


/*
 * GROUP BY 사용하여 스마트하게 집계 
 */

SELECT DEPTNO
	, COUNT(SAL) --통계 정보가 의미가 있으려면 세트인 값
	, AVG(SAL)
	, MAX(SAL)
	, MIN(SAL)
	, SUM(SAL)
FROM EMP
GROUP BY DEPTNO 
ORDER BY DEPTNO
;

SELECT DEPTNO
	, JOB 
	, COUNT(SAL) AS num
	, AVG(SAL) AS avg_pay
	, AVG(SAL + NVL(COMM,0)) AS avg_pay
	, MAX(SAL) AS max_pay
	, MIN(SAL) AS min_pay
	, SUM(SAL) AS sum_pay
FROM EMP
GROUP BY DEPTNO, JOB 
ORDER BY DEPTNO
;



/*
 * JOIN 키워드 : 테이블 정규화로 분할된 테이블 칼럼을 다시 합치는 작업
 */

SELECT * 
FROM EMP, DEPT --잘못된 JOIN사용 : cartesian product
ORDER BY EMPNO
;


SELECT *
FROM EMP e, DEPT d -- 잘못된 JOIN 사용 
WHERE E.ENAME = 'MILLER'
ORDER BY E.EMPNO
;

SELECT E.DEPTNO , D.DEPTNO 
FROM EMP e, DEPT d -- 잘못된 JOIN 사용 
WHERE E.ENAME = 'MILLER'
ORDER BY E.EMPNO
;

/*
 * INNER JOIN : 교집합 컬럼 연결 
 */


SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO  = DEPT.DEPTNO 
ORDER BY EMPNO 
;


SELECT E.EMPNO 
	, E.HIREDATE 
	, D.DNAME 
	, E.SAL 
FROM EMP E JOIN DEPT D 
	ON E.DEPTNO = D.DEPTNO -- ON 키워드 위에 값 비교
ORDER BY EMPNO
;



SELECT E.EMPNO 
	, E.HIREDATE 
	, D.DNAME 
	, E.SAL 
FROM EMP E JOIN DEPT D 
	USING ( DEPTNO) -- USING 키워드 하나로 동일 컬럼 비교 // USING안에는 별칭 없어야 함
ORDER BY EMPNO
;


/*
 * 자바, c/c++ 로 프로그래밍에서 sql쿼리문 사용하는 경우
 * 쿼리문을 문자열로 사용 가능 
 */
var_deptno ; -- 사용자로부터 입력받은 부서 번호
var_sql = "SELECT E.EMPNO 
	, E.HIREDATE 
	, D.DNAME 
	, E.SAL 
FROM EMP E JOIN DEPT D 
	USING (($var_deptno))
ORDER BY EMPNO
"


SELECT E.EMPNO 
--	, E.HIREDATE
	, TO_CHAR(E.HIREDATE, 'YYYY MM-DD') AS hire_ymd
	, E.ENAME
	, D.DEPTNO
	, D.LOC
	, E.SAL 
FROM EMP e 
	, DEPT D
WHERE E.DEPTNO = D.DEPTNO AND E.SAL < 2000
ORDER BY E.SAL DESC --SAL 2000미만 밑에 누가 있을까 ?
; 


SELECT D.DNAME AS DNAME
	, E.JOB AS JOB
	, AVG(E.SAL) AS AVG_SAL
	, SUM (E.SAL) AS SUM_SAL
	, MAX (E.SAL) AS MAX_SAL
	, MIN (E.SAL) AS MIN_SAL
	, COUNT (E.SAL) AS CNT_SAL
FROM EMP e 
	, DEPT D
WHERE E.DEPTNO = D.DEPTNO AND E.SAL < 2000
GROUP BY D.DNAME , E.JOB -- GROUPBY에 있는 컬럼이 SELECT에 꼭 있어야 함??
;

SELECT *
FROM SALGRADE 
;

-- 이름과 그레이드가 나오는 1,2열이 핵심이다. 
-- SMITH가 1등급이네라는 정보를 알고 싶어함 
SELECT E.ENAME
	, S.GRADE
	, E.DEPTNO
	, E.SAL 
	, E.JOB
FROM EMP E, SALGRADE s 
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL
;

SELECT E.ENAME
	, E.DEPTNO 
	, E.JOB 
	, S.GRADE 
	, E.SAL 
	, S.LOSAL AS LOW_RNG
	, S.HISAL AS HIGH_RNG
FROM EMP E, SALGRADE s 
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL 
;


/*
 * JOIN 함수로 SALGRADE부여 후 GRADE로 그룹별 직원 수 
 */
SELECT S.GRADE 
	, COUNT(E.ENAME) AS EMP_CNT
FROM EMP E, SALGRADE s 
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL 
GROUP BY S.GRADE 
ORDER BY EMP_CNT DESC 
;


SELECT *
FROM EMP e , DEPT d 
WHERE E.DEPTNO = D.DEPTNO 
;


/*
 * SELF-JOIN 자기 자신의 릴레이션을 이용해서 테이블 컬럽을 조작
 * 
 */

SELECT 	E1.EMPNO
	, E1.ENAME 
	, E1.MGR 
	, E2.ENAME AS MGR_ENAME
FROM EMP E1, EMP E2 -- SELF-JOIN 목적으로 테이블 사용
WHERE E1.MGR = E2.EMPNO -- E1의 매니저 번호(E1직원의 직속 매니저)가 E2의 직원번호와 같을 때 
;


/*
 * LEFT-JOIN (1) : (+) 활용
 * : 왼쪽 테이블 값을 모두 가져오고
 *   JOIN하는 테이블에 해당되는 값 일부만 가져오기
 *   (+) 붙인 테이블을 반대편테이블( = 왼쪽 테이블)에다가 오른쪽에 추가한다고 생각
 * 	
 * 	 WHERE A(*) = B (+) 라고생각 B테이블은 ADD한다 A는 모두 쓴다고 생각
 */


SELECT 	E1.EMPNO
	, E1.ENAME 
	, E1.MGR 
	, E2.ENAME AS MGR_ENAME
FROM EMP E1, EMP E2 
WHERE E1.MGR = E2.EMPNO(+)
;


/*
 * LEFT-JOIN (2): 표준 SQL
 * 
 * 직원을 세워놓고 상사를 달아주는 방향
 */

SELECT E1.EMPNO
	, E1.ENAME 
	, E1.MGR 
	, E2.EMPNO AS MGR_NO
	, E2.ENAME AS MGR_ENAME
FROM EMP E1 LEFT OUTER JOIN EMP E2
		ON ( E1.MGR = E2. EMPNO )
;



/*
 * RIGHT-JOIN : 오라클 SQL 활용
 * 
 * 상사를 먼저 보고 직원을 달아주는 방향
 */
SELECT E1.EMPNO
	, E1.ENAME 
	, E1.MGR 
	, E2.EMPNO AS MGR_NO
	, E2.ENAME AS MGR_ENAME
FROM EMP E1, EMP E2
WHERE E1.MGR = E2.EMPNO(+) 
ORDER BY EMPNO 
;


/*
 * RIGHT OUTER JOIN : 표준 SQL
 */
SELECT E1.EMPNO
	, E1.ENAME 
	, E1.MGR 
	, E2.EMPNO AS MGR_NO
	, E2.ENAME AS MGR_ENAME
FROM EMP E1 RIGHT OUTER JOIN EMP E2
				ON (E1.MGR = E2.EMPNO)
ORDER BY EMPNO 
;


/*
 * FULL OUTER JOIN : 표준 SQL 
 * ( FULL-JOIN ) 양측 조인
 * 
 * OUTER= 기준이 있고 기준 밖에 있는 테이블들을 ADD시킨다는 의미로 이해 
 * FULLE OUTER = LEFT + RIGHT + 기준 테이블
 */ 

SELECT E1.EMPNO
	, E1.ENAME 
	, E1.MGR 
	, E2.EMPNO AS MGR_NO
	, E2.ENAME AS MGR_ENAME
FROM EMP E1 FULL OUTER JOIN EMP E2
		ON E1.MGR = E2.EMPNO 
ORDER BY E2.EMPNO
;


/*
 * FULL OUTER JOIN : ORACLE 조인
 * 
 * 은 존재하지 않음
 * 목적이 불분명하고 활용도가 낮아 개발하지 않았을 가능성이 높음
 * 
 * FULL OUTER JOIN의 용도는 한번에 테이블을 생성해서 
 * 분할해서 사용할 수 있기에 추후에 만들어졌다는 썰 정도....
 * 
 * 분할 전 테이블의 기준이 명확하지 않아 활용도가 낮다....
 * 
 * */

SELECT E1.EMPNO
	, E1.ENAME 
	, E1.MGR 
	, E2.EMPNO AS MGR_NO
	, E2.ENAME AS MGR_ENAME
FROM EMP E1(+) = EMP E2 (+)
;


/*
 * EMP, DEPT, SALGRADE, SELF-JOIN EMP
 * 4개 테이블을 활용하여 값을 출력
 * 
 * 
 */

SELECT D.DEPTNO 
	, D.DNAME 
	, E1.EMPNO 
	, E1.ENAME 
	, E1.MGR 
	, E1.SAL 
	, E1.DEPTNO 
	, S.LOSAL 
	, S.HISAL 
	, S.GRADE 
	, E2.EMPNO  AS MGR_EMPNO
	, E2.ENAME  AS MGR_ENAME
FROM EMP e1 , DEPT d , SALGRADE s , EMP e2 
WHERE E1.DEPTNO(+)= D.DEPTNO 
AND E1.SAL BETWEEN S.LOSAL(+) AND S.HISAL(+)
AND E1.MGR = E2.EMPNO(+) 
ORDER BY D.DEPTNO , E1.EMPNO
;

/*
 *  EMP, DEPT, SALGRADE, SELF-JOIN EMP
 *  2개씩 연관된 테이블의 일부를 오라클 SQL로 출력
 */

SELECT D.DEPTNO 
	, D.DNAME 
	, E1.EMPNO 
	, E1.ENAME 
	, E1.MGR 
	, E1.SAL 
FROM EMP e1 , DEPT d
WHERE E1.DEPTNO(+)= D.DEPTNO
; -- 직원중에 operation 부서에 해당하는 사람은 없지만 RIGHT JOIN 이기에 deptno는 다 출력

SELECT * FROM DEPT WHERE DEPTNO = 40;


SELECT E1.EMPNO 
	, E1.ENAME 
	, E1.MGR 
	, E1.SAL
	, S.LOSAL 
	, S.HISAL 
	, S.GRADE 
FROM EMP e1 , SALGRADE s 
WHERE E1.SAL BETWEEN S.LOSAL (+) AND S.HISAL
ORDER BY E1.EMPNO 
;


SELECT E1.EMPNO 
	, E1.ENAME 
	, E1.MGR 
	, E1.SAL 
	, E1.DEPTNO 
	, E2.EMPNO  AS MGR_EMPNO
	, E2.ENAME  AS MGR_ENAME
FROM EMP e1 , EMP e2 
WHERE E1.MGR = E2.EMPNO(+) 
ORDER BY E1.EMPNO
;


/*
 * 표준 SQL 출력
 * EMP e1, DEPT d, SALGRADE s, EMP e2
 */


SELECT D.DEPTNO 
	, D.DNAME 
	, E1.EMPNO 
	, E1.ENAME 
	, E1.MGR 
	, E1.SAL 
	, E1.DEPTNO 
	, S.LOSAL 
	, S.HISAL 
	, S.GRADE 
	, E2.EMPNO  AS MGR_EMPNO
	, E2.ENAME  AS MGR_ENAME
FROM EMP e1 RIGHT JOIN DEPT d
			ON E1.DEPTNO= D.DEPTNO 
	LEFT OUTER JOIN SALGRADE s 
			ON ( E1.SAL >= S.LOSAL AND E1.SAL <= S.HISAL )
	LEFT OUTER JOIN EMP e2 
			ON ( E1.MGR = E2.EMPNO)
ORDER BY D.DEPTNO , E1.EMPNO
;

/*
 * 단일행 서브 쿼리 : 쿼리 안에 쿼리 문장을 사용
 * 
 * SELECT 쿼리의 결과는 --> 1개의 값이 출력
 * 
 */


SELECT *
FROM EMP e
WHERE SAL > ( SELECT SAL FROM EMP WHERE ENAME= 'SMITH'); --서브쿼리 해당부분에 800을 넣은 것과 마찬가지

SELECT SAL FROM EMP WHERE ENAME= 'SMITH';  --값은 800


SELECT *
FROM EMP e ,DEPT d 
WHERE E.DEPTNO = D.DEPTNO -- JOIN에 대한 정보를 주기 위해 WHERE문의 첫번째에 보통 온다
	AND E.DEPTNO = 20
	AND E.SAL > ( SELECT AVG(SAL) FROM EMP);


/*
 * 다중행 서브 쿼리 
 * 
 * SELECT 쿼리의 결과는 --> 2개 이상의 값으로 된 테이블 
 */

SELECT DEPTNO, ENAME, SAL
FROM EMP e 
WHERE SAL IN ( SELECT MAX(SAL) FROM EMP GROUP BY DEPTNO );

SELECT DEPTNO, ENAME, SAL
FROM EMP e 
WHERE SAL IN ( SELECT AVG(SAL) FROM EMP GROUP BY DEPTNO ); -- 에러

SELECT DEPTNO , MAX(SAL)
FROM EMP e 
GROUP BY DEPTNO
ORDER BY DEPTNO
; -- SUB-QUERY 1 , 그룹별 최고 샐러리를 출력

SELECT MIN(SAL), MAX(SAL)
FROM EMP e 
WHERE DEPTNO = 30
; -- SUB-QUERY 2 , 30그룹의 최소, 최고 샐러리 출력

SELECT *
FROM EMP
WHERE SAL < ANY (
	SELECT SAL 
	FROM EMP e 
	WHERE DEPTNO = 30
)
;
-- ANY 내의 그 어떤 값이더라도 (다중행) SAL이 작으면 TRUE = EXITST 같은 느낌...
-- 예를 들어 CLARK 은 2450으로 DEPTNO = 30 인 EMP와 비교시 딱 1사람에 대해서만 TRUE이여도 TUPLE에 포함된다.



/*
 * 다중 열 서브 쿼리 
 * 
 * 서브 퀄 결과가 두 개 이상의 컬럼으로 구성된 테이블  
 */

SELECT DEPTNO , SAL, EMPNO , ENAME 
FROM EMP e 
WHERE ( DEPTNO, SAL ) IN 
		(SELECT DEPTNO , MAX(SAL) 
		FROM EMP
		GROUP BY DEPTNO 
		)
ORDER BY DEPTNO 
;

-- GROUP BY 절에는 SELECT에 집계 함수가 필요. 
-- 서브쿼리 내에서 SELECT DEPTNO, SAL로 하게 되면
-- GROUP BY DEPTNO 로 했을 때 싱글 값이 아니라 배열이 SAL에 담겨있기 떄문에 다 담을 수 없음



/*
 * FROM 절에 사용되는 서브 쿼리 
 */


SELECT 
FROM ( SELECT FROM ) A
	, (SELECT FROM ) B
WHERE A. = B.
-- 기본틀


SELECT A.EMPNO
	, A.SAL
	, B.DNAME
	, B.LOC
FROM ( SELECT * FROM EMP WHERE DEPTNO = 30 ) A
	, (SELECT * FROM DEPT) B
WHERE A.DEPTNO = B.DEPTNO
;

/*
 * WITH 절 (구문) 사용 
 * - 편리한 가상 테이블 사용
 */

WITH E AS ( ) 
	, D AS ( )
	SELECT  .....
	FROM E, D
--기본틀 

	
WITH E AS (SELECT * FROM EMP WHERE DEPTNO = 20 ) 
	, D AS (SELECT * FROM DEPT )
	, S AS ( SELECT * FROM SALGRADE)
	SELECT  E.ENAME 
	, D.DNAME
	, E.SAL
	, D.LOC
	, S.GRADE
	FROM E, D, S
	WHERE E.DEPTNO = D.DEPTNO
	AND E.SAL BETWEEN S.LOSAL AND S.HISAL
;	

	



/*
 * CREATE TABLE
 * 
 * 
 */
CREATE TABLE DEPT_TEMP
AS SELECT * FROM DEPT; 
-- 기존 테이블의 '구조(컬럼 속성들)'와 '데이터'를 그대로 가져와서 복사 
-- DB에서 git 같은 존재

-- DML 중 INSERT 및 DELETE 는 WHERE절과 같은 조건절이 따라오기 마련
--
SELECT * FROM DEPT_TEMP;


