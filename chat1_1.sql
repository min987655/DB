create sequence num increment by 1 start with 1 maxvalue 99999 cycle;

create table UserContent (
    pryNumber number(5) NOT NULL PRIMARY KEY,
    idName varchar2(40),
    password varchar2(40),
    name varchar2(10),
    age varchar2(30),
    email varchar2(100),
    phoneNumber varchar2(30)
);

create table Room (
    rID number(4) NOT NULL PRIMARY KEY,
    title varchar2(100),
    rPassword varchar2(30),
    userCount varchar2(10),
    masterName varchar2(100),
    subject varchar2(30),
    condtionP number(1) default 0
);

SELECT * FROM usercontent;
SELECT * FROM room;

alter table UserContent drop column email;