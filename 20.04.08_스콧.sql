SELECT *
FROM BOARD;

SELECT *
FROM REPLY;

SELECT ID, TITLE, (SELECT COUNT(*) FROM REPLY WHERE BOARDID = B.ID)
FROM BOARD B;

SELECT B.ID, B.TITLE, 
(SELECT COUNT(*) FROM REPLY WHERE BOARDID = B.ID)
FROM BOARD B, REPLY R
WHERE R.BOARDID(+) = B.ID;

