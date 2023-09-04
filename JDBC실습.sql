--Java���� ó������ JDBC ���α׷��� �غ���
--�켱 system �������� ���� �� �� �ǽ����� ����
alter session set "_ORACLE_SCRIPT"=true;
create user education identified by 1234;
grant connect, resource, unlimited tablespace to education;
create table member (
    id varchar2(30) not null,
    pass varchar2(40) not null,
    name varchar2(50) not null,
    regidate date default sysdate,
    primary key (id)    );
insert into member (id, pass, name) values ('test', 1234, '�׽�Ʈ');
commit;

insert into member (id, pass, name) values ('test9', 9999, '�׽�Ʈ9');
commit;
--HR���������� ���� ������ ����
select * from employees where department_id=50 order by employee_id desc;

------------------------------------------------------------------------------
--JDBC > CallableStatement �������̽� ����ϱ�
--education ���� ���� �ǽ�
select substr('hongildong', 1, 1) from dual;
select rpad('h', 10, '*') from dual;
select rpad(substr('hongildong', 1, 1), length('hongildong'), '*') from dual;

/* ����1-1] �Լ� : fillAsterik()
�ó�����] �Ű������� ȸ�����̵�(String)�� ������ ù���� ������ ������ �κ��� *�� ��ȯ�ϴ� �Լ��� �����Ͻÿ�
��) oracle21c -> 0********    */
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

/* ����2-1] ���ν��� : MyMemberInsert()
�ó�����] member ���̺� ���ο� ȸ�������� �Է��ϴ� ���ν����� �����Ͻÿ�
    �Ķ���� : In => ���̵�, �н�����, �̸�     Out => returnVal(����:1, ����:0) */
create or replace procedure MyMemberInsert 
    (id in varchar2, pw in varchar2, name in varchar2, rval out number)
is 
begin
    insert into member (id, pass, name) values (id, pw, name);
    if sql%found then --�Է�����ó���� true��ȯ
        rval := sql%rowcount; --�Է¼����� �హ�� ���� out�Ķ���Ϳ� ����
        commit; --�ຯȭ����Ƿ� �ݵ�� commit�ؾ��Ѵ�
    else rval := 0; --���н� 0��ȯ
    end if;
end;
/
var res varchar2;
execute MyMemberInsert('pro02', '1234', '���ν���1', :res);
execute MyMemberInsert('pro03', '1234', '���ν���2', :res);
execute MyMemberInsert('pro04', '1234', '���ν���4', :res);
print res;

/* ����3-1] ���ν��� : MyMemberDelete()
�ó�����] member���̺��� ���ڵ带 �����ϴ� ���ν����� �����Ͻÿ�
    �Ķ���� : In => member_id(���̵�)    Out => returnVal(SUCCESS/FAIL ��ȯ) */
create or replace procedure MyMemberDelete (mid in varchar2, rval out varchar2)
is 
begin
    delete from member where id=mid;
    if sql%found then 
        rval := 'SUCCESS'; --ȸ�����ڵ尡 ��������� ����, Ŀ���Ѵ�. 
        commit; 
    else rval := 'FAIL'; 
    end if;
end;
/
var res2 varchar2(20);
execute MyMemberDelete('pro05', :res2);
execute MyMemberDelete('test99', :res2);
print res2;

/* ����4-1] ���ν��� : MyMemberAuth()
�ó�����] ���̵�� �н����带 �Ű������� ���޹޾Ƽ� ȸ������ ���θ� �Ǵ��ϴ� ���ν����� �ۼ��Ͻÿ�. 
    �Ű����� : In -> user_id, user_pass,    Out -> returnVal
    ��ȯ�� : 
        0 -> ȸ����������(�Ѵ�Ʋ��)
        1 -> ���̵�� ��ġ�ϳ� �н����尡 Ʋ�����
        2 -> ���̵�/�н����� ��� ��ġ�Ͽ� ȸ������ ����  */
