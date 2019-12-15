CREATE TABLE `track` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_bin NOT NULL,
  `album_id` int(10) unsigned DEFAULT NULL,
  `track_no` tinyint(3) unsigned NOT NULL,
  `performer_id` int(10) unsigned DEFAULT NULL,
  `avg_vote` tinyint(3) unsigned DEFAULT NULL,
  `safe_title` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `album_id_2` (`album_id`,`track_no`),
  KEY `album_id` (`album_id`),
  KEY `performer_id` (`performer_id`),
  CONSTRAINT `track_ibfk_3` FOREIGN KEY (`performer_id`) REFERENCES `shared_performer_mess_def` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `track_ibfk_4` FOREIGN KEY (`album_id`) REFERENCES `album` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)