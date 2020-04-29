
CREATE TABLE users (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(20),
    email VARCHAR2(20),
    password VARCHAR2(20)
);

SELECT * 
FROM users
WHERE name = '¿Â∫∏∞Ì' and password = 1 or 1 = 1;

select id, name, email, password from users where id = :bi;

