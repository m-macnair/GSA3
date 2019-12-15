CREATE TABLE `song_lyrics` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `song_id` int(10) unsigned NOT NULL,
  `lyrics_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `song_id` (`song_id`),
  KEY `lyrics_id` (`lyrics_id`),
  CONSTRAINT `song_lyrics_ibfk_2` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `song_lyrics_ibfk_3` FOREIGN KEY (`lyrics_id`) REFERENCES `lyrics` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)