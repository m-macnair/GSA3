CREATE TABLE `prototype_mess_cloud` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `foreign_id` int(4) unsigned NOT NULL,
  `mess_def_id` int(4) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `post_id` (`foreign_id`),
  KEY `tag_def_id` (`mess_def_id`)
)