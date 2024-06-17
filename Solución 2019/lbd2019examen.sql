-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema lbd2019examen
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `lbd2019examen` ;

-- -----------------------------------------------------
-- Schema lbd2019examen
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lbd2019examen` DEFAULT CHARACTER SET utf8 ;
USE `lbd2019examen` ;

-- -----------------------------------------------------
-- Table `lbd2019examen`.`Puestos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2019examen`.`Puestos` ;

CREATE TABLE IF NOT EXISTS `lbd2019examen`.`Puestos` (
  `puesto` INT NOT NULL,
  `nombre` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`puesto`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2019examen`.`Personas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2019examen`.`Personas` ;

CREATE TABLE IF NOT EXISTS `lbd2019examen`.`Personas` (
  `persona` INT NOT NULL,
  `nombres` VARCHAR(25) NOT NULL,
  `apellidos` VARCHAR(25) NOT NULL,
  `puesto` INT NOT NULL,
  `fechaIngreso` DATE NOT NULL,
  `fechaBaja` DATE NULL,
  PRIMARY KEY (`persona`),
  INDEX `fk_Personas_puestos1_idx` (`puesto` ASC) VISIBLE,
  CONSTRAINT `fk_Personas_puestos1`
    FOREIGN KEY (`puesto`)
    REFERENCES `lbd2019examen`.`Puestos` (`puesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2019examen`.`Categorias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2019examen`.`Categorias` ;

CREATE TABLE IF NOT EXISTS `lbd2019examen`.`Categorias` (
  `categoria` INT NOT NULL,
  `nombre` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`categoria`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2019examen`.`Conocimientos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2019examen`.`Conocimientos` ;

CREATE TABLE IF NOT EXISTS `lbd2019examen`.`Conocimientos` (
  `conocimiento` INT NOT NULL,
  `categoria` INT NOT NULL,
  `nombre` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`conocimiento`),
  INDEX `fk_Conocimientos_Categorias_idx` (`categoria` ASC) VISIBLE,
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE,
  CONSTRAINT `fk_Conocimientos_Categorias`
    FOREIGN KEY (`categoria`)
    REFERENCES `lbd2019examen`.`Categorias` (`categoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2019examen`.`Niveles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2019examen`.`Niveles` ;

CREATE TABLE IF NOT EXISTS `lbd2019examen`.`Niveles` (
  `nivel` INT NOT NULL,
  `nombre` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`nivel`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2019examen`.`Habilidades`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2019examen`.`Habilidades` ;

CREATE TABLE IF NOT EXISTS `lbd2019examen`.`Habilidades` (
  `habilidad` INT NOT NULL,
  `persona` INT NOT NULL,
  `conocimiento` INT NOT NULL,
  `nivel` INT NOT NULL,
  `fechaUltimaModificacion` DATE NOT NULL,
  `observaciones` VARCHAR(200) NULL,
  PRIMARY KEY (`habilidad`),
  INDEX `fk_Habilidades_Conocimientos1_idx` (`conocimiento` ASC) VISIBLE,
  INDEX `fk_Habilidades_Personas1_idx` (`persona` ASC) VISIBLE,
  INDEX `fk_Habilidades_Niveles1_idx` (`nivel` ASC) VISIBLE,
  CONSTRAINT `fk_Habilidades_Conocimientos1`
    FOREIGN KEY (`conocimiento`)
    REFERENCES `lbd2019examen`.`Conocimientos` (`conocimiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Habilidades_Personas1`
    FOREIGN KEY (`persona`)
    REFERENCES `lbd2019examen`.`Personas` (`persona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Habilidades_Niveles1`
    FOREIGN KEY (`nivel`)
    REFERENCES `lbd2019examen`.`Niveles` (`nivel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
