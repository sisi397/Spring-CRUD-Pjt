   
create table board (
    no number,
    title varchar2(100) not null,
    name varchar2(20) not null,
    content clob not null,
    regdate date default sysdate,
    readcount number default 0,
    password varchar2(128) not null
);

create sequence board_no_seq;
alter table board add constraint pk_board primary key(no);
alter table board add constraint fk_board_users foreign key (name) references users(username);

create table comments (
    cno number(10,0),
    bno number(10, 0) not null,
    comments varchar2(1000) not null,
    name varchar2(50) not null,
    regDate date default sysdate,
    updateDate date default sysdate
    );

create sequence seq_comments;
alter table comments add constraint pk_comments primary key(cno);
alter table comments add constraint fk_comments_board foreign key (bno) references board(no) on delete cascade;

create table attach(
    uuid varchar2(100) not null,
    uploadPath varchar2(200) not null,
    fileName varchar2(100) not null,
    filetype number(1) default 0,
    bno number(10, 0) not null
);

alter table attach add constraint pk_attach primary key(uuid);
alter table attach add constraint fk_board_attach foreign key (bno) references board(no) on delete cascade;

create table search(
    sno number(10,0) not null,
    keyword varchar2(200) not null,
    scount number(10,0) not null,
    regDate date default sysdate
    );
create sequence seq_search;
alter table search add constraint pk_search primary key(sno);

create table users(
    username varchar2(50) not null primary key,
    password varchar2(50) not null,
    enabled char(1) default '1');
create table authorities(
    username varchar2(50) not null,
    authority varchar2(50) not null,
    constraint fk_authorities_users foreign key(username) references users(username));