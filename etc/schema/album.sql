CREATE TABLE `album` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `tracks` tinyint(3) unsigned NOT NULL,
  `converted` int(11) DEFAULT NULL,
  `performer_id` int(10) unsigned DEFAULT NULL,
  `safe_title` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `title` (`title`),
  KEY `title_2` (`title`),
  KEY `performer_id` (`performer_id`),
  CONSTRAINT `album_ibfk_1` FOREIGN KEY (`performer_id`) REFERENCES `shared_performer_mess_def` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)