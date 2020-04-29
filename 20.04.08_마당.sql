DROP USER c##madang CASCADE; 

CREATE USER c##madang IDENTIFIED BY c##madang 
DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp PROFILE DEFAULT;
alter user madang default tablespace users quota unlimited on users;


GRANT CONNECT, RESOURCE TO c##madang; 
GRANT CREATE TABLE, CREATE VIEW, CREATE SYNONYM TO c##madang;

ALTER USER c##madang ACCOUNT UNLOCK; /* ���⼭���ʹ� ���� �������� ���� */ 

alter user c##madang default tablespace 
users quota unlimited on users;

conn c##madang/c##madang;

CREATE TABLE Book (  
                bookid     NUMBER(2) PRIMARY KEY, 
                bookname   VARCHAR2(40),  
                publisher  VARCHAR2(40),  
                price       NUMBER(8) );
                

INSERT INTO Book VALUES(1, '�౸�� ����', '�½�����', 7000); 
INSERT INTO Book VALUES(2, '�౸�ƴ� ����', '������', 13000); 
INSERT INTO Book VALUES(3, '�౸�� ����', '���ѹ̵��', 22000); 
INSERT INTO Book VALUES(4, '���� ���̺�', '���ѹ̵��', 35000); 
INSERT INTO Book VALUES(5, '�ǰ� ����', '�½�����', 8000); 
INSERT INTO Book VALUES(6, '���� �ܰ躰���', '�½�����', 6000); 
INSERT INTO Book VALUES(7, '�߱��� �߾�', '�̻�̵��', 20000); 
INSERT INTO Book VALUES(8, '�߱��� ��Ź��', '�̻�̵��', 13000); 
INSERT INTO Book VALUES(9, '�ø��� �̾߱�', '�Ｚ��', 7500); 
INSERT INTO Book VALUES(10, 'Olympic Champions', 'Pearson', 13000);                

CREATE TABLE  Customer (  custid      NUMBER(2) PRIMARY KEY,    
			  name        VARCHAR2(40),  
			  address     VARCHAR2(50),  
			  phone       VARCHAR2(20) );

INSERT INTO Customer VALUES (1, '������', '���� ��ü��Ÿ', '000-5000-0001');
INSERT INTO Customer VALUES (2, '�迬��', '���ѹα� ����', '000-6000-0001'); 
INSERT INTO Customer VALUES (3, '��̶�', '���ѹα� ������', '000-7000-0001'); 
INSERT INTO Customer VALUES (4, '�߽ż�', '�̱� Ŭ������', '000-8000-0001'); 
INSERT INTO Customer VALUES (5, '�ڼ���', '���ѹα� ����',  NULL);

CREATE TABLE Orders (  orderid    NUMBER(2) PRIMARY KEY,  
			custid     NUMBER(2) REFERENCES Customer(custid),  
			bookid     NUMBER(2) REFERENCES Book(bookid),  
			saleprice NUMBER(8) ,  orderdate DATE ); /* Book, Customer, Orders ������ ���� */ INSERT INTO Book VALUES(1, '�౸�� ����', '�½�����', 7000); INSERT INTO Book VALUES(2, '�౸�ƴ� ����', '������', 13000); INSERT INTO Book VALUES(3, '�౸�� ����', '���ѹ̵��', 22000); INSERT INTO Book VALUES(4, '���� ���̺�', '���ѹ̵��', 35000); INSERT INTO Book VALUES(5, '�ǰ� ����', '�½�����', 8000); INSERT INTO Book VALUES(6, '���� �ܰ躰���', '�½�����', 6000); INSERT INTO Book VALUES(7, '�߱��� �߾�', '�̻�̵��', 20000); INSERT INTO Book VALUES(8, '�߱��� ��Ź��', '�̻�̵��', 13000); INSERT INTO Book VALUES(9, '�ø��� �̾߱�', '�Ｚ��', 7500); INSERT INTO Book VALUES(10, 'Olympic Champions', 'Pearson', 13000);

