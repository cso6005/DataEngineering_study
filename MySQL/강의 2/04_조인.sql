use hr_join;

/* ********************************************************************************
조인(JOIN) 이란
- 2개 이상의 테이블에 있는 컬럼들을 합쳐서 가상의 테이블을 만들어 조회하는 방식을 말한다.

1
 	- 소스테이블 : 내가 먼저 읽어야 한다고 생각하는 테이블
	- 타겟테이블 : 소스를 읽은 후 소스에 조인할 대상이 되는 테이블

2
- 각 테이블을 어떻게 합칠지를 표현하는 것을 조인 연산이라고 한다.
    - 조인 연산에 따른 조인종류
        - Equi join ,  non-equi join
3
- 조인의 종류
    - Inner Join 
        - 양쪽 테이블에서 조인 조건을 만족하는 행들만 합친다. 
    - Outer Join
        - 한쪽 테이블의 행들을 모두 사용하고 다른 쪽 테이블은 조인 조건을 만족하는 행만 합친다. 조인조건을 만족하는 행이 없는 경우 NULL을 합친다.
        - 종류 : Left Outer Join,  Right Outer Join, Full Outer Join
    - Cross Join
        - 두 테이블의 곱집합을 반환한다. 
        - 거의 안쓰는데 a테이블 1과 b 테이블과 1 / 1과 2/ 2와 2 이렇게 모든 행의 곱 조건을 다 해보는 것. 
        - 한 대상에 대한 데이터여야 할테데 이렇게 하면 대부분의 상황이 틀릴 것이다. 이 개념은 있지만 쓸 일은 없다. 
       
******************************************************************************** */        
/* **********************
크로스조인
SELECT * 
  FROM t1 CROSS JOIN t2;
* **********************/
-- select * from emp cross join dept;  == select 107*27; 107 * 27 값이랑 같다. 이렇게 대부분의 상황에서 곱집합 할 일이 없다.

-- join은 form 절 에서 한다. 

-- join은 form 절 에서 한다. 테이블을 합치는. 테이블을 만드는 과정
/* ****************************************
-- INNER JOIN
FROM  테이블a INNER JOIN 테이블b ON 조인조건  -- a와 b 테이블을 합칠거야 근데 조인조건(연산)으로 합칠거야 .
   INNER은 제외 가능

- inner는 생략 할 수 있다.
**************************************** */
-- 직원의 ID(emp.emp_id)가 100인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회.
-- 조회하고 싶은 것 : emp 테이블과 dept 테이블 이를 한 sql문으로 해야 한다. 근데 select는 한 테이블 대상밖에 안됨. 그렇다면 emp 테이블과 dept 테이블을 합치자.
-- 조건이 맞는 행을 들고 와, 부모 테이블 해당 행과 자식 테이블 해당 행끼리 맞춰서 합친 새로운 테이블을 만들는 것! 

select e.emp_id, -- 생략해도 되지만 넣어주는 게 좋음
	   e.emp_name,
       e.hire_date,
       d.dept_name
from    emp e inner join dept d on e.dept_id = d.dept_id  -- 어떻게 합칠 건지 on 뒤에 적는 것.
where   e.emp_id = 100;
-- 테이블 합치기 -> 만들어진 테이블에서 조건 맞는 행 찾기 -> 조회할 컬럼에 맞게 출력.

select e.emp_id, e.emp_name, e.hire_date, d.dept_name -- 이전까지는 한 테이블 대상 조회이기때문에 적을 필요가 없었다. 만약 적는다면
from emp e inner join dept d on e.dept_id = d.dept_id; -- 별칭을 지정해준다. 보통 앞글자따사ㅓ



-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회
select e.emp_id, e.emp_name, e.hire_date, d.dept_name, count(*) -- 새로 만들어진 join테이블에서 d.dept_name
from emp e inner join dept d on e.dept_id = d.dept_id; 

select count(*)
from emp e inner join dept d on e.dept_id = d.dept_id; -- 102 출력. null 제외 부서가 있는 애들만 나온것.

select count(*) from emp where dept_id is null; --     107 - 5

-- >> 위와 달리 모든 데이터에서 다 보고 싶을 때? -> outer join


-- 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회

select e.dept_name, e.job_id-- e.emp_id, e.emp_name, e.salary, j.job_title, d.dept_name
from emp e join job j on e.job_id = j.job_id
		   join dept d on e.dept_id = d.dept_id;

select * from emp;

select e.job_id, e.dept_id
from emp e join job j on e.job_id = j.job_id
		   join dept d on e.dept_id = d.dept_id;

-- 부서_ID(dept.dept_id)가 30인 부서의 이름(dept.dept_name), 위치(dept.loc), 그 부서에 소속된 직원의 이름(emp.emp_name)을 조회.
-- select e.emp_id, e.emp_name, e.salary, j.job_title,
 -- 강사나미 파일로 다시 쓰기
 
 -- 이전까지는 source : 자식 테이블, target :  부모 테이블
--  지금은 부모 기준으로 자식을 찾는데 그럼 여러 자식이 나온다. 한 부모에 여러 자식 형태를 뽑을 때 그렇다면 부모 값은 동일값(한 부모의 값) 찍힐 것.
select d.dept_id, d.dept_name, d.loc, e.emp_name
from dept d join emp e on d.dept_id = e.dept_id
where d.dept_id = 30;


