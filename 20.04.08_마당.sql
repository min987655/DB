DROP USER c##madang CASCADE; 

CREATE USER c##madang IDENTIFIED BY c##madang 
DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp PROFILE DEFAULT;
alter user madang default tablespace users quota unlimited on users;


GRANT CONNECT, RESOURCE TO c##madang; 
GRANT CREATE TABLE, CREATE VIEW, CREATE SYNONYM TO c##madang;

ALTER USER c##madang ACCOUNT UNLOCK; /* 여기서부터는 마당 계정으로 접속 */ 

alter user c##madang default tablespace 
users quota unlimited on users;

conn c##madang/c##madang;

CREATE TABLE Book (  
                bookid     NUMBER(2) PRIMARY KEY, 
                bookname   VARCHAR2(40),  
                publisher  VARCHAR2(40),  
                price       NUMBER(8) );
                

INSERT INTO Book VALUES(1, '축구의 역사', '굿스포츠', 7000); 
INSERT INTO Book VALUES(2, '축구아는 여자', '나무수', 13000); 
INSERT INTO Book VALUES(3, '축구의 이해', '대한미디어', 22000); 
INSERT INTO Book VALUES(4, '골프 바이블', '대한미디어', 35000); 
INSERT INTO Book VALUES(5, '피겨 교본', '굿스포츠', 8000); 
INSERT INTO Book VALUES(6, '역도 단계별기술', '굿스포츠', 6000); 
INSERT INTO Book VALUES(7, '야구의 추억', '이상미디어', 20000); 
INSERT INTO Book VALUES(8, '야구를 부탁해', '이상미디어', 13000); 
INSERT INTO Book VALUES(9, '올림픽 이야기', '삼성당', 7500); 
INSERT INTO Book VALUES(10, 'Olympic Champions', 'Pearson', 13000);                

CREATE TABLE  Customer (  custid      NUMBER(2) PRIMARY KEY,    
			  name        VARCHAR2(40),  
			  address     VARCHAR2(50),  
			  phone       VARCHAR2(20) );

INSERT INTO Customer VALUES (1, '박지성', '영국 맨체스타', '000-5000-0001');
INSERT INTO Customer VALUES (2, '김연아', '대한민국 서울', '000-6000-0001'); 
INSERT INTO Customer VALUES (3, '장미란', '대한민국 강원도', '000-7000-0001'); 
INSERT INTO Customer VALUES (4, '추신수', '미국 클리블랜드', '000-8000-0001'); 
INSERT INTO Customer VALUES (5, '박세리', '대한민국 대전',  NULL);

CREATE TABLE Orders (  orderid    NUMBER(2) PRIMARY KEY,  
			custid     NUMBER(2) REFERENCES Customer(custid),  
			bookid     NUMBER(2) REFERENCES Book(bookid),  
			saleprice NUMBER(8) ,  orderdate DATE ); /* Book, Customer, Orders 데이터 생성 */ INSERT INTO Book VALUES(1, '축구의 역사', '굿스포츠', 7000); INSERT INTO Book VALUES(2, '축구아는 여자', '나무수', 13000); INSERT INTO Book VALUES(3, '축구의 이해', '대한미디어', 22000); INSERT INTO Book VALUES(4, '골프 바이블', '대한미디어', 35000); INSERT INTO Book VALUES(5, '피겨 교본', '굿스포츠', 8000); INSERT INTO Book VALUES(6, '역도 단계별기술', '굿스포츠', 6000); INSERT INTO Book VALUES(7, '야구의 추억', '이상미디어', 20000); INSERT INTO Book VALUES(8, '야구를 부탁해', '이상미디어', 13000); INSERT INTO Book VALUES(9, '올림픽 이야기', '삼성당', 7500); INSERT INTO Book VALUES(10, 'Olympic Champions', 'Pearson', 13000);

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

-- 도서번호 1인 도서의 이름
SELECT BOOKID, BOOKNAME
FROM BOOK
WHERE BOOKID = 1;
-- 가격이 20,000원 이상인 도서의 이름
SELECT BOOKNAME, PRICE
FROM BOOK
WHERE PRICE >= 20000;
-- 박지성의 총 구매액
SELECT c.name, SUM(o.saleprice) 구매합계
FROM CUSTOMER C, ORDERS O  
WHERE c.custid = o.custid and c.name LIKE '박지성'
GROUP BY c.name;
-- 박지성이 구매한 도서의 수
SELECT c.name, COUNT(*) 구매도서수
FROM CUSTOMER C, ORDERS O
WHERE c.custid = o.custid AND c.name LIKE '박지성'
GROUP BY c.name;
-- 마당서점 도서의 총 개수
SELECT COUNT(*)
FROM BOOK;
-- 마당서점에 도서를 출고하는 출판사의 총 개수
SELECT COUNT(DISTINCT PUBLISHER) 출판사개수
FROM BOOK;
-- 모든 고객의 이름, 주소
SELECT NAME, ADDRESS 
FROM CUSTOMER;
-- 14/7/4~7/7 사이에 주문받은 도서의 주문번호
SELECT orderid, orderdate
FROM ORDERS
WHERE ORDERDATE BETWEEN '140704' AND '140707';
-- 14/7/4~7/7 사이에 주문받은 도서를 제외한 주문번호
SELECT orderid, orderdate
FROM ORDERS
WHERE ORDERDATE NOT BETWEEN '140704' AND '140707';
-- 성이 김씨인 고객의 이름과 주소
SELECT NAME, ADDRESS 
FROM CUSTOMER
WHERE NAME LIKE '김%';
-- 성이 김씨이고 이름이 아로 끝나는 고객의 이름과 주소
SELECT NAME, ADDRESS 
FROM CUSTOMER
WHERE NAME LIKE '김%아';











