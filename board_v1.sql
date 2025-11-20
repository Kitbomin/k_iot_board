drop database if exists board_v1;
create database if not exists board_v1
	character set utf8mb4
    collate utf8mb4_general_ci;

use board_v1;

SET NAMES utf8mb4;				-- 클라이언트와 MySQL 서버 간의 문자 인코딩 설정 
SET FOREIGN_KEY_CHECKS = 0;		-- 외래키 제약조건 검사를 일시적으로 끄는 설정

# 기존 테이블 제거
DROP TABLE IF EXISTS post_files;
DROP TABLE IF EXISTS file_infos;

DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS board_likes;
DROP TABLE IF EXISTS board_drafts;
DROP TABLE IF EXISTS boards;
DROP TABLE IF EXISTS board_categories;

DROP TABLE IF EXISTS refresh_tokens;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS users;

# === File_Info (파일 정보 테이블) === #
create table if not exists file_infos(
	id bigint auto_increment primary key,
    
    original_name varchar(255) not null comment '원본 파일명',
    stored_name varchar(255) not null comment 'UUID가 적용된 파일명',	-- UUID: 고유 식별 번호
    content_type varchar(255),
    file_size bigint,
    file_path varchar(255) not null comment '서버 내 실제 경로',
    
    created_at datetime(6) not null default current_timestamp(6)
    
)engine=InnoDB default charset = utf8mb4 collate = utf8mb4_unicode_ci comment = '파일 정보 테이블';



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
    profile_file_id bigint null comment '프로필 이미지 파일 ID',
    
    created_at datetime(6) not null default current_timestamp(6),
    updated_at datetime(6) not null default current_timestamp(6) on update current_timestamp(6),
    
    constraint `uk_users_username` unique(username),
    constraint `uk_users_email` unique(email),
    constraint `uk_users_nickname` unique(nickname),
    constraint `chk_users_gender` check(gender in ('MALE', 'FEMAIL', 'NONE', 'OTHER')),
    constraint `fk_users_profile_file` foreign key (profile_file_id) references file_infos(id) on delete set null -- 파일 이미지가 삭제 되어도 null 값 유지 해라 -> 유저 건들지 말라는 뜻
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


# === board_Files(게시글 파일 매핑) === #
create table board_files(
	id bigint auto_increment primary key,
	
    board_id bigint not null,
    file_id bigint not null,
    
    display_order int default 0, 	-- 대표이미지 고려
    
    constraint `fk_board_files_board` foreign key (board_id) references boards(id) on delete cascade,
    constraint `fk_board_files_file_info` foreign key (file_id) references file_infos(id) on delete cascade
    
)engine=InnoDB default charset = utf8mb4 collate = utf8mb4_unicode_ci comment = '게시글 파일 매핑 테이블';




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

create table board_drafts (
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