--Java에서 처음으로 JDBC 프로그래밍 해보기
--우선 system 계정으로 연결 후 새 실습계정 생성
alter session set "_ORACLE_SCRIPT"=true;
create user education identified by 1234;
grant connect, resource, unlimited tablespace to education;
create table member (
    id varchar2(30) not null,
    pass varchar2(40) not null,
    name varchar2(50) not null,
    regidate date default sysdate,
    primary key (id)    );
insert into member (id, pass, name) values ('test', 1234, '테스트');
commit;

insert into member (id, pass, name) values ('test9', 9999, '테스트9');
commit;
--HR계정연결후 다음 쿼리문 실행
select * from employees where department_id=50 order by employee_id desc;

------------------------------------------------------------------------------
--JDBC > CallableStatement 인터페이스 사용하기
--education 계정 에서 실습
select substr('hongildong', 1, 1) from dual;
select rpad('h', 10, '*') from dual;
select rpad(substr('hongildong', 1, 1), length('hongildong'), '*') from dual;

/* 예제1-1] 함수 : fillAsterik()
시나리오] 매개변수로 회원아이디(String)을 받으면 첫문자 제외한 나머지 부분을 *로 변환하는 함수를 생성하시오
예) oracle21c -> 0********    */
create or replace function fillAsterik (id varchar2)
return varchar2 
is st varchar2(30); 
begin
    st := rpad(substr(id, 1, 1), length(id), '*');
    return st;
end;
/
select fillAsterik('Nancy') from dual;
select fillAsterik(id) from member;

/* 예제2-1] 프로시저 : MyMemberInsert()
시나리오] member 테이블에 새로운 회원정보를 입력하는 프로시저를 생성하시오
    파라미터 : In => 아이디, 패스워드, 이름     Out => returnVal(성공:1, 실패:0) */
create or replace procedure MyMemberInsert 
    (id in varchar2, pw in varchar2, name in varchar2, rval out number)
is 
begin
    insert into member (id, pass, name) values (id, pw, name);
    if sql%found then --입력정상처리시 true반환
        rval := sql%rowcount; --입력성공한 행갯수 얻어와 out파라미터에 저장
        commit; --행변화생기므로 반드시 commit해야한다
    else rval := 0; --실패시 0반환
    end if;
end;
/
var res varchar2;
execute MyMemberInsert('pro02', '1234', '프로시저1', :res);
execute MyMemberInsert('pro03', '1234', '프로시저2', :res);
execute MyMemberInsert('pro04', '1234', '프로시저4', :res);
print res;

/* 예제3-1] 프로시저 : MyMemberDelete()
시나리오] member테이블에서 레코드를 삭제하는 프로시저를 생성하시오
    파라미터 : In => member_id(아이디)    Out => returnVal(SUCCESS/FAIL 반환) */
create or replace procedure MyMemberDelete (mid in varchar2, rval out varchar2)
is 
begin
    delete from member where id=mid;
    if sql%found then 
        rval := 'SUCCESS'; --회원레코드가 정삭삭제시 실행, 커밋한다. 
        commit; 
    else rval := 'FAIL'; 
    end if;
end;
/
var res2 varchar2(20);
execute MyMemberDelete('pro05', :res2);
execute MyMemberDelete('test99', :res2);
print res2;

/* 예제4-1] 프로시저 : MyMemberAuth()
시나리오] 아이디와 패스워드를 매개변수로 전달받아서 회원인지 여부를 판단하는 프로시저를 작성하시오. 
    매개변수 : In -> user_id, user_pass,    Out -> returnVal
    반환값 : 
        0 -> 회원인증실패(둘다틀림)
        1 -> 아이디는 일치하나 패스워드가 틀린경우
        2 -> 아이디/패스워드 모두 일치하여 회원인증 성공  */
create or replace procedure MyMemberAuth (uid in varchar2, upw in varchar2, rval out number)
is
    mcnt number(1) := 0; --count(*)로 반환되는값 저장
    mpw varchar2(30); --테이블에서 입력한 아이디와 일치하는 레코드중 비번 저장할 변수