create or replace procedure MyMemberAuth (uid in varchar2, upw in varchar2, rval out number)
is
    mcnt number(1) := 0; --count(*)�� ��ȯ�Ǵ°� ����
    mpw varchar2(30); --���̺��� �Է��� ���̵�� ��ġ�ϴ� ���ڵ��� ��� ������ ����
begin
    select count(*) into mcnt from member where id=uid;
    if mcnt=1 then --ȸ�����̵� �����ϴ°����
        select pass into mpw from member where id=uid; --�н�����Ȯ������ �ι�°��������
        if mpw=upw then rval := 2; --���Ķ���ͷ� ���޵� ����� DB���� ������ ��� ��
        else rval := 1; --���̵� ��ġ�Ѱ��
        end if;
    else rval := 0; --���̵� ��ġ�����ʴ°��
    end if;
end;
/
var res_auth varchar2(1);
execute MyMemberAuth('pro07', '1234', :res_auth);
execute MyMemberAuth('pro07', '1111', :res_auth);
execute MyMemberAuth('pro08', '1111', :res_auth);
print res_auth;

---------------------------------------------------------------------
--JSP �����α׷��� �ǽ� / musthave �������
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
insert into member (id, pw, name) values ('musthave', '1234', '�ӽ�Ʈ�غ�');
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '����1�Դϴ�', '����1�Դϴ�', 'musthave', sysdate, 0);
commit;
insert into member (id, pw, name) values ('siwool', '1234', '���ÿ�');
insert into member (id, pw, name) values ('test', '1234', '�׽�Ʈȸ��');
commit;
---------------------------------------------------------------------
--��1 ����� ȸ���� �Խ��� �����ϱ� : ȸ�����̺��� member�� �Խ������̺��� board ���
---------------------------------------------------------------------
--�Խ��Ǹ�� �� �˻����� ���̵����� �߰�
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '������ ���Դϴ�.', '���ǿ���', 'musthave', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '������ �����Դϴ�.', '�������', 'musthave', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '������ �����Դϴ�.', '������ȭ', 'musthave', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '������ �ܿ��Դϴ�.', '�ܿ￬��', 'musthave', sysdate, 0);
commit;

--�Խ��� ��� �����ϱ�
--1. �Խù� ���� ī��Ʈ
select count(*) from board;
--�˻���� �߰����� where�� �߰� > �˻����� �����ϴ� �Խù� ���� ī��Ʈ
select count(*) from board where title like '%����%' or content like '%����%';
--2. ����� �Խù� ����ϱ�
--�Խ��� ����� �ֱ� �ۼ� �Խù��� ��ܿ� ��µž��ϹǷ� �Ϸù�ȣ�� �������������Ͽ� ���
select * from board where title like '%����%' order by num desc;

--������ ���̺� ���� �� ���̵����� �߰�
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
('siwool', '1234', '���ÿ�', 'siwool123@navr.com', 'no', '02452', '����� ���빮�� �̹��� 37', '1421ȣ', '01056371055', 'no', sysdate);

--�Խ��� �۾��� �����ϱ� 
/* board���̺��� id�÷��� not null�� �����Ǿ��־� ���Էµ��������� ������������� �����߻�
  tjoeun �̶� ���̵�� �θ����̺���meember�� ���� ���ڵ��̹Ƿ� �ܷ�Ű �������ǿ� ����Ǿ� �����߻� */
insert into board (num, title, content, postdate, visitcnt) values 
    (seq_board_num.nextval, '������ ���Դϴ�.', '���ǿ���', sysdate, 0);
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '������ ���Դϴ�.', '���ǿ���', 'tjoeun', sysdate, 0);
update board set id='test2' where title='���� �׽�Ʈ';
insert into board (num, title, content, id, postdate, visitcnt) values 
    (seq_board_num.nextval, '���� �׽�Ʈ�Դϴ�.', '���� �׽�Ʈ�Դϴ�.', 'test', sysdate, 0);
    
