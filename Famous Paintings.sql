create database painting;
use painting;
select * from artist;
select * from canvas_size;
select * from image_link;
select * from museum;
select * from museum_hours;
select * from product_size;
select * from subject;
select * from work;
use painting;

##1 Fetch all the paintings which are not displayed on any museums?
select * from museum;
select * from museum where museum_id is null;

##2 Are there museums without any paintings?
select * 
from museum m 
left join work w 
on m.museum_id = w.museum_id
where w.work_id is null;

##3 How many paintings have an asking price of more than their regular price?
select count(*) as total from product_size where sale_price > regular_price; 

##4 Identify the painting whose asking price is less than 50% of its regular price?
select * from product_size
WHERE sale_price < (0.5 * regular_price);

##5 Which canva size costs the most?
select c.label , p.sale_price
from product_size p
join canvas_size c
ON p.size_id = c.size_id
group by c.label , p.sale_price
having max(p.sale_price)
order by p.sale_price desc
limit 1;

##6 Fetch the  top 10 most famous painting subject?
select distinct subject, count(*)
from subject s
join work w on s.work_id = w.work_id
group by subject
order by count(*)desc 
limit 10;


##7 Identify the museums which are open on both Sunday and Monday. Display museum name, city.
select m.name as museum_name , m.city
from museum_hours mh1
join museum m on m.museum_id = mh1.museum_id
where day = 'Sunday'
and exists (select 1 from museum_hours mh2
where mh2.museum_id = mh1.museum_id 
and mh2.day = 'Monday');


##8  How many museums are open every single day?
select count(*) from
(select museum_id,COUNT(museum_id)
from museum_hours
group by museum_id
having COUNT(day) =7)a; 


##9 A Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)?
select m.museum_id , m.name,
count(*) as no_of_painting
from museum m 
join work w
on m.museum_id = w.museum_id
group by  m.museum_id , m.name
order by count(*)desc
limit 5;

##10 Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)?
select a.full_name , a.nationality , count(*)as no_of_painting
from artist a
join work w 
on a.artist_id = w.artist_id
group by a.full_name , a.nationality
order by count(*)desc
limit 5;

##11 A Which museum has the most no of most popular painting style?
select m.name, w.style , count(*) as no_of_paint
from museum m 
join work w 
on m.museum_id = w.museum_id
group by m.name, w.style
order by count(*) desc
limit 1;

##12 Identify the artists whose paintings are displayed in multiple countries?
select a.full_name , a.style , count(*) as no_of_painting
from artist a 
join work w 
on a.artist_id = w.artist_id
join museum m on m.museum_id = w.museum_id
group by a.full_name , a.style
order by count(*) desc
limit 5;


##13 A Which country has the 5th highest no of paintings?
select m.country , count(*) as no_of_painting
from artist a 
join work w on 
a.artist_id = w.artist_id
join museum m on m.museum_id = w.museum_id
group by m.country
order by count(*) desc 
limit 1
offset 4 ;


##14 A Which are the 3 most popular and 3 least popular painting styles?
(select style , count(*) as no_of_painting, 'Most Popular' as remarks
from work 
group by style
order by count(*) desc
limit 3)
UNION
(select style , count(*) as no_of_painting , 'Least Popular' as remarks
from work 
group by style
order by count(*) desc
limit 3);





