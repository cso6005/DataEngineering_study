/* *********************************************************************
INSERT 문 - 행 추가
-- 삽입, 업데이트, 삭제 다 조인해서 할 수 없다. 한 테이블에 대해서만. 서브쿼리로 처리 구현해야 한다.
-- 사실 where절만 이해하면 이것들 다 쉽게 할 수 있다. 

구문
 1. 한행추가 :
   - INSERT INTO 테이블명 (컬럼 [, 컬럼]) VALUES (값 [, 값[])
   - 모든 컬럼에 값을 넣을 경우 컬럼 지정구문은 생략 할 수 있다.

 2. 조회결과(select)를 INSERT 하기 (subquery 이용)
   - INSERT INTO 테이블명 (컬럼 [, 컬럼])  SELECT 구문
	 - INSERT할 컬럼과 조회한(subquery) 컬럼의 개수와 타입이 맞아야 한다.
	 - 모든 컬럼에 다 넣을 경우 컬럼 설정은 생략할 수 있다.
************************************************************************ */

-- 테이블의 상태를 바꾸는 작업을 배울 것이다. 
-- 사실 select 제외하고 모든 작업은 다 데이터베이스의 상태를 바꾸는 작업이다.

-- < transaction 관리>
-- transaction 관리 : rollback, commit -> 처음 상태로 돌리는 것.
-- 하나의 데이터 처리 작업을 위해 만약 여러 개의 데이터를 변경하는 작업 즉, 여러 개의 명령어를 쓰는 작업을 해야 한다.
-- 이게 등급 올리기 작업을 위해 a고객도 처리해야하고 b고객도 변경 처리해야 한다. 이를 사실 한 번에 못한다. 두가지 작업을 해야 한다. 이걸 transaction 이라고 한다. 
-- 근데 만약 a는 처리했는데 b는 처리 못함. 이건 비정상. 그렇다면 a를 다시 돌려나야 한다. 이게 transaction 관리다.
-- 하나의 작업을 위해 여러가지 동작이 필요하다. 이때 이 모든 동작이 다 이뤄져야 정상 처리이다. 만약 한 동작이라도 에러난다면 에러 안난 동작도 처리 전으로 되돌려야 한다. => tansaction
-- 이걸 어떻게 처리하냐
-- 동작 처리할 때 임시적 임시적임시적 했는데 마지막까지 처리가 잘 될 때 그때 commit 근데 잘 못된게 있어 돌아간다 rollback


select @@autocommit;
-- autocommit : sql 문 실행시마다 커밋처리. (최종적용하는 것을 바로바로 해준다는 것.)
-- 만약 삽입 업데이트 삽입 삭제 이게 한 작업을 위해 한다고 하자. 이때 임시 임시 임시 임시 그러고 최종적으로 적용하고  rollback 하면 마지막으로 commit 한 상태로 돌아간다. 
-- auto는 한 줄 임시 할 때마다 최종적용 commit하는 것. 그렇기에 rollback 적용 안 된다.

-- autocommit 값 : 1 이면 autocommit

-- autocommit 해제 => @@autocommit 값을 0으로 설정.
set autocommit = 0;
select @@autocommit;
-- 테이블 모든 행을 삭제했다.  autocommit = 0 설정으로 이게 아직 최종적용 된 것이 아니라 임시적용된 것. 그렇기에 잘못삭제를 하였을 때 rollback 가능. 
-- 그러고 이걸 최종 적용을 하고 싶다. 이때 commit; 를 하는 것이다. 그럼 테이블 최종 적용됨.!
-- commit눌렀다. 그때 만약 rollback하면 최종 commit 상태인 방금한 commit으로 돌아가기에 delete 했던 그 상태로 돌아가지 못한다.

-- autocommit = 1  은 임시적용만 하는 게 아니라, 한 처리마다 알아서 최종적용 commit이 알아서 됨. rollback하면 마지막 commit 상태로 돌아가기에 delete했던 그 상태로 돌아가지 못한다.

use hr;
select * from emp;

