SELECT * FROM BOOK;
SELECT * FROM CUSTOMER;
SELECT * FROM ORDERS;
SELECT * FROM IMPORTED_BOOK;

-- 박지성이 구매한 도서의 출판사 수
SELECT COUNT(DISTINCT b.publisher) 출판사수
FROM BOOK B, CUSTOMER C, ORDERS O
WHERE b.bookid = o.bookid 
    AND c.custid = o.custid 
    AND c.name LIKE '박지성';
    
-- 박지성이 구매한 도서의 이름, 정가, 정가와 판매가의 차이
SELECT C.NAME, B.BOOKNAME, B.PRICE, B.PRICE-O.SALEPRICE 금액차이  
FROM BOOK B, CUSTOMER C, ORDERS O
WHERE b.bookid = o.bookid 
    AND c.custid = o.custid
    AND c.name LIKE '박지성'; 
    
-- 박지성이 구매하지 않은 도서의 이름    
SELECT bookname
FROM book
MINUS 
SELECT b.bookname 
FROM BOOK B, CUSTOMER C, ORDERS O
WHERE b.bookid = o.bookid 
    AND c.custid = o.custid 
    AND c.name LIKE '박지성'; 
    
SELECT BOOKNAME
FROM BOOK
WHERE bookname NOT IN
    (
    SELECT b.bookname 
    FROM BOOK B, CUSTOMER C, ORDERS O
    WHERE b.bookid = o.bookid 
        AND c.custid = o.custid 
        AND c.name LIKE '박지성'
    );

SELECT b.BOOKNAME
FROM BOOK b
WHERE NOT EXISTS
    (
    SELECT b.bookname 
    FROM CUSTOMER C, ORDERS O
    WHERE b.bookid = o.bookid 
        AND c.custid = o.custid 
        AND c.name LIKE '박지성'
    );
    
-- 주문하지 않은 고객의 이름
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


-- 주문 금액의 총액과 주문의 평균 금액
SELECT SUM(SALEPRICE) 주문총액, AVG(SALEPRICE) 평균금액
FROM ORDERS;

-- 고객의 이름과 고객별 구매액
SELECT c.name, SUM(o.saleprice)
FROM CUSTOMER C, ORDERS O
WHERE o.custid = c.custid
GROUP BY c.name;

-- 고객의 이름과 고객이 구매한 도서 목록
SELECT c.name, b.bookname 
FROM CUSTOMER C, ORDERS O, BOOK B
WHERE o.custid = c.custid AND o.bookid = b.bookid;

-- 도서의 가격과 판매가격의 차이가 가장 많은 주문
SELECT *
FROM BOOK B, ORDERS O
WHERE o.bookid = b.bookid AND b.price-o.saleprice = 
    (
    SELECT MAX(b.price-o.saleprice) 
    FROM BOOK B, ORDERS O
    WHERE o.bookid = b.bookid
    );

-- 도서의 판매액 평균보다 자신의 구매액 평균이 더 높은 고객의 이름
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
       VALUES(11,'스포츠 의학','한솔의학서적',90000);
       
INSERT INTO BOOK(BOOKID, BOOKNAME, PUBLISHER)
       VALUES(14, '스포츠 의학', '한솔의학서적');
       
INSERT INTO BOOK(BOOKID, BOOKNAME, PRICE, PUBLISHER)
       SELECT BOOKID, BOOKNAME, PRICE, PUBLISHER
       FROM IMPORTED_BOOK;
       
UPDATE CUSTOMER
SET ADDRESS = '대한민국 부산'
WHERE CUSTID = 5;

UPDATE CUSTOMER
SET ADDRESS = (SELECT ADDRESS
               FROM CUSTOMER
               WHERE NAME = '김연아')
WHERE NAME = '박세리';

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

-- 박지성이 구매한 도서의 출판사와 같은 출판사에서 도서를 구매한 고객의 이름
SELECT DISTINCT C.NAME
FROM CUSTOMER C, ORDERS O, BOOK B
WHERE C.CUSTID = O.CUSTID AND O.BOOKID = B.BOOKID
AND B.PUBLISHER in 
(SELECT B.PUBLISHER
 FROM CUSTOMER C, ORDERS O, BOOK B
 WHERE C.CUSTID = O.CUSTID AND O.BOOKID = B.BOOKID AND C.NAME LIKE '박지성'
) AND NAME NOT LIKE '박지성';

-- 두개 이상의 서로 다른 출판사에서 도서를 구매한 고객의 이름
SELECT C.NAME
FROM CUSTOMER C, ORDERS O, BOOK B
WHERE C.CUSTID = O.CUSTID AND O.BOOKID = B.BOOKID 
GROUP BY C.NAME
HAVING COUNT(DISTINCT B.PUBLISHER) >= 2;
-- (상관쿼리)
SELECT NAME 
FROM CUSTOMER C1
WHERE 2 <= ( SELECT COUNT(DISTINCT PUBLISHER)
        FROM CUSTOMER C, ORDERS O, BOOK B
        WHERE C.CUSTID = O.CUSTID AND O.BOOKID = B.BOOKID
            AND C.NAME = C1.NAME );
 
-- 전체 고객의 30% 이상이 구매한 도서
SELECT BOOKNAME
FROM ORDERS O, BOOK B
WHERE O.BOOKID = B.BOOKID 
GROUP BY BOOKNAME
HAVING COUNT(B.BOOKID) >= 0.3 * (SELECT COUNT(*) FROM CUSTOMER);
-- (상관쿼리)
SELECT BOOKNAME
FROM BOOK B1
WHERE 0.3 * (SELECT COUNT(*) FROM CUSTOMER) 
    <= (SELECT COUNT(O.BOOKID) 
        FROM ORDERS O, BOOK B
        WHERE O.BOOKID = B.BOOKID
        AND B.BOOKNAME = B1.BOOKNAME);

