CREATE TABLE `content_block` (
  `id` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tag` (`name`)
)