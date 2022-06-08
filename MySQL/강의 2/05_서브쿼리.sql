/* **************************************************************************
서브쿼리(Sub Query)
- 쿼리안에서 select 쿼리를 사용하는 것.
- 메인 쿼리 - 서브쿼리

서브쿼리가 사용되는 구
 - select절,  where절, having절 -> 값 대신 쓰는 것. ex) where salary = (select) select의 값
 - from절 -> 테이블 대신
 
서브쿼리의 종류
- 어느 구절에 사용되었는지에 따른 구분
    - 스칼라 서브쿼리 - select 절에 사용. 반드시 서브쿼리 결과가 1행 1열(값 하나-스칼라) 0행이 조회되면 null을 반환
    - 인라인 뷰 - from 절에 사용되어 테이블의 역할을 한다.
    
서브쿼리 조회결과 행수에 따른 구분
    - 단일행 서브쿼리 - 서브쿼리의 조회결과 행이 한행인 것.
    - 다중행 서브쿼리 - 서브쿼리의 조회결과 행이 여러행인 것.
    
동작 방식에 따른 구분
    - 비상관(비연관) 서브쿼리 - 서브쿼리에 메인쿼리의 컬럼이 사용되지 않는다.
                메인쿼리에 사용할 값을 서브쿼리가 제공하는 역할을 한다.
    - 상관(연관) 서브쿼리 - 서브쿼리에서 메인쿼리의 컬럼을 사용한다. 
                            메인쿼리가 먼저 수행되어 읽혀진 데이터를 서브쿼리에서 조건이 맞는지 확인하고자 할때 주로 사용한다.

- 서브쿼리는 반드시 ( ) 로 묶어줘야 한다.
************************************************************************** */
use hr_join;

-- 직원_ID(emp.emp_id)가 120번인 직원과 같은 업무(emp.job_id)를 하는 직원의 id(emp_id),이름(emp.emp_name), 업무(emp.job_id), 급여(emp.salary) 조회

-- main query
select emp_id, emp_name, job_id, salary
from emp
where job_id = (select job_id from emp where emp_id= 120); -- (select문) : subquery
-- 1. sub query 가 먼저 실행된다.
-- 2. sub query 의 조회 결과를 이용해 main query가 실행된다.


-- 직원_id(emp.emp_id)가 115번인 직원과 / 같은 업무(emp.job_id)를 하고 and 같은 부서(emp.dept_id)에 속한 직원들을 조회하시오.
select * from emp 
where (job_id, dept_id) = (select job_id, dept_id from emp where emp_id=115) ; -- 마치 튜플 대입 처럼. 단, 양 쪽 다 괄호 쳐줘야 함.

-- ** DB 마다 다르다. MYSQL에서는 아래 처럼 값을 직접 PAIR 방식으로 대입해서 행을 선택하는 것도된다. -- 서브 쿼리는 모든 dbms 가 다 된다.
-- 그러니 이때는 그냥 and 연산으로 하자.
select * from emp
where (job_id, dept_id) = ('PU_MAN', 30);


-- 조회하는 컬럼나 다르고 select 조건이 동일하다. 

-- pair 방식 서브쿼리.  두개 이상 컬럼 비교해도 된다.



-- 직원들 중 급여(emp.salary)가 전체 직원의 평균 급여보다 적은 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 조회. 
select emp_id emp_name, salary
from emp
where salary < (select avg(salary) from emp);



-- '부서직원들의 평균'이 전체 직원의 평균(emp.salary) 이상인 부서의 이름(dept.dept_name), 평균 급여(emp.salary) 조회.
-- 평균급여는 소숫점 2자리까지 나오고 통화표시($)와 단위 구분자 출력

select d.dept_name, concat('$',format(avg(e.salary), 2)) "평균급여"
from dept d join emp e on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name
having avg(e.salary) >= (select avg(salary) from emp) -- 서브 쿼리는 조인 아님. 그냥 써주기
order by 2; -- 인덱스2 적으면 concat 적용한 문자열이 되어서 원하는 정렬이 안 나옴.