-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 급여등급(salary_grade.grade) 를 조회. 급여 등급 오름차순으로 정렬
----- ????????

select e.emp_id, e.emp_name, e.salary,
       concat(s.grade, '등급') "salart_grade"
from emp e join salary_grade s on e.salary between s.low_sal and s.high_sal
order by 4;

select * from salary_grade; 

-- TODO 직원 id(emp.emp_id)가 200번대(200 ~ 299)인 직원들의  
-- 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 내림차순으로 정렬.


-- TODO 업무(emp.job_id)가 'FI_ACCOUNT'인 직원의 ID(emp.emp_id), 이름(emp.emp_name),
-- 업무(emp.job_id), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 내림차순으로 정렬.


-- TODO 커미션을(emp.comm_pct) 받는 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name),
-- 급여(emp.salary), 커미션비율(emp.comm_pct), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 내림차순으로 정렬.


-- TODO 'New York'에 위치한(dept.loc) 부서의 부서_ID(dept.dept_id), 부서이름(dept.dept_name), 위치(dept.loc), 
-- 그 부서에 소속된 직원_ID(emp.emp_id), 직원 이름(emp.emp_name), 업무(emp.job_id)를 조회. 


-- TODO 직원_ID(emp.emp_id), 이름(emp.emp_name), 업무_ID(emp.job_id), 업무명(job.job_title) 를 조회.

      
-- TODO: 직원 ID 가 200 인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 
-- 급여(emp.salary), 담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회              


-- TODO: 'Shipping' 부서의 부서명(dept.dept_name), 위치(dept.loc), 
-- 소속 직원의 이름(emp.emp_name), 업무명(job.job_title)을 조회. 직원이름 내림차순으로 정렬


-- TODO: 'San Francisco' 에 근무(dept.loc)하는 직원의 id(emp.emp_id), 
-- 이름(emp.emp_name), 입사일(emp.hire_date)를 조회 입사일은 'yyyy년 mm월 dd일' 형식으로 출력


-- TODO 부서별 급여(salary)의 평균을 조회. 부서이름(dept.dept_name)과 급여평균을 출력. 급여 평균이 높은 순서로 정렬. 


-- TODO 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 
-- 급여(emp.salary), 급여등급(salary_grade.grade), 소속부서명(dept.dept_name)을 조회. 등급 내림차순으로 정렬


-- TODO salary 등급(salary_grade.grade)이 1인 직원들이 부서별로 몇명있는지 조회. 직원수가 많은 부서 순서대로 정렬.



/* ****************************************************
Self 조인
- 물리적으로 하나의 테이블을 두개의 테이블처럼 조인하는 것.
**************************************************** */
-- 직원 ID가 101인 직원의 직원의 ID(emp.emp_id), 이름(emp.emp_name), 상사이름(emp.emp_name)을 조회




/* ****************************************************************************
외부 조인 (Outer Join)
- 불충분 조인
    - 조인 연산 조건을 만족하지 않는 행도 포함해서 합친다
종류
 left  outer join: 구문상 소스 테이블이 왼쪽
 right outer join: 구문상 소스 테이블이 오른쪽
 full outer join:  둘다 소스 테이블 (Mysql은 지원하지 않는다. - union 연산을 이용해서 구현)

- 구문
from 테이블a [LEFT | RIGHT] OUTER JOIN 테이블b ON 조인조건
- OUTER는 생략 가능.

**************************************************************************** */

-- 직원의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 부서명(dept.dept_name), 부서위치(dept.loc)를 조회. 
-- 부서가 없는 직원의 정보도 나오도록 조회. dept_name의 내림차순으로 정렬한다.



-- 모든 직원의 id(emp.emp_id), 이름(emp.emp_name), 부서_id(emp.dept_id)를 조회하는데
-- 부서_id가 80 인 직원들은 부서명(dept.dept_name)과 부서위치(dept.loc) 도 같이 출력한다. (부서 ID가 80이 아니면 null이 나오도록)


        
-- TODO: 직원_id(emp.emp_id)가 100, 110, 120, 130, 140인 
--  직원의 ID(emp.emp_id),이름(emp.emp_name), 업무명(job.job_title) 을 조회. 업무명이 없을 경우 '미배정' 으로 조회


-- TODO: 부서 ID(dept.dept_id), 부서이름(dept.dept_name)과 그 부서에 속한 직원들의 수를 조회. 직원이 없는 부서는 0이 나오도록 조회하고 직원수가 많은 부서 순서로 조회.
-- count(*) : 행수


-- TODO: EMP 테이블에서 부서_ID(emp.dept_id)가 90 인 모든 직원들의 id(emp.emp_id), 이름(emp.emp_name), 상사이름(emp.emp_name), 입사일(emp.hire_date)을 조회. 
-- 입사일은 yyyy/mm/dd 형식으로 출력


-- TODO 2003년~2005년 사이에 입사한 모든 직원의 id(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 입사일(emp.hire_date),
-- 상사이름(emp.emp_name), 상사의입사일(emp.hire_date), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.














