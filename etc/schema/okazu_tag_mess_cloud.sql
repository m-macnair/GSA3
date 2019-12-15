CREATE TABLE `okazu_tag_mess_cloud` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `okazu_id` int(4) unsigned NOT NULL,
  `tag_def_id` int(4) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `post_id` (`okazu_id`),
  KEY `tag_def_id` (`tag_def_id`),
  CONSTRAINT `okazu_tag_mess_cloud_ibfk_1` FOREIGN KEY (`tag_def_id`) REFERENCES `shared_tag_mess_def` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `okazu_tag_mess_cloud_ibfk_2` FOREIGN KEY (`okazu_id`) REFERENCES `okazu` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)