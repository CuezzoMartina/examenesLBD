-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema lbd2021t1
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `lbd2021t1` ;

-- -----------------------------------------------------
-- Schema lbd2021t1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lbd2021t1` DEFAULT CHARACTER SET utf8 ;
USE `lbd2021t1` ;

-- -----------------------------------------------------
-- Table `lbd2021t1`.`Peliculas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t1`.`Peliculas` ;

CREATE TABLE IF NOT EXISTS `lbd2021t1`.`Peliculas` (
  `idPelicula` INT NOT NULL,
  `titulo` VARCHAR(128) NOT NULL,
  `estreno` INT NULL,
  `duracion` INT NULL,
  `clasificacion` ENUM('G', 'PG', 'PG-13', 'R', 'NC-17') NOT NULL DEFAULT 'G',
  PRIMARY KEY (`idPelicula`),
  UNIQUE INDEX `titulo_UNIQUE` (`titulo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2021t1`.`Direcciones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t1`.`Direcciones` ;

CREATE TABLE IF NOT EXISTS `lbd2021t1`.`Direcciones` (
  `idDireccion` INT NOT NULL,
  `calleYNumero` VARCHAR(50) NOT NULL,
  `municipio` VARCHAR(20) NOT NULL,
  `codigoPostal` VARCHAR(10) NULL,
  `telefono` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idDireccion`),
  UNIQUE INDEX `calleYNumero_UNIQUE` (`calleYNumero` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2021t1`.`Personal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t1`.`Personal` ;

CREATE TABLE IF NOT EXISTS `lbd2021t1`.`Personal` (
  `idPersonal` INT NOT NULL,
  `nombres` VARCHAR(45) NOT NULL,
  `apellidos` VARCHAR(45) NOT NULL,
  `idDireccion` INT NOT NULL,
  `correo` VARCHAR(50) NULL,
  `estado` ENUM('E', 'D') NOT NULL DEFAULT 'E',
  PRIMARY KEY (`idPersonal`),
  UNIQUE INDEX `correo_UNIQUE` (`correo` ASC) VISIBLE,
  INDEX `fk_Personal_Direcciones_idx` (`idDireccion` ASC) VISIBLE,
  CONSTRAINT `fk_Personal_Direcciones`
    FOREIGN KEY (`idDireccion`)
    REFERENCES `lbd2021t1`.`Direcciones` (`idDireccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2021t1`.`Sucursales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t1`.`Sucursales` ;

CREATE TABLE IF NOT EXISTS `lbd2021t1`.`Sucursales` (
  `idSucursal` INT NOT NULL,
  `idGerente` INT NOT NULL,
  `idDireccion` INT NOT NULL,
  PRIMARY KEY (`idSucursal`),
  INDEX `fk_Sucursales_Direcciones1_idx` (`idDireccion` ASC) VISIBLE,
  INDEX `fk_Sucursales_Personal1_idx` (`idGerente` ASC) VISIBLE,
  CONSTRAINT `fk_Sucursales_Direcciones1`
    FOREIGN KEY (`idDireccion`)
    REFERENCES `lbd2021t1`.`Direcciones` (`idDireccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Sucursales_Personal1`
    FOREIGN KEY (`idGerente`)
    REFERENCES `lbd2021t1`.`Personal` (`idPersonal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2021t1`.`Inventario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t1`.`Inventario` ;

CREATE TABLE IF NOT EXISTS `lbd2021t1`.`Inventario` (
  `idInventario` INT NOT NULL,
  `idPelicula` INT NOT NULL,
  `idSucursal` INT NOT NULL,
  PRIMARY KEY (`idInventario`),
  INDEX `fk_Inventario_Sucursales1_idx` (`idSucursal` ASC) VISIBLE,
  INDEX `fk_Inventario_Peliculas1_idx` (`idPelicula` ASC) VISIBLE,
  CONSTRAINT `fk_Inventario_Sucursales1`
    FOREIGN KEY (`idSucursal`)
    REFERENCES `lbd2021t1`.`Sucursales` (`idSucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Inventario_Peliculas1`
    FOREIGN KEY (`idPelicula`)
    REFERENCES `lbd2021t1`.`Peliculas` (`idPelicula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2021t1`.`Generos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t1`.`Generos` ;

CREATE TABLE IF NOT EXISTS `lbd2021t1`.`Generos` (
  `idGenero` CHAR(10) NOT NULL,
  `nombre` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`idGenero`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2021t1`.`GenerosDePeliculas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t1`.`GenerosDePeliculas` ;

CREATE TABLE IF NOT EXISTS `lbd2021t1`.`GenerosDePeliculas` (
  `idPelicula` INT NOT NULL,
  `idGenero` CHAR(10) NOT NULL,
  PRIMARY KEY (`idPelicula`, `idGenero`),
  INDEX `fk_GenerosDePeliculas_Peliculas1_idx` (`idPelicula` ASC) VISIBLE,
  INDEX `fk_GenerosDePeliculas_Generos1_idx` (`idGenero` ASC) VISIBLE,
  CONSTRAINT `fk_Generos_has_Peliculas_Generos1`
    FOREIGN KEY (`idGenero`)
    REFERENCES `lbd2021t1`.`Generos` (`idGenero`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Generos_has_Peliculas_Peliculas1`
    FOREIGN KEY (`idPelicula`)
    REFERENCES `lbd2021t1`.`Peliculas` (`idPelicula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


/***************************************************************************************************************/

/* Crear una vista llamada VCantidadPeliculas que muestre por cada película su código, título y la cantidad
total entre las distintas sucursales. La salida deberá estar ordenada alfabéticamente según el título de las películas. 
Incluir el código con la consulta a la vista. */

drop view if exists VCantidadPeliculas;
create view VCantidadPeliculas as
select 
	p.idPelicula as `Id Película`,
    p.titulo as `Título`,
    count(*) as `Cantidad`
from 
	Peliculas p
    left join inventario i on i.idPelicula = p.idPelicula
group by p.idPelicula
order by p.titulo;

select * from VCantidadPeliculas;

