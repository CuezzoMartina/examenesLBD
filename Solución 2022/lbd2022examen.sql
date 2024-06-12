-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema lbd2022examen
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `lbd2022examen` ;

-- -----------------------------------------------------
-- Schema lbd2022examen
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lbd2022examen` DEFAULT CHARACTER SET utf8 ;
USE `lbd2022examen` ;

-- -----------------------------------------------------
-- Table `lbd2022examen`.`Autores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2022examen`.`Autores` ;

CREATE TABLE IF NOT EXISTS `lbd2022examen`.`Autores` (
  `idAutor` VARCHAR(11) NOT NULL,
  `apellido` VARCHAR(40) NOT NULL,
  `nombre` VARCHAR(20) NOT NULL,
  `telefono` CHAR(12) DEFAULT ('UNKNOWN') NOT NULL,
  `domicilio` VARCHAR(40) NULL,
  `ciudad` VARCHAR(20) NULL,
  `estado` CHAR(2) NULL,
  `codigoPostal` CHAR(5) NULL,
  PRIMARY KEY (`idAutor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2022examen`.`Editoriales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2022examen`.`Editoriales` ;

CREATE TABLE IF NOT EXISTS `lbd2022examen`.`Editoriales` (
  `idEditorial` CHAR(4) NOT NULL,
  `nombre` VARCHAR(40) NOT NULL,
  `ciudad` VARCHAR(20) NULL UNIQUE,
  `estado` CHAR(2) NULL,
  `pais` VARCHAR(30) DEFAULT 'USA' NOT NULL,
  PRIMARY KEY (`idEditorial`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2022examen`.`Titulos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2022examen`.`Titulos` ;

CREATE TABLE IF NOT EXISTS `lbd2022examen`.`Titulos` (
  `idTitulo` VARCHAR(6) NOT NULL,
  `titulo` VARCHAR(80) NOT NULL,
  `genero` CHAR(12) DEFAULT 'UNDECIDED' NOT NULL,
  `idEditorial` CHAR(4) NOT NULL,
  `precio` DECIMAL(8,2) NULL CHECK(precio > 0),
  `sinopsis` VARCHAR(200) NULL,
  `fechaPublicacion` DATETIME DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY (`idTitulo`),
  INDEX `fk_Titulos_Editoriales1_idx` (`idEditorial` ASC) VISIBLE,
  CONSTRAINT `fk_Titulos_Editoriales1`
    FOREIGN KEY (`idEditorial`)
    REFERENCES `lbd2022examen`.`Editoriales` (`idEditorial`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2022examen`.`TitulosDelAutor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2022examen`.`TitulosDelAutor` ;

CREATE TABLE IF NOT EXISTS `lbd2022examen`.`TitulosDelAutor` (
  `idAutor` VARCHAR(11) NOT NULL,
  `idTitulo` VARCHAR(6) NOT NULL,
  PRIMARY KEY (`idAutor`, `idTitulo`),
  INDEX `fk_TitulosDelAutor_Titulos1_idx` (`idTitulo` ASC) VISIBLE,
  INDEX `fk_TitulosDelAutor_Autores_idx` (`idAutor` ASC) VISIBLE,
  CONSTRAINT `fk_TitulosDelAutor_Autores`
    FOREIGN KEY (`idAutor`)
    REFERENCES `lbd2022examen`.`Autores` (`idAutor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TitulosDelAutor_Titulos1`
    FOREIGN KEY (`idTitulo`)
    REFERENCES `lbd2022examen`.`Titulos` (`idTitulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2022examen`.`Tiendas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2022examen`.`Tiendas` ;

CREATE TABLE IF NOT EXISTS `lbd2022examen`.`Tiendas` (
  `idTienda` CHAR(4) NOT NULL,
  `nombre` VARCHAR(40) NOT NULL UNIQUE,
  `domicilio` VARCHAR(40) NULL,
  `ciudad` VARCHAR(20) NULL,
  `estado` CHAR(2) NULL,
  `codigoPostal` CHAR(5) NULL,
  PRIMARY KEY (`idTienda`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2022examen`.`Ventas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2022examen`.`Ventas` ;

CREATE TABLE IF NOT EXISTS `lbd2022examen`.`Ventas` (
  `codigoVenta` VARCHAR(20) NOT NULL,
  `idTienda` CHAR(4) NOT NULL,
  `fecha` DATETIME NOT NULL,
  `tipo` VARCHAR(12) NOT NULL,
  PRIMARY KEY (`codigoVenta`),
  INDEX `fk_Ventas_Tiendas1_idx` (`idTienda` ASC) VISIBLE,
  CONSTRAINT `fk_Ventas_Tiendas1`
    FOREIGN KEY (`idTienda`)
    REFERENCES `lbd2022examen`.`Tiendas` (`idTienda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2022examen`.`Detalles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2022examen`.`Detalles` ;

CREATE TABLE IF NOT EXISTS `lbd2022examen`.`Detalles` (
  `idDetalle` INT NOT NULL AUTO_INCREMENT,
  `codigoVenta` VARCHAR(20) NOT NULL,
  `idTitulo` VARCHAR(6) NOT NULL,
  `cantidad` SMALLINT NOT NULL CHECK (cantidad>0),
  PRIMARY KEY (`idDetalle`),
  INDEX `fk_Detalles_Ventas1_idx` (`codigoVenta` ASC) VISIBLE,
  INDEX `fk_Detalles_Titulos1_idx` (`idTitulo` ASC) VISIBLE,
  CONSTRAINT `fk_Detalles_Ventas1`
    FOREIGN KEY (`codigoVenta`)
    REFERENCES `lbd2022examen`.`Ventas` (`codigoVenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Detalles_Titulos1`
    FOREIGN KEY (`idTitulo`)
    REFERENCES `lbd2022examen`.`Titulos` (`idTitulo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/********************************************************************************************************************************/


