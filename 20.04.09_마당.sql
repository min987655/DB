SELECT * FROM BOOK;
SELECT * FROM CUSTOMER;
SELECT * FROM ORDERS;
SELECT * FROM IMPORTED_BOOK;

-- �������� ������ ������ ���ǻ� ��
SELECT COUNT(DISTINCT b.publisher) ���ǻ��
FROM BOOK B, CUSTOMER C, ORDERS O
WHERE b.bookid = o.bookid 
    AND c.custid = o.custid 
    AND c.name LIKE '������';
    
-- �������� ������ ������ �̸�, ����, ������ �ǸŰ��� ����
SELECT C.NAME, B.BOOKNAME, B.PRICE, B.PRICE-O.SALEPRICE �ݾ�����  
FROM BOOK B, CUSTOMER C, ORDERS O
WHERE b.bookid = o.bookid 
    AND c.custid = o.custid
    AND c.name LIKE '������'; 
    
-- �������� �������� ���� ������ �̸�    
SELECT bookname
FROM book
MINUS 
SELECT b.bookname 
FROM BOOK B, CUSTOMER C, ORDERS O
WHERE b.bookid = o.bookid 
    AND c.custid = o.custid 
    AND c.name LIKE '������'; 
    
SELECT BOOKNAME
FROM BOOK
WHERE bookname NOT IN
    (
    SELECT b.bookname 
    FROM BOOK B, CUSTOMER C, ORDERS O
    WHERE b.bookid = o.bookid 
        AND c.custid = o.custid 
        AND c.name LIKE '������'
    );

SELECT b.BOOKNAME
FROM BOOK b
WHERE NOT EXISTS
    (
    SELECT b.bookname 
    FROM CUSTOMER C, ORDERS O
    WHERE b.bookid = o.bookid 
        AND c.custid = o.custid 
        AND c.name LIKE '������'
    );
    
-- �ֹ����� ���� ���� �̸�
SELECT name
FROM customer
MINUS
SELECT DISTINCT C.NAME
FROM CUSTOMER C, ORDERS O
WHERE o.custid = c.custid;

SELECT NAME
FROM customer
WHERE NAME NOT IN 
    (
    SELECT DISTINCT C.NAME
    FROM CUSTOMER C, ORDERS O
    WHERE o.custid = c.custid
    );

SELECT NAME
FROM customer C
WHERE NOT EXISTS 
    (
    SELECT DISTINCT C.NAME
    FROM ORDERS O
    WHERE o.custid = c.custid
    );


-- �ֹ� �ݾ��� �Ѿװ� �ֹ��� ��� �ݾ�
SELECT SUM(SALEPRICE) �ֹ��Ѿ�, AVG(SALEPRICE) ��ձݾ�
FROM ORDERS;

-- ���� �̸��� ���� ���ž�
SELECT c.name, SUM(o.saleprice)
FROM CUSTOMER C, ORDERS O
WHERE o.custid = c.custid
GROUP BY c.name;

-- ���� �̸��� ���� ������ ���� ���
SELECT c.name, b.bookname 
FROM CUSTOMER C, ORDERS O, BOOK B
WHERE o.custid = c.custid AND o.bookid = b.bookid;

-- ������ ���ݰ� �ǸŰ����� ���̰� ���� ���� �ֹ�
SELECT *
FROM BOOK B, ORDERS O
WHERE o.bookid = b.bookid AND b.price-o.saleprice = 
    (
    SELECT MAX(b.price-o.saleprice) 
    FROM BOOK B, ORDERS O
    WHERE o.bookid = b.bookid
    );

-- ������ �Ǹž� ��պ��� �ڽ��� ���ž� ����� �� ���� ���� �̸�
SELECT c.name
FROM customer c, orders o
WHERE c.custid = o.custid
GROUP BY c.name
HAVING AVG(saleprice) >
    (SELECT AVG(saleprice)
     FROM orders);
     
CREATE TABLE NewCustomer(
CUSTID  NUMBER PRIMARY KEY,
NAME    VARCHAR2(40),
ADDRESS VARCHAR2(40),
PHONE   VARCHAR2(30));

SELECT * FROM newcustomer;

CREATE TABLE NewOrders (
ORDERID   NUMBER PRIMARY KEY,
CUSTID    NUMBER NOT NULL, 
BOOKID    NUMBER NOT NULL,
SALEPRICE NUMBER,
ORDERDATE DATE,
FOREIGN KEY (CUSTID) REFERENCES NewCustomer(CUSTID) ON DELETE CASCADE
);

DROP TABLE NEWBOOK;

CREATE TABLE NEWBOOK (
BOOKID    NUMBER,
BOOKNAME  VARCHAR2(20),
PUBLISHER VARCHAR2(20),
PRICE     NUMBER);

ALTER TABLE NEWBOOK ADD isbn VARCHAR2(13);