begin
    select count(*) into mcnt from member where id=uid;
    if mcnt=1 then --회원아이디가 존재하는경우라면
        select pass into mpw from member where id=uid; --패스워드확인위해 두번째쿼리실행
        if mpw=upw then rval := 2; --인파라미터로 전달된 비번과 DB에서 가져온 비번 비교
        else rval := 1; --아이디만 일치한경우
        end if;
    else rval := 0; --아이디가 일치하지않는경우
    end if;
end;
/
var res_auth varchar2(1);
execute MyMemberAuth('pro07', '1234', :res_auth);
execute MyMemberAuth('pro07', '1111', :res_auth);
execute MyMemberAuth('pro08', '1111', :res_auth);
print res_auth;

---------------------------------------------------------------------
--JSP 웹프로그래밍 실습 / musthave 계정사용
---------------------------------------------------------------------
alter session set "_oracle_script"=true;
create user musthave identified by 1234;
grant connect, resource, unlimited tablespace to musthave;

select * from tab;
drop table member;
create table member(
    id varchar2(10) primary key,
    pw varchar2(10) not null,
    name varchar2(10) not null,
    regidate date default sysdate not null
);
alter table member modify (id varchar2(30), pw varchar2(30), name varchar2(30));
create table board(
    num number primary key,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    id varchar2(10) not null,
    postdate date default sysdate not null,
    visitcnt number(6),
    foreign key(id) references member(id)
);
create sequence seq_board_num
    increment by 1
    start with 1
    minvalue 1
    nomaxvalue
    nocycle
    nocache;
insert into member (id, pw, name) values ('musthave', '1234', '머스트해브');
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '제목1입니다', '내용1입니다', 'musthave', sysdate, 0);
commit;
insert into member (id, pw, name) values ('siwool', '1234', '강시울');
insert into member (id, pw, name) values ('test', '1234', '테스트회원');
commit;
---------------------------------------------------------------------
--모델1 방식의 회원제 게시판 제작하기 : 회원케이블인 member와 게시판테이블인 board 사용
---------------------------------------------------------------------
--게시판목록 및 검색위한 더미데이터 추가
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '지금은 봄입니다.', '봄의왈츠', 'musthave', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '지금은 여름입니다.', '여름향기', 'musthave', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '지금은 가을입니다.', '가을동화', 'musthave', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '지금은 겨울입니다.', '겨울연가', 'musthave', sysdate, 0);
commit;

--게시판 목록 구현하기
--1. 게시물 갯수 카운트
select count(*) from board;
--검색기능 추가위해 where절 추가 > 검색조건 만족하는 게시물 개수 카운트
select count(*) from board where title like '%여름%' or content like '%여름%';
--2. 출력할 게시물 출력하기
--게시판 목록은 최근 작성 게시물이 상단에 출력돼야하므로 일련번호를 내림차순정렬하여 출력
select * from board where title like '%지금%' order by num desc;

--과제용 테이블 생성 및 더미데이터 추가
create table member2(
    id varchar2(30) primary key,
    pw varchar2(30) not null,
    name varchar2(30) not null,
    email varchar2(60) not null,
    emailok varchar2(20) check(emailok in ('yes', 'no')),
    add1 number(10),
    add2 varchar2(100),
    add3 varchar2(100),
    phone varchar2(30) not null,
    smsok varchar2(20) check(smsok in ('yes', 'no')),
    regidate date default sysdate not null
);
alter table member2 modify add1 varchar(10);
insert into member2 values 
('siwool', '1234', '강시울', 'siwool123@navr.com', 'no', '02452', '서울시 동대문구 이문로 37', '1421호', '01056371055', 'no', sysdate);

--게시판 글쓰기 구현하기 
/* board테이블의 id컬럼은 not null로 지정되어있어 값입력되지않으면 제약조건위배로 에러발생
  tjoeun 이란 아이디는 부모테이블의meember에 없는 레코드이므로 외래키 제약조건에 위배되어 에러발생 */
insert into board (num, title, content, postdate, visitcnt) values 
    (seq_board_num.nextval, '지금은 봄입니다.', '봄의왈츠', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '지금은 봄입니다.', '봄의왈츠', 'tjoeun', sysdate, 0);
update board set id='test2' where title='제목 테스트';
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '나는 테스트입니다.', '나는 테스트입니다.', 'test', sysdate, 0);
    
