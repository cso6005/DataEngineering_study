/* ********************************************************************************
조인(JOIN) 이란
- 2개 이상의 테이블에 있는 컬럼들을 합쳐서 가상의 테이블을 만들어 조회하는 방식을 말한다.
 	- 소스테이블 : 내가 먼저 읽어야 한다고 생각하는 테이블
	- 타겟테이블 : 소스를 읽은 후 소스에 조인할 대상이 되는 테이블
 
- 각 테이블을 어떻게 합칠지를 표현하는 것을 조인 연산이라고 한다.
    - 조인 연산에 따른 조인종류
        - Equi join , non-equi join
- 조인의 종류
    - Inner Join 
        - 양쪽 테이블에서 조인 조건을 만족하는 행들만 합친다. 
    - Outer Join
        - 한쪽 테이블의 행들을 모두 사용하고 다른 쪽 테이블은 조인 조건을 만족하는 행만 합친다. 조인조건을 만족하는 행이 없는 경우 NULL을 합친다.
        - 종류 : Left Outer Join,  Right Outer Join, Full Outer Join
    - Cross Join
        - 두 테이블의 곱집합을 반환한다. 
******************************************************************************** */        
/* **********************
크로스조인
SELECT * 
  FROM t1 CROSS JOIN t2;
* **********************/



/* ****************************************
-- INNER JOIN
FROM  테이블a INNER JOIN 테이블b ON 조인조건 

- inner는 생략 할 수 있다.
**************************************** */
-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회


-- 직원의 ID(emp.emp_id)가 100인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 입사년도(emp.hire_date), 소속부서이름(dept.dept_name)을 조회.


-- 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회


-- 부서_ID(dept.dept_id)가 30인 부서의 이름(dept.dept_name), 위치(dept.loc), 그 부서에 소속된 직원의 이름(emp.emp_name)을 조회.


-- 직원의 ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 급여등급(salary_grade.grade) 를 조회. 급여 등급 오름차순으로 정렬


