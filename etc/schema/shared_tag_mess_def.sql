CREATE TABLE `shared_tag_mess_def` (
  `id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin NOT NULL,
  `alias_for_def_id` int(11) unsigned DEFAULT NULL,
  `has_implications` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tag` (`name`),
  KEY `alias_for_id` (`alias_for_def_id`),
  CONSTRAINT `shared_tag_mess_def_ibfk_1` FOREIGN KEY (`alias_for_def_id`) REFERENCES `shared_tag_mess_def` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)