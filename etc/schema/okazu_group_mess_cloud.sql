CREATE TABLE `okazu_group_mess_cloud` (
  `id` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `okazu_id` int(4) unsigned NOT NULL,
  `okazu_group_id` int(4) unsigned NOT NULL,
  `position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `foreign_id` (`okazu_id`),
  KEY `group_id` (`okazu_group_id`),
  KEY `position` (`position`),
  CONSTRAINT `okazu_group_mess_cloud_ibfk_3` FOREIGN KEY (`okazu_id`) REFERENCES `okazu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `okazu_group_mess_cloud_ibfk_4` FOREIGN KEY (`okazu_group_id`) REFERENCES `okazu_group_mess_def` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)