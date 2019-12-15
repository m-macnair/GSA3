CREATE TABLE `okazu_group_mess_def` (
  `id` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
)