CREATE TABLE `okazu` (
  `md5` binary(16) NOT NULL,
  `content_block_id` int(4) unsigned DEFAULT NULL,
  `id` int(8) unsigned NOT NULL AUTO_INCREMENT,
  `mime_id` mediumint(8) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `resource_md` (`md5`),
  KEY `content_block_id` (`content_block_id`),
  KEY `mime_id` (`mime_id`),
  CONSTRAINT `okazu_ibfk_4` FOREIGN KEY (`mime_id`) REFERENCES `mime_mess_def` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `okazu_ibfk_5` FOREIGN KEY (`content_block_id`) REFERENCES `content_block` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
)