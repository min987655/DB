-- Describe (����)
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


-- ENAME �� WARD�� ����� �˻��Ͻÿ�.
SELECT *
FROM emp
WHERE ename = 'WARD';
-- JOB �� SALESMAN�� ����� �˻��Ͻÿ�.
SELECT *
FROM emp
WHERE job = 'SALESMAN';
-- JOB �� SALESMAN�̰� DEPTNO�� 30�� ����� �˻��Ͻÿ�.
SELECT *
FROM emp
WHERE job = 'SALESMAN' and deptno = 30;

-- �ѹ��� : �츮 ȸ�翡 JOB�� ���� �ִ��� ���� �;� !(�ߺ� ���� DISTINCT)
SELECT DISTINCT JOB
FROM emp;

-- �ѹ��� : �츮 ȸ�翡 �μ���ȣ�� ���� �ִ��� ���� �;� !(��Ī, ���Ƿ� �÷� ���� �ٲ㼭 ������. ���� ������ "")
SELECT DISTINCT DEPTNO �μ���ȣ
FROM emp;

DESC STUDENT;

SELECT *
FROM STUDENT
WHERE HEIGHT >=170; -- ( = , > , < , >= , <= )

--STUDENT ���̺��� GRADE(�г�)�� 2�г��̰ų� 3�г��� �л��� �˻��Ͻÿ�.
SELECT *
FROM STUDENT
WHERE GRADE = 2 or GRADE = 3;

-- ����(query) -> �Ľ�(parsing) : ������ �м��Ͽ� DB�� ���� �� �ְ� ����(�����Ϸ��� ����� ����)
SELECT *
FROM STUDENT
WHERE GRADE in (2,3); -- or�� �Ȱ��� ������. ����ϰ� ����� ������ �� ����.

-- EMP ���̺��� JOB�� SALESMAN �̰ų� MANAGER �̰ų� CLERK �� ����� ã���ÿ�.
SELECT *
FROM emp
WHERE JOB in ('SALESMAN', 'MANAGER', 'CLERK');

-- EMP ���̺��� �̸��� M���� ���۵Ǵ� ����� ã���ÿ�.
-- ��� : ��ġ�ʴ� �� ��µǴ� �࿡ ���߿� �÷��� ����. 
SELECT SUBSTR('CRIS', 1, 1)
FROM DUAL; -- DUAL : ������ ���̺��� �ϳ� �����Ͽ� ���ڿ��� �ٷ� ����

SELECT ENAME, SAL || '$' -- || : ����� �÷�(����)�� �����Ͽ� ����.
FROM emp;

-- emp���� ENAME ù���� M ã��
SELECT *
FROM emp
WHERE SUBSTR(ENAME,1,1) = 'M'; 

-- STUDENT���� 76��� ã��
SELECT *
FROM STUDENT
WHERE SUBSTR(JUMIN,1,2) = 76;

-- STUDENT���� �λ꿡 ��� ��� ã��
SELECT *
FROM STUDENT
WHERE SUBSTR(TEL,1,3) = '051';

-- 2���� �¾ ��� ã��
SELECT *
FROM STUDENT
WHERE SUBSTR(BIRTHDAY, 4,2) = '02';


-- ���ڿ��� ã���ִ� �Լ�
SELECT SUBSTR(TEL,INSTR(TEL,')')+1,INSTR(TEL, '-') - INSTR(TEL, ')')-1), TEL, INSTR(TEL,')')+1
FROM STUDENT;

SELECT INSTR(TEL, '-') - INSTR(TEL, ')')-1, TEL
FROM STUDENT;

-- ���� ����
-- 76p ����
SELECT name, SUBSTR(jumin,3,4) "Birthday",
             SUBSTR(jumin,3,4) -1 "Birthday -1"
FROM STUDENT
WHERE deptno1 = 101;
--78p ����
SELECT name, tel, INSTR(tel,')')
FROM STUDENT
WHERE deptno1 = 201;
--79p ����
SELECT name, tel, INSTR(tel,'3')
FROM STUDENT
WHERE deptno1 = 101;
--79p ����
SELECT name, tel, 
SUBSTR
(
    tel, 
    1, 
    INSTR(tel,')')- 
) "AREA CODE"
FROM STUDENT
WHERE deptno1 = 201;

-- REPLACE �Լ� ����غ���
SELECT REPLACE('ABC', 'AB', 'F')
FROM DUAL;

SELECT RPAD(SUBSTR(JUMIN, 1, 7), 13, '*') -- ������ ���鿡 ä��.
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

-- 84p ���� 1
SELECT ENAME, REPLACE(ENAME, SUBSTR(ENAME, 2,2),'--')"REPLACE"
FROM emp
WHERE deptno = 20;

-- 84p ���� 2
SELECT NAME, JUMIN, REPLACE(JUMIN, SUBSTR(JUMIN,7),'-/-/-/-')"REPLACE"
FROM STUDENT
WHERE deptno1 = 101;

-- 85p ���� 3
SELECT NAME, TEL, REPLACE(TEL, SUBSTR(TEL, 5, 3), '***')
FROM STUDENT
WHERE deptno1 = 102;
-- 85p ���� 3
SELECT NAME, TEL, REPLACE(TEL, SUBSTR(TEL, INSTR(TEL,')')+1, INSTR(TEL,'-')-INSTR(TEL,')')-1), '***')
FROM STUDENT
WHERE deptno1 = 102;

-- 85p ���� 4 
SELECT NAME, TEL, REPLACE(TEL, SUBSTR(TEL, INSTR(TEL, '-')+1),SUBSTR('****',1, INSTR(TEL, '-')+1))
FROM STUDENT
WHERE deptno1 = 101;

-- 71p INITCAP()�Լ�
SELECT ENAME, INITCAP(ENAME) "INITCAP"
FROM emp
WHERE deptno = 10;

SELECT LOC, INITCAP(LOC) "INITCAP"
FROM DEPT;

-- 72p LOWER()�Լ�, UPPER()�Լ�
SELECT ENAME, LOWER(ENAME), UPPER(ENAME)
FROM emp
WHERE DEPTNO = 10;

-- 80p LPAD()�Լ�
SELECT name, id, LPAD(id, 10, '*')
FROM STUDENT
WHERE DEPTNO1 = 201;

-- 81p LPAD() ����
SELECT ENAME, LPAD(ENAME, 9, '12345')
FROM emp
WHERE DEPTNO = 10;

-- 81p RPAD() �Լ�
SELECT ENAME, RPAD(ENAME, 10, '-')
FROM emp
WHERE DEPTNO = 10; 

-- 82p RPAD() ����
SELECT ENAME
FROM emp
WHERE DEPTNO = 10;