CREATE TABLE `track_tag_mess_cloud` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `track_id` int(4) unsigned NOT NULL,
  `tag_def_id` int(4) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `post_id` (`track_id`),
  KEY `tag_def_id` (`tag_def_id`),
  CONSTRAINT `track_tag_mess_cloud_ibfk_2` FOREIGN KEY (`tag_def_id`) REFERENCES `shared_tag_mess_def` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `track_tag_mess_cloud_ibfk_3` FOREIGN KEY (`track_id`) REFERENCES `track` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)