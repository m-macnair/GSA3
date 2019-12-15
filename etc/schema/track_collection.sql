CREATE TABLE `track_collection` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(4) unsigned NOT NULL DEFAULT '1',
  `name` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `post_id` (`user_id`),
  KEY `name` (`name`)
)