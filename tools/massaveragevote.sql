update `track_votes` v 
join track t on v.track_id = t.id 
set t.avg_vote = v.vote
where t.avg_vote is null