-- 1 모든 컬럼에 넣을 때는 컬럼 생략
insert into emp values (300, '홍길동','AC_ACCOUNT', 205, '2022-05-31', 4000, null, 50);
select * from emp;
-- 만약 또 실행한다. 그렇다면 오류. pk키 동일한 값을 또 넣는 것은 안된다. 제약조건 걸림. 에러 처리.
-- Error Code: 1062. Duplicate entry '302' for key 'emp.PRIMARY'	0.000 sec

-- 2 안 넣어준 컬럼은 Nulllable 컬럼 처리.
insert into emp (emp_id, emp_name, job, hire_date) values ('301','유관순', 'AC_ACCOUNT', '2020-10-30');

-- 3 테이블 생성 시 지정한 컬럼의 데이터 타입에 맞게 데이터를 삽입해야 한다.
-- salary : decimal(7,2) - 전체 7자리 실수부 2자리
-- comm_pct : decimal(2,2) - 전체 2자리 실수부 2자리    0~1 실수값
insert into emp values (302, '강감찬', 'AC_ACCOUNT', 205, '2020-01-03', 100000, NULL, NULL);
-- > Error Code: 1264. Out of range value for column 'salary' at row 1	0.000 sec
-- > range 맞춰져야 함. salary 지금 정수부 6 자리 범위 밖임.
insert into emp values (302, '강감찬', 'AC_ACCOUNT', 205, '2020-01-03', 10000, NULL, NULL);

-- comm_pct = 0.001 을 삽입. 이는 범위 밖 넘기에 0.00으로 짤려서 처리됨. 처리는 되는데 경고메시지.
insert into emp values (303, '강다람', 'AC_ACCOUNT', 205, '2020-01-03', 10000, 0.001, NULL);


-- 2. insert select
create table emp_copy(
	emp_id int,
    emp_name varchar(20),
    salary decimal(7,2)
);

-- 직원 중에 account 부서의 직원들만 emp_copy에 저장하겠다.
select emp_id, emp_name, salary from emp where dept_name = 'It'; -- 이걸 emp_copy 테이블에 고대로 넣고 싶다.

insert into emp_copy (emp_id, emp_name, salary)
select emp_id, emp_name, salary from emp where dept_name = 'It';

-- 전체에 넣는 거라 컬럼 생략 가능.
insert into emp_copy select emp_id, emp_name, salary from emp where dept_name = 'Accounting';

-- 일부 컬럼에 넣는 것은 컬럼 생략 하면 안된다. -- 없는 컬럼 값 null처리
insert into emp_copy (emp_id, emp_name)
select emp_id, emp_name from emp where dept_name = 'Sales';


select * from emp_copy;


-- TODO 부서별 직원의 급여에 대한 통계 테이블 생성. 
-- emp의 다음 조회결과를 insert. 집계: 합계, 평균, 최대, 최소, 분산, 표준편차

-- salary 통계 데이터를 저장할 테이블
drop table if exists salary_stat;
create table salary_stat(
	dept_name varchar(30),
    sum double,
    avg double,
    max double,
    min double,
    var double,
    steddev double
);
insert into salary_stat 
select dept_name,
       sum(salary),
       round(avg(salary),3),
       max(salary),
       min(salary),
       round(variance(salary),3),
       round(stddev(salary),3)
from emp
group by dept_name
order by dept_name; -- 삽입할 때 정렬
       
select * from salary_stat;



/* *********************************************************************
UPDATE : 테이블의 컬럼의 값을 수정
UPDATE 테이블명
SET    변경할 컬럼 = 변경할 값  [, 변경할 컬럼 = 변경할 값] -- 변경할 값으로 변결할 컬럼을 바꿔라. 넣어라.
[WHERE 제약조건]

 - UPDATE: 변경할 테이블 지정
 - SET: 변경할 컬럼과 값을 지정
 - WHERE: 변경할 행을 선택. 
************************************************************************ */
commit;

-- 직원 ID가 200인 직원의 급여를 5000으로 변경
select * from emp where emp_id = 200;

