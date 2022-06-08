/* ****************************************************
집합 연산자 (결합 쿼리)
- 둘 이상의 select 결과를 합치는 연산
- 구문
 select문  집합연산자 select문 [집합연산자 select문 ...] [order by 정렬컬럼 정렬방식]

-연산자
  - UNION: 두 select 결과를 하나로 결합한다. 단 중복되는 행은 제거한다. 
  - UNION ALL : 두 select 결과를 하나로 결합한다. 중복되는 행을 포함한다. 
   
   - 오라클에서는 더 있는데 mysql에는 두 가지 있다.
   
 - 규칙
  - 연산대상 select 문의 컬럼 수가 같아야 한다. 
  - 연산대상 select 문의 컬럼의 타입이 같아야 한다. 컬럼은 같은 속성타입이기 때문에 한 컬럼에 대한 타입이 당연히 같아야 한다.
  - 연산 결과의 컬럼이름은 첫번째 (왼쪽) select문의 것을 따른다.
  - order by 절은 구문의 마지막에 넣을 수 있다. 한 select에 대해 정렬하고 한 select에 또 정렬하고 이게 아니라 다 합치고 나서 마지막에 정렬한다.
*******************************************************/

-- select 결과 표를 합치는 것. 
-- union : set 같은 집합
select 10, 20
union
select 100, 200
union
select 100, 200 -- 전체 행 값이 모두 중복이면 제거.
union
select 100, 2000;

-- all union : 데이터 결과 행 합치기
select 10, 20
union all
select 100, 200
union all
select 100, 200 -- 전체 행 값이 모두 중복이면 제거.
union all
select 100, 2000;


-- emp 테이블의 salary 최대값와 salary 최소값, salary 평균값 조회
use hr_join;

select '최댓값' as "label", max(salary) as "통계값" from emp  -- 값을 명시적으로 할 때는 별칭 as 붙이기.
union all
select '평균값', min(salary) from emp
union all
select '평균값', avg(salary) from emp
order by 2;


-- full outer join
-- A 조인 B : A,B 둘다 SOURCE table인 경우. 둘 다 데이터 행 다 보고 싶다.
-- A left join B unoion A right join B
select * 
from emp e left join dept d on e.dept_id = d.dept_id -- 이건 emp전부와 emp가 참조하는 dept 값 나오고 빈 공간 부서없는 직원은 dept 데이터들 null로.
union -- 중복된 값 빼야한다. -- union all 하면 중복된 값 겹쳐 나옴. 
select *
from emp e right join dept d on e.dept_id = d.dept_id; -- 이건 dept 전부나오고 dept와 관계짓어진 emp 행 나오고 직원 없는 부서는 emp 데이터들 null로 