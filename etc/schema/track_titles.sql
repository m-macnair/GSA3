CREATE TABLE `track_titles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title_id` int(10) unsigned NOT NULL,
  `track_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `lyrics_id` (`title_id`),
  KEY `track_id` (`track_id`),
  CONSTRAINT `track_titles_ibfk_1` FOREIGN KEY (`title_id`) REFERENCES `titles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `track_titles_ibfk_2` FOREIGN KEY (`track_id`) REFERENCES `track` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)