CREATE TABLE `content_block_attribute_mess_cloud` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `content_block_id` int(4) unsigned NOT NULL,
  `block_attribute_id` int(10) unsigned NOT NULL,
  `value` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `content_block_id` (`content_block_id`),
  KEY `block_attribute_id` (`block_attribute_id`),
  CONSTRAINT `content_block_attribute_mess_cloud_ibfk_1` FOREIGN KEY (`content_block_id`) REFERENCES `content_block` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `content_block_attribute_mess_cloud_ibfk_2` FOREIGN KEY (`block_attribute_id`) REFERENCES `content_block_attribute_mess_def` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)