--게시판 내용보기구현
/* 내용보기 페이지에서는 작성핮의 이름을 출력하기위해 member 테이브로가 inner join통해 쿼리문 작성 */
select * from board natural join member where num=1;
select b.*, m.name from board b, member m where b.id=m.id and num=1;

--내용보기하면 해당게시물 조회수가 1증가한다.
update board set visitcnt=visitcnt+1 where num=1;

--게시물 수정하기
update board set title='제목1 수정', content='내용1 수정' where num=1;

--게시물 삭제하기
delete from board where num=1;
commit;
-----------------------------------게시판 페이징 구현하기----------------------------------------
select * from board where title like '%지금%' order by num desc;
select rownum, t1.* from (select * from board where title like '%페이징%' order by num desc) t1;
select * from (select rownum, t1.* from (select * from board where title like '%페이징%' order by num desc) t1) 
    where rownum between 1 and 10; --1페이지
    
select rownum, t1.* from (select * from board order by num desc) t1; 

select * from (select rownum r, t1.* from (select * from board order by num desc) t1) where r between 11 and 20; 
--2페이지
select * from (select rownum r, t1.* from (select * from board where title like '%게시물-3%'
    order by num desc) t1) where r between 11 and 20;

select sal, empno, sum(sal) from emp group by grouping sets(sal, (sal, empno), ()) order by sal;

-----------------------------------아이디 중복 확인하기----------------------------------------
select * from member where id='aaaaa123';

--barovone 회원 테이블 만들기
create table member3(
    id varchar2(30) primary key,
    pw varchar2(30) not null,
    name varchar2(30) not null,
    email varchar2(60) not null,
    phone varchar2(30) not null,
    birthdate date not null,
    add1 varchar2(10),
    add2 varchar2(100),
    add3 varchar2(100),
    married varchar2(3),
    inter1 varchar2(30),
    inter2 varchar2(30),
    regidate date default sysdate not null
);
insert into member3 values 
('siwool123', '12341234', '강이화', 'siwool12321@gmail.com', '01056371055', '19840412', 
'02452', '서울시 동대문구 이문로 37', '1421호', 'n', '종교', '불교', sysdate);
commit;

--------파일업로드 구현하기
create table myfile(
    idx number primary key,
    title varchar2(200) not null,
    cate varchar2(100),
    ofile varchar2(100) not null,
    sfile varchar2(30) not null,
    postdate date default sysdate not null
);
insert into myfile values ();
----------모델2방식의 파일첨부형 게시판 테이블 생성
create table mvcboard(
    idx number primary key,
    name varchar2(30) not null,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    postdate date default sysdate not null,
    ofile varchar2(100) not null,
    sfile varchar2(30) not null,
    downcnt number(5) default 0 not null,
    pw varchar2(30) not null,
    visitcnt number default 0 not null
);
drop table mvcboard;
create table mvcboard(
    idx number primary key,
    name varchar2(30) not null,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    postdate date default sysdate not null,
    ofile varchar2(100), --원본파일명
    sfile varchar2(30), --서버에 저장파일명
    downcnt number(5) default 0 not null, --파일다운로드횟수
    pw varchar2(30) not null,
    visitcnt number default 0 not null
);
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
commit;
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
commit;
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
commit;
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
commit;


    
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');
commit;
---------DB와 연동하여 관심분야 2단 셀렉트박스 구현위한 테이블작성
create table etc1 (etc1_code varchar2(50) not null, etc1_name varchar2(50) not null);
create table etc2 (etc2_code varchar2(50) not null, etc2_name varchar2(50));
insert into etc1 values ('Literature', '문학');
insert into etc1 values ('Economy', '경제/경영');
insert into etc1 values ('Human', '인문');
insert into etc1 values ('Art', '예술/대중문화');
insert into etc1 values ('Religion', '종교');
insert into etc1 values ('History', '역사');
insert into etc1 values ('People', '인물');
insert into etc1 values ('Society', '사회');
insert into etc1 values ('Science', '과학');
insert into etc1 values ('Kid', '어린이');
insert into etc1 values ('Study', '학습/참고서');
insert into etc1 values ('Exam', '수험서/자격증');
insert into etc1 values ('Computer', '컴퓨터/인터넷');
insert into etc1 values ('Magazine', '잡지');
insert into etc1 values ('Textbook', '대학교재');
insert into etc1 values ('Life', '가정/건강/생활');
insert into etc1 values ('Language', '외국어/어학');
insert into etc1 values ('Dictionary', '사전');
insert into etc1 values ('Foreign', '외국도서');

