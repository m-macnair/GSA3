CREATE TABLE `song_titles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `song_id` int(10) unsigned NOT NULL,
  `title_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `song_id` (`song_id`),
  KEY `lyrics_id` (`title_id`),
  CONSTRAINT `song_titles_ibfk_1` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `song_titles_ibfk_2` FOREIGN KEY (`title_id`) REFERENCES `titles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)