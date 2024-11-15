PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(80) NOT NULL UNIQUE,
    email VARCHAR(120) NOT NULL UNIQUE,
    hashed_password VARCHAR(120) NOT NULL
);
INSERT INTO users VALUES(1,'teste','teste@teste.com','pbkdf2:sha256:600000$jfR3F8LRdYbAWSn2$e828dd91852987600ed51868e0e0047d4818d848a6f0123f69930f5b6d2685e0');
CREATE TABLE workouts (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    image_path VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL
);
INSERT INTO workouts VALUES(1,'Tatkaar (Footwork)','Tatkaar is a foundational footwork pattern in Kathak where dancers tap their feet to rhythmic beats.','images/workouts/upper-body.jpg','Tatkaar');
INSERT INTO workouts VALUES(2,'Basic Hand Positions','Learning mudras (hand gestures) like Pataka is essential in Kathak, as they express emotions and enhance the dance.','images/workouts/lower-body.jpg','Hand Postures');
INSERT INTO workouts VALUES(3,'Basic Postures','Learning mudras like Tripataka is essential in Kathak, as they express emotions and enhance the dance.','images/workouts/stretch.jpg','Basic Postures');
INSERT INTO workouts VALUES(4,'Padhant (Rhythmic Syllables)','In Padhant, dancers practice rhythmic syllables, or bols-like "Ta Thai Thai" and "Dha Ti Na"-to synchronize and refine their footwork rhythm.','images/workouts/yoga.jpg','Padhant');
INSERT INTO workouts VALUES(5,'Chakkar (Spin/Turns)','Chakkar (spin) is a key element of Kathak, but it’s important to first focus on basic balance and footwork before mastering the spin.','images/workouts/cycling.jpg','Chakkar');
INSERT INTO workouts VALUES(6,'Basic Postures-II','Learning mudras like Tripataka is essential in Kathak, as they express emotions and enhance the dance.','images/workouts/running-gym.jpg','Basic Postures II');
INSERT INTO workouts VALUES(7,'Chakkar (Spin/Turns)-II','Chakkar (spin) is a key element of Kathak, but it’s important to first focus on basic balance and footwork before mastering the spin.','images/workouts/lower_body_home.jpg','Chakkar-II');
INSERT INTO workouts VALUES(8,'Basic Postures-III','Learning mudras like Tripataka is essential in Kathak, as they express emotions and enhance the dance.','images/workouts/yoga_gym.jpg','Basic Postures III');
CREATE TABLE activities (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    age INTEGER NOT NULL,
    gender VARCHAR(10) NOT NULL,
    weight FLOAT NOT NULL,
    height FLOAT NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    duration INTEGER NOT NULL,
    intensity VARCHAR(10) NOT NULL,
    resting_heart_rate INTEGER NOT NULL,
    exercise_heart_rate INTEGER NOT NULL,
    body_fat_percentage FLOAT NOT NULL,
    muscle_mass FLOAT NOT NULL,
    water_intake FLOAT NOT NULL,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id)
);
INSERT INTO activities VALUES(1,1,30,'male',65.0,180.0,'running',45,'moderate',70,120,15.0,70.0,1.0,'2023-07-24 12:34:56');
INSERT INTO activities VALUES(2,1,30,'male',150.0,180.0,'running',45,'moderate',70,120,15.0,70.0,1.5,'2023-04-24 12:34:56');
INSERT INTO activities VALUES(3,1,30,'male',55.0,180.0,'running',45,'moderate',70,120,15.0,70.0,2.0,'2023-05-24 12:34:56');
INSERT INTO activities VALUES(4,1,30,'male',45.0,180.0,'running',45,'moderate',70,120,15.0,70.0,1.0,'2023-06-23 12:34:56');
CREATE TABLE contacts (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    message TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE articles (
    id INTEGER PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    category VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    image_path TEXT
);
INSERT INTO articles VALUES(1,'Tatkaar (Footwork)','Tatkaar is a foundational footwork pattern in Kathak where dancers tap their feet to rhythmic beats.','Tatkaar','2023-07-01 17:24:12','images/articles/Tatkaar.mp4');
INSERT INTO articles VALUES(2,'Basic Hand Positions','Learning mudras (hand gestures) like Pataka is essential in Kathak, as they express emotions and enhance the dance.','Hand Postures','2023-07-01 17:24:12','images/articles/Basic Hand Positions.mp4');
INSERT INTO articles VALUES(3,'Basic Postures','Learning mudras like Tripataka is essential in Kathak, as they express emotions and enhance the dance.','Basic Postures','2023-04-01 17:24:12','images/articles/Basic_Postures.mp4');
INSERT INTO articles VALUES(4,'Padhant (Rhythmic Syllables)','In Padhant, dancers practice rhythmic syllables, or bols-like "Ta Thai Thai" and "Dha Ti Na"-to synchronize and refine ','Padhant','2023-01-03 17:24:12','images/articles/Basic_Postures.mp4');
INSERT INTO articles VALUES(5,'Chakkar (Spin/Turns)','Chakkar (spin) is a key element of Kathak, but it’s important to first focus on basic balance and footwork before master...  ','Chakkar','2022-12-08 17:24:12','images/articles/Chakkars.mp4');
INSERT INTO articles VALUES(6,'Basic Postures II','Learning mudras like Tripataka is essential in Kathak, as they express emotions and enhance the dance. ','Basic_2','2022-12-07 17:24:12','images/articles/Basic_Postures.mp4');
INSERT INTO articles VALUES(7,'Chakkar-Spin/TurnsII','Chakkar (spin) is a key element of Kathak, but it’s important to first focus on basic balance and footwork before... ','Chakker-II','2022-11-14 17:24:12','images/articles/Chakkar (SpinTurns)_2.mp4');
INSERT INTO articles VALUES(8,'Basic Postures III','Learning mudras like Tripataka is essential in Kathak, as they express emotions and enhance the dance. ','Basic_3','2022-07-27 17:24:12','images/articles/Basic_Postures.mp4');
DELETE FROM sqlite_sequence;
INSERT INTO sqlite_sequence VALUES('users',1);
CREATE INDEX idx_users_username ON users (username);
CREATE INDEX idx_users_email ON users (email);
CREATE INDEX idx_workouts_category ON workouts (category);
CREATE INDEX idx_user_id ON activities (user_id);
COMMIT;
