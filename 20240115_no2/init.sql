CREATE DATABASE todoDB;

USE todoDB;

CREATE TABLE `user`
(
    `USER_ID`    int unsigned NOT NULL AUTO_INCREMENT COMMENT 'ユーザID',
    `NAME`       varchar(255) NOT NULL COMMENT 'ユーザ名',
    `EMAIL`      varchar(255) NOT NULL COMMENT 'メールアドレス',
    `PASSWORD`   varchar(255) NOT NULL COMMENT 'パスワード',
    `CREATED_AT` datetime DEFAULT NULL COMMENT '作成日時',
    `UPDATED_AT` datetime DEFAULT NULL COMMENT '更新日時',
    PRIMARY KEY (`USER_ID`),
    UNIQUE KEY `idx_uniq_email` (`EMAIL`)
) ENGINE=InnoDB CHARSET=utf8;

CREATE TABLE `todo`
(
    `TODO_ID`     int unsigned NOT NULL AUTO_INCREMENT COMMENT 'TODO ID',
    `USER_ID`     int unsigned NOT NULL COMMENT 'ユーザID',
    `TITLE`       varchar(50) NOT NULL COMMENT 'タイトル',
    `DISCRIPTION` varchar(100) DEFAULT NULL COMMENT '説明文',
    `STATUS`      tinyint     NOT NULL COMMENT 'ステータス',
    `CREATED_AT`  datetime     DEFAULT NULL COMMENT '作成日時',
    `UPDATED_AT`  datetime     DEFAULT NULL COMMENT '更新日時',
    PRIMARY KEY (`TODO_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert user(name,email,password,created_at,updated_at)
values( 'matsui' ,'matsui@example.com' , 'password' , now(), now())

insert user(name,email,password,created_at,updated_at)
select 'matsui'
     , concat('matsui', ceil(rand() * 1000000), ceil(rand() * 1000000), '@example.com')
     , 'password'
     , addtime(now() + interval rand(now())* - 362 day, '00:00:00')
     , addtime(now() + interval rand(now())* - 365 day, '00:00:00')
from user
         cross join (select * from user) tmp_u limit 100000;

insert into todo (user_id, title, discription, status, created_at, updated_at)
select user.user_id
     , 'タイトル'
     , '説明'
     , ceil(rand() * 3)
     , addtime(now() + interval rand(now())* -362 day, '00:00:00')
     , addtime(now() + interval rand(now())* -365 day, '00:00:00')
from user
         cross join (select * from user limit 100) tmp_100;