-- TODO 직원 id(emp.emp_id)가 200번대(200 ~ 299)인 직원들의  
-- 직원_ID(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 내림차순으로 정렬.
select e.emp_id, e.emp_name, e.salary,
		d.dept_name, d.loc
from emp e inner join dept d on e.dept_id = d.dept_id
where e.emp_id>=200 and e.emp_id<300
order by 1 desc;


-- TODO 업무(emp.job_id)가 'FI_ACCOUNT'인 직원의 ID(emp.emp_id), 이름(emp.emp_name),
-- 업무(emp.job_id), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 내림차순으로 정렬.
select e.emp_id, e.emp_name, e.job_id, d.dept_name, d.loc
from emp e join dept d on e.dept_id = d.dept_id
where e.job_id = 'FI_ACCOUNT'
order by 1 desc;

# 일단 테이블 합치고 나서 가상 테이블을 불러와 무언가 처리가 일어난 다는 것을 일자.

-- TODO 커미션을(emp.comm_pct) 받는 직원들의 직원_ID(emp.emp_id), 이름(emp.emp_name),
-- 급여(emp.salary), 커미션비율(emp.comm_pct), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회. 직원_ID의 내림차순으로 정렬.
select e.emp_id, e.emp_name, e.salary, e.comm_pct, d.dept_name, d.loc
from emp e join dept d on e.emp_id = d.dept_id
where e.comm_pct is not null
order by 1 desc; 

-- TODO 'New York'에 위치한(dept.loc) 부서의 부서_ID(dept.dept_id), 부서이름(dept.dept_name), 위치(dept.loc), 
-- 그 부서에 소속된 직원_ID(emp.emp_id), 직원 이름(emp.emp_name), 업무(emp.job_id)를 조회. 
--  지금 주된 관심사가 부서 정보. -> dept d join emp e --> dept가 앞에 먼저 오고 그옆에 emp가 붙는 것 뿐이지 데이터가 바뀌는 게 아니다.
-- 사실 inner join 에서는 이 순서가 상관없는데 outer 에서 중요함. 
-- 습관이 소스 테이블을 먼저두고. 타켓을 두로 두는 습관을 가지자. 이래야 아웃터 조인에서 안 헷갈림. 먼저 볼려고 하는 걸 앞에 두는 것. 주된 관심사가 dept면 그걸 먼저 오게 하고
select d.dept_id, d.dept_name, d.loc, e.emp_id, e.emp_name, e.job_id
from emp e join dept d on e.dept_id = d.dept_id
where d.loc = 'New York';

-- TODO 직원_ID(emp.emp_id), 이름(emp.emp_name), 업무_ID(emp.job_id), 업무명(job.job_title) 를 조회.
select e.emp_id, e.emp_name, e.job_id, j.job_title
from emp e join job j on e.job_id = j.job_id;
      
-- TODO: 직원 ID 가 200 인 직원의 직원_ID(emp.emp_id), 이름(emp.emp_name), 
-- 급여(emp.salary), 담당업무명(job.job_title), 소속부서이름(dept.dept_name)을 조회              
select e.emp_id, e.emp_name, e.salary, j.job_title
from emp e join job j on e.job_id = j.job_id -- 몇 개 든 이렇게 join 가능
			join dept d on e.dept_id = d.dept_id; -- 타켓 정보 테이블은 순서는 상관없다.

-- TODO: 'Shipping' 부서의 부서명(dept.dept_name), 위치(dept.loc), 
-- 소속 직원의 이름(emp.emp_name), 업무명(job.job_title)을 조회. 직원이름 내림차순으로 정렬
select d.dept_name, d.loc, e.emp_name, j.job_title
from dept d join emp e on d.dept_id = e.dept_id join job j on e.job_id = j.job_id
where d.dept_name = 'Shipping'
order by 3 desc;

-- TODO: 'San Francisco' 에 근무(dept.loc)하는 직원의 id(emp.emp_id), 
-- 이름(emp.emp_name), 입사일(emp.hire_date)를 조회 입사일은 'yyyy년 mm월 dd일' 형식으로 출력
select e.emp_id, e.emp_name, date_format(e.hire_date,'%Y년 %m월 %d일') "hire_date", d.loc
from dept d join emp e on d.dept_id = e.dept_id
where d.loc = 'San Francisco';

-- TODO 부서별 급여(salary)의 평균을 조회. 부서이름(dept.dept_name)과 급여평균을 출력. 급여 평균이 높은 순서로 정렬. 
-- 시애틀에 있는 마케팅 산프란에 있는 맠케팅 이렇게 데이터가 있을 수도 있다.
select d.dept_name, avg(salary) "급여평균"
from emp e join dept d on e.dept_id = d.dept_id
group by d.dept_id, d.dept_name -- dept_naeme이 Unique key 컬럼이 아님. 같은 이름에 다른 부서가 있을 수 있다. dept_id와 같이  group by로 묶어준다.
order by 2 desc;


-- TODO 직원의 ID(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 
-- 급여(emp.salary), 급여등급(salary_grade.grade), 소속부서명(dept.dept_name)을 조회. 등급 내림차순으로 정렬
select e.emp_id, e.emp_name, j.job_title, e.salary, concat(s.grade, '등급') "salary grade", d.dept_name
from emp e join job j  on e.job_id = j.job_id 
			join salary_grade s on e.salary between s.low_sal and s.high_sal --  업무적으로 풀어야 함. 뭘로 조인해야 할까. 직원 급여에 대해 등급에 맞게 행이
			join dept d on e.dept_id = d.dept_id
order by 5 desc;

-- TODO salary 등급(salary_grade.grade)이 1인 직원들이 부서별로 몇명있는지 조회. 직원수가 많은 부서 순서대로 정렬.
select d.dept_name, count(*) "급여등급이 1인 직원 수"
from emp e join salary_grade s on e.salary between s.low_sal and s.high_sal
			join dept d on d.dept_id = e.dept_id
where s.grade =1
group by d.dept_id, d.dept_name
order by 1 desc;


/* ****************************************************
Self 조인
- 물리적으로 하나의 테이블을 두개의 테이블처럼 조인하는 것.
**************************************************** */
-- 직원 ID가 101인 직원의 직원의 ID(emp.emp_id), 이름(emp.emp_name), 상사이름(emp.emp_name)을 조회
select e.emp_id, e.emp_name, m.emp_name
from emp e join emp m on e.mgr_id = m.emp_id
where e.emp_id = 101;
-- e : 부하 직원의 emp table. 부하직원에 대한 데이터
-- m : 상하 직원의 emp table. 상사직원에 대한 데이터



/* ****************************************************************************
외부 조인 (Outer Join)
- 불충분 조인
    - 조인 연산 조건을 만족하지 않는 행도 포함해서 합친다
종류 
 left  outer join: 구문상 소스 테이블이 왼쪽  -- 소스가 어디에 있는 지 알려준다.
 right outer join: 구문상 소스 테이블이 오른쪽
 full outer join:  둘다 소스 테이블 (Mysql은 지원하지 않는다. - union 연산을 이용해서 구현)

- 구문
from 테이블a [LEFT | RIGHT] OUTER JOIN 테이블b ON 조인조건
- OUTER는 생략 가능.

-----
-- join : inner join
-- left join: left outer join
-- right join : right outer join
**************************************************************************** */

-- null 인 부서가 없는 애들이 있는데 조인할 때 얘네가 빠져버린다. 
-- d.dept_id는 pk not null unique key인데 얘네는 null 값이 당연히 없다. 
-- e.dept_id  null인 애들이 빠져버림.
-- 모든 정보가 안 뜰 수가 있다.

-- 특정 부서에 소속된 직원의 정보 이상으로 부서에 소속되지 않은 null인 애들도 보고 싶다면 outer로 해야함.
-- 이때 소스 테이블은 무엇일까 -> 소스테입ㄹ의 모든 행은 다 보겠다.
-- 직원이면 다 보겠다. 타켓 정보 있든 없든 다 보겠다. 있으면 붙이고 아님 말고 
-- 없는 타켓 정보 붙일 대상이 없음. 없는 정보는  null 처리

-- 목적 : 나 소스 정보를 다 볼거야!!!!!!!!!! 있으면 주고 없으면 null 붙여.! // 조건만 만족하는 특정부서에 해당하는 값을 볼게 이럴 때  inner
select *
from emp e left join dept d on e.dept_id = d.dept_id
order by emp_id;

select count(*) -- why
from emp e right join dept d on e.dept_id = d.dept_id
order by emp_id;

-- 어떤 것이 소스테이블이냐 에 따라 테이블 아예 달라짐. 그래서 소스 타켓 구분을 잘 짓어야 한다.


-- 문제

-- 직원의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary), 부서명(dept.dept_name), 부서위치(dept.loc)를 조회. 
-- 부서가 없는 직원의 정보도 나오도록 조회. dept_name의 내림차순으로 정렬한다.
-- emp : source , dept : target
select e.emp_id, e.emp_name, e.salary, d.dept_name, d.loc 
from emp e left join dept d on e.dept_id = d.dept_id
order by 4 desc;
-- from dept d right join emp e on d.dept_id = e.dept_id -- 결과 동일함.


-- 전체! 모든 직원의 id(emp.emp_id), 이름(emp.emp_name), 부서_id(emp.dept_id)를 조회하는데
-- 부서_id가 80 인 직원들은 부서명(dept.dept_name)과 부서위치(dept.loc) 도 같이 출력한다. (부서 ID가 80이 아니면 null이 나오도록)
-- 행선택 조건이면 where, 조인 조건은 from에 // inner은 어디에 넣어도 상관없지만 outer 일때는 조건을 어디 붙일 지 생각해야 함.
 select e.emp_id, e.emp_name, e.dept_id, d.dept_name, d.loc
 from emp e left join dept d on e.dept_id = d.dept_id and d.dept_id=80 -- id 가 80 인 것만 붙여.! 그렇다면 안 붙인 빈공간은 null 로 채우게 됨
order by 3; 
-- left join 이니깐 소스테이블은 다 나오는 게 맞다. 근데  on 조건에 따라 타켓테이블 중 붙이는 게!! 행이, 데이터가 달라지는 것. 
--  join 조건은 여러 개 와도 된다 . and 연산자로.        
        
        
-- TODO: 직원_id(emp.emp_id)가 100, 110, 120, 130, 140인 
--  직원의 ID(emp.emp_id),이름(emp.emp_name), 업무명(job.job_title) 을 조회. 업무명이 없을 경우 '미배정' 으로 조회
select e.emp_id, e.emp_name, ifnull(j.job_title, '미배정') "job_title"
from emp e left join job j on e.job_id = j.job_id
where e.emp_id in (100,110,120,130,140);

-- TODO: 부서 ID(dept.dept_id), 부서이름(dept.dept_name)과 그 부서에 속한 직원들의 수를 조회. 
-- 직원이 없는 부서는 0이 나오도록 조회하고 직원수가 많은 부서 순서로 조회.
-- count(*) : 행수
select d.dept_id, d.dept_name, 
	  count(e.emp_id) "직원수" 
 --     count(*) "직원수" -- 이건 행을 세는 함수라 null로 된 값이여도 한 행으로 카운트 해서 1로 출력.
from dept d left join emp e on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name
order by 3 desc;

select *
from dept d left join emp e on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name
order by 3 desc;


-- TODO: EMP 테이블에서 부서_ID(emp.dept_id)가 90 인 모든 직원들의 id(emp.emp_id), 이름(emp.emp_name), 상사이름(emp.emp_name), 입사일(emp.hire_date)을 조회. 
-- 입사일은 yyyy/mm/dd 형식으로 출력
select e.emp_id, e.emp_name, m.emp_name "상사이름", date_format(e.hire_date, '%Y/%m/%d') "입사일"
from emp e left join emp m on e.mgr_id=m.emp_id
where e.dept_id = 90;



-- TODO 2003년~2005년 사이에 입사한 모든 직원의 id(emp.emp_id), 이름(emp.emp_name), 업무명(job.job_title), 급여(emp.salary), 입사일(emp.hire_date),
-- 상사이름(emp.emp_name), 상사의입사일(emp.hire_date), 소속부서이름(dept.dept_name), 부서위치(dept.loc)를 조회.
select e.emp_id, e.emp_name, j.job_title, e.salary, e.hire_date, m.emp_name "상사이름", m.hire_date "상사의 입사일", d.dept_name, d.loc 
from emp e left join job j on j.job_id = e.job_id
			left join dept d on e.dept_id = d.dept_id
            join emp m on e.mgr_id = m.emp_id
where year(e.hire_date) between 2003 and 2005;


-- 위 문제에서 상사의 소속부서이름, 부서위치를 물어본다고 했을 때 
-- 셀프 조인에서 들고온 상사의 테이블까지 합친 테이블에서, 부서 테이블에서 상사의 id와 동일하다는 조건을 두고 일치하는 행을 들고 오는 것. 
select e.emp_id, e.emp_name, j.job_title, e.salary, e.hire_date "직원 입사일", m.emp_name "상사이름", m.hire_date "상사의 입사일", d.dept_name, dm.dept_name "상사의 부서명", d.loc, dm.loc"상사의 근무지" 
from emp e left join job j on j.job_id = e.job_id
			left join dept d on e.dept_id = d.dept_id
            join emp m on e.mgr_id = m.emp_id
            left join dept dm on m.dept_id = d.dept_id
where year(e.hire_date) between 2003 and 2005;

select * from emp where emp_name = 'Nancy';
select * from dept where dept_id=100;










