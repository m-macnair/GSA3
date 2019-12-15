CREATE TABLE `okazu_tag_imply` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `parent_def_id` int(4) unsigned NOT NULL,
  `child_def_id` int(4) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `post_id` (`parent_def_id`),
  KEY `tag_def_id` (`child_def_id`),
  CONSTRAINT `okazu_tag_imply_ibfk_1` FOREIGN KEY (`parent_def_id`) REFERENCES `shared_tag_mess_def` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `okazu_tag_imply_ibfk_2` FOREIGN KEY (`child_def_id`) REFERENCES `shared_tag_mess_def` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)