--�Խ��� ���뺸�ⱸ��
/* ���뺸�� ������������ �ۼ��F�� �̸��� ����ϱ����� member ���̺�ΰ� inner join���� ������ �ۼ� */
select * from board natural join member where num=1;
select b.*, m.name from board b, member m where b.id=m.id and num=1;

--���뺸���ϸ� �ش�Խù� ��ȸ���� 1�����Ѵ�.
update board set visitcnt=visitcnt+1 where num=1;

--�Խù� �����ϱ�
update board set title='����1 ����', content='����1 ����' where num=1;

--�Խù� �����ϱ�
delete from board where num=1;
commit;
-----------------------------------�Խ��� ����¡ �����ϱ�----------------------------------------
select * from board where title like '%����%' order by num desc;
select rownum, t1.* from (select * from board where title like '%����¡%' order by num desc) t1;
select * from (select rownum, t1.* from (select * from board where title like '%����¡%' order by num desc) t1) 
    where rownum between 1 and 10; --1������
    
select rownum, t1.* from (select * from board order by num desc) t1; 

select * from (select rownum r, t1.* from (select * from board order by num desc) t1) where r between 11 and 20; 
--2������
select * from (select rownum r, t1.* from (select * from board where title like '%�Խù�-3%'
    order by num desc) t1) where r between 11 and 20;

select sal, empno, sum(sal) from emp group by grouping sets(sal, (sal, empno), ()) order by sal;

-----------------------------------���̵� �ߺ� Ȯ���ϱ�----------------------------------------
select * from member where id='aaaaa123';

--barovone ȸ�� ���̺� �����
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
('siwool123', '12341234', '����ȭ', 'siwool12321@gmail.com', '01056371055', '19840412', 
'02452', '����� ���빮�� �̹��� 37', '1421ȣ', 'n', '����', '�ұ�', sysdate);
commit;

--------���Ͼ��ε� �����ϱ�
create table myfile(
    idx number primary key,
    title varchar2(200) not null,
    cate varchar2(100),
    ofile varchar2(100) not null,
    sfile varchar2(30) not null,
    postdate date default sysdate not null
);
insert into myfile values ();
----------��2����� ����÷���� �Խ��� ���̺� ����
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
    ofile varchar2(100), --�������ϸ�
    sfile varchar2(30), --������ �������ϸ�
    downcnt number(5) default 0 not null, --���ϴٿ�ε�Ƚ��
    pw varchar2(30) not null,
    visitcnt number default 0 not null
);
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
commit;
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
commit;
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
commit;
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
commit;


    
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pw)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');
commit;
---------DB�� �����Ͽ� ���ɺо� 2�� ����Ʈ�ڽ� �������� ���̺��ۼ�
create table etc1 (etc1_code varchar2(50) not null, etc1_name varchar2(50) not null);
create table etc2 (etc2_code varchar2(50) not null, etc2_name varchar2(50));
insert into etc1 values ('Literature', '����');
insert into etc1 values ('Economy', '����/�濵');
insert into etc1 values ('Human', '�ι�');
insert into etc1 values ('Art', '����/���߹�ȭ');
insert into etc1 values ('Religion', '����');
insert into etc1 values ('History', '����');
insert into etc1 values ('People', '�ι�');
insert into etc1 values ('Society', '��ȸ');
insert into etc1 values ('Science', '����');
insert into etc1 values ('Kid', '���');
insert into etc1 values ('Study', '�н�/����');
insert into etc1 values ('Exam', '���輭/�ڰ���');
insert into etc1 values ('Computer', '��ǻ��/���ͳ�');
insert into etc1 values ('Magazine', '����');
insert into etc1 values ('Textbook', '���б���');
insert into etc1 values ('Life', '����/�ǰ�/��Ȱ');
insert into etc1 values ('Language', '�ܱ���/����');
insert into etc1 values ('Dictionary', '����');
insert into etc1 values ('Foreign', '�ܱ�����');

