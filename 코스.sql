CREATE TABLE PLAYER 
(
  ID NUMBER 
, NAME VARCHAR2(30) 
, POSITION VARCHAR2(20) 
, TEAMID NUMBER 
);

INSERT INTO player(id, name, position, teamid)
VALUES(1, '�̴�ȣ', '1���', 1);

commit;

SELECT * FROM player;

UPDATE player set position = '2���' WHERE name='�̴�ȣ';

commit;

DELETE FROM player WHERE id = 1;

commit;