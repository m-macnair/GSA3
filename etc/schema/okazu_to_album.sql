CREATE TABLE `okazu_to_album` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `okazu_id` int(10) unsigned NOT NULL,
  `album_id` int(10) unsigned NOT NULL,
  `file_number` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `okazu_id` (`okazu_id`),
  KEY `album_id` (`album_id`),
  CONSTRAINT `okazu_to_album_ibfk_1` FOREIGN KEY (`okazu_id`) REFERENCES `okazu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `okazu_to_album_ibfk_2` FOREIGN KEY (`album_id`) REFERENCES `album` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)