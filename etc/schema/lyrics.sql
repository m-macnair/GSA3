CREATE TABLE `lyrics` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `content` text COLLATE utf8_bin NOT NULL,
  `language` varchar(2) COLLATE utf8_bin NOT NULL,
  `meta1` varchar(16) COLLATE utf8_bin DEFAULT NULL,
  `meta2` varchar(16) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `language` (`language`),
  KEY `meta2` (`meta2`)
)