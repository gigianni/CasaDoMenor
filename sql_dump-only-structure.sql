-- MySQL dump 10.13  Distrib 8.0.28, for Win64 (x86_64)
--
-- Host: localhost    Database: cdm_git
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `banks`
--

DROP TABLE IF EXISTS `banks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banks` (
  `iban` varchar(35) NOT NULL,
  `name` varchar(512) NOT NULL,
  `address` varchar(512) DEFAULT NULL,
  `city` varchar(9) DEFAULT 'dfval',
  `swift` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`iban`),
  KEY `city` (`city`),
  CONSTRAINT `banks_ibfk_1` FOREIGN KEY (`city`) REFERENCES `cities` (`zipcode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cdm_donors`
--

DROP TABLE IF EXISTS `cdm_donors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cdm_donors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` char(10) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `country_code` char(2) DEFAULT NULL,
  `contacts` varchar(500) DEFAULT NULL,
  `sending_type` varchar(255) DEFAULT NULL,
  `notes` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `country_code` (`country_code`),
  CONSTRAINT `cdm_donors_ibfk_1` FOREIGN KEY (`country_code`) REFERENCES `countries` (`code`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `donors_update` BEFORE UPDATE ON `cdm_donors` FOR EACH ROW INSERT INTO log SET
tableName='cdm_donors',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.code,''), ';',COALESCE(OLD.name,''), ';',COALESCE(OLD.country_code,''), ';',COALESCE(OLD.contacts,''), ';',COALESCE(OLD.sending_type,''), ';',COALESCE(OLD.notes,'')),
username=USER(),
updateDate=NOW(),
auditType='U' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `donors_delete` BEFORE DELETE ON `cdm_donors` FOR EACH ROW INSERT INTO log SET
tableName='cdm_donors',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.code,''), ';',COALESCE(OLD.name,''), ';',COALESCE(OLD.country_code,''), ';',COALESCE(OLD.contacts,''), ';',COALESCE(OLD.sending_type,''), ';',COALESCE(OLD.notes,'')),
username=USER(),
updateDate=NOW(),
auditType='D' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cdm_houses`
--

DROP TABLE IF EXISTS `cdm_houses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cdm_houses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `address` varchar(512) NOT NULL,
  `city` varchar(9) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `city` (`city`),
  CONSTRAINT `cdm_houses_ibfk_1` FOREIGN KEY (`city`) REFERENCES `cities` (`zipcode`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `houses_update` BEFORE UPDATE ON `cdm_houses` FOR EACH ROW INSERT INTO log SET
tableName='cdm_houses',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.name,''), ';',COALESCE(OLD.address,''), ';',COALESCE(OLD.city,'')),
username=USER(),
updateDate=NOW(),
auditType='U' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `houses_delete` BEFORE DELETE ON `cdm_houses` FOR EACH ROW INSERT INTO log SET
tableName='cdm_houses',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.name,''), ';',COALESCE(OLD.address,''), ';',COALESCE(OLD.city,'')),
username=USER(),
updateDate=NOW(),
auditType='D' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cdm_projects`
--

DROP TABLE IF EXISTS `cdm_projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cdm_projects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `donors_code` int DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `status` char(20) NOT NULL,
  `notice` varchar(255) DEFAULT NULL,
  `sector` varchar(500) DEFAULT NULL,
  `info` varchar(1000) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `criteria` varchar(500) DEFAULT NULL,
  `max_funding` decimal(20,2) DEFAULT NULL,
  `required_funding` decimal(20,2) DEFAULT NULL,
  `house_id` int DEFAULT NULL,
  `attachments` varchar(500) DEFAULT NULL,
  `report_closing` date DEFAULT NULL,
  `notes` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `donors_code` (`donors_code`),
  KEY `house_id` (`house_id`),
  CONSTRAINT `cdm_projects_ibfk_1` FOREIGN KEY (`donors_code`) REFERENCES `cdm_donors` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `cdm_projects_ibfk_2` FOREIGN KEY (`house_id`) REFERENCES `cdm_houses` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `projects_update` BEFORE UPDATE ON `cdm_projects` FOR EACH ROW INSERT INTO log SET
