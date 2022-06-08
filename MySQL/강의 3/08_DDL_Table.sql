/* ***********************************************************************************
테이블 생성
- 구문
create table 테이블 이름(
  컬럼 설정
)
컬럼 설정
- 컬럼명   데이터타입  [default 값]  [제약조건] 
- 데이터타입
- default : 기본값. 값을 입력하지 않을 때 넣어줄 기본값. 값을 입력하면 입력한 값이 들어가고.

제약조건 설정 
- primary key (PK): 행식별 컬럼. NOT NULL, 유일값(Unique)
- unique Key (uk) : 유일값을 가지는 컬럼(중복x). null을 가질 수있다.
- not null (nn)   : 값이 없어서는 안되는 컬럼.
- check key (ck)  : 컬럼에 들어갈 수 있는 값의 조건을 직접 설정.
- foreign key (fk): 다른 테이블의 primary key 컬럼의 값만 가질 수 있는 컬럼. 
                    다른 테이블을 참조할 때 사용하는 컬럼.

- 컬럼 레벨 설정
    - 컬럼 설정에 같이 설정  한 컬럼 설정 뒤에 /not null의 경우 컬럼 설정에 해줘야 한다.
- 테이블 레벨 설정
    - 컬럼 설정 뒤에 따로 설정. 컬럼 정의하고 그 다음 constraint ~~ 설정하고

- 정의한 제약 조건을 어겼을 때 어떤 제약 조건을 어겼는 지 제약조건이름으로 알 수 있다. 출력메시지로 알 수 있다.
- 기본 문법 : constraint 제약조건이름 제약조건타입(지정할컬럼명)  /(PK, UK는 이름 없이 바로 설정 가능-컬럼레벨에서)
fk-emp-dept                     이렇게 ? fk-emp-name-dept-name
- 테이블 제약 조건 조회
    - select * from information_schema.table_constraints;

    
테이블 삭제
- 구분
DROP TABLE 테이블이름;

- 제약조건 해제
   SET FOREIGN_KEY_CHECKS = 0;
- 제약조건 설정
   SET FOREIGN_KEY_CHECKS = 1;   
*********************************************************************************** */

create database testdb;
use testdb;

-- parent_db (부모)  ------ child_tb (자식)
-- 1 제약 조건 : 컬럼 레벨. (제약 조건 이름 설정 못함.)
create table parent_tb(
	no int primary key, -- no : number  -- pk 제약조건 컬럼레벨로 지정.
    name varchar(50) not null,  -- not null 제약 조건은 컬럼레벨로 지정.
    join_date timestamp default current_timestamp, 
    -- 날짜/시간 타입의 컬럼에 insert 시점의 일시를 기본값으로 넣을 경우 
    -- > type : timestamp, default값 : current_timestamp  
    -- dbms 마다 다른데 mysql은 이렇게 작성해주면 됨 
    -- 생일 등 이러한 등록은 사용자가. 가입한 날짜의 경우는 사용자의 입력이 아님. 등록 버튼을 누른 그 순간을 자동으로 해야 함. 그때 이렇게 작성.
	
    email varchar(100) unique, -- uk 제약조건. 
    gender char(1) not null check(gender in ('M', 'F')),
    -- check : gender 컬럼은 m과 f만 올 수 있다는 제약 조건. check(컬럼명 조건)  
    age int check(age between 10 and 30) -- age 컬럼의 값은 10-30사이의 정수만 가능. 비교해서 트루가 되는 값만 반환.
);	
 select * from information_schema.table_constraints where table_schema = 'testdb'; -- 제약 조건이름을 안 적어주면 알아서 

insert into parent_tb values (100, '홍길동', '2020-12-31 11:23:12', 'a@a.com', 'M', 20);
insert into parent_tb (no, name, gender, age) values (101, '유관순','F', 20);
-- 가입일 넣지 않아 디폴트갑 들어감. 넣지 않은 이메일 null들어갈 수 있어 null 처리.

-- 제약 조건 어겼을 때 --
insert into parent_tb (no, name, email, gender, age) values (104, '유관순','a@a.com','F', 29);
-- 이메일은 uk 제약조건있음. 중복된 값이 들어 갈 수 없다.
-- Error Code: 1062. Duplicate entry 'a@a.com' for key 'parent_tb.email'