ALTER TABLE NEWBOOK MODIFY isbn NUMBER;

ALTER TABLE NEWBOOK DROP COLUMN isbn;

ALTER TABLE NEWBOOK MODIFY BOOKID NUMBER NOT NULL;

ALTER TABLE NEWBOOK MODIFY BOOKID NUMBER PRIMARY KEY;

DROP TABLE NewBook;

DROP TABLE NEWORDERS;

DROP TABLE NEWCUSTOMER;

INSERT INTO BOOK(BOOKID, BOOKNAME, PUBLISHER, PRICE)
       VALUES(11,'������ ����','�Ѽ����м���',90000);
       
INSERT INTO BOOK(BOOKID, BOOKNAME, PUBLISHER)
       VALUES(14, '������ ����', '�Ѽ����м���');
       
INSERT INTO BOOK(BOOKID, BOOKNAME, PRICE, PUBLISHER)
       SELECT BOOKID, BOOKNAME, PRICE, PUBLISHER
       FROM IMPORTED_BOOK;
       
UPDATE CUSTOMER
SET ADDRESS = '���ѹα� �λ�'
WHERE CUSTID = 5;

UPDATE CUSTOMER
SET ADDRESS = (SELECT ADDRESS
               FROM CUSTOMER
               WHERE NAME = '�迬��')
WHERE NAME = '�ڼ���';

DELETE 
FROM CUSTOMER
WHERE CUSTID=5;

DELETE
FROM CUSTOMER;

SELECT * FROM BOOK;
SELECT * FROM CUSTOMER;
SELECT * FROM IMPORTED_BOOK;
SELECT * FROM ORDERS;

SELECT C.NAME, B.BOOKNAME, B.PUBLISHER
FROM CUSTOMER C, ORDERS O, BOOK B
WHERE C.CUSTID = O.CUSTID AND O.BOOKID = B.BOOKID;

-- �������� ������ ������ ���ǻ�� ���� ���ǻ翡�� ������ ������ ���� �̸�
SELECT DISTINCT C.NAME
FROM CUSTOMER C, ORDERS O, BOOK B
WHERE C.CUSTID = O.CUSTID AND O.BOOKID = B.BOOKID
AND B.PUBLISHER in 
(SELECT B.PUBLISHER
 FROM CUSTOMER C, ORDERS O, BOOK B
 WHERE C.CUSTID = O.CUSTID AND O.BOOKID = B.BOOKID AND C.NAME LIKE '������'
) AND NAME NOT LIKE '������';

-- �ΰ� �̻��� ���� �ٸ� ���ǻ翡�� ������ ������ ���� �̸�
SELECT C.NAME
FROM CUSTOMER C, ORDERS O, BOOK B
WHERE C.CUSTID = O.CUSTID AND O.BOOKID = B.BOOKID 
GROUP BY C.NAME
HAVING COUNT(DISTINCT B.PUBLISHER) >= 2;
-- (�������)
SELECT NAME 
FROM CUSTOMER C1
WHERE 2 <= ( SELECT COUNT(DISTINCT PUBLISHER)
        FROM CUSTOMER C, ORDERS O, BOOK B
        WHERE C.CUSTID = O.CUSTID AND O.BOOKID = B.BOOKID
            AND C.NAME = C1.NAME );
 
-- ��ü ���� 30% �̻��� ������ ����
SELECT BOOKNAME
FROM ORDERS O, BOOK B
WHERE O.BOOKID = B.BOOKID 
GROUP BY BOOKNAME
HAVING COUNT(B.BOOKID) >= 0.3 * (SELECT COUNT(*) FROM CUSTOMER);
-- (�������)
SELECT BOOKNAME
FROM BOOK B1
WHERE 0.3 * (SELECT COUNT(*) FROM CUSTOMER) 
    <= (SELECT COUNT(O.BOOKID) 
        FROM ORDERS O, BOOK B
        WHERE O.BOOKID = B.BOOKID
        AND B.BOOKNAME = B1.BOOKNAME);