tableName=’cdm_projects’,
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.donors_code,''), ';',COALESCE(OLD.title,''), ';',COALESCE(OLD.status,''), ';',COALESCE(OLD.notice,''), ';',COALESCE(OLD.sector,''), ';',COALESCE(OLD.info,''), ';',COALESCE(OLD.start_date,''), ';',COALESCE(OLD.end_date,''), ';',COALESCE(OLD.criteria,''), ';',COALESCE(OLD.max_funding,''), ';',COALESCE(OLD.required_funding,''), ';',COALESCE(OLD.house_id,''), ';',COALESCE(OLD.attachments,''), ';',COALESCE(OLD.report_closing,''), ';',COALESCE(OLD.notes,'')),
username=USER(),
updateDate=NOW(),
auditType='U' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `projects_delete` BEFORE DELETE ON `cdm_projects` FOR EACH ROW INSERT INTO log SET
tableName=’cdm_projects’,
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.donors_code,''), ';',COALESCE(OLD.title,''), ';',COALESCE(OLD.status,''), ';',COALESCE(OLD.notice,''), ';',COALESCE(OLD.sector,''), ';',COALESCE(OLD.info,''), ';',COALESCE(OLD.start_date,''), ';',COALESCE(OLD.end_date,''), ';',COALESCE(OLD.criteria,''), ';',COALESCE(OLD.max_funding,''), ';',COALESCE(OLD.required_funding,''), ';',COALESCE(OLD.house_id,''), ';',COALESCE(OLD.attachments,''), ';',COALESCE(OLD.report_closing,''), ';',COALESCE(OLD.notes,'')),
username=USER(),
updateDate=NOW(),
auditType='D' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cities`
--

DROP TABLE IF EXISTS `cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cities` (
  `zipcode` varchar(9) NOT NULL,
  `name` varchar(256) DEFAULT NULL,
  `state` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`zipcode`),
  KEY `state` (`state`),
  CONSTRAINT `cities_ibfk_1` FOREIGN KEY (`state`) REFERENCES `states` (`code`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `cities_update` BEFORE UPDATE ON `cities` FOR EACH ROW INSERT INTO log SET
tableName='cities',
recordID=OLD.zipcode,
idType='string',
record=CONCAT(COALESCE(OLD.name,''), ';',COALESCE(OLD.state,'')),
username=USER(),
updateDate=NOW(),
auditType='U' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `cities_delete` BEFORE DELETE ON `cities` FOR EACH ROW INSERT INTO log SET
tableName='cities',
recordID=OLD.zipcode,
idType='string',
record=CONCAT(COALESCE(OLD.name,''), ';',COALESCE(OLD.state,'')),
username=USER(),
updateDate=NOW(),
auditType='D' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `code` varchar(5) NOT NULL,
  `name` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tableName` varchar(50) NOT NULL,
  `recordID` varchar(30) NOT NULL,
  `idType` varchar(30) NOT NULL,
  `record` varchar(5000) NOT NULL,
  `username` varchar(64) NOT NULL,
  `updateDate` datetime NOT NULL,
  `auditType` char(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1488 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `private_accounts`
--

DROP TABLE IF EXISTS `private_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `private_accounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_accounts_update` BEFORE UPDATE ON `private_accounts` FOR EACH ROW INSERT INTO log SET
tableName='private_accounts',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.name,''), ';',COALESCE(OLD.description,'')),
username=USER(),
updateDate=NOW(),
auditType='U' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_accounts_delete` BEFORE DELETE ON `private_accounts` FOR EACH ROW INSERT INTO log SET
tableName='private_accounts',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.name,''), ';',COALESCE(OLD.description,'')),
username=USER(),
updateDate=NOW(),
auditType='D' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `private_causals`
--

