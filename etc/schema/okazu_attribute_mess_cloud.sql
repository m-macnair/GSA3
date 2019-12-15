CREATE TABLE `okazu_attribute_mess_cloud` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `okazu_id` int(4) unsigned NOT NULL,
  `okazu_attribute_id` int(4) unsigned NOT NULL,
  `value` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `okazu_id` (`okazu_id`),
  KEY `okazu_attribute_id` (`okazu_attribute_id`),
  CONSTRAINT `okazu_attribute_mess_cloud_ibfk_1` FOREIGN KEY (`okazu_id`) REFERENCES `okazu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `okazu_attribute_mess_cloud_ibfk_2` FOREIGN KEY (`okazu_attribute_id`) REFERENCES `okazu_attribute_mess_def` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)