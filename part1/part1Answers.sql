-- #1
select person_id,
       coalesce(preferred_first_name, first_name) REPORTING_NAME,
       last_name,
       date_of_birth,
       hire_date,
       occupation
from person;

-- #2
select *
from person
where occupation is null;

-- #3
select *
from person
where date_of_birth < to_date('08/07/1990', 'MM/dd/yyy');

-- #4
select *
from person
where hire_date >= CURRENT_DATE - 100;

-- #5
select *
from person
         join address a on person.person_id = a.person_id
where address_type = 'HOME';

-- #6
select p.person_id,
       first_name,
       preferred_first_name,
       last_name,
       date_of_birth,
       hire_date,
       occupation,
       address_id,
       coalesce(address_type, 'NONE') as address_type,
       street_line_1,
       city,
       state,
       zip
from person p
         left join address a on p.person_id = a.person_id and a.address_type = 'BILL';

-- #7
select address_type, count(address_type) count
from address
group by address_type;

-- #8
select p.last_name,
       (select concat(street_line_1, ', ', city, ', ', state, ' ', zip)
        from address
                 join person p2 on address.person_id = p2.person_id
        where address_type = 'HOME'
          and p2.person_id = p.person_id) home_address,
       (select concat(street_line_1, ', ', city, ', ', state, ' ', zip)
        from address
                 join person p2 on address.person_id = p2.person_id
        where address_type = 'BILL'
          and p2.person_id = p.person_id) billing_address
from person p;

-- #9
update person p
set occupation = 'X'
where (select count(address_id) from address a where a.person_id = p.person_id and address_type = 'BILL') > 0;