insert into parent_tb (no, name, email, gender, age) values (105, '강감찬','abd@a.com','남', 29);
-- Error Code: 3819. Check constraint 'parent_tb_chk_1' is violated.	
-- gender check 제약 조건을 어겨서 

insert into parent_tb (no, name, email, gender, age) values (106, '강감찬','abd@a.com','남', 40);
-- Error Code: 3819. Check constraint 'parent_tb_chk_1' is violated.	0.000 sec
-- 나이 check제약 조건 어겨서

select * from parent_tb;

-- 2 제약 조건 : 테이블 레벨. (제약 조건 이름 설정 할 수 있음.) / not null 빼고 가능.
-- 제약 조건 이름 : 테이블명_컬럼명_제약조건타입  제약조건타입_테이블명_컬럼명  이렇게 둘 중 하나 관례적으로 씀.  child_tb_no_pk 이렇게 컬럼명도 
create table child_tb(
	no int auto_increment,  -- auto_increment는 자동증가 컬럼. insert시 1씩 증가하는 정수를 가진다. PK
    jumin_num char(14),  -- UK  -- 6-7 이렇게 자리수가 14 고정으로 입력 받으니.
    age int not null, -- CK
    p_no int not null, -- FK (parent_tb.no 참조)    
    constraint child_tb_no_pk primary key(no), -- mysql은 제약조건이름 입력해도 primary로 등록이 된다. 다른 db는 지정이름으로 됨.
    constraint child_tb_jumin_num_uk unique(jumin_num),
    constraint child_tb_age_ck check(age > 0 and age <= 100),
    constraint child_tb_p_no_parent_tb_no_fk foreign key(p_no) references parent_tb(no) on delete cascade 
    -- 부모삭제 시 자식 해당 행도 같이 삭제 -- on 설정 안 하면 부모 테이블 삭제 불가. -- p_no가 not null이라 delete set null 설정 못함.  
);

insert into child_tb(jumin_num, age, p_no) values ('111111-2222222', 20, 101);
insert into child_tb(jumin_num, age, p_no) values ('222222-2222222', 23, 100);

insert into child_tb(jumin_num, age, p_no) values ('333333-2222222', 25, 201);
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`testdb`.`child_tb`, CONSTRAINT `child_tb_p_no_parent_tb_no_fk` FOREIGN KEY (`p_no`) REFERENCES `parent_tb` (`no`) ON DELETE CASCADE)	0.000 sec
-- p_no는 fk 참조하는 컬럼이다. 부모테이블에 없는 값을 넣었다면 오류가 날 것이다.!!! 부모테이블에서 참조할 행 데이터에 맞게 적어줘야 한다.

select * from parent_tb;
select * from child_tb; -- insert가 실패해도 에러나도 그걸 측정해서 no가 

delete from parent_tb where no = 101; -- child_tb 조회하면 101 번을 참조한 해당 행 삭제된 것을 볼 수 있다.




-- TODO
-- 출판사(publisher) 테이블 (부모)
-- 컬럼명                 | 데이터타입        | 제약조건        
-- publisher_no 		| int  			| primary key, 자동증가
-- publisher_name 		| varchar(50)   | not null 
-- publisher_address 	| varchar(100)  |
-- publisher_tel 		| varchar(20)   | not null


-- 책(book) 테이블 (자식)
-- 컬럼명 		   | 데이터타입            | 제약 조건         |기타 
-- isbn 		   | varchar(13),       | primary key
-- title 		   | varchar(50) 		| not null 
-- author 		   | varchar(50) 		| not null 
-- page 		   | int 		 		| not null, check key-0초과값
-- price 		   | int 		 		| not null, check key-0초과값 
-- publish_date   | timestamp 			| not null, default-current_timestamp(등록시점 일시)
-- publisher_no   | int 		        | not null, Foreign key-publisher

-- 테이블 생성 --
-- ddl은 rollback 불가.
DROP TABLE book;
DROP TABLE publisher;

create table publisher(
	publisher_no int primary key auto_increment,
    publisher_name varchar(50) not null,
    publisher_address varchar(100),
    publisher_tel varchar(20) not null
    
);

