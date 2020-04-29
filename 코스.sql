CREATE TABLE PLAYER 
(
  ID NUMBER 
, NAME VARCHAR2(30) 
, POSITION VARCHAR2(20) 
, TEAMID NUMBER 
);

INSERT INTO player(id, name, position, teamid)
VALUES(1, '이대호', '1루수', 1);

commit;

SELECT * FROM player;

UPDATE player set position = '2루수' WHERE name='이대호';

commit;

DELETE FROM player WHERE id = 1;

commit;