update emp -- table 선택(select을 제외하고는 한 테이블에 대해서만 가능하다.) emp dept 이렇게 설정못함.
set salary = 5000 -- 어떤 컬럼의 값을 어떤 값으로 바꿀지 설정.
where emp_id = 200; -- 변경할 행을 선택. 컬럼의 모든 데이터를 바꿀일은 없으니 where절도 거의 필수.

-- 직원 ID가 200인 직원의 급여를 10% 인상한 값으로 변경.
update emp
set salary = salary*1.1
where emp_id = 200;

use hr_join;

-- 부서 ID가 100인 직원의 커미션 비율을 0.2로 salary는 3000을 더한 값으로, 상사_id는 100 변경.
update emp
set comm_pct = 0.2,
	salary = salary + 3000,
    mgr_id = 100
where dept_id = 100;

select * from emp where dept_id = 100;

-- 부서 ID가 100인 직원의 커미션 비율을 null 로 변경.
update emp
set comm_pct = null
where dept_id = 100;
select * from emp where dept_id = 100;


-- TODO: 부서 ID가 100인 직원들의 급여를 100% 인상
update emp
set salary = salary*2
where dept_id = 100;

-- TODO: IT 부서의 직원들의 급여를 3배 인상
-- 삽입, 업데이트, 삭제 다 조인해서 할 수 없다. 한 테이블에 대해서만. 서브쿼리로 처리 구현해야 한다.

update emp
set salary = salary*3
where dept_id = (select dept_id from dept where dept_name = 'IT');

select * from emp where dept_id = (select dept_id from dept where dept_name = 'IT') ;


-- TODO: EMP 테이블의 모든 데이터를 MGR_ID는 NULL로   HIRE_DATE 는 현재일시로   COMM_PCT는 0.5로 수정.
update emp
set mgr_id = null, hire_date = curdate(), comm_pct = 0.5;
select * from emp;

/* *********************************************************************
DELETE : 테이블의 행을 삭제
구문 
 - DELETE FROM 테이블명 [WHERE 제약조건]
   - WHERE: 삭제할 행을 선택
- 컬럼 기준으로 지우는 게 아님. sql에서 유일하게 쿼리에 컬럼이 안 들어감.
- 데이터는 한 행 전체가 정보이다. 김나라 데이터의 정보는 한 행 자체. 이 데이터. 이 행 기준으로 삭제하는 것.
- 데이터에서 특정 컬럼의 값을 없애는 의미는 update으로 set 컬럼 = null 처리해주는 것.  
************************************************************************ */

delete from emp;
select * from emp;
rollback;

-- 부서테이블에서 부서_ID가 200인 부서 삭제
delete from dept where dept_id = 200;
select * from dept;

-- 부서테이블에서 부서_ID가 10인 부서 삭제
select * from emp where emp_id = 200; -- 부서id가 10이다.

delete from dept where dept_id = 10; 
-- 부서테이블의 부서 id가 10인 데이터가 지운다면, 직원테이블의 원래 부서 id가 10였던 행의 부서 id값이 null처리 된다. 
-- 부모테이블이의 참조 row가 지워진다면 자식 테이블의 참조 row 값을 null로 설정.
-- on delete set null 제약 조건을 그렇게 해줬음. 

select * from dept where dept_id = 10;

select * from emp where emp_id = 200; -- 자식테이블의 해당 값도 지워진다.


-- TODO: 부서 ID가 없는 직원들을 삭제
delete from emp where dept_id is null;
select * from emp where dept_id is null;

-- TODO: 담당 업무(emp.job_id)가 'SA_MAN'이고 급여(emp.salary) 가 12000 미만인 직원들을 삭제. 
delete from emp where job_id = 'SA_MAN' and salary < 12000;


-- TODO: comm_pct 가 null이고 job_id 가 IT_PROG인 직원들을 삭제
-- 삽입, 업데이트, 삭제 다 조인해서 할 수 없다. 한 테이블에 대해서만. 서브쿼리로 처리 구현해야 한다.
delete from emp where comm_pct is null and job_id = 'IT_PROG';