insert into etc2 values ('Literature', '�ѱ��Ҽ�');
insert into etc2 values ('Literature', '�ܱ��Ҽ�');
insert into etc2 values ('Literature', '�ѱ�������');
insert into etc2 values ('Literature', '�ܱ�������');
insert into etc2 values ('Literature', '�帣����');
insert into etc2 values ('Literature', '��������/��ȭ');
insert into etc2 values ('Literature', '��');
insert into etc2 values ('Literature', '���/�ó�����');
insert into etc2 values ('Literature', '�����̷�/����');
insert into etc2 values ('Economy', '�濵');
insert into etc2 values ('Economy', '����');
insert into etc2 values ('Economy', '������/������');
insert into etc2 values ('Economy', '����ũ/����');
insert into etc2 values ('Economy', 'â��/���');
insert into etc2 values ('Economy', 'CEO/������');
insert into etc2 values ('Economy', '�ڱ����');
insert into etc2 values ('Human', '�ι�����');
insert into etc2 values ('Human', 'ö��');
insert into etc2 values ('Human', '�����/��ȣ��');
insert into etc2 values ('Human', '�ɸ���');
insert into etc2 values ('Human', '����/����/â��');
insert into etc2 values ('Human', '��ȭ��');
insert into etc2 values ('Human', '����/�����');
insert into etc2 values ('Art', '����������');
insert into etc2 values ('Art', '�̼�');
insert into etc2 values ('Art', '����');
insert into etc2 values ('Art', '����');
insert into etc2 values ('Art', '��ȭ/����');
insert into etc2 values ('Art', '����/������');
insert into etc2 values ('Art', '����/������');
insert into etc2 values ('Art', '���߹�ȭ');
insert into etc2 values ('Religion', '������');
insert into etc2 values ('Religion', '�⵶��');
insert into etc2 values ('Religion', '���縯');
insert into etc2 values ('Religion', '�ұ�');
insert into etc2 values ('Religion', '��������');
insert into etc2 values ('Religion', '����');
insert into etc2 values ('History', '������');
insert into etc2 values ('History', '�ѱ���');
insert into etc2 values ('History', '�����');
insert into etc2 values ('History', '�����');
insert into etc2 values ('History', '����������');
insert into etc2 values ('People', '������');
insert into etc2 values ('People', '��ȸ���/����');
insert into etc2 values ('People', '�����ι��̾߱�');
insert into etc2 values ('People', 'ö����/���');
insert into etc2 values ('People', '������/�Ƿ���');
insert into etc2 values ('People', '������');
insert into etc2 values ('People', '�����ι�');
insert into etc2 values ('People', '�濵/�����');
insert into etc2 values ('People', '�ڼ���');
insert into etc2 values ('People', '������');
insert into etc2 values ('People', '��ġ��/����');
insert into etc2 values ('People', '������/�����');
insert into etc2 values ('People', '�����');
insert into etc2 values ('People', '�ι���Ÿ');
insert into etc2 values ('Society', '��ȸ��');
insert into etc2 values ('Society', '������');
insert into etc2 values ('Society', '������');
insert into etc2 values ('Society', '��ġ/�ܱ���');
insert into etc2 values ('Society', '����');
insert into etc2 values ('Society', '�����');
insert into etc2 values ('Society', '���/�̵��');
insert into etc2 values ('Society', '������');
insert into etc2 values ('Society', '������');
insert into etc2 values ('Society', 'ȯ��/����');
insert into etc2 values ('Society', '��ȸ���');
insert into etc2 values ('Society', '����/������');
insert into etc2 values ('Science', '����������');
insert into etc2 values ('Science', '����');
insert into etc2 values ('Science', 'ȭ��');
insert into etc2 values ('Science', '�������');
insert into etc2 values ('Science', 'õ����');
insert into etc2 values ('Science', '����');
insert into etc2 values ('Science', '��������');
insert into etc2 values ('Science', '����/��ȣ��');
insert into etc2 values ('Science', '���/����');
insert into etc2 values ('Science', '�������');
insert into etc2 values ('Kid', '�ʵ�1~2');
insert into etc2 values ('Kid', '�ʵ�3~4');
insert into etc2 values ('Kid', '�ʵ�5~6');
insert into etc2 values ('Kid', '�ѱ���ȭ');
insert into etc2 values ('Kid', '�ܱ���ȭ');
insert into etc2 values ('Kid', '����/����');
insert into etc2 values ('Kid', '����н�');
insert into etc2 values ('Kid', '��̸�ȭ');
insert into etc2 values ('Kid', '������/����');
insert into etc2 values ('Kid', '��Ʈ/����');
insert into etc2 values ('Study', '�ʵ�1�г�');
insert into etc2 values ('Study', '�ʵ�2�г�');
insert into etc2 values ('Study', '�ʵ�3�г�');
insert into etc2 values ('Study', '�ʵ�4�г�');
insert into etc2 values ('Study', '�ʵ�5�г�');
insert into etc2 values ('Study', '�ʵ�6�г�');
insert into etc2 values ('Study', '�ʵ���������');
insert into etc2 values ('Study', '����1�г�');
insert into etc2 values ('Study', '����2�г�');
insert into etc2 values ('Study', '����3�г�');
insert into etc2 values ('Study', '������������');
insert into etc2 values ('Study', '���1�г�');
insert into etc2 values ('Study', '���2�г�');
insert into etc2 values ('Study', '���3�г�');
insert into etc2 values ('Study', '������');
insert into etc2 values ('Study', '����ڽ���');
insert into etc2 values ('Study', '���ɿ�����');
insert into etc2 values ('Study', '��������');
insert into etc2 values ('Study', 'EBS�������');
insert into etc2 values ('Study', '����/���������');
insert into etc2 values ('Exam', '�������');
insert into etc2 values ('Exam', '������');
insert into etc2 values ('Exam', '�ӿ���');
insert into etc2 values ('Exam', '����/����/���л�');
insert into etc2 values ('Exam', '�����߰���/���ð�����');
insert into etc2 values ('Exam', '����/����/����');
insert into etc2 values ('Exam', '����/����/����');
insert into etc2 values ('Exam', '����/��ȸ');
insert into etc2 values ('Exam', '���/���/�����˻�');
insert into etc2 values ('Exam', '����/����');
insert into etc2 values ('Exam', '����/����');
insert into etc2 values ('Exam', '����/���/���');
insert into etc2 values ('Exam', '����/����/ȯ��');
insert into etc2 values ('Exam', '����/�̿�');
insert into etc2 values ('Exam', '��ǻ��/IT');
insert into etc2 values ('Exam', '����');
insert into etc2 values ('Exam', '��Ÿ');
insert into etc2 values ('Computer', '����/��ī/�Թ�/Ȱ��');
insert into etc2 values ('Computer', 'OS/Networking');
insert into etc2 values ('Computer', 'e����Ͻ�/â��');
insert into etc2 values ('Computer', '���ǽ�Ȱ��');
insert into etc2 values ('Computer', 'Ȩ������/��');
insert into etc2 values ('Computer', '��ǻ�Ͱ���');
insert into etc2 values ('Computer', '���α׷��־��');
insert into etc2 values ('Computer', '�׷���/��Ƽ�̵��');
insert into etc2 values ('Computer', '���α׷��� ����/�����');
insert into etc2 values ('Magazine', '����/����');
insert into etc2 values ('Magazine', '����/�濵');
insert into etc2 values ('Magazine', '�丮/�ǰ�');
insert into etc2 values ('Magazine', '����/����/�м�');
insert into etc2 values ('Magazine', '����/���/������');
insert into etc2 values ('Magazine', '����/��ȭ');
insert into etc2 values ('Magazine', '����');
insert into etc2 values ('Magazine', '��ȭ/����');
insert into etc2 values ('Magazine', '�ڵ���/����/���');
insert into etc2 values ('Magazine', '��ǻ��/����/�׷���');
insert into etc2 values ('Magazine', '������(19+)');
insert into etc2 values ('Magazine', '����/���б���');
insert into etc2 values ('Magazine', '��ȭ/�ִϸ��̼�');
insert into etc2 values ('Magazine', '�û�');
insert into etc2 values ('Magazine', '����');
insert into etc2 values ('Magazine', '���̾/�޷�');
insert into etc2 values ('Magazine', '��ȸ����');
insert into etc2 values ('Textbook', '���迭');
insert into etc2 values ('Textbook', '���а迭');
insert into etc2 values ('Textbook', '�ڿ����а迭');
insert into etc2 values ('Textbook', '�Ǿణȣ�迭');
insert into etc2 values ('Textbook', '������а迭');
insert into etc2 values ('Textbook', '���а迭');
insert into etc2 values ('Textbook', '����迭');
insert into etc2 values ('Textbook', '��ȸ���а迭');
insert into etc2 values ('Textbook', '�ι��迭');
insert into etc2 values ('Textbook', '��а迭');
insert into etc2 values ('Textbook', '��ü�ɰ迭');
insert into etc2 values ('Textbook', '��Ȱȯ��迭');
insert into etc2 values ('Life', '������Ȱ');
insert into etc2 values ('Life', '��ȭ/�ִϸ��̼�');
insert into etc2 values ('Life', '�丮');
insert into etc2 values ('Life', '����');
insert into etc2 values ('Life', '�ӽ�/���/�±�');
insert into etc2 values ('Life', '���׸���/�ְ�ȯ��');
insert into etc2 values ('Life', '�ǰ�/���̾�Ʈ/�̿�');
insert into etc2 values ('Life', '����������');
insert into etc2 values ('Life', '�м�/������');
insert into etc2 values ('Life', '�ڳ౳��');
insert into etc2 values ('Language', '����');
insert into etc2 values ('Language', '�Ϻ���');
insert into etc2 values ('Language', '�߱���');
insert into etc2 values ('Language', '�ѹ�/�ѱ���');
insert into etc2 values ('Language', '���Ͼ�/��������/�����ξ�');
insert into etc2 values ('Language', '��Ÿ�ܱ���');
insert into etc2 values ('Dictionary', '�������');
insert into etc2 values ('Dictionary', '�߱���/����/����');
insert into etc2 values ('Dictionary', '�������');
insert into etc2 values ('Dictionary', '�Ͼ����');
insert into etc2 values ('Dictionary', '���Ͼ�');
insert into etc2 values ('Dictionary', '�����ξ�');
insert into etc2 values ('Dictionary', '��������');
insert into etc2 values ('Dictionary', '��Ÿ�ܱ���');
insert into etc2 values ('Dictionary', '���/����');
insert into etc2 values ('Dictionary', '��������');
insert into etc2 values ('Foreign', '����');
insert into etc2 values ('Foreign', '����/���');
insert into etc2 values ('Foreign', 'ELT/����');
insert into etc2 values ('Foreign', '����/�濵');
insert into etc2 values ('Foreign', '�ǿ�');
insert into etc2 values ('Foreign', '����/������');
insert into etc2 values ('Foreign', '��ǻ��/���');
insert into etc2 values ('Foreign', '����');
insert into etc2 values ('Foreign', '����Ʈ');
commit;
select * from etc1, etc2 where etc1.etc1_code=etc2.etc2_code and etc2_code='Literature';
select * from mvcboard where idx='436';
alter table member3 add subscription varchar2(10);
alter table member3 add smsok varchar2(3);
alter table member3 rename column subscription to mailok;
alter table member3 modify mailok varchar2(3);
------------------------- 3�� ������Ʈ - ������Ʈ ����� : �����ڰ�������, ȸ�����̺����
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
('siwool123', '12341234', '���ÿ�', 'siwool123@navr.com', null, '01056371055', '02452', '����� ���빮�� �̹��� 37', '1421ȣ', sysdate);
select * from member where id='siwool123' and pw='12341234';
alter table member modify add1 varchar2(6);
update member set add1 = '02452';
