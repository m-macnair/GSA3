CREATE TABLE `titles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `language` varchar(2) COLLATE utf8_bin NOT NULL,
  `meta1` varchar(16) COLLATE utf8_bin DEFAULT NULL,
  `meta2` varchar(16) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `title` (`title`),
  KEY `language` (`language`),
  KEY `meta` (`meta1`),
  KEY `meta2` (`meta2`)
)