select dept_name, concat('$', format(평균급여, 2)) "평균급여" -- 원하는 format을 여기 맞춰줌.
from(
select d.dept_name, avg(e.salary) "평균급여"
from dept d join emp e on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name
having avg(e.salary) >= (select avg(salary) from emp)
order by 2) t ; -- 일단 원하는 정렬된 상태로 만들어서!

 -- select의 결과는 표 테이블 이다. 이 조회한 표를 from 테이블로 쓰겠다. => 인라인 뷰



-- TODO: 직원의 ID(emp.emp_id)가 145인 직원보다 많은 연봉을 받는 직원들의 이름(emp.emp_name)과 급여(emp.salary) 조회.급여가 큰 순서대로 조회
select emp_name, salary -- 메인쿼리 실행.
from emp 
where salary > (select salary from emp where emp_id = 145) -- 서브쿼리 실행되고
order by salary desc;

-- TODO: 직원의 ID(emp.emp_id)가 150인 직원과 업무(emp.job_id)와 상사(emp.mgr_id)가 같은 직원들의 
-- id(emp.emp_id), 이름(emp.emp_name), 업무(emp.job_id), 상사(emp.mgr_id) 를 조회
select emp_id, emp_name, job_id, mgr_id
from emp
where (job_id, mgr_id) = (select job_id, mgr_id from emp where emp_id = 150); 
-- where (job_id, mgr_id) = ('SA_REP', 145) 도 되지만, mysql에서만 가능하기에 비추.


-- TODO : EMP 테이블에서 직원 이름이(emp.emp_name)이  'John'인 직원들 중에서 
-- 급여(emp.salary)가 가장 높은 직원의 salary(emp.salary)보다 많이 받는 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 조회.
select emp_id, emp_name, salary
from emp
where salary > (select max(salary) from emp where emp_name = 'John');

-- TODO: 급여(emp.salary)가장 많이 받는 직원이 속한 부서의 이름(dept.dept_name), 위치(dept.loc)를 조회.
select d.dept_name, d.loc, e.salary
from emp e left join dept d on e.dept_id = d.dept_id
where salary = (select max(salary) from emp) ;

-- 이렇게 풀어도 됨. dept 내의 정보만 조회라.
select *
from dept
where dept_id in (select dept_id from emp where salary = (select max(salary) from emp));


-- TODO: 급여(emp.salary)를 제일 많이 받는 직원들의 이름(emp.emp_name), 부서명(dept.dept_name), 급여(emp.salary) 조회. 
select e.emp_name, d.dept_name, e.salary
from emp e left join dept d on e.dept_id = d.dept_id
where e.salary = (select max(salary) from emp);


-- TODO: 30번 부서(emp.dept_id) 의 평균 급여(emp.salary)보다 급여가 많은 직원들의 모든 정보를 조회.
select *
from emp
where salary > (select avg(salary) from emp where dept_id = 30);

-- TODO: 전체 직원들 중 담당 업무 ID(emp.job_id) 가 'ST_CLERK'인 직원들의 평균 급여보다 적은 급여를 받는 직원들의 모든 정보를 조회. 
-- 단 업무 ID가 'ST_CLERK'이 아닌 직원들만 조회. 
select *
from emp
where salary < (select avg(salary) from emp where job_id = 'ST_CLERK') 
and (job_id != 'ST_CLERK' or job_id is null) -- null도 포함되게 -- and연산자가 or보다 우선이기에 꼭 맞게 괄호 쳐주기. 조심.
order by salary desc;

-- 다른 방법
select *
from emp
where salary < (select avg(salary) from emp where job_id = 'ST_CLERK') 
and ifnull(job_id, 'None') != 'ST_CLERK'
order by salary desc;


select * from emp
where job_id != 'ST_CLERK';
-- 이 연산을 했더니 job_id 값인 null인 행도 조회가 안됨.
-- null 모르는 값이 이 값을 같냐 다르냐 이러한 연산은 결과를 알 수 없다. 그래서 null 비교 안산은 무조건 False가 된다.


