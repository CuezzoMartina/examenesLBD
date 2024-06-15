-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema lbd2020examen
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `lbd2020examen` ;

-- -----------------------------------------------------
-- Schema lbd2020examen
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lbd2020examen` DEFAULT CHARACTER SET utf8 ;
USE `lbd2020examen` ;

-- -----------------------------------------------------
-- Table `lbd2020examen`.`Unidades`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2020examen`.`Unidades` ;

CREATE TABLE IF NOT EXISTS `lbd2020examen`.`Unidades` (
  `Nombre` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Nombre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2020examen`.`MateriaPrima`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2020examen`.`MateriaPrima` ;

CREATE TABLE IF NOT EXISTS `lbd2020examen`.`MateriaPrima` (
  `IDMateriaPrima` INT NOT NULL,
  `Nombre` VARCHAR(35) NOT NULL,
  `PrecioUnitario` FLOAT NOT NULL CHECK(PrecioUnitario > 0),
  `Unidad` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`IDMateriaPrima`),
  INDEX `fk_MateriaPrima_Unidades_idx` (`Unidad` ASC) VISIBLE,
  UNIQUE INDEX `Nombre_UNIQUE` (`Nombre` ASC) VISIBLE,
  CONSTRAINT `fk_MateriaPrima_Unidades`
    FOREIGN KEY (`Unidad`)
    REFERENCES `lbd2020examen`.`Unidades` (`Nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2020examen`.`Categorias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2020examen`.`Categorias` ;

CREATE TABLE IF NOT EXISTS `lbd2020examen`.`Categorias` (
  `Nombre` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Nombre`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2020examen`.`Recetas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2020examen`.`Recetas` ;

CREATE TABLE IF NOT EXISTS `lbd2020examen`.`Recetas` (
  `IDReceta` INT NOT NULL,
  `Rendimiento` FLOAT NOT NULL CHECK(Rendimiento > 0),
  `Procedimiento` VARCHAR(1000) NOT NULL,
  `Nombre` VARCHAR(45) NOT NULL,
  `Unidad` VARCHAR(10) NOT NULL,
  `Categoria` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`IDReceta`),
  INDEX `fk_Recetas_Categorias1_idx` (`Categoria` ASC) VISIBLE,
  INDEX `fk_Recetas_Unidades1_idx` (`Unidad` ASC) VISIBLE,
  UNIQUE INDEX `Nombre_UNIQUE` (`Nombre` ASC) VISIBLE,
  CONSTRAINT `fk_Recetas_Categorias1`
    FOREIGN KEY (`Categoria`)
    REFERENCES `lbd2020examen`.`Categorias` (`Nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Recetas_Unidades1`
    FOREIGN KEY (`Unidad`)
    REFERENCES `lbd2020examen`.`Unidades` (`Nombre`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2020examen`.`RecetasRecetas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2020examen`.`RecetasRecetas` ;

CREATE TABLE IF NOT EXISTS `lbd2020examen`.`RecetasRecetas` (
  `IDReceta` INT NOT NULL,
  `IDComponente` INT NOT NULL,
  `Cantidad` FLOAT NOT NULL CHECK(Cantidad > 0),
  PRIMARY KEY (`IDReceta`, `IDComponente`),
  INDEX `fk_RecetasRecetas_Componente1_idx` (`IDComponente` ASC) VISIBLE,
  INDEX `fk_RecetasRecetas_Recetas1_idx` (`IDReceta` ASC) VISIBLE,
  CONSTRAINT `fk_Recetas_has_Recetas_Recetas1`
    FOREIGN KEY (`IDReceta`)
    REFERENCES `lbd2020examen`.`Recetas` (`IDReceta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Recetas_has_Recetas_Recetas2`
    FOREIGN KEY (`IDComponente`)
    REFERENCES `lbd2020examen`.`Recetas` (`IDReceta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2020examen`.`Composicion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2020examen`.`Composicion` ;

CREATE TABLE IF NOT EXISTS `lbd2020examen`.`Composicion` (
  `IDReceta` INT NOT NULL,
  `IDMateriaPrima` INT NOT NULL,
  `Cantidad` FLOAT NOT NULL CHECK(Cantidad > 0),
  PRIMARY KEY (`IDReceta`, `IDMateriaPrima`),
  INDEX `fk_Composicion_Recetas1_idx` (`IDReceta` ASC) VISIBLE,
  INDEX `fk_Composicion_MateriaPrima1_idx` (`IDMateriaPrima` ASC) VISIBLE,
  CONSTRAINT `fk_MateriaPrima_has_Recetas_MateriaPrima1`
    FOREIGN KEY (`IDMateriaPrima`)
    REFERENCES `lbd2020examen`.`MateriaPrima` (`IDMateriaPrima`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MateriaPrima_has_Recetas_Recetas1`
    FOREIGN KEY (`IDReceta`)
    REFERENCES `lbd2020examen`.`Recetas` (`IDReceta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