DROP TABLE IF EXISTS `private_causals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `private_causals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_causals_update` BEFORE UPDATE ON `private_causals` FOR EACH ROW INSERT INTO log SET
tableName='private_causals',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.name,'')),
username=USER(),
updateDate=NOW(),
auditType='U' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_causals_delete` BEFORE DELETE ON `private_causals` FOR EACH ROW INSERT INTO log SET
tableName='private_causals',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.name,'')),
username=USER(),
updateDate=NOW(),
auditType='D' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `private_donations_groups`
--

DROP TABLE IF EXISTS `private_donations_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `private_donations_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_group` int NOT NULL,
  `date_payment` date DEFAULT NULL,
  `date_registration` date DEFAULT NULL,
  `id_causal` int DEFAULT NULL,
  `id_account` int DEFAULT NULL,
  `value` decimal(30,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_group` (`id_group`),
  KEY `id_causal` (`id_causal`),
  KEY `private_donations_groups_ibfk_2` (`id_account`),
  CONSTRAINT `private_donations_groups_ibfk_1` FOREIGN KEY (`id_group`) REFERENCES `private_groups` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `private_donations_groups_ibfk_2` FOREIGN KEY (`id_account`) REFERENCES `private_accounts` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `private_donations_groups_ibfk_3` FOREIGN KEY (`id_causal`) REFERENCES `private_causals` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=749 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_donations_groups_update` BEFORE UPDATE ON `private_donations_groups` FOR EACH ROW INSERT INTO log SET
tableName='private_donations_groups',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.id_group,''), ';', COALESCE(OLD.date_payment,''), ';', COALESCE(OLD.date_registration,''), ';', COALESCE(OLD.id_causal,''), ';', COALESCE(OLD.id_account,''), ';', COALESCE(OLD.value,'')),
username=USER(),
updateDate=NOW(),
auditType='U' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_donations_groups_delete` BEFORE DELETE ON `private_donations_groups` FOR EACH ROW INSERT INTO log SET
tableName='private_donations_groups',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.id_group,''), ';', COALESCE(OLD.date_payment,''), ';', COALESCE(OLD.date_registration,''), ';', COALESCE(OLD.id_causal,''), ';', COALESCE(OLD.id_account,''), ';', COALESCE(OLD.value,'')),
username=USER(),
updateDate=NOW(),
auditType='D' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `private_donations_persons`
--

DROP TABLE IF EXISTS `private_donations_persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `private_donations_persons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_person` int DEFAULT NULL,
  `date_payment` date DEFAULT NULL,
  `date_registration` date DEFAULT NULL,
  `id_causal` int DEFAULT NULL,
  `id_account` int DEFAULT NULL,
  `value` decimal(20,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_person` (`id_person`),
  KEY `id_causal` (`id_causal`),
  KEY `private_donations_persons_ibfk_2` (`id_account`),
  CONSTRAINT `private_donations_persons_ibfk_1` FOREIGN KEY (`id_person`) REFERENCES `private_persons` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `private_donations_persons_ibfk_2` FOREIGN KEY (`id_account`) REFERENCES `private_accounts` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `private_donations_persons_ibfk_3` FOREIGN KEY (`id_causal`) REFERENCES `private_causals` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14238 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_donations_persons_update` BEFORE UPDATE ON `private_donations_persons` FOR EACH ROW INSERT INTO log SET
tableName='private_donations_persons',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.id_person,''), ';', COALESCE(OLD.date_payment,''), ';', COALESCE(OLD.date_registration,''), ';', COALESCE(OLD.id_causal,''), ';', COALESCE(OLD.id_account,''), ';', COALESCE(OLD.value,'')),
username=USER(),
updateDate=NOW(),
auditType='U' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_donations_persons_delete` BEFORE DELETE ON `private_donations_persons` FOR EACH ROW INSERT INTO log SET
tableName='private_donations_persons',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.id_person,''), ';', COALESCE(OLD.date_payment,''), ';', COALESCE(OLD.date_registration,''), ';', COALESCE(OLD.id_causal,''), ';', COALESCE(OLD.id_account,''), ';', COALESCE(OLD.value,'')),
username=USER(),
updateDate=NOW(),
auditType='D' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `private_groups`
--