-- TODO: EMP 테이블에서 업무(emp.job_id)가 'IT_PROG' 인 직원들의 평균 급여보다 더 많은 급여를 받는 
-- 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 급여 내림차순으로 조회.
select emp_id, emp_name, salary
from emp 
where salary > (select avg(salary) from emp where job_id ='IT_PROG');


-- TODO: 전체 직원들 중 'IT' 부서(dept.dept_name)의 직원중 가장 많은 급여를 받는 직원보다 더 많이 받는  
-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 입사일(emp.hire_date), 부서 ID(emp.dept_id), 급여(emp.salary) 조회
-- 입사일은 "yyyy년 mm월 dd일" 형식으로 출력
select emp_id, emp_name, date_format(hire_date,'%Y년 %m월 %d일') "입사일", dept_id, salary
from emp
where salary > (select max(e.salary) from emp e join dept d on e.dept_id = d.dept_id where d.dept_name = 'IT' )
order by salary;


-- 서브쿼리의 조회된 결과 값이 하나가 아닌 여러 데이터 값이(여러 행이) 나오는 것. 이때는 다중행서브쿼리
-- > 컬럼이 두개 아님. 행 데이터가 두개인 것.
/* ----------------------------------------------
 다중행 서브쿼리
 - 서브쿼리의 조회 결과가 여러행인 경우
 - where절 에서의 연산자
	- in : 값들 중에 하나만.
	- 비교연산자 any (subquery) : 조회된 값들 중 하나만 참이면 참 (where 컬럼 >,<,=,=! any(서브쿼리) )
	- 비교연산자 all (subquery) : 조회된 값들 모두와 참이면 참 (where 컬럼 >,<,=,=! all(서브쿼리) )

# 궁금한 점
-- 다중행 서브쿼리를 한다고 했을 때 조회결과가 Null 이 포함 되어있다.
-- in 안에 null이 있으면 어떻게 처리하나,,?

------------------------------------------------*/
-- 'Alexander' 란 이름(emp.emp_name)을 가진 관리자(emp.mgr_id)의 
-- 부하 직원들의 ID(emp_id), 이름(emp_name), 업무(job_id), 입사년도(hire_date-년도만출력), 급여(salary)를 조회
-- 알렉산더가 두명 -> 다중행
select emp_id, emp_name, job_id, year(hire_date) "입사년도", salary
from emp
where mgr_id in (select emp_id from emp where emp_name = 'Alexander');

-- where mgr_id = 103, 115 이렇게 비교가 말이 안됨. -> in 연산자 다중행 쿼리로


-- ALL
-- 직원 ID(emp.emp_id)가 101, 102, 103 인 직원들 보다 급여(emp.salary)를 많이 받는 직원의 모든 정보를 조회.
select * from emp
where salary > all(select salary from emp where emp_id in (101,102,103));
-- 서브쿼리로 조회한 값들이 있는데 이 값 모두보다 큰 것을 조회하라.

-- 이렇게 풀 수는 있지만. 위처럼도 풀 수 있다.
select * from emp
where salary > (select max(salary) from emp where emp_id in (101,102,103));

-- ANY
-- 직원 ID(emp.emp_id)가 101, 102, 103 인 직원들 중 급여가 가장 적은 직원보다 급여를 많이 받는 직원의 모든 정보를 조회.
select * from emp
where salary > any (select salary from emp where emp_id in (101,102,103))
order by salary;
-- 나오는 셋 값 중 하나하고만 맞으면 해당 값 출력. 
-- > 그렇다면 가장 적은 값에 대해 그보다 덜 받는 상황이 구현됨.




-- TODO : 부서 위치(dept.loc) 가 'New York'인 부서에 소속된 직원의 ID(emp.emp_id), 이름(emp.emp_name), 부서_id(emp.dept_id) 를 sub query를 이용해 조회.
-- dept emp 조인해서 해도 된다. 지금은 서브쿼리로.
select count(*) -- emp_id, emp_name, dept_id
from emp e 
where dept_id in (select dept_id from dept where loc = 'New York' ); 
-- 부서가 있어야 부서 loc가 있다. 근무지가 있으면 부서 있음. 부서에 대한 정보는 부서테이블에만 있음~~~
-- 부서테이블에는 pk null인 부서미배치라는 값은 없다.