INSERT INTO Orders VALUES (1, 1, 1, 6000, TO_DATE('2014-07-01','yyyy-mm-dd')); 
INSERT INTO Orders VALUES (2, 1, 3, 21000, TO_DATE('2014-07-03','yyyy-mm-dd')); INSERT INTO Orders VALUES (3, 2, 5, 8000, TO_DATE('2014-07-03','yyyy-mm-dd')); INSERT INTO Orders VALUES (4, 3, 6, 6000, TO_DATE('2014-07-04','yyyy-mm-dd')); INSERT INTO Orders VALUES (5, 4, 7, 20000, TO_DATE('2014-07-05','yyyy-mm-dd')); INSERT INTO Orders VALUES (6, 1, 2, 12000, TO_DATE('2014-07-07','yyyy-mm-dd')); INSERT INTO Orders VALUES (7, 4, 8, 13000, TO_DATE( '2014-07-07','yyyy-mm-dd')); INSERT INTO Orders VALUES (8, 3, 10, 12000, TO_DATE('2014-07-08','yyyy-mm-dd')); INSERT INTO Orders VALUES (9, 2, 10, 7000, TO_DATE('2014-07-09','yyyy-mm-dd')); INSERT INTO Orders VALUES (10, 3, 8, 13000, TO_DATE('2014-07-10','yyyy-mm-dd'));
CREATE TABLE Imported_Book (  bookid      NUMBER,  bookname    VARCHAR(40),  publisher   VARCHAR(40),  price        NUMBER(8)   );
INSERT INTO Imported_Book VALUES(21, 'Zen Golf', 'Pearson', 12000); INSERT INTO Imported_Book VALUES(22, 'Soccer Skills', 'Human Kinetics', 15000);
COMMIT;


--

SELECT * FROM BOOK;
SELECT * FROM CUSTOMER;
SELECT * FROM ORDERS;
SELECT * FROM IMPORTED_BOOK;

-- ������ȣ 1�� ������ �̸�
SELECT BOOKID, BOOKNAME
FROM BOOK
WHERE BOOKID = 1;
-- ������ 20,000�� �̻��� ������ �̸�
SELECT BOOKNAME, PRICE
FROM BOOK
WHERE PRICE >= 20000;
-- �������� �� ���ž�
SELECT c.name, SUM(o.saleprice) �����հ�
FROM CUSTOMER C, ORDERS O  
WHERE c.custid = o.custid and c.name LIKE '������'
GROUP BY c.name;
-- �������� ������ ������ ��
SELECT c.name, COUNT(*) ���ŵ�����
FROM CUSTOMER C, ORDERS O
WHERE c.custid = o.custid AND c.name LIKE '������'
GROUP BY c.name;
-- ���缭�� ������ �� ����
SELECT COUNT(*)
FROM BOOK;
-- ���缭���� ������ ����ϴ� ���ǻ��� �� ����
SELECT COUNT(DISTINCT PUBLISHER) ���ǻ簳��
FROM BOOK;
-- ��� ���� �̸�, �ּ�
SELECT NAME, ADDRESS 
FROM CUSTOMER;
-- 14/7/4~7/7 ���̿� �ֹ����� ������ �ֹ���ȣ
SELECT orderid, orderdate
FROM ORDERS
WHERE ORDERDATE BETWEEN '140704' AND '140707';
-- 14/7/4~7/7 ���̿� �ֹ����� ������ ������ �ֹ���ȣ
SELECT orderid, orderdate
FROM ORDERS
WHERE ORDERDATE NOT BETWEEN '140704' AND '140707';
-- ���� �达�� ���� �̸��� �ּ�
SELECT NAME, ADDRESS 
FROM CUSTOMER
WHERE NAME LIKE '��%';
-- ���� �达�̰� �̸��� �Ʒ� ������ ���� �̸��� �ּ�
SELECT NAME, ADDRESS 
FROM CUSTOMER
WHERE NAME LIKE '��%��';











