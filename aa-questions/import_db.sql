PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_follows; 
DROP TABLE IF EXISTS question_likes; 
DROP TABLE IF EXISTS replies; 
DROP TABLE IF EXISTS questions; 
DROP TABLE IF EXISTS users; 

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT,
  user_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  body TEXT,
  reply_id INTEGER,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ('Bob', 'Builder'),
  ('John', 'Doe'),
  ('Zan', 'Mor'),
  ('Ken', 'Ngu');
  
INSERT INTO
  questions (title, body, user_id)
VALUES
  ('sql', 'what does sql stand for?', 2),
  ('ruby', 'what does ruby do?', 1),
  ('sqlite3', 'how is it different from postreSQL?', 4),
  ('postreSQL', 'how is it different from sqlite3?', 3);
  
INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (1, 2),
  (3, 3),
  (1, 4),
  (1, 1),
  (4, 4),
  (3, 2);

INSERT INTO
  replies(question_id, user_id, body, reply_id)
VALUES
  (1, 3, 'Structured Query Language', NULL),
  (1, 2, 'Thanks!', 1),
  (3, 4, 'See my question', NULL);
  
INSERT INTO
  question_likes(user_id, question_id)
VALUES
(3, 2),
(4, 1),
(1, 4),
(4, 4),
(2, 2);




