CREATE TABLE `track_collection_entry` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `track_id` int(4) unsigned NOT NULL,
  `track_collection_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tag_def_id` (`track_id`),
  KEY `track_collection_id` (`track_collection_id`),
  CONSTRAINT `track_collection_entry_ibfk_1` FOREIGN KEY (`track_id`) REFERENCES `track` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `track_collection_entry_ibfk_2` FOREIGN KEY (`track_collection_id`) REFERENCES `track_collection` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
)