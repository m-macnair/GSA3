CREATE TABLE `album_remark_mess_cloud` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `foreign_id` int(4) unsigned NOT NULL,
  `mess_def_id` int(4) unsigned NOT NULL,
  `value` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  KEY `post_id` (`foreign_id`),
  KEY `tag_def_id` (`mess_def_id`),
  CONSTRAINT `album_remark_mess_cloud_ibfk_1` FOREIGN KEY (`foreign_id`) REFERENCES `album` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `album_remark_mess_cloud_ibfk_2` FOREIGN KEY (`mess_def_id`) REFERENCES `album_remark_mess_def` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)