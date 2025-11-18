drop database if exists board_v1;
create database if not exists board_v1
	character set utf8mb4
    collate utf8mb4_general_ci;

use board_v1;

SET NAMES utf8mb4;				-- 클라이언트와 MySQL 서버 간의 문자 인코딩 설정 
SET FOREIGN_KEY_CHECKS = 0;		-- 외래키 제약조건 검사를 일시적으로 끄는 설정

# === USERS (사용자) === #
drop table if exists user_roles;
drop table if exists roles;
drop table if exists refresh_tokens;
drop table if exists users;

create table if not exists users (
	id bigint auto_increment primary key,
    
    username varchar(50) not null comment '로그인 ID',
    password varchar(255) not null comment 'Bcrypt 암호화 비밀번호',
    email varchar(255) not null comment 'users email',
    nickname varchar(50) not null comment 'nickname',
    
    gender varchar(10) comment '성별',
    
    created_at datetime(6) not null default current_timestamp(6),
    updated_at datetime(6) not null default current_timestamp(6) on update current_timestamp(6),
    
    constraint `uk_users_username` unique(username),
    constraint `uk_users_email` unique(email),
    constraint `uk_users_nickname` unique(nickname),
    constraint `chk_users_gender` check(gender in ('MALE', 'FEMAIL', 'NONE', 'OTHER'))
) engine=InnoDB default charset = utf8mb4 collate = utf8mb4_unicode_ci comment = '사용자';

create table if not exists roles (
	role_name varchar(30) not null primary key,
    
    constraint `chk_roles_role_name` check(role_name in ('ROLE_USER', 'ROLE_ADMIN', 'ROLE_MANAGER'))
)engine=InnoDB default charset = utf8mb4 collate = utf8mb4_unicode_ci comment = '권한';

create table if not exists user_roles (
	id bigint auto_increment primary key,
    
    user_id bigint not null,
    role_name varchar(30) not null,
    
    unique key `uk_user_roles_user_id_role_name` (user_id, role_name),
    index `idx_user_roles_user_id` (user_id),
    index `idx_user_roles_role_name` (role_name),
    
    constraint `fk_user_role_user` foreign key (user_id) references users(id),
    constraint `fk_user_role_role` foreign key (role_name) references roles(role_name)
)engine=InnoDB default charset = utf8mb4 collate = utf8mb4_unicode_ci comment = '유저-권한 매핑 테이블';

create table if not exists refresh_tokens (
	id bigint auto_increment primary key,
    
    user_id bigint not null unique comment '사용자 ID',
    token varchar(350) not null comment'refresh Token 값',
    expiry datetime(6) not null comment '만료 시간',
    
    created_at datetime(6) not null default current_timestamp(6),
    updated_at datetime(6) not null default current_timestamp(6) on update current_timestamp(6),
    
    index `idx_refresh_token_user_id` (user_id),
    constraint `fk_refresh_token_user` foreign key (user_id) references users(id)
)engine=InnoDB default charset = utf8mb4 collate = utf8mb4_unicode_ci comment = '리프레시토큰 저장 테이블';

drop table if exists boards;
drop table if exists board_categories;
drop table if exists comments;
drop table if exists board_likes;
drop table if exists board_draft;

create table board_categories (
	id bigint auto_increment primary key,
    
    name varchar(50) not null comment '카테고리 명',
    
    created_at datetime(6) not null default current_timestamp(6),
    updated_at datetime(6) not null default current_timestamp(6) on update current_timestamp(6),
    
    constraint `uk_board_category_name` unique (name)
)engine=InnoDB default charset = utf8mb4 collate = utf8mb4_unicode_ci comment = '카테고리';

create table boards (
	id bigint auto_increment primary key,
    
    title varchar(150) not null comment '제목',
    content longtext not null comment '내용',
    
    view_count bigint not null default 0 comment '조회수',
    is_pinned boolean not null default false comment '상단 고정 여부',
    
    user_id bigint not null comment '작성자',
    category_id bigint not null comment '카테고리 ID',
    
    created_at datetime(6) not null default current_timestamp(6),
    updated_at datetime(6) not null default current_timestamp(6) on update current_timestamp(6),
    
    index `idx_boards_created_at` (created_at),
    index `idx_boards_updated_at` (updated_at),
    
    constraint `fk_board_user` foreign key (user_id) references users(id),
    constraint `fk_board_category` foreign key (category_id) references board_categories(id)
)engine=InnoDB default charset = utf8mb4 collate = utf8mb4_unicode_ci comment = '게시판';


create table comments (
	id bigint auto_increment primary key,
    content longtext not null comment '댓글 본문',
    
    board_id bigint not null comment '게시글 ID',
    user_id bigint not null comment '작성자 ID',
    
    created_at datetime(6) not null default current_timestamp(6),
    updated_at datetime(6) not null default current_timestamp(6) on update current_timestamp(6),
    
    index `idx_comments_board_id` (board_id),
    index `idx_comments_user_id` (user_id),
    
    constraint `fk_comment_board` foreign key (board_id) references boards(id),
    constraint `fk_comment_user` foreign key (user_id) references users(id)
)engine=InnoDB default charset = utf8mb4 collate = utf8mb4_unicode_ci comment = '게시글 댓글';

create table board_likes (
	id bigint auto_increment primary key,
    
    board_id bigint not null comment '게시글 ID',
    user_id bigint not null comment '유저 ID',
    
    created_at datetime(6) not null default current_timestamp(6),
    updated_at datetime(6) not null default current_timestamp(6) on update current_timestamp(6),
    
    unique key `uk_board_like_user` (board_id, user_id),
    
    index `idx_board_like_board` (board_id),
    index `idx_board_like_user` (user_id),
    
    constraint `fk_board_like_board` foreign key (board_id) references boards(id),
    constraint `fk_board_like_user` foreign key (user_id) references users(id)
)engine=InnoDB default charset = utf8mb4 collate = utf8mb4_unicode_ci comment = '게시글 좋아요';

create table board_draft (
	id bigint auto_increment primary key,
    
    title varchar(150) null comment '임시 제목',
    content longtext null comment '임시 내용',
    
    user_id bigint not null comment '유저 ID',
    
    created_at datetime(6) not null default current_timestamp(6),
    updated_at datetime(6) not null default current_timestamp(6) on update current_timestamp(6),
    
    index `idx_board_drafts_user_id` (user_id),
    index `idx_board_draft_updated_at` (updated_at),
    
    constraint `fk_board_draft_user` foreign key (user_id) references users(id)
)engine=InnoDB default charset = utf8mb4 collate = utf8mb4_unicode_ci comment = '게시글 임시 저장';











SET FOREIGN_KEY_CHECKS = 1;