CREATE TABLE `track_lyrics` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lyrics_id` int(10) unsigned NOT NULL,
  `track_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `lyrics_id` (`lyrics_id`),
  KEY `track_id` (`track_id`),
  CONSTRAINT `track_lyrics_ibfk_2` FOREIGN KEY (`track_id`) REFERENCES `track` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `track_lyrics_ibfk_3` FOREIGN KEY (`lyrics_id`) REFERENCES `lyrics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)