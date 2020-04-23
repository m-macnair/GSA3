SET foreign_key_checks=0;

CREATE TABLE `album` (
  `id` integer unsigned NOT NULL auto_increment,
  `title` varchar(255) NULL,
  `tracks` tinyint unsigned NOT NULL,
  `converted` integer NULL,
  `performer_id` integer unsigned NULL,
  `safe_title` varchar(255) NULL,
  INDEX `album_idx_performer_id` (`performer_id`),
  PRIMARY KEY (`id`)

) ;

CREATE TABLE `album_remark_mess_cloud` (
  `id` integer unsigned NOT NULL auto_increment,
  `foreign_id` integer unsigned NOT NULL,
  `mess_def_id` integer unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  INDEX `album_remark_mess_cloud_idx_foreign_id` (`foreign_id`),
  INDEX `album_remark_mess_cloud_idx_mess_def_id` (`mess_def_id`),
  PRIMARY KEY (`id`)


) ;

CREATE TABLE `album_remark_mess_def` (
  `id` integer unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ;

CREATE TABLE `content_block` (
  `id` integer unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ;

CREATE TABLE `content_block_attribute_mess_cloud` (
  `id` mediumint unsigned NOT NULL auto_increment,
  `content_block_id` integer unsigned NOT NULL,
  `block_attribute_id` integer unsigned NOT NULL,
  `value` varchar(255) NULL,
  INDEX `content_block_attribute_mess_cloud_idx_block_attribute_id` (`block_attribute_id`),
  INDEX `content_block_attribute_mess_cloud_idx_content_block_id` (`content_block_id`),
  PRIMARY KEY (`id`)


) ;

CREATE TABLE `content_block_attribute_mess_def` (
  `id` integer unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ;

CREATE TABLE `mime_mess_def` (
  `id` mediumint unsigned NOT NULL auto_increment,
  `mime` varchar(32) NOT NULL,
  `extension` varchar(32) NULL,
  `class` varchar(32) NULL,
  PRIMARY KEY (`id`)
) ;

CREATE TABLE `okazu` (
  `md5` binary(16) NULL,
  `content_block_id` integer unsigned NULL,
  `id` integer unsigned NOT NULL auto_increment,
  `mime_id` mediumint unsigned NULL,
  INDEX `okazu_idx_content_block_id` (`content_block_id`),
  INDEX `okazu_idx_mime_id` (`mime_id`),
  PRIMARY KEY (`id`),
  UNIQUE `resource_md` (`md5`)


) ;

CREATE TABLE `okazu_attribute_mess_cloud` (
  `id` integer unsigned NOT NULL auto_increment,
  `okazu_id` integer unsigned NOT NULL,
  `okazu_attribute_id` integer unsigned NOT NULL,
  `value` varchar(255) NULL,
  INDEX `okazu_attribute_mess_cloud_idx_okazu_id` (`okazu_id`),
  INDEX `okazu_attribute_mess_cloud_idx_okazu_attribute_id` (`okazu_attribute_id`),
  PRIMARY KEY (`id`)


) ;

CREATE TABLE `okazu_attribute_mess_def` (
  `id` integer unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ;

CREATE TABLE `okazu_group_mess_cloud` (
  `id` integer unsigned NOT NULL auto_increment,
  `okazu_id` integer unsigned NOT NULL,
  `okazu_group_id` integer unsigned NOT NULL,
  `position` integer NULL,
  INDEX `okazu_group_mess_cloud_idx_okazu_id` (`okazu_id`),
  INDEX `okazu_group_mess_cloud_idx_okazu_group_id` (`okazu_group_id`),
  PRIMARY KEY (`id`)


) ;

CREATE TABLE `okazu_group_mess_def` (
  `id` integer unsigned NOT NULL auto_increment,
  `name` varchar(255) NULL,
  PRIMARY KEY (`id`)
) ;

CREATE TABLE `okazu_tag_imply` (
  `id` integer unsigned NOT NULL auto_increment,
  `parent_def_id` integer unsigned NOT NULL,
  `child_def_id` integer unsigned NOT NULL,
  INDEX `okazu_tag_imply_idx_child_def_id` (`child_def_id`),
  INDEX `okazu_tag_imply_idx_parent_def_id` (`parent_def_id`),
  PRIMARY KEY (`id`)


) ;

CREATE TABLE `okazu_tag_mess_cloud` (
  `id` integer unsigned NOT NULL auto_increment,
  `okazu_id` integer unsigned NOT NULL,
  `tag_def_id` integer unsigned NOT NULL,
  INDEX `okazu_tag_mess_cloud_idx_okazu_id` (`okazu_id`),
  INDEX `okazu_tag_mess_cloud_idx_tag_def_id` (`tag_def_id`),
  PRIMARY KEY (`id`)


) ;

CREATE TABLE `okazu_to_album` (
  `id` integer unsigned NOT NULL auto_increment,
  `okazu_id` integer unsigned NOT NULL,
  `album_id` integer unsigned NOT NULL,
  `file_number` integer NULL,
  INDEX `okazu_to_album_idx_album_id` (`album_id`),
  INDEX `okazu_to_album_idx_okazu_id` (`okazu_id`),
  PRIMARY KEY (`id`)


) ;

CREATE TABLE `okazu_to_track` (
  `id` integer unsigned NOT NULL auto_increment,
  `okazu_id` integer unsigned NOT NULL,
  `track_id` integer unsigned NOT NULL,
  `file_number` integer unsigned NULL,
  INDEX `okazu_to_track_idx_okazu_id` (`okazu_id`),
  INDEX `okazu_to_track_idx_track_id` (`track_id`),
  PRIMARY KEY (`id`),
  UNIQUE `okazu_id_2` (`okazu_id`, `track_id`)


) ;

CREATE TABLE `prototype_mess_cloud` (
  `id` integer unsigned NOT NULL auto_increment,
  `foreign_id` integer unsigned NOT NULL,
  `mess_def_id` integer unsigned NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `prototype_mess_def` (
  `id` integer unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `shared_performer_mess_def` (
  `id` integer unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ;

CREATE TABLE `shared_tag_mess_def` (
  `id` integer unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `alias_for_def_id` integer unsigned NULL,
  `has_implications` tinyint NULL,
  INDEX `shared_tag_mess_def_idx_alias_for_def_id` (`alias_for_def_id`),
  PRIMARY KEY (`id`)

) ;

CREATE TABLE `songs` (
  `id` integer unsigned NOT NULL auto_increment,
  `name` text NOT NULL,
  PRIMARY KEY (`id`)
) ;

CREATE TABLE `track` (
  `id` integer unsigned NOT NULL auto_increment,
  `title` varchar(255) NOT NULL,
  `album_id` integer unsigned NULL,
  `track_no` tinyint unsigned NOT NULL,
  `performer_id` integer unsigned NULL,
  `avg_vote` tinyint unsigned NULL,
  `song_id` integer unsigned NULL,
  `safe_title` varchar(255) NULL,
  INDEX `track_idx_album_id` (`album_id`),
  INDEX `track_idx_performer_id` (`performer_id`),
  INDEX `track_idx_song_id` (`song_id`),
  PRIMARY KEY (`id`),
  UNIQUE `album_id_2` (`album_id`, `track_no`)



) ;

CREATE TABLE `track_metadata` (
  `track_id` integer unsigned NOT NULL auto_increment,
  `data` text NOT NULL,
  INDEX (`track_id`),
  PRIMARY KEY (`track_id`)

) ;

CREATE TABLE `track_tag_mess_cloud` (
  `id` integer unsigned NOT NULL auto_increment,
  `track_id` integer unsigned NOT NULL,
  `tag_def_id` integer unsigned NOT NULL,
  INDEX `track_tag_mess_cloud_idx_tag_def_id` (`tag_def_id`),
  INDEX `track_tag_mess_cloud_idx_track_id` (`track_id`),
  PRIMARY KEY (`id`)


) ;

CREATE TABLE `track_votes` (
  `id` integer unsigned NOT NULL auto_increment,
  `user_id` integer unsigned NOT NULL DEFAULT 1,
  `track_id` integer unsigned NOT NULL,
  `vote` tinyint unsigned NOT NULL,
  `date_int` integer unsigned NOT NULL,
  INDEX `track_votes_idx_track_id` (`track_id`),
  PRIMARY KEY (`id`),
  UNIQUE `unique_vote` (`user_id`, `track_id`)

) ;

CREATE TABLE `translation_mess_cloud` (
  `id` integer unsigned NOT NULL auto_increment,
  `foreign_id` integer unsigned NOT NULL,
  `mess_def_id` integer unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `translation_mess_def` (
  `id` integer unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `translations` (
  `id` integer unsigned NOT NULL auto_increment,
  `song_id` integer unsigned NOT NULL,
  `translation` text NOT NULL,
  `type` integer unsigned NULL,
  INDEX `translations_idx_song_id` (`song_id`),
  PRIMARY KEY (`id`)

) ;

SET foreign_key_checks=1;