DROP TABLE IF EXISTS `private_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `private_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `reference` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `n_civ` varchar(255) DEFAULT NULL,
  `loc` varchar(255) DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `province_code` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `magazine` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=614 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_groups_update` BEFORE UPDATE ON `private_groups` FOR EACH ROW INSERT INTO log SET
tableName='private_groups',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.name,''), ';', COALESCE(OLD.reference,''), ';', COALESCE(OLD.address,''), ';', COALESCE(OLD.n_civ,''), ';', COALESCE(OLD.loc,''), ';', COALESCE(OLD.zip,''), ';', COALESCE(OLD.city,''), ';', COALESCE(OLD.province_code,''), ';', COALESCE(OLD.country,''), ';', COALESCE(OLD.telephone,''), ';', COALESCE(OLD.email,''), ';', COALESCE(OLD.magazine,'')),
username=USER(),
updateDate=NOW(),
auditType='U' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_groups_delete` BEFORE DELETE ON `private_groups` FOR EACH ROW INSERT INTO log SET
tableName='private_groups',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.name,''), ';', COALESCE(OLD.reference,''), ';', COALESCE(OLD.address,''), ';', COALESCE(OLD.n_civ,''), ';', COALESCE(OLD.loc,''), ';', COALESCE(OLD.zip,''), ';', COALESCE(OLD.city,''), ';', COALESCE(OLD.province_code,''), ';', COALESCE(OLD.country,''), ';', COALESCE(OLD.telephone,''), ';', COALESCE(OLD.email,''), ';', COALESCE(OLD.magazine,'')),
username=USER(),
updateDate=NOW(),
auditType='D' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `private_mg_groups`
--

DROP TABLE IF EXISTS `private_mg_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `private_mg_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_mg_groups_update` BEFORE UPDATE ON `private_mg_groups` FOR EACH ROW INSERT INTO log SET
tableName='private_mg_groups',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.name,'')),
username=USER(),
updateDate=NOW(),
auditType='U' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_mg_groups_delete` BEFORE DELETE ON `private_mg_groups` FOR EACH ROW INSERT INTO log SET
tableName='private_mg_groups',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.name,'')),
username=USER(),
updateDate=NOW(),
auditType='D' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `private_mg_items`
--

DROP TABLE IF EXISTS `private_mg_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `private_mg_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_group` int NOT NULL,
  `code` varchar(200) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` varchar(700) DEFAULT NULL,
  `amountRoracco` int DEFAULT '0',
  `amountCuneo` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_group` (`id_group`),
  CONSTRAINT `private_mg_items_ibfk_1` FOREIGN KEY (`id_group`) REFERENCES `private_mg_groups` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_mg_items_insert_trades` AFTER INSERT ON `private_mg_items` FOR EACH ROW IF (NEW.amountRoracco <> 0 OR NEW.amountCuneo <> 0) THEN
        INSERT INTO private_mg_trades SET
		id_item=NEW.id,
		date=NOW(),
		amountRoracco=NEW.amountRoracco,
		amountCuneo=NEW.amountCuneo
		;