-- TODO : 최대 급여(job.max_salary)가 6000이하인 업무를 담당하는  직원(emp)의 모든 정보를 sub query를 이용해 조회.
select * from emp
where job_id in (select job_id from job where max_salary <= 6000);

-- TODO: 전체 직원들중 부서_ID(emp.dept_id)가 20인 부서의 모든 직원들 보다 급여(emp.salary)를 많이 받는 직원들의 정보를  sub query를 이용해 조회. max 써도 되지만
select *
from emp
where salary > all (select salary from emp where dept_id = 20);

-- TODO: 부서별 급여의 평균중 가장 적은 부서의 평균 급여보다 보다 많이 받는 직원들의 이름, 급여, 업무를 서브쿼리를 이용해 조회
select emp_name, salary, j.*
from emp e left join job j on e.job_id = j.job_id
where salary > any (select avg(salary) from emp group by dept_id);


-- TODO: 업무 id(job_id)가 'SA_REP' 인 직원들중 가장 많은 급여를 받는 직원보다 
-- 많은 급여를 받는 직원들의 이름(emp_name), 급여(salary), 업무(job_id) 를 subquery를 이용해 조회.

select emp_name, salary, job_id
from emp
where salary > all (select salary from emp where job_id = 'SA_REP');



/* *************************************************************************************************
비상관 쿼리
- 서브쿼리가 메인 쿼리와 상괍없이 일하는 것. 독립적으로 일하는 실행. 그리고 그 결과값으로 메인쿼리가 처리하는 것. 
1. 서브 쿼리 -> 2. 메인쿼리
- 지금까지 한 거.

상관(연관) 쿼리
- 메인쿼리문의 조회값을 서브쿼리의 조건에서 사용하는 쿼리.
- 메인쿼리를 실행하고 그 결과를 바탕으로 서브쿼리의 조건절을 비교한다.
	- 메인 쿼리의 where을 실행하면서 subquery가 같이 실행된다. 이때 메인쿼리 where 절에서 비교하는 그 행의 컬럼값들을 가지고 subquery가 실행된다.
메인쿼리가 먼저 일하고 그 내 메인이 일하는 도중에 서브쿼리가 일한다. 
메인쿼리의 조회결과로 서브쿼리가 사용하는 것.
* *************************************************************************************************/

-- 부서별(DEPT)에서 급여(emp.salary)를 가장 많이 받는 
-- 직원들의 id(emp.emp_id), 이름(emp.emp_name), 연봉(emp.salary), 소속부서ID(dept.dept_id) 조회
-- 동시에 메인, 서브 일어난다. 연관성있게

select emp_name, salary, dept_id
from emp e
where salary = (select max(salary) from emp where dept_id = e.dept_id) -- e.dpet_id는 메인 쿼리의 값. dept_id는 서브쿼리 값.
order by dept_id;
-- 메인 쿼리의 테이블의 컬럼을 사용하고 있다면 상관쿼리가 된다. 일하는 방식이 틀려진다. 메인 쿼리가 먼저 일하고 where절 salary가 뭐냐는 부분에서부터 서브쿼리가 실행
-- 메인쿼리 where절에서 e.dept 가 같은 sub dept 값을 뽑아 그 중에 max salary 뽑고 그 값이 메인 쿼리 salary와 같냐 같으면 뽑고 같지 않으면 넘어가 그다음 e.dept 컬럼 데이터 다음 행 또 똑같이 처리.
-- where 절은 매 행 마다 처리한다.
-- 한 행 처리할 때마다 서브쿼리가 실행되는 것. 메인쿼리의 행 수 만큼 서브쿼리가 실행되는 것. 메인쿼리 한 줄씩 비교하는 것이다.


-- 지금 db에서 메인 쿼리 emp, 서브 쿼리 emp 두 개 들고 왔다.




