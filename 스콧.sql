-- Describe (설명)
DESC emp;

SELECT EMPNO, ENAME, SAL
FROM emp;

SELECT *
FROM emp;

SELECT *
FROM emp
WHERE sal = 1250;

SELECT *
FROM emp
WHERE sal = 1250 or comm > 1000;


-- ENAME 이 WARD인 사람을 검색하시오.
SELECT *
FROM emp
WHERE ename = 'WARD';
-- JOB 이 SALESMAN인 사람을 검색하시오.
SELECT *
FROM emp
WHERE job = 'SALESMAN';
-- JOB 이 SALESMAN이고 DEPTNO가 30인 사람을 검색하시오.
SELECT *
FROM emp
WHERE job = 'SALESMAN' and deptno = 30;

-- 총무과 : 우리 회사에 JOB이 뭐가 있는지 보고 싶어 !(중복 제거 DISTINCT)
SELECT DISTINCT JOB
FROM emp;

-- 총무과 : 우리 회사에 부서번호가 뭐가 있는지 보고 싶어 !(별칭, 임의로 컬럼 명을 바꿔서 보여줌. 띄어쓰기 있으면 "")
SELECT DISTINCT DEPTNO 부서번호
FROM emp;

DESC STUDENT;

SELECT *
FROM STUDENT
WHERE HEIGHT >=170; -- ( = , > , < , >= , <= )

--STUDENT 테이블에서 GRADE(학년)이 2학년이거나 3학년인 학생을 검색하시오.
SELECT *
FROM STUDENT
WHERE GRADE = 2 or GRADE = 3;

-- 쿼리(query) -> 파싱(parsing) : 쿼리를 분석하여 DB가 읽을 수 있게 해줌(컴파일러와 비슷한 역할)
SELECT *
FROM STUDENT
WHERE GRADE in (2,3); -- or와 똑같은 연산자. 깔끔하게 결과값 보여줄 수 있음.

-- EMP 테이블에서 JOB이 SALESMAN 이거나 MANAGER 이거나 CLERK 인 사람을 찾으시오.
SELECT *
FROM emp
WHERE JOB in ('SALESMAN', 'MANAGER', 'CLERK');

-- EMP 테이블에서 이름이 M으로 시작되는 사람을 찾으시오.
-- 상수 : 변치않는 값 출력되는 행에 맞추여 컬럼이 생김. 
SELECT SUBSTR('CRIS', 1, 1)
FROM DUAL; -- DUAL : 가상의 테이블을 하나 생성하여 문자열을 바로 인출

SELECT ENAME, SAL || '$' -- || : 상수를 컬럼(변수)와 결합하여 인출.
FROM emp;

-- emp에서 ENAME 첫글자 M 찾기
SELECT *
FROM emp
WHERE SUBSTR(ENAME,1,1) = 'M'; 

-- STUDENT에서 76년생 찾기
SELECT *
FROM STUDENT
WHERE SUBSTR(JUMIN,1,2) = 76;

-- STUDENT에서 부산에 사는 사람 찾기
SELECT *
FROM STUDENT
WHERE SUBSTR(TEL,1,3) = '051';

-- 2월에 태어난 사람 찾기
SELECT *
FROM STUDENT
WHERE SUBSTR(BIRTHDAY, 4,2) = '02';


-- 문자열을 찾아주는 함수
SELECT SUBSTR(TEL,INSTR(TEL,')')+1,INSTR(TEL, '-') - INSTR(TEL, ')')-1), TEL, INSTR(TEL,')')+1
FROM STUDENT;

SELECT INSTR(TEL, '-') - INSTR(TEL, ')')-1, TEL
FROM STUDENT;

-- 교재 연습
-- 76p 예제
SELECT name, SUBSTR(jumin,3,4) "Birthday",
             SUBSTR(jumin,3,4) -1 "Birthday -1"
FROM STUDENT
WHERE deptno1 = 101;
--78p 예제
SELECT name, tel, INSTR(tel,')')
FROM STUDENT
WHERE deptno1 = 201;
--79p 예제
SELECT name, tel, INSTR(tel,'3')
FROM STUDENT
WHERE deptno1 = 101;
--79p 퀴즈
SELECT name, tel, 
SUBSTR
(
    tel, 
    1, 
    INSTR(tel,')')- 
) "AREA CODE"
FROM STUDENT
WHERE deptno1 = 201;

-- REPLACE 함수 사용해보기
SELECT REPLACE('ABC', 'AB', 'F')
FROM DUAL;

SELECT RPAD(SUBSTR(JUMIN, 1, 7), 13, '*') -- 오른쪽 여백에 채움.
FROM STUDENT;

SELECT REPLACE(JUMIN, '901813', '******')
FROM STUDENT;

SELECT REPLACE(JUMIN,SUBSTR(JUMIN,8),'******')
FROM STUDENT;

SELECT REPLACE
(
    tel, 
    SUBSTR(tel,1,INSTR(tel,')')-1), 
    SUBSTR('***', 1, INSTR(tel,')')-1)
) 
FROM STUDENT;

-- 84p 퀴즈 1
SELECT ENAME, REPLACE(ENAME, SUBSTR(ENAME, 2,2),'--')"REPLACE"
FROM emp
WHERE deptno = 20;

-- 84p 퀴즈 2
SELECT NAME, JUMIN, REPLACE(JUMIN, SUBSTR(JUMIN,7),'-/-/-/-')"REPLACE"
FROM STUDENT
WHERE deptno1 = 101;

-- 85p 퀴즈 3
SELECT NAME, TEL, REPLACE(TEL, SUBSTR(TEL, 5, 3), '***')
FROM STUDENT
WHERE deptno1 = 102;
-- 85p 퀴즈 3
SELECT NAME, TEL, REPLACE(TEL, SUBSTR(TEL, INSTR(TEL,')')+1, INSTR(TEL,'-')-INSTR(TEL,')')-1), '***')
FROM STUDENT
WHERE deptno1 = 102;

-- 85p 퀴즈 4 
SELECT NAME, TEL, REPLACE(TEL, SUBSTR(TEL, INSTR(TEL, '-')+1),SUBSTR('****',1, INSTR(TEL, '-')+1))
FROM STUDENT
WHERE deptno1 = 101;

-- 71p INITCAP()함수
SELECT ENAME, INITCAP(ENAME) "INITCAP"
FROM emp
WHERE deptno = 10;

SELECT LOC, INITCAP(LOC) "INITCAP"
FROM DEPT;

-- 72p LOWER()함수, UPPER()함수
SELECT ENAME, LOWER(ENAME), UPPER(ENAME)
FROM emp
WHERE DEPTNO = 10;

-- 80p LPAD()함수
SELECT name, id, LPAD(id, 10, '*')
FROM STUDENT
WHERE DEPTNO1 = 201;

-- 81p LPAD() 퀴즈
SELECT ENAME, LPAD(ENAME, 9, '12345')
FROM emp
WHERE DEPTNO = 10;

-- 81p RPAD() 함수
SELECT ENAME, RPAD(ENAME, 10, '-')
FROM emp
WHERE DEPTNO = 10; 

-- 82p RPAD() 퀴즈
SELECT ENAME
FROM emp
WHERE DEPTNO = 10;