create table book(
	isbn varchar(13),
    title varchar(50) not null,
    author varchar(50) not null,
    page int not null,
    price int not null,
    publish_date timestamp default current_timestamp not null,
    publisher_no int not null,
    constraint book_isbn_pk primary key(isbn),
    constraint book_page_ck check(page > 0),
    constraint book_price_ck check(price > 0),
    constraint book_publisher_publisher_no_fk foreign key(publisher_no) references publisher(publisher_no) on delete cascade
    
    );

-- 조회 --    
show tables; -- 해당 DB 내 테이블 조회
desc publisher; -- 생성한 테이블 정보 알 수 있다.
select * from information_schema.table_constraints where table_name = 'book'; -- 제약 조건이름을 안 적어줘서 알아서 


insert into publisher(publisher_name, publisher_address, publisher_tel) values ('김나라', '부산시', '0102342223');
insert into publisher(publisher_name, publisher_address, publisher_tel) values ('오진심', '마산시', '010232424');
select * from publisher;

insert into book(isbn, title, author, page, price, publisher_no) values(101, '앨리스', '탐', 34, 10000, 1);
select * from book;

/* ************************************************************************************
ALTER : 테이블 수정

컬럼 관련 수정

- 컬럼 추가
  ALTER TABLE 테이블이름 ADD COLUMN 추가할 컬럼설정 [,ADD COLUMN 추가할 컬럼설정]
  
- 컬럼 수정
	타입에 대해 수정.
  ALTER TABLE 테이블이름 MODIFY COLUMN 수정할컬럼명 변경설정 [, MODIFY COLUMN 수정할컬럼명  변경설정]
	- 숫자/문자열 컬럼은 크기를 늘릴 수 있다.
		- 크기를 줄일 수 있는 경우 : 열에 값이 없거나 모든 값이 줄이려는 크기보다 작은 경우
	- 데이터가 모두 NULL이면 데이터타입을 변경할 수 있다. (단 CHAR<->VARCHAR2 는 가능.)

- 컬럼 삭제	
  ALTER TABLE 테이블이름 DROP COLUMN 컬럼이름 [CASCADE CONSTRAINTS]
    - CASCADE CONSTRAINTS : 삭제하는 컬럼이 Primary Key인 경우 그 컬럼을 참조하는 다른 테이블의 Foreign key 설정을 모두 삭제한다.
	- 한번에 하나의 컬럼만 삭제 가능.

- 컬럼 이름 바꾸기
  ALTER TABLE 테이블이름 RENAME COLUMN 원래이름 TO 바꿀이름;

**************************************************************************************  
제약 조건 관련 수정
- 제약조건은 수정 불가. 삭제하고 다시 만들어야 함.
-제약조건 추가
  ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건 설정

- 제약조건 삭제
  ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건이름
  PRIMARY KEY 제거: ALTER TABLE 테이블명 DROP PRIMARY KEY 
	- CASECADE : 제거하는 Primary Key를 Foreign key 가진 다른 테이블의 Foreign key 설정을 모두 삭제한다.

- NOT NULL <-> NULL 변환은 컬럼 수정을 통해 한다.
   - ALTER TABLE 테이블명 MODIFY COLUMN 컬럼명 타입 NOT NULL  
   - ALTER TABLE 테이블명 MODIFY COLUMN 컬럼명 NULL
************************************************************************************ */
use shopping;
/*
기존 테이블을 복사한 테이블 생성 - 제약 조건은 복사 되지 않는다. (not null 조건만 복제됨.)
create table 이름
as
select 문 -- subquery


*/

-- customers 테이블 생성(not null을 제외한 제약 조건은 copy가 안됨)
create table cust2
as
select * from customers;

select * from cust2;
select * from information_schema.table_constraints where table_name = 'customers'; 
select * from information_schema.table_constraints where table_name = 'cust2'; 
desc cust2; -- not null 조건은 복사됨.

create table cust
as
select * from customers where 1 = 0; -- 테이블의 구조만 복사 (where 성립 안 하니 데이터는 복사하지 않는다.) -- 당연히 제약조건도 복사안됨.
select * from cust1;

create table ord
as
select * from orders where 1 = 0;
desc ord;