/* **************************************************************************************
EXISTS, NOT EXISTS 연산자 (상관(연관)쿼리와 같이 사용된다)
-- 서브쿼리의 결과를 만족하는 값이 존재하는지 여부를 확인하는 조건. 
-- 조건을 만족하는 행이 여러개라도 한행만 있으면 더이상 검색하지 않는다. 몇 개인지 보고 싶은 게 아니라 있는지 없는지만 보는 것.

- 보통 데이터테이블의 값이 내역/이력 테이블(Transaction TB)에 있는지 여부를 조회할 때 사용된다.
	- 메인쿼리: 데이터테이블
	- 서브쿼리: 내역테이블
	- 메인쿼리에서 조회할 행이 서브쿼리의 테이블에 있는지(또는 없는지) 확인 => sub query의 where절
    
내역테이블(Transaction TB) : 일이 진행되는 과정에 대해 저장되어있는 테이블. 주문 테이블(내역 테이블)에 고객테이블이 있는데 해당 고객이 주문테이블에 있는 지
고객(데이터-부모) 주문(내역-자식) -> 특정 고객이 주문을 했는지 여부?
장비(데이터) 대여(내역) -> 특정 장비가 대여 됐는지 여부?
공연장(데이터) 대관(내역) -> 특정 공연장이 대관된 적이 있는 여부?
************************************************************************************* */

-- 직원이 한명이상 있는 부서의 부서ID(dept.dept_id)와 이름(dept.dept_name),위치(dept.loc)를 조회
-- 상관쿼리 : main query의 테이블을 sub query에서 사용.
-- 데이터 : dept, 내역: emp
select dept_id, dept_name, loc
from dept d
where exists (select emp_id from emp where dept_id = d.dept_id);
-- emp_id가 반환되는 게 아니다. emp_id는 아무거나 써도 됨. 'a' 20 막 이렇게 써도 됨 의미 없는 값.
-- main 쿼리의 현재 행의 dept_id와 서브쿼리 emp의 dept_id가 같은 것이 있는지 여부 => 하나라도 있으면 True 반환하고 끝 ,하나도 없다면 False

-- 직원이 한명도 없는 부서의 부서ID(dept.dept_id)와 이름(dept.dept_name), 위치(dept.loc)를 조회
select dept_id, dept_name, loc
from dept d
where not exists (select emp_id from emp where dept_id = d.dept_id);
-- 부서테이블에서 dept_id 데이터로 비교를 하는데 emp 테이블에 이 dept_id의 해당 데이터가 없다면 False반환. 이 없는 데이터 dept_id 조회.

-- 부서(dept)에서 연봉(emp.salary)이 13000이상인 한명이라도 있는 부서의 부서ID(dept.dept_id)와 이름(dept.dept_name), 위치(dept.loc)를 조회
select *
from dept d
where exists (select 1 from emp 
							where dept_id = d.dept_id -- 직원이 한 명 이상인 부서도 찾고
							and salary >=13000 ); -- 조건에 맞는


/* ******************************
TODO 문제 
주문 관련 테이블들 이용.
******************************* */
use shopping;
-- TODO: 고객(customers) 중 주문(orders)을 한번 이상 한 고객들을 조회.
select * from customers c
where exists (select order_id from orders where cust_id = c.cust_id);

-- TODO: 고객(customers) 중 주문(orders)을 한번도 하지 않은 고객들을 조회.
select * from customers c
where exists (select order_id from orders where cust_id = c.cust_id); -- cust_id(c.cust_id)가 orders table (cust_id) 에 있냐 !!

-- TODO: 제품(products) 중 한번이상 주문된 제품 정보 조회
select * from products p -- 메인쿼리에 데이터테이블. 부모.
where exists (select product_id from order_items where product_id = p.product_id); -- 서브쿼리에 내역테이블. 자식

-- TODO: 제품(products)중 주문이 한번도 안된 제품 정보 조회
select * from products p -- 메인쿼리에 데이터테이블. 부모.
where not exists (select product_id from order_items where product_id = p.product_id); 

-- 상관쿼리가 어려워서 잘 안 쓰이긴 하는데 이 상황에서는(내역 조회하는) 자주 쓰임

