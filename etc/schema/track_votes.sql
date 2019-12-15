CREATE TABLE `track_votes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(4) unsigned NOT NULL DEFAULT '1',
  `track_id` int(4) unsigned NOT NULL,
  `vote` tinyint(3) unsigned NOT NULL,
  `date_int` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_vote` (`user_id`,`track_id`),
  KEY `post_id` (`user_id`),
  KEY `tag_def_id` (`track_id`),
  CONSTRAINT `track_votes_ibfk_1` FOREIGN KEY (`track_id`) REFERENCES `track` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)