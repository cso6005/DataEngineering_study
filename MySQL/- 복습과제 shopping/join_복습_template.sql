/*
1. 제품 테이블은 제품_ID 컬럼이 __Primart Key(PK)__ 컬럼으로 그 행을 다른 행과 식별할 때 사용된다.
2. 제품 테이블의 제조사 컬럼은 Not Null(NN) 인 것으로 봐서 __Null(값이 없는)_ 인 상태일 수가 없다.
3. 고객 테이블에서 다른행과 식별할 때 사용하는 컬럼은 __cust_id 이다. 
4. 고객 테이블의 전화번호 컬럼의 데이터 타입은 __VARCHAR(15)__ 으로 _문자열 형태의 값 _15글자__ 저장할 수 있으며 NULL 값을 __가질 수 있다._.
5. 고객 테이블의 가입일 컬럼에 대해 4번 처럼 설명해 보시오. DATE 로 날짜 형태의 값을 저장할 수 있으며 NULL 값을 넣을 수 없다.
6. 주문 테이블은 총 5개 컬럼이 있다. 정수 타입이 __3 개이고 문자열 타입이 __1__개 이고 날짜 타입이 ___1___개이다.
7. 고객 테이블과 주문테이블은 서로 관계가 있는 테이블입니다.
    부모테이블은 ____customers___ 이고 자식 테이블은 _____orders______이다.
    부모테이블의 ____cust_id___컬럼을 자식테이블의 ____cust_id_____컬럼이 참조하고 있다.
    고객테이블의 한행의 데이터는 주문테이블의 ____1~n_______ 행과 관계가 있을 수 있다.
    주문테이블의 한행은 고객테이블의 ______1_______행과 관계가 있을 수 있다.
8. 주문 테이블과 주문_제품 테이블은 서로 관계가 있는 테이블입니다.
    부모 테이블은 ___orders_____ 이고 자식 테이블은 ____order_items_____이다.
    부모 테이블의 ___orders.order_id(PK)_____컬럼을 자식 테이블의 ___order_items.order_id(FK)____컬럼이 참조하고 있다.
    주문 테이블의 한행의 데이터는 주문_제품 테이블의 ____1~n__ 행과 관계가 있을 수 있다.
    주문_제품 테이블의 한행은 주문 테이블의 ___1___행과 관계가 있을 수 있다.
9. 제품과 주문_제품은 서로 관계가 있는 테이블입니다. 
    부모 테이블은 ___products_____ 이고 자식 테이블은 ___order_items__이다.
    부모 테이블의 ___products_id(PK)___컬럼을 자식 테이블의 __order_itmes.products_id(PK)____컬럼이 참조하고 있다.
    제품 테이블의 한행의 데이터는 주문_제품 테이블의 __1~n__ 행과 관계가 있을 수 있다.
    주문_제품 테이블의 한행은 제품 테이블의 __1___행과 관계가 있을 수 있다.
*/

-- TODO: 4개의 테이블에 어떤 값들이 있는지 확인.
select * from customers;
select * from order_items;
select * from orders;
select * from products;

-- TODO: 주문 번호가 1인 주문의 주문자 이름, 주소, 우편번호, 전화번호 조회
select c.cust_name, c.address, c.postal_code, c.phone_number
from customers c join orders o on c.cust_id = o.cust_id -- not null이고 모든 주문을 다 보는 게 아니라 inner 조인해도 됨.
where o.order_id = 1;


-- TODO : 주문 번호가 2인 주문의 주문일, 주문상태, 총금액, / 주문고객 이름, 주문고객 이메일 주소 조회
select o.order_date, o.order_status, o.order_total, c.cust_name, c.cust_email
from orders o join customers c on c.cust_id = o.cust_id
where o.order_id = 2;

-- TODO : 고객 ID가 120인 고객의 이름, 성별, 가입일과 / 지금까지 주문한 주문정보중 주문_ID, 주문일, 총금액을 조회
-- 만약 한 번도 주문을 안한 고객일 수 있다. 그래서 outer join 하자.
select c.cust_id, c.cust_name, c.gender, c.join_date, o.order_id, o.order_date, o.order_total
from customers c left join orders o on c.cust_id = o.cust_id where c.cust_id =120;
-- 왜 on 조건으로 120 id 넣었을 때 안될까,,


-- TODO : 고객 ID가 110인 고객의 이름, 주소, 전화번호, 그가 지금까지 주문한 주문정보중 주문_ID, 주문일, 주문상태 조회
-- 만약 한 번도 주문을 안한 고객일 수 있다. 그래서 outer join 하자.
 select c.cust_name, c.address, c.phone_number, o.order_id, o.order_date, o.order_status
from customers c left join orders o on c.cust_id = o.cust_id
where c.cust_id = 110;


-- TODO : 고객 ID가 120인 고객의 정보와 지금까지 주문한 주문정보를 모두 조회.
select *
from customers c join orders o on c.cust_id = o.cust_id and c.cust_id = 120;

-- 주문정보 정보 조회. customers의 모든 컬럼 조회. -- 테이블명(별칭).* : 지정한 테이블의 모든 컬럼
select c.*
from customers c join orders o on c.cust_id = o.cust_id and c.cust_id = 120;


-- TODO : '2017/11/13'(주문날짜) 에 주문된 주문의 주문고객의 고객_ID, 이름, 주문상태, 총금액을 조회
-- inner 나 outer 나 무관. 특정 날짜 주문 내용이라서.
select c.cust_id, c.cust_name, o.order_status, o.order_total
from customers c join orders o on c.cust_id = o.cust_id and o.order_date='2017-11-13';


-- TODO : 주문상세 ID가 xxxx(임의의 id)인 주문제품의 제품이름, 판매가격, 제품가격을 조회.
-- 
select p.product_name, oi.sell_price "판매가격", p.price "제품가격"
from order_items oi join products p on oi.product_id = p.product_id
where oi.order_item_id =19; -- 주문 상세 ID

-- TODO : 주문 ID가 4 (orders)인 주문의 주문 고객의 이름, 주소, 우편번호, (cust)/ 주문일, 주문상태, 총금액, (orders)/주문 제품이름, 제조사, 제품가격, (prod)/판매가격, 제품수량(order_items)을 조회.
select *
from customers c join orders o on c.cust_id = o.cust_id and o.order_id = 4
				join order_items oi on o.order_id = oi.order_id
                join products p on oi.product_id = p.product_id;
                
-- 강사님은 order을 소스 기준으로
select c.cust_name, c.address, c.postal_code,
		o.order_date, o.order_status, o.order_total,
        p.product_name, p.maker, p.price,
        oi.sell_price, oi.quantity
from orders o join customers c  on c.cust_id = o.cust_id
			join order_items oi on o.order_id = oi.order_id
            join products p on oi.product_id = p.product_id
where o.order_id = 4;



-- TODO : 제품 ID가 200인 제품이 2017년에 몇개 주문되었는지 조회.
select sum(quantity) "총 주문 수량", count(*) "주문량"
from order_items oi join orders o on oi.order_id = o.order_id
where product_id = 200 and year(o.order_date) = 2017;


-- TODO : 제품분류별 총 주문량을 조회 (카테고리 별로 몇 개 주문되었는지)
select p.category, ifnull(sum(quantity), 0) "총주문량"
from products p left join order_items oi on p.product_id = oi.product_id
group by p.category;

select * from order_items ; 