-- 1 제약조건 추가
-- pk 설정
alter table cust add constraint cust_pk primary key(cust_id);

desc cust;

-- fk 설정    ord.cust_id fk 설정    (부모 cust.cust_id)
alter table ord add constraint ord_cust_fk foreign key(cust_id) references cust(cust_id);

select * from information_schema.table_constraints where table_name = 'ord'; 

-- 3 제약 조건 삭제
alter table ord drop constraint ord_cust_fk;

-- 컬럼 ------------
-- 4 컬럼 추가
-- column 뒤에 컬럼 지정 제약조건 생성할 때와 똑같이  넣어주면 된다. 
alter table cust add column age int default 0 not null;
alter table cust add column age2 int default 0 not null check(age2 > 10);

desc cust;
select * from information_schema.table_constraints where table_name = 'cust'; 

-- 5 컬럼 수정 - datatype, null 허용 여부 이 두 가지를 바꾸는.
alter table cust modify column age tinyint not null; -- datatype 변경 설정.  not null을 지정하지 않으면 null 허용으로.
alter table cust modify column age2 int null; -- null 허용 여부 설정. 데이터 타입은 그대로 둘거기 때문에 그대로 또 적어줌. null 생략 가능.
-- 컬럼명 타입;  => nollable /// null 생략 가능하기에
-- 컬럼명 타입 not null => not null 

-- 데이터 타입 크기를 줄이는 경우에 담겨있는 데이터들의 크기보다 작은 크기를 설정할 수 없다. 에러.
alter table cust modify column address varchar(2) not null;
alter table cust2 modify column address varchar(2) not null; -- 데이터 값들이 이미 2 이상. 에러남. 


-- 6 컬럼 이름 변경
-- not null을 제외한 제약 조건이 있으면 변경이 안 된다. age2는 check 제약 조건 있어서 안 됨. 
alter table cust rename column age to cust_age; -- age2를 cust_age로 바꿈.

-- 컬럼 삭제
alter table cust drop column cust_age;



use hr_join;
-- TODO: emp 테이블의 구조만 복사해서 emp2를 생성 (이후 TODO 문제들은 emp2 테이블을 가지고 한다.)
create table emp2
as 
select * from emp where 1!=1;


-- TODO: gender 컬럼을 추가: type char(1)
alter table emp2 add column gender char(1);

-- TODO: email, jumin_num 컬럼 추가 
--   email varchar(100),  not null  
--   jumin_num char(14),  null 허용 unique
alter table emp2 add column email varchar(100) not null, add column jumin_num char(14) unique;


-- TODO: emp_id 를 primary key 로 변경

alter table emp2 add constraint primary key(emp_id);
 -- alter table emp2 add primary key(emp_id) primary는 이 구문도 가능. 
  
-- TODO: gender 컬럼의 M, F 저장하도록  제약조건 추가
alter table emp2 add constraint emp2_gender_ck check(gender in ('M','F'));


-- TODO: salary 컬럼에 0이상의 값들만 들어가도록 제약조건 추가
alter table emp2 add constraint emp2_salary_ck check(salary > 0);


-- TODO: email 컬럼에 unique 제약조건 추가.
alter table emp2 add constraint emp2_email_uk unique(email);


-- TODO: emp_name 의 데이터 타입을 varchar(100) 으로 변환
alter table emp2 modify column emp_name varchar(100) not null;

desc emp2;

-- TODO: job_id를 not null 컬럼으로 변경
alter table emp2 modify column job_id varchar(30) not null;

-- TODO: job_id  를 null 허용 컬럼으로 변경
alter table emp2 modify column job_id varchar(30);

-- TODO: 위에서 지정한 emp_email_uk 제약 조건을 제거
select * from information_schema.table_constraints where table_name = 'emp2'; 

alter table emp2 drop constraint emp2_email_uk;


-- TODO: 위에서 지정한 emp_salary_ck 제약 조건을 제거
alter table emp2 drop constraint emp2_salary_ck;

-- TODO: gender 컬럼제거
alter table emp2 drop column gender;

-- TODO: email 컬럼 제거
alter table emp2 drop column email;

insert into emp2(emp_id,emp_name, hire_date, salary) values(300,'홍길동','2022-12-12',-1); 
select * from emp2;


