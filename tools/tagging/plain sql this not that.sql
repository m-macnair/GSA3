-- this = 'misato'
-- that = 'not_odoriko'


SELECT id  FROM `shared_tag_mess_def` WHERE `name` LIKE 'misato' 
SELECT id  FROM `shared_tag_mess_def` WHERE `name` LIKE 'not_odoriko' 

select * from
(
select track_id from track_tag_mess_cloud as c
	join shared_tag_mess_def as d on c.tag_def_id = d.id
	WHERE `name` LIKE 'misato'
)
 q1 left join 

(select track_id from track_tag_mess_cloud as c
	join shared_tag_mess_def as d on c.tag_def_id = d.id
	WHERE `name` LIKE 'not_odoriko'
)
 q2

using (track_id)
where q2.track_id IS NULL