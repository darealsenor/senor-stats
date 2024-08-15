CREATE TABLE `players_stats` (
	`identifier` VARCHAR(80) NOT NULL COLLATE 'utf8mb4_general_ci',
	`kills` INT(11) NOT NULL DEFAULT '0',
	`deaths` INT(11) NOT NULL DEFAULT '0',
	`headshot` INT(11) NOT NULL DEFAULT '0',
	`playtime` INT(11) NOT NULL DEFAULT '0',
	`dpi` INT(11) NULL DEFAULT '0',
	`sens` INT(11) NULL DEFAULT '0',
	`airdrop` INT(11) NULL DEFAULT '0',
	`war` INT(11) NULL DEFAULT '0',
	`name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`identifier`) USING BTREE,
	INDEX `Btree` (`kills`, `deaths`, `headshot`) USING BTREE,
	CONSTRAINT `fk_players_stats_players` FOREIGN KEY (`identifier`) REFERENCES `players` (`license`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	CONSTRAINT `Above 0 Kills` CHECK (`kills` >= 0),
	CONSTRAINT `Above 0 Deaths` CHECK (`deaths` >= 0),
	CONSTRAINT `Above 0 HS` CHECK (`headshot` >= 0)
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