-- ���ο� ���� �԰�(BOOKID(PK)�� �ߺ��Ǿ� ���� �ȵ�.
INSERT INTO BOOK VALUES(11,'������ ����','���ѹ̵��',10000);

-- �Ｚ�翡�� ������ ���� ����
DELETE FROM BOOK WHERE publisher='�Ｚ��';

-- �̻�̵��� ������ ������ ����
-- ORDERS���� BOOKID�� �����Ͽ� ���� �Ұ���.

-- ���ǻ� �̸� ���� 
UPDATE BOOK 
SET publisher = '�������ǻ�'
WHERE publisher = '���ѹ̵��';

-- SQL �����Լ�
-- ���� �Լ�
-- ���밪 ���
SELECT ABS(-15) FROM DUAL;
-- ���ں��� ũ�ų� ���� �ּ��� ����
SELECT CEIL(15.7) FROM DUAL;
-- �ڻ��� ��ȯ
SELECT COS(3.14159) FROM DUAL;
-- ���ں��� �۰ų� ���� �ּ��� ����
SELECT FLOOR(15.7) FROM DUAL;
-- ������ �ڿ��α� ���� ��ȯ
SELECT LOG(10, 100) FROM DUAL;
-- ������ �� ���
SELECT MOD(11,4) FROM DUAL;
-- ���� n���� ���� ���
SELECT POWER(3,2) FROM DUAL;
-- ���� �ݿø�(�ݿø� ���� �ڸ��� ���� �� ����) 
SELECT ROUND(15.7) FROM DUAL;
-- ���ڰ� ������ -1, 0�̸� 0, ����� 1
SELECT SIGN(-15) FROM DUAL;
-- ������ �ڸ� ���� ���� ����(�ݿø�X)
SELECT TRUNC(15.7) FROM DUAL;
-- ���� �ƽ�Ű �ڵ带 ���ڷ� ��ȯ
SELECT CHR(67) FROM DUAL;
-- �� ���ڿ��� ����
SELECT CONCAT('HAPPY',' Birthday') FROM DUAL;
-- ���ڿ��� ��� �ҹ��ڷ� ��ȯ
SELECT LOWER('Birthday') FROM DUAL;
-- ���ʺ��� ������ �ڸ� �� ���������� ���ڷ� ä��
SELECT LPAD('Page 1', 15, '*.') FROM DUAL;
-- ���ʺ��� ������ ���ڵ��� ����
SELECT LTRIM('Page 1', 'ae') FROM DUAL;
-- ������ ���ڸ� ���ϴ� ���ڷ� ����
SELECT REPLACE('JACK','J','BL') FROM DUAL;
-- �����ʺ��� ������ �ڸ� ������ ������ ���ڷ� ä��
SELECT RPAD('Page 1', 15, '*.') FROM DUAL;
-- �����ʺ��� ������ ���ڵ� ����
SELECT RTRIM('Page 1', 'ae') FROM DUAL;
-- ���ڿ��� ������ �ڸ��������� ������ ���̸�ŭ �߶� ��ȯ
SELECT SUBSTR('ABCDEFG', 3, 4) FROM DUAL;
-- ���ʿ��� ������ ���ڸ� ����(���ڿ��� ������ �⺻������ ���� ����)
SELECT TRIM(LEADING 0 FROM '00AA00') FROM DUAL;
-- �빮�� ��ȯ
SELECT UPPER('Birthday') FROM DUAL;
-- ���ĺ� ������ �ƽ�Ű �ڵ� �� ��ȯ
SELECT ASCII('A') FROM DUAL;
-- 3��° ���ں��� OR�� 2��° ��Ÿ���� �ڸ� ��
SELECT INSTR('CORPORATE FLOOR', 'OR', 3, 2) FROM DUAL;
-- ���� �� ��ȯ
SELECT LENGTH('Birthday') FROM DUAL;
-- ������ �޸�ŭ ����
SELECT ADD_MONTHS('14/05/21', 1) FROM DUAL;
-- ���� ������ �� ��ȯ
SELECT LAST_DAY(SYSDATE) FROM DUAL;
-- ������ ��¥ ���� ��¥���� ���� ����� ������ ������ ��¥�� ��ȯ
SELECT NEXT_DAY(SYSDATE, '������') FROM DUAL;
-- ��, �� ������ �ݿø��ϰų� ������(������ ���� ������ �ð����� �ݿø� �ǰų� ������)
SELECT ROUND(SYSDATE) FROM DUAL;
-- DBMS �ý��ۻ��� ���� ��¥�� ��ȯ
SELECT SYSDATE FROM DUAL;
-- ��¥�� ���ڷ� ��ȯ
SELECT TO_CHAR(SYSDATE) FROM DUAL;
-- ���ڸ� ���ڷ� ��ȯ
SELECT TO_CHAR(123) FROM DUAL;
-- ���ڸ� ��¥�������� ��ȯ
SELECT TO_DATE('12 05 2014', 'DD MM YYYY') FROM DUAL;
-- Ư�� �����͸� ���������� ��ȯ
SELECT TO_NUMBER('12.3') FROM DUAL;
-- DECODE(�÷���, ����, ���) : ���ǿ� ���� ���
SELECT DECODE(1, 1, 'aa', 'bb') FROM DUAL;
-- NULL(ǥ����1, ǥ����2) : ǥ���� 1 = ǥ����2 �̸�NULL ���, �ƴϸ� ǥ���� 1 ���
SELECT NULLIF(123, 345) FROM DUAL;
-- NULL�� 0 �Ǵ� �ٸ� ������ ��ȯ
SELECT NVL(NULL, 123) FROM DUAL;