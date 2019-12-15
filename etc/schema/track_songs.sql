CREATE TABLE `track_songs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `song_id` int(10) unsigned NOT NULL,
  `track_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `lyrics_id` (`song_id`),
  KEY `track_id` (`track_id`),
  CONSTRAINT `track_songs_ibfk_1` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `track_songs_ibfk_2` FOREIGN KEY (`track_id`) REFERENCES `track` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)