insert into etc2 values ('Literature', '한국소설');
insert into etc2 values ('Literature', '외국소설');
insert into etc2 values ('Literature', '한국에세이');
insert into etc2 values ('Literature', '외국에세이');
insert into etc2 values ('Literature', '장르문학');
insert into etc2 values ('Literature', '고전문학/신화');
insert into etc2 values ('Literature', '시');
insert into etc2 values ('Literature', '희곡/시나리오');
insert into etc2 values ('Literature', '문학이론/비평');
insert into etc2 values ('Economy', '경영');
insert into etc2 values ('Economy', '경제');
insert into etc2 values ('Economy', '마케팅/세일즈');
insert into etc2 values ('Economy', '재테크/투자');
insert into etc2 values ('Economy', '창업/취업');
insert into etc2 values ('Economy', 'CEO/리더쉽');
insert into etc2 values ('Economy', '자기관리');
insert into etc2 values ('Human', '인문교양');
insert into etc2 values ('Human', '철학');
insert into etc2 values ('Human', '언어학/기호학');
insert into etc2 values ('Human', '심리학');
insert into etc2 values ('Human', '출판/도서/창작');
insert into etc2 values ('Human', '신화학');
insert into etc2 values ('Human', '문명/고고학');
insert into etc2 values ('Art', '예술의이해');
insert into etc2 values ('Art', '미술');
insert into etc2 values ('Art', '음악');
insert into etc2 values ('Art', '사진');
insert into etc2 values ('Art', '영화/연극');
insert into etc2 values ('Art', '무용/뮤지컬');
insert into etc2 values ('Art', '건축/디자인');
insert into etc2 values ('Art', '대중문화');
insert into etc2 values ('Religion', '종교학');
insert into etc2 values ('Religion', '기독교');
insert into etc2 values ('Religion', '가톨릭');
insert into etc2 values ('Religion', '불교');
insert into etc2 values ('Religion', '세계종교');
insert into etc2 values ('Religion', '역학');
insert into etc2 values ('History', '역사학');
insert into etc2 values ('History', '한국사');
insert into etc2 values ('History', '서양사');
insert into etc2 values ('History', '동양사');
insert into etc2 values ('History', '주제별역사');
insert into etc2 values ('People', '종교인');
insert into etc2 values ('People', '사회운동가/혁명가');
insert into etc2 values ('People', '여러인물이야기');
insert into etc2 values ('People', '철학자/사상가');
insert into etc2 values ('People', '과학자/의료인');
insert into etc2 values ('People', '교육자');
insert into etc2 values ('People', '여성인물');
insert into etc2 values ('People', '경영/기업가');
insert into etc2 values ('People', '자서전');
insert into etc2 values ('People', '예술가');
insert into etc2 values ('People', '정치인/군인');
insert into etc2 values ('People', '연예인/운동선수');
insert into etc2 values ('People', '언론인');
insert into etc2 values ('People', '인물기타');
insert into etc2 values ('Society', '사회학');
insert into etc2 values ('Society', '행정학');
insert into etc2 values ('Society', '교육학');
insert into etc2 values ('Society', '정치/외교학');
insert into etc2 values ('Society', '법학');
insert into etc2 values ('Society', '통계학');
insert into etc2 values ('Society', '언론/미디어');
insert into etc2 values ('Society', '여성학');
insert into etc2 values ('Society', '지리학');
insert into etc2 values ('Society', '환경/생태');
insert into etc2 values ('Society', '사회사상');
insert into etc2 values ('Society', '국방/군사학');
insert into etc2 values ('Science', '과학의이해');
insert into etc2 values ('Science', '물리');
insert into etc2 values ('Science', '화학');
insert into etc2 values ('Science', '생명과학');
insert into etc2 values ('Science', '천문학');
insert into etc2 values ('Science', '수학');
insert into etc2 values ('Science', '지구과학');
insert into etc2 values ('Science', '의학/간호학');
insert into etc2 values ('Science', '농업/임학');
insert into etc2 values ('Science', '기술공학');
insert into etc2 values ('Kid', '초등1~2');
insert into etc2 values ('Kid', '초등3~4');
insert into etc2 values ('Kid', '초등5~6');
insert into etc2 values ('Kid', '한국동화');
insert into etc2 values ('Kid', '외국동화');
insert into etc2 values ('Kid', '동요/동시');
insert into etc2 values ('Kid', '어린이학습');
insert into etc2 values ('Kid', '어린이만화');
insert into etc2 values ('Kid', '어린이취미/놀이');
insert into etc2 values ('Kid', '세트/전집');
insert into etc2 values ('Study', '초등1학년');
insert into etc2 values ('Study', '초등2학년');
insert into etc2 values ('Study', '초등3학년');
insert into etc2 values ('Study', '초등4학년');
insert into etc2 values ('Study', '초등5학년');
insert into etc2 values ('Study', '초등6학년');
insert into etc2 values ('Study', '초등종합참고서');
insert into etc2 values ('Study', '중학1학년');
insert into etc2 values ('Study', '중학2학년');
insert into etc2 values ('Study', '중학3학년');
insert into etc2 values ('Study', '중학종합참고서');
insert into etc2 values ('Study', '고등1학년');
insert into etc2 values ('Study', '고등2학년');
insert into etc2 values ('Study', '고등3학년');
insert into etc2 values ('Study', '고등문제집');
insert into etc2 values ('Study', '고등자습서');
insert into etc2 values ('Study', '수능영역별');
insert into etc2 values ('Study', '고등영어종합');
insert into etc2 values ('Study', 'EBS교육방송');
insert into etc2 values ('Study', '대입/논술과면접');
insert into etc2 values ('Exam', '국가고시');
insert into etc2 values ('Exam', '공무원');
insert into etc2 values ('Exam', '임용고시');
insert into etc2 values ('Exam', '편입/검정/독학사');
insert into etc2 values ('Exam', '공인중개사/주택관리사');
insert into etc2 values ('Exam', '금융/경제/물류');
insert into etc2 values ('Exam', '보건/위생/의학');
insert into etc2 values ('Exam', '법무/사회');
insert into etc2 values ('Exam', '취업/상식/적성검사');
insert into etc2 values ('Exam', '운전/관광');
insert into etc2 values ('Exam', '전자/전기');
insert into etc2 values ('Exam', '건축/토목/기계');
insert into etc2 values ('Exam', '가스/안전/환경');
insert into etc2 values ('Exam', '음식/미용');
insert into etc2 values ('Exam', '컴퓨터/IT');
insert into etc2 values ('Exam', '한자');
insert into etc2 values ('Exam', '기타');
insert into etc2 values ('Computer', '게임/디카/입문/활용');
insert into etc2 values ('Computer', 'OS/Networking');
insert into etc2 values ('Computer', 'e비즈니스/창업');
insert into etc2 values ('Computer', '오피스활용');
insert into etc2 values ('Computer', '홈페이지/웹');
insert into etc2 values ('Computer', '컴퓨터공학');
insert into etc2 values ('Computer', '프로그래밍언어');
insert into etc2 values ('Computer', '그래픽/멀티미디어');
insert into etc2 values ('Computer', '프로그래밍 개발/방법론');
insert into etc2 values ('Magazine', '가정/육아');
insert into etc2 values ('Magazine', '경제/경영');
insert into etc2 values ('Magazine', '요리/건강');
insert into etc2 values ('Magazine', '여성/남성/패션');
insert into etc2 values ('Magazine', '여행/취미/스포츠');
insert into etc2 values ('Magazine', '연예/영화');
insert into etc2 values ('Magazine', '교양');
insert into etc2 values ('Magazine', '문화/예술');
insert into etc2 values ('Magazine', '자동차/과학/기술');
insert into etc2 values ('Magazine', '컴퓨터/게임/그래픽');
insert into etc2 values ('Magazine', '성인지(19+)');
insert into etc2 values ('Magazine', '수험/어학교재');
insert into etc2 values ('Magazine', '만화/애니메이션');
insert into etc2 values ('Magazine', '시사');
insert into etc2 values ('Magazine', '종교');
insert into etc2 values ('Magazine', '다이어리/달력');
insert into etc2 values ('Magazine', '사회과학');
insert into etc2 values ('Textbook', '경상계열');
insert into etc2 values ('Textbook', '공학계열');
insert into etc2 values ('Textbook', '자연과학계열');
insert into etc2 values ('Textbook', '의약간호계열');
insert into etc2 values ('Textbook', '농축산학계열');
insert into etc2 values ('Textbook', '법학계열');
insert into etc2 values ('Textbook', '사범계열');
insert into etc2 values ('Textbook', '사회과학계열');
insert into etc2 values ('Textbook', '인문계열');
insert into etc2 values ('Textbook', '어문학계열');
insert into etc2 values ('Textbook', '예체능계열');
insert into etc2 values ('Textbook', '생활환경계열');
insert into etc2 values ('Life', '가정생활');
insert into etc2 values ('Life', '만화/애니메이션');
insert into etc2 values ('Life', '요리');
insert into etc2 values ('Life', '육아');
insert into etc2 values ('Life', '임신/출산/태교');
insert into etc2 values ('Life', '인테리어/주거환경');
insert into etc2 values ('Life', '건강/다이어트/미용');
insert into etc2 values ('Life', '질병과예방');
insert into etc2 values ('Life', '패션/수공예');
insert into etc2 values ('Life', '자녀교육');
insert into etc2 values ('Language', '영어');
insert into etc2 values ('Language', '일본어');
insert into etc2 values ('Language', '중국어');
insert into etc2 values ('Language', '한문/한국어');
insert into etc2 values ('Language', '독일어/프랑스어/스페인어');
insert into etc2 values ('Language', '기타외국어');
insert into etc2 values ('Dictionary', '국어사전');
insert into etc2 values ('Dictionary', '중국어/한자/옥편');
insert into etc2 values ('Dictionary', '영어사전');
insert into etc2 values ('Dictionary', '일어사전');
insert into etc2 values ('Dictionary', '독일어');
insert into etc2 values ('Dictionary', '스페인어');
insert into etc2 values ('Dictionary', '프랑스어');
insert into etc2 values ('Dictionary', '기타외국어');
insert into etc2 values ('Dictionary', '백과/연감');
insert into etc2 values ('Dictionary', '전문사전');
insert into etc2 values ('Foreign', '문학');
insert into etc2 values ('Foreign', '유아/어린이');
insert into etc2 values ('Foreign', 'ELT/사전');
insert into etc2 values ('Foreign', '경제/경영');
insert into etc2 values ('Foreign', '실용');
insert into etc2 values ('Foreign', '예술/디자인');
insert into etc2 values ('Foreign', '컴퓨터/기술');
insert into etc2 values ('Foreign', '잡지');
insert into etc2 values ('Foreign', '베스트');
commit;
select * from etc1, etc2 where etc1.etc1_code=etc2.etc2_code and etc2_code='Literature';
select * from mvcboard where idx='436';
alter table member3 add subscription varchar2(10);
alter table member3 add smsok varchar2(3);
alter table member3 rename column subscription to mailok;
alter table member3 modify mailok varchar2(3);
------------------------- 3차 프로젝트 - 웹사이트 만들기 : 관리자계정생성, 회원테이블생성
alter session set "_ORACLE_SCRIPT"=true;
create user sua_project identified by 1234;
grant connect, resource, unlimited tablespace to sua_project;
create table member(
    id varchar2(30) primary key,
    pw varchar2(30) not null,
    name varchar2(30) not null,
    email varchar2(60) not null,
    emailok varchar2(3) check(emailok in ('y', 'n')),
    phone varchar2(30) not null,
    add1 number(10),
    add2 varchar2(100),
    add3 varchar2(100),
    regidate date default sysdate not null
);
insert into member values 
('siwool123', '12341234', '강시울', 'siwool123@navr.com', null, '01056371055', '02452', '서울시 동대문구 이문로 37', '1421호', sysdate);
select * from member where id='siwool123' and pw='12341234';
alter table member modify add1 varchar2(6);
update member set add1 = '02452';
