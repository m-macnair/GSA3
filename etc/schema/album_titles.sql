CREATE TABLE `album_titles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title_id` int(10) unsigned NOT NULL,
  `album_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `lyrics_id` (`title_id`),
  KEY `track_id` (`album_id`),
  CONSTRAINT `album_titles_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `album` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `album_titles_ibfk_2` FOREIGN KEY (`title_id`) REFERENCES `titles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)