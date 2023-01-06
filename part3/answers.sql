-- #1
SELECT count(enrollment.id) enrollments, name course_name
from enrollment
         join course c on enrollment.course = c.id
         join pet p on enrollment.pet = p.id
group by name
order by name;

-- #2
SELECT first_name, last_name, owner_first_name, owner_last_name, name course_name, instructor
from enrollment
         join pet p on enrollment.pet = p.id
         join course c on c.id = enrollment.course
         full join grade g on enrollment.id = g.enrollment
where g is null
  and current_date > c.month + 28;

-- #3
SELECT first_name,
       last_name,
       owner_first_name,
       owner_last_name,
       'financial hold'   hold_type,
       'tuition not paid' hold_description,
       month,
       current_date       hold_date,
       cost
from enrollment
         join pet p on enrollment.pet = p.id
         join course c on c.id = enrollment.course
where (select coalesce(sum(amount), cast(0 as money)) from payment where payment.enrollment = enrollment.id) < c.cost
UNION
SELECT first_name,
       last_name,
       owner_first_name,
       owner_last_name,
       'vaccination hold'   hold_type,
       'missing vaccination' hold_description,
       month,
       current_date       hold_date,
       cost
from enrollment
         join pet p on enrollment.pet = p.id
         join course c on c.id = enrollment.course
where (select vaccination from requirement where requirement.pet_type = p.type) not in (select name from vaccination where vaccination.pet = p.id);