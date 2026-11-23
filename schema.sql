/*
 Navicat Premium Dump SQL

 Source Server         : Bazy Danych lokalnie
 Source Server Type    : MySQL
 Source Server Version : 100432 (10.4.32-MariaDB)
 Source Host           : localhost:3306
 Source Schema         : project

 Target Server Type    : MySQL
 Target Server Version : 100432 (10.4.32-MariaDB)
 File Encoding         : 65001

 Date: 20/11/2026 09:40:08
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for club_leagues
-- ----------------------------
DROP TABLE IF EXISTS `club_leagues`;
CREATE TABLE `club_leagues`  (
  `id_club` int UNSIGNED NOT NULL,
  `id_league` int UNSIGNED NOT NULL,
  PRIMARY KEY (`id_club`, `id_league`) USING BTREE,
  INDEX `fk_club_leagues_league`(`id_league` ASC) USING BTREE,
  CONSTRAINT `fk_club_leagues_club` FOREIGN KEY (`id_club`) REFERENCES `clubs` (`id_club`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_club_leagues_league` FOREIGN KEY (`id_league`) REFERENCES `leagues` (`id_league`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for clubs
-- ----------------------------
DROP TABLE IF EXISTS `clubs`;
CREATE TABLE `clubs`  (
  `id_club` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `club_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `stadium_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `id_country` int UNSIGNED NOT NULL,
  `is_national_team` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_club`) USING BTREE,
  INDEX `clubs_ibfk_1`(`id_country` ASC) USING BTREE,
  CONSTRAINT `clubs_ibfk_1` FOREIGN KEY (`id_country`) REFERENCES `countries` (`id_country`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1046 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;


-- ----------------------------
-- Table structure for comments
-- ----------------------------
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments`  (
  `id_comment` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_user` int UNSIGNED NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `creation_date` datetime NOT NULL,
  PRIMARY KEY (`id_comment`) USING BTREE,
  INDEX `id_user`(`id_user` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of comments
-- ----------------------------

-- ----------------------------
-- Table structure for countries
-- ----------------------------
DROP TABLE IF EXISTS `countries`;
CREATE TABLE `countries`  (
  `id_country` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name_country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `federation_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `confederation_country` enum('UEFA','CONMEBOL','CONCACAF','FIFA','OFC','AFC','CAF') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id_country`) USING BTREE,
  UNIQUE INDEX `uq_federation_name`(`federation_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 212 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for game_lineups
-- ----------------------------
DROP TABLE IF EXISTS `game_lineups`;
CREATE TABLE `game_lineups`  (
  `id_game` int UNSIGNED NOT NULL,
  `id_player` int UNSIGNED NOT NULL,
  `id_club` int UNSIGNED NOT NULL,
  `id_position` int UNSIGNED NULL DEFAULT NULL,
  `is_starting` tinyint(1) NOT NULL DEFAULT 1,
  `minute_in` tinyint UNSIGNED NULL DEFAULT NULL,
  `minute_out` tinyint UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id_game`, `id_player`) USING BTREE,
  INDEX `fk_lineups_player`(`id_player` ASC) USING BTREE,
  INDEX `fk_lineups_club`(`id_club` ASC) USING BTREE,
  INDEX `fk_lineups_position`(`id_position` ASC) USING BTREE,
  CONSTRAINT `fk_lineups_club` FOREIGN KEY (`id_club`) REFERENCES `clubs` (`id_club`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_lineups_game` FOREIGN KEY (`id_game`) REFERENCES `games` (`id_game`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_lineups_player` FOREIGN KEY (`id_player`) REFERENCES `players` (`id_player`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_lineups_position` FOREIGN KEY (`id_position`) REFERENCES `positions` (`id_position`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for games
-- ----------------------------
DROP TABLE IF EXISTS `games`;
CREATE TABLE `games`  (
  `id_game` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_home_club` int UNSIGNED NOT NULL,
  `id_away_club` int UNSIGNED NOT NULL,
  `game_date` datetime NOT NULL,
  `status` enum('scheduled','in_progress','finished','postponed','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'scheduled',
  `id_league` int UNSIGNED NOT NULL,
  PRIMARY KEY (`id_game`) USING BTREE,
  INDEX `id_home_club`(`id_home_club` ASC) USING BTREE,
  INDEX `id_away_club`(`id_away_club` ASC) USING BTREE,
  INDEX `id_league`(`id_league` ASC) USING BTREE,
  CONSTRAINT `games_ibfk_1` FOREIGN KEY (`id_home_club`) REFERENCES `clubs` (`id_club`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `games_ibfk_2` FOREIGN KEY (`id_away_club`) REFERENCES `clubs` (`id_club`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `games_ibfk_3` FOREIGN KEY (`id_league`) REFERENCES `leagues` (`id_league`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `games_different_clubs` CHECK (`id_home_club` <> `id_away_club`)
) ENGINE = InnoDB AUTO_INCREMENT = 241 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;


-- ----------------------------
-- Table structure for goal_history
-- ----------------------------
DROP TABLE IF EXISTS `goal_history`;
CREATE TABLE `goal_history`  (
  `id_goal_history` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_game` int UNSIGNED NOT NULL,
  `id_player` int UNSIGNED NOT NULL,
  `id_credited_club` int UNSIGNED NOT NULL,
  `is_own_goal` tinyint(1) NOT NULL DEFAULT 0,
  `minute` tinyint UNSIGNED NOT NULL,
  PRIMARY KEY (`id_goal_history`) USING BTREE,
  INDEX `goal_history_game_club`(`id_game` ASC, `id_credited_club` ASC) USING BTREE,
  INDEX `id_player`(`id_player` ASC) USING BTREE,
  INDEX `id_credited_club`(`id_credited_club` ASC) USING BTREE,
  CONSTRAINT `goal_history_ibfk_1` FOREIGN KEY (`id_game`) REFERENCES `games` (`id_game`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `goal_history_ibfk_2` FOREIGN KEY (`id_player`) REFERENCES `players` (`id_player`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `goal_history_ibfk_3` FOREIGN KEY (`id_credited_club`) REFERENCES `clubs` (`id_club`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 205 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for injuries
-- ----------------------------
DROP TABLE IF EXISTS `injuries`;
CREATE TABLE `injuries`  (
  `id_injury` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_player` int UNSIGNED NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `start_date` date NOT NULL,
  `end_date` date NULL DEFAULT NULL,
  PRIMARY KEY (`id_injury`) USING BTREE,
  INDEX `id_player`(`id_player` ASC) USING BTREE,
  CONSTRAINT `injuries_ibfk_1` FOREIGN KEY (`id_player`) REFERENCES `players` (`id_player`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `injuries_valid_dates` CHECK (`end_date` is null or `end_date` >= `start_date`)
) ENGINE = InnoDB AUTO_INCREMENT = 156 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for jersey_history
-- ----------------------------
DROP TABLE IF EXISTS `jersey_history`;
CREATE TABLE `jersey_history`  (
  `id_jersey_history` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_player` int UNSIGNED NOT NULL,
  `id_club` int UNSIGNED NULL DEFAULT NULL,
  `jersey_nr` tinyint UNSIGNED NOT NULL,
  `jersey_date` date NOT NULL,
  PRIMARY KEY (`id_jersey_history`) USING BTREE,
  INDEX `fk_jersey_history_player`(`id_player` ASC) USING BTREE,
  INDEX `fk_jersey_history_club`(`id_club` ASC) USING BTREE,
  CONSTRAINT `fk_jersey_history_club` FOREIGN KEY (`id_club`) REFERENCES `clubs` (`id_club`) ON DELETE NO ACTION ON UPDATE RESTRICT,
  CONSTRAINT `fk_jersey_history_player` FOREIGN KEY (`id_player`) REFERENCES `players` (`id_player`) ON DELETE NO ACTION ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1260 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for leagues
-- ----------------------------
DROP TABLE IF EXISTS `leagues`;
CREATE TABLE `leagues`  (
  `id_league` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `league_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `competition_type` enum('league','cup','friendly') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'friendly',
  `id_country` int UNSIGNED NULL DEFAULT NULL,
  `confederation_league` enum('UEFA','CONMEBOL','CONCACAF','FIFA','OFC','AFC','CAF') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `is_national_only` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_league`) USING BTREE,
  INDEX `id_country`(`id_country` ASC) USING BTREE,
  CONSTRAINT `leagues_ibfk_1` FOREIGN KEY (`id_country`) REFERENCES `countries` (`id_country`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 438 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;


-- ----------------------------
-- Table structure for players
-- ----------------------------
DROP TABLE IF EXISTS `players`;
CREATE TABLE `players`  (
  `id_player` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `surname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `jersey_nr` tinyint UNSIGNED NULL DEFAULT NULL,
  `height` decimal(5, 2) NULL DEFAULT NULL,
  `date_of_birth` date NULL DEFAULT NULL,
  `id_country` int UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id_player`) USING BTREE,
  INDEX `id_country`(`id_country` ASC) USING BTREE,
  CONSTRAINT `players_ibfk_1` FOREIGN KEY (`id_country`) REFERENCES `countries` (`id_country`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 221 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for players_positions
-- ----------------------------
DROP TABLE IF EXISTS `players_positions`;
CREATE TABLE `players_positions`  (
  `id_player` int UNSIGNED NOT NULL,
  `id_position` int UNSIGNED NOT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT 0,
  `primary_guard` int UNSIGNED GENERATED ALWAYS AS (case when `is_primary` = 1 then `id_player` else NULL end) VIRTUAL NULL,
  PRIMARY KEY (`id_player`, `id_position`) USING BTREE,
  UNIQUE INDEX `uq_one_primary_position_per_player`(`primary_guard` ASC) USING BTREE,
  INDEX `id_position`(`id_position` ASC) USING BTREE,
  CONSTRAINT `players_positions_ibfk_1` FOREIGN KEY (`id_player`) REFERENCES `players` (`id_player`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `players_positions_ibfk_2` FOREIGN KEY (`id_position`) REFERENCES `positions` (`id_position`) ON DELETE RESTRICT ON UPDATE NO ACTION
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for positions
-- ----------------------------
DROP TABLE IF EXISTS `positions`;
CREATE TABLE `positions`  (
  `id_position` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `position_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `position_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_position`) USING BTREE,
  UNIQUE INDEX `uq_position_code`(`position_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;



-- ----------------------------
-- Table structure for transfers
-- ----------------------------
DROP TABLE IF EXISTS `transfers`;
CREATE TABLE `transfers`  (
  `id_transfer` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_player` int UNSIGNED NOT NULL,
  `id_from_club` int UNSIGNED NULL DEFAULT NULL,
  `id_to_club` int UNSIGNED NULL DEFAULT NULL,
  `transfer_date` date NOT NULL,
  `transfer_fee` int UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id_transfer`) USING BTREE,
  INDEX `id_player`(`id_player` ASC) USING BTREE,
  INDEX `id_from_club`(`id_from_club` ASC) USING BTREE,
  INDEX `id_to_club`(`id_to_club` ASC) USING BTREE,
  CONSTRAINT `transfers_ibfk_1` FOREIGN KEY (`id_player`) REFERENCES `players` (`id_player`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `transfers_ibfk_2` FOREIGN KEY (`id_from_club`) REFERENCES `clubs` (`id_club`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `transfers_ibfk_3` FOREIGN KEY (`id_to_club`) REFERENCES `clubs` (`id_club`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 993 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;


-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `id_role` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_role`) USING BTREE,
  UNIQUE INDEX `uq_role`(`role` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;


-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id_user` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `login` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL WITHOUT SYSTEM VERSIONING,
  PRIMARY KEY (`id_user`) USING BTREE,
  UNIQUE INDEX `login`(`login` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC WITH SYSTEM VERSIONING;

-- ----------------------------
-- Records of users
-- ----------------------------

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles`  (
  `id_user` int UNSIGNED NOT NULL,
  `id_role` int UNSIGNED NOT NULL,
  PRIMARY KEY (`id_user`, `id_role`) USING BTREE,
  INDEX `fk_user_roles_role`(`id_role` ASC) USING BTREE,
  CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`id_role`) REFERENCES `roles` (`id_role`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_roles
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------
-- System versioning & partitioning
-- ----------------------------
ALTER TABLE `players` ADD SYSTEM VERSIONING;
ALTER TABLE `games` ADD SYSTEM VERSIONING;
ALTER TABLE `injuries` ADD SYSTEM VERSIONING;
ALTER TABLE `comments` ADD SYSTEM VERSIONING;
ALTER TABLE `comments` PARTITION BY SYSTEM_TIME (
    PARTITION p_hist HISTORY,
    PARTITION p_cur CURRENT
);
ALTER TABLE `roles` ADD SYSTEM VERSIONING;
-- `users` is created WITH SYSTEM VERSIONING above so `password` can be marked WITHOUT SYSTEM VERSIONING
ALTER TABLE `user_roles` ADD SYSTEM VERSIONING;

-- ----------------------------
-- Views (drop legacy duplicates, create unified views)
-- ----------------------------
DROP VIEW IF EXISTS `view_games_with_scores`;
DROP VIEW IF EXISTS `view_players_details`;
DROP VIEW IF EXISTS `v_player_career_stats`;

CREATE OR REPLACE VIEW `v_match_results` AS
SELECT
    g.`id_game`,
    g.`id_league`,
    l.`league_name`,
    g.`game_date`,
    g.`id_home_club`,
    c_home.`club_name` AS `home_club_name`,
    COALESCE(SUM(CASE WHEN gh.`id_credited_club` = g.`id_home_club` THEN 1 ELSE 0 END), 0) AS `home_goals`,
    COALESCE(SUM(CASE WHEN gh.`id_credited_club` = g.`id_away_club` THEN 1 ELSE 0 END), 0) AS `away_goals`,
    g.`id_away_club`,
    c_away.`club_name` AS `away_club_name`,
    g.`status`
FROM `games` AS g
JOIN `clubs` AS c_home ON g.`id_home_club` = c_home.`id_club`
JOIN `clubs` AS c_away ON g.`id_away_club` = c_away.`id_club`
JOIN `leagues` AS l ON g.`id_league` = l.`id_league`
LEFT JOIN `goal_history` AS gh ON g.`id_game` = gh.`id_game`
GROUP BY
    g.`id_game`,
    g.`id_league`,
    l.`league_name`,
    g.`game_date`,
    g.`id_home_club`,
    c_home.`club_name`,
    g.`id_away_club`,
    c_away.`club_name`,
    g.`status`;

CREATE OR REPLACE VIEW `v_player_details` AS
WITH ranked_transfers AS (
    SELECT
        tr.`id_player`,
        tr.`id_to_club`,
        ROW_NUMBER() OVER (
            PARTITION BY tr.`id_player` ORDER BY tr.`transfer_date` DESC, tr.`id_transfer` DESC
        ) AS `transfer_rank`
    FROM `transfers` AS tr
    LEFT JOIN `clubs` AS cl ON cl.`id_club` = tr.`id_to_club`
    WHERE tr.`transfer_date` <= CURRENT_DATE
      AND (tr.`id_to_club` IS NULL OR cl.`is_national_team` = 0)
), lineup_totals AS (
    SELECT
        `id_player`,
        COUNT(DISTINCT `id_game`) AS `matches_played`,
        COALESCE(SUM(`is_starting`), 0) AS `starting_appearances`
    FROM `game_lineups`
    GROUP BY `id_player`
), goal_totals AS (
    SELECT
        `id_player`,
        SUM(CASE WHEN `is_own_goal` = FALSE THEN 1 ELSE 0 END) AS `total_goals`,
        SUM(CASE WHEN `is_own_goal` = TRUE THEN 1 ELSE 0 END) AS `total_own_goals`
    FROM `goal_history`
    GROUP BY `id_player`
), elapsed_injuries AS (
    SELECT
        `id_injury`,
        `id_player`,
        `start_date`,
        LEAST(COALESCE(`end_date`, CURRENT_DATE), CURRENT_DATE) AS `elapsed_end_date`,
        CASE WHEN `end_date` IS NULL OR `end_date` >= CURRENT_DATE THEN 1 ELSE 0 END AS `is_active`
    FROM `injuries`
    WHERE `start_date` <= CURRENT_DATE
), injury_ranges AS (
    SELECT
        `id_injury`,
        `id_player`,
        `start_date`,
        `elapsed_end_date`,
        `is_active`,
        MAX(`elapsed_end_date`) OVER (
            PARTITION BY `id_player` ORDER BY `start_date`, `id_injury`
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
        ) AS `previous_end_date`
    FROM elapsed_injuries
), injury_totals AS (
    SELECT
        `id_player`,
        COUNT(*) AS `total_injuries`,
        MAX(`is_active`) AS `is_currently_injured`,
        SUM(
            CASE
                WHEN `previous_end_date` IS NULL OR `start_date` > `previous_end_date`
                    THEN DATEDIFF(`elapsed_end_date`, `start_date`) + 1
                ELSE GREATEST(0, DATEDIFF(`elapsed_end_date`, `previous_end_date`))
            END
        ) AS `total_days_injured`
    FROM injury_ranges
    GROUP BY `id_player`
)
SELECT
    p.`id_player`,
    p.`name`,
    p.`surname`,
    pp.`id_position`,
    pos.`position_name`,
    pos.`position_code`,
    p.`jersey_nr`,
    p.`height`,
    p.`date_of_birth`,
    p.`id_country`,
    country.`name_country`,
    t.`id_to_club` AS `id_club`,
    c.`club_name`,
    COALESCE(l.`matches_played`, 0) AS `matches_played`,
    COALESCE(l.`starting_appearances`, 0) AS `starting_appearances`,
    COALESCE(g.`total_goals`, 0) AS `total_goals`,
    COALESCE(g.`total_own_goals`, 0) AS `total_own_goals`,
    COALESCE(i.`total_injuries`, 0) AS `total_injuries`,
    COALESCE(i.`is_currently_injured`, 0) AS `is_currently_injured`,
    COALESCE(i.`total_days_injured`, 0) AS `total_days_injured`
FROM `players` AS p
LEFT JOIN `players_positions` AS pp ON pp.`id_player` = p.`id_player` AND pp.`is_primary` = 1
LEFT JOIN `positions` AS pos ON pos.`id_position` = pp.`id_position`
LEFT JOIN `countries` AS country ON country.`id_country` = p.`id_country`
LEFT JOIN ranked_transfers AS t ON t.`id_player` = p.`id_player` AND t.`transfer_rank` = 1
LEFT JOIN `clubs` AS c ON c.`id_club` = t.`id_to_club`
LEFT JOIN lineup_totals AS l ON l.`id_player` = p.`id_player`
LEFT JOIN goal_totals AS g ON g.`id_player` = p.`id_player`
LEFT JOIN injury_totals AS i ON i.`id_player` = p.`id_player`;

CREATE OR REPLACE VIEW `v_top_scorers` AS
SELECT
    p.`id_player`,
    p.`name`,
    p.`surname`,
    co.`name_country` AS `nationality`,
    COUNT(gh.`id_goal_history`) AS `goals_scored`
FROM `players` AS p
JOIN `goal_history` AS gh ON p.`id_player` = gh.`id_player`
LEFT JOIN `countries` AS co ON p.`id_country` = co.`id_country`
WHERE gh.`is_own_goal` = 0
GROUP BY p.`id_player`, p.`name`, p.`surname`, co.`name_country`;

CREATE OR REPLACE VIEW `v_active_injuries` AS
SELECT
    i.`id_injury`,
    p.`id_player`,
    CONCAT_WS(' ', p.`name`, p.`surname`) AS `player_name`,
    i.`description` AS `injury_description`,
    i.`start_date`,
    i.`end_date`,
    DATEDIFF(CURDATE(), i.`start_date`) AS `days_elapsed`,
    DATEDIFF(i.`end_date`, CURDATE()) AS `expected_days_remaining`
FROM `injuries` AS i
JOIN `players` AS p ON i.`id_player` = p.`id_player`
WHERE i.`start_date` <= CURDATE()
  AND (i.`end_date` IS NULL OR i.`end_date` >= CURDATE());
