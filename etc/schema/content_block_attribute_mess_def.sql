CREATE TABLE `content_block_attribute_mess_def` (
  `id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tag` (`name`)
)