CREATE TABLE IF NOT EXISTS `__EFMigrationsHistory` (
    `MigrationId` varchar(150) NOT NULL,
    `ProductVersion` varchar(32) NOT NULL,
    PRIMARY KEY (`MigrationId`)
);

START TRANSACTION;
IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20260724100852_InitialAccountSchema')
BEGIN
    CREATE TABLE `outbox_messages` (
        `id` char(36) NOT NULL,
        `type` varchar(500) NOT NULL,
        `content` longtext NOT NULL,
        `occurred_at_utc` datetime(6) NOT NULL,
        `processed_at_utc` datetime(6) NULL,
        `error` longtext NULL,
        PRIMARY KEY (`id`)
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20260724100852_InitialAccountSchema')
BEGIN
    CREATE TABLE `processed_messages` (
        `message_id` char(36) NOT NULL,
        `processed_at_utc` datetime(6) NOT NULL,
        PRIMARY KEY (`message_id`)
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20260724100852_InitialAccountSchema')
BEGIN
    CREATE TABLE `profiles` (
        `id` char(36) NOT NULL,
        `user_id` char(36) NOT NULL,
        `display_name` varchar(60) NOT NULL,
        `slug` varchar(80) NOT NULL,
        `bio` varchar(500) NULL,
        `avatar_public_id` varchar(255) NULL,
        `avatar_url` varchar(500) NULL,
        `country_code` varchar(2) NULL,
        `visibility` varchar(20) NOT NULL,
        `created_at_utc` datetime(6) NOT NULL,
        `updated_at_utc` datetime(6) NOT NULL,
        PRIMARY KEY (`id`)
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20260724100852_InitialAccountSchema')
BEGIN
    CREATE TABLE `profile_stats` (
        `profile_id` char(36) NOT NULL,
        `total_ascents` int NOT NULL,
        `distinct_peaks` int NOT NULL,
        `highest_altitude_m` int NOT NULL,
        `highest_peak_id` char(36) NULL,
        `highest_peak_name` varchar(200) NULL,
        `last_ascent_date` date NULL,
        `updated_at_utc` datetime(6) NOT NULL,
        PRIMARY KEY (`profile_id`),
        CONSTRAINT `FK_profile_stats_profiles_profile_id` FOREIGN KEY (`profile_id`) REFERENCES `profiles` (`id`) ON DELETE CASCADE
    );
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20260724100852_InitialAccountSchema')
BEGIN
    CREATE INDEX `ix_outbox_messages_processed_at_utc` ON `outbox_messages` (`processed_at_utc`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20260724100852_InitialAccountSchema')
BEGIN
    CREATE UNIQUE INDEX `ux_profiles_slug` ON `profiles` (`slug`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20260724100852_InitialAccountSchema')
BEGIN
    CREATE UNIQUE INDEX `ux_profiles_user_id` ON `profiles` (`user_id`);
END;

IF NOT EXISTS(SELECT * FROM `__EFMigrationsHistory` WHERE `MigrationId` = '20260724100852_InitialAccountSchema')
BEGIN
    INSERT INTO `__EFMigrationsHistory` (`MigrationId`, `ProductVersion`)
    VALUES ('20260724100852_InitialAccountSchema', '10.0.10');
END;

COMMIT;