END IF */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_mg_items_update` BEFORE UPDATE ON `private_mg_items` FOR EACH ROW INSERT INTO log SET
tableName='private_mg_items',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.id_group,''), ';',COALESCE(OLD.code,''), ';',COALESCE(OLD.name,''), ';',COALESCE(OLD.description,''), ';',COALESCE(OLD.amountRoracco,''), ';',COALESCE(OLD.amountCuneo,'')),
username=USER(),
updateDate=NOW(),
auditType='U' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_mg_items_update_trades` BEFORE UPDATE ON `private_mg_items` FOR EACH ROW IF (NEW.amountRoracco <> OLD.amountRoracco OR NEW.amountCuneo <> OLD.amountCuneo) THEN
        INSERT INTO private_mg_trades SET
		id_item=OLD.id,
		date=NOW(),
		amountRoracco=NEW.amountRoracco-OLD.amountRoracco,
		amountCuneo=NEW.amountCuneo-OLD.amountCuneo;
END IF */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_mg_items_delete` BEFORE DELETE ON `private_mg_items` FOR EACH ROW INSERT INTO log SET
tableName='private_mg_items',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.id_group,''), ';',COALESCE(OLD.code,''), ';',COALESCE(OLD.name,''), ';',COALESCE(OLD.description,''), ';',COALESCE(OLD.amountRoracco,''), ';',COALESCE(OLD.amountCuneo,'')),
username=USER(),
updateDate=NOW(),
auditType='D' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `private_mg_trades`
--

DROP TABLE IF EXISTS `private_mg_trades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `private_mg_trades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_item` int NOT NULL,
  `date` date NOT NULL,
  `amountRoracco` int DEFAULT '0',
  `amountCuneo` int DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_item` (`id_item`),
  CONSTRAINT `private_mg_trades_ibfk_1` FOREIGN KEY (`id_item`) REFERENCES `private_mg_items` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `private_persons`
--

DROP TABLE IF EXISTS `private_persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `private_persons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cfc` varchar(50) DEFAULT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `n_civ` varchar(255) DEFAULT NULL,
  `loc` varchar(255) DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `province_code` varchar(10) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `magazine` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19070 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_persons_update` BEFORE UPDATE ON `private_persons` FOR EACH ROW INSERT INTO log SET
tableName='private_persons',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.cfc,''), ';',COALESCE(OLD.surname,''), ';',COALESCE(OLD.name,''), ';',COALESCE(OLD.address,''), ';',COALESCE(OLD.n_civ,''), ';',COALESCE(OLD.loc,''), ';',COALESCE(OLD.zip,''), ';',COALESCE(OLD.city,''), ';',COALESCE(OLD.province_code,''), ';',COALESCE(OLD.country,''), ';',COALESCE(OLD.telephone,''), ';',COALESCE(OLD.email,''), ';',COALESCE(OLD.magazine)),
username=USER(),
updateDate=NOW(),
auditType='U' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`192.168.2.201`*/ /*!50003 TRIGGER `private_persons_delete` BEFORE DELETE ON `private_persons` FOR EACH ROW INSERT INTO log SET
tableName='private_persons',
recordID=OLD.id,
idType='int',
record=CONCAT(COALESCE(OLD.cfc,''), ';',COALESCE(OLD.surname,''), ';',COALESCE(OLD.name,''), ';',COALESCE(OLD.address,''), ';',COALESCE(OLD.n_civ,''), ';',COALESCE(OLD.loc,''), ';',COALESCE(OLD.zip,''), ';',COALESCE(OLD.city,''), ';',COALESCE(OLD.province_code,''), ';',COALESCE(OLD.country,''), ';',COALESCE(OLD.telephone,''), ';',COALESCE(OLD.email,''), ';',COALESCE(OLD.magazine)),
username=USER(),
updateDate=NOW(),
auditType='D' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `states` (
  `code` varchar(5) NOT NULL,
  `name` varchar(100) NOT NULL,
  `country` varchar(5) NOT NULL,
  PRIMARY KEY (`code`),
  KEY `country` (`country`),
  CONSTRAINT `states_ibfk_1` FOREIGN KEY (`country`) REFERENCES `countries` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `username` varchar(64) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `type` char(1) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'cdm_git'
--

--
-- Dumping routines for database 'cdm_git'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-12-08 13:04:36
