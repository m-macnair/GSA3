CREATE TABLE `mime_mess_def` (
  `id` mediumint(2) unsigned NOT NULL AUTO_INCREMENT,
  `mime` varchar(32) COLLATE utf8_bin NOT NULL,
  `extension` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  `class` varchar(32) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
)