-- 새로운 도서 입고(BOOKID(PK)가 중복되어 삽입 안됨.
INSERT INTO BOOK VALUES(11,'스포츠 세계','대한미디어',10000);

-- 삼성당에서 출판한 도서 삭제
DELETE FROM BOOK WHERE publisher='삼성당';

-- 이상미디어에서 출판한 도서를 삭제
-- ORDERS에서 BOOKID를 참조하여 삭제 불가함.

-- 출판사 이름 변경 
UPDATE BOOK 
SET publisher = '대한출판사'
WHERE publisher = '대한미디어';

-- SQL 내장함수
-- 숫자 함수
-- 절대값 계산
SELECT ABS(-15) FROM DUAL;
-- 숫자보다 크거나 같은 최소의 정소
SELECT CEIL(15.7) FROM DUAL;
-- 코사인 반환
SELECT COS(3.14159) FROM DUAL;
-- 숫자보다 작거나 같은 최소의 정수
SELECT FLOOR(15.7) FROM DUAL;
-- 숫자의 자연로그 값을 반환
SELECT LOG(10, 100) FROM DUAL;
-- 나머지 값 계산
SELECT MOD(11,4) FROM DUAL;
-- 숫자 n제곱 값을 계산
SELECT POWER(3,2) FROM DUAL;
-- 숫자 반올림(반올림 기준 자릿수 정할 수 있음) 
SELECT ROUND(15.7) FROM DUAL;
-- 숫자가 음수면 -1, 0이면 0, 양수면 1
SELECT SIGN(-15) FROM DUAL;
-- 지정한 자리 이하 값을 버림(반올림X)
SELECT TRUNC(15.7) FROM DUAL;
-- 정수 아스키 코드를 문자로 반환
SELECT CHR(67) FROM DUAL;
-- 두 문자열을 연결
SELECT CONCAT('HAPPY',' Birthday') FROM DUAL;
-- 문자열을 모두 소문자로 변환
SELECT LOWER('Birthday') FROM DUAL;
-- 왼쪽부터 지정한 자리 수 까지지정한 문자로 채움
SELECT LPAD('Page 1', 15, '*.') FROM DUAL;
-- 왼쪽부터 지정한 문자들을 제거
SELECT LTRIM('Page 1', 'ae') FROM DUAL;
-- 지정한 문자를 원하는 문자로 변경
SELECT REPLACE('JACK','J','BL') FROM DUAL;
-- 오른쪽부터 지정한 자리 수까지 지정한 문자로 채움
SELECT RPAD('Page 1', 15, '*.') FROM DUAL;
-- 오른쪽부터 지정한 문자들 제거
SELECT RTRIM('Page 1', 'ae') FROM DUAL;
-- 문자열의 지정된 자리에서부터 지정된 길이만큼 잘라서 변환
SELECT SUBSTR('ABCDEFG', 3, 4) FROM DUAL;
-- 양쪽에서 지정된 문자를 삭제(문자열만 넣으면 기본값으로 공백 제거)
SELECT TRIM(LEADING 0 FROM '00AA00') FROM DUAL;
-- 대문자 변환
SELECT UPPER('Birthday') FROM DUAL;
-- 알파벳 문자의 아스키 코드 값 반환
SELECT ASCII('A') FROM DUAL;
-- 3번째 문자부터 OR가 2번째 나타나는 자리 수
SELECT INSTR('CORPORATE FLOOR', 'OR', 3, 2) FROM DUAL;
-- 글자 수 반환
SELECT LENGTH('Birthday') FROM DUAL;
-- 지정한 달만큼 더함
SELECT ADD_MONTHS('14/05/21', 1) FROM DUAL;
-- 달의 마지막 날 반환
SELECT LAST_DAY(SYSDATE) FROM DUAL;
-- 지정한 날짜 뒤쪽 날짜에서 가장 가까운 지정한 요일의 날짜가 반환
SELECT NEXT_DAY(SYSDATE, '월요일') FROM DUAL;
-- 년, 월 단위로 반올림하거나 버리기(단위를 쓰지 않으면 시간에서 반올림 되거나 버려짐)
SELECT ROUND(SYSDATE) FROM DUAL;
-- DBMS 시스템상의 오늘 날짜를 반환
SELECT SYSDATE FROM DUAL;
-- 날짜를 문자로 변환
SELECT TO_CHAR(SYSDATE) FROM DUAL;
-- 숫자를 문자로 변환
SELECT TO_CHAR(123) FROM DUAL;
-- 문자를 날짜형식으로 변환
SELECT TO_DATE('12 05 2014', 'DD MM YYYY') FROM DUAL;
-- 특정 데이터를 숫자형으로 변환
SELECT TO_NUMBER('12.3') FROM DUAL;
-- DECODE(컬럼명, 조건, 결과) : 조건에 따른 결과
SELECT DECODE(1, 1, 'aa', 'bb') FROM DUAL;
-- NULL(표현식1, 표현식2) : 표현식 1 = 표현식2 이면NULL 출력, 아니면 표현식 1 출력
SELECT NULLIF(123, 345) FROM DUAL;
-- NULL을 0 또는 다른 값으로 변환
SELECT NVL(NULL, 123) FROM DUAL;