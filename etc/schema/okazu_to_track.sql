CREATE TABLE `okazu_to_track` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `okazu_id` int(10) unsigned NOT NULL,
  `track_id` int(10) unsigned NOT NULL,
  `file_number` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `okazu_id_2` (`okazu_id`,`track_id`),
  KEY `album_id` (`track_id`),
  KEY `okazu_id` (`okazu_id`),
  CONSTRAINT `okazu_to_track_ibfk_1` FOREIGN KEY (`okazu_id`) REFERENCES `okazu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `okazu_to_track_ibfk_2` FOREIGN KEY (`track_id`) REFERENCES `track` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)