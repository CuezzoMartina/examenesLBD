-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema lbd2017examen
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `lbd2017examen` ;

-- -----------------------------------------------------
-- Schema lbd2017examen
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lbd2017examen` DEFAULT CHARACTER SET utf8 ;
USE `lbd2017examen` ;

-- -----------------------------------------------------
-- Table `lbd2017examen`.`Clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2017examen`.`Clientes` ;

CREATE TABLE IF NOT EXISTS `lbd2017examen`.`Clientes` (
  `IdCliente` INT NOT NULL,
  `Apellidos` VARCHAR(50) NOT NULL,
  `Nombres` VARCHAR(50) NOT NULL,
  `Telefono` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`IdCliente`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `Telefono_UNIQUE` ON `lbd2017examen`.`Clientes` (`Telefono` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `lbd2017examen`.`Categorias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2017examen`.`Categorias` ;

CREATE TABLE IF NOT EXISTS `lbd2017examen`.`Categorias` (
  `IdCategoria` INT NOT NULL,
  `Nombre` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`IdCategoria`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `Nombre_UNIQUE` ON `lbd2017examen`.`Categorias` (`Nombre` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `lbd2017examen`.`Productos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2017examen`.`Productos` ;

CREATE TABLE IF NOT EXISTS `lbd2017examen`.`Productos` (
  `IdProducto` INT NOT NULL,
  `Nombre` VARCHAR(50) NOT NULL,
  `Color` VARCHAR(15) NULL,
  `Precio` DECIMAL(10,4) NOT NULL,
  `IdCategoria` INT NOT NULL,
  PRIMARY KEY (`IdProducto`),
  CONSTRAINT `fk_Productos_Categorias1`
    FOREIGN KEY (`IdCategoria`)
    REFERENCES `lbd2017examen`.`Categorias` (`IdCategoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Productos_Categorias1_idx` ON `lbd2017examen`.`Productos` (`IdCategoria` ASC) VISIBLE;

CREATE UNIQUE INDEX `Nombre_UNIQUE` ON `lbd2017examen`.`Productos` (`Nombre` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `lbd2017examen`.`Ofertas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2017examen`.`Ofertas` ;

CREATE TABLE IF NOT EXISTS `lbd2017examen`.`Ofertas` (
  `IdOferta` INT NOT NULL,
  `Descuento` FLOAT NOT NULL check (Descuento >= 0.05),
  `FechaInicio` DATETIME NOT NULL DEFAULT current_timestamp,
  `FechaFin` DATETIME NOT NULL,
  `CantidadMinima` INT NOT NULL,
  `CantidadMaxima` INT NULL,
  check (FechaInicio < FechaFin),
  PRIMARY KEY (`IdOferta`))
ENGINE = InnoDB;

CREATE INDEX `FechaInicio_Ofertas` ON `lbd2017examen`.`Ofertas` (`FechaInicio` DESC) VISIBLE;

CREATE INDEX `FechaFin_Ofertas` ON `lbd2017examen`.`Ofertas` (`FechaFin` DESC) VISIBLE;

-- -----------------------------------------------------
-- Table `lbd2017examen`.`OfertasDelProducto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2017examen`.`OfertasDelProducto` ;

CREATE TABLE IF NOT EXISTS `lbd2017examen`.`OfertasDelProducto` (
  `IdOferta` INT NOT NULL,
  `IdProducto` INT NOT NULL,
  PRIMARY KEY (`IdOferta`, `IdProducto`),
  CONSTRAINT `fk_OfertasDelProducto_Ofertas`
    FOREIGN KEY (`IdOferta`)
    REFERENCES `lbd2017examen`.`Ofertas` (`IdOferta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OfertasDelProducto_Productos1`
    FOREIGN KEY (`IdProducto`)
    REFERENCES `lbd2017examen`.`Productos` (`IdProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_OfertasDelProducto_Productos1_idx` ON `lbd2017examen`.`OfertasDelProducto` (`IdProducto` ASC) VISIBLE;

CREATE INDEX `fk_OfertasDelProducto_Ofertas_idx` ON `lbd2017examen`.`OfertasDelProducto` (`IdOferta` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `lbd2017examen`.`Ventas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2017examen`.`Ventas` ;

CREATE TABLE IF NOT EXISTS `lbd2017examen`.`Ventas` (
  `IdVenta` INT NOT NULL,
  `Fecha` DATETIME NOT NULL DEFAULT current_timestamp,
  `IdCliente` INT NOT NULL,
  PRIMARY KEY (`IdVenta`),
  CONSTRAINT `fk_Ventas_Clientes1`
    FOREIGN KEY (`IdCliente`)
    REFERENCES `lbd2017examen`.`Clientes` (`IdCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Ventas_Clientes1_idx` ON `lbd2017examen`.`Ventas` (`IdCliente` ASC) VISIBLE;

CREATE INDEX `Fecha_Ventas` ON `lbd2017examen`.`Ventas` (`Fecha` desc) VISIBLE;

-- -----------------------------------------------------
-- Table `lbd2017examen`.`Detalles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2017examen`.`Detalles` ;

CREATE TABLE IF NOT EXISTS `lbd2017examen`.`Detalles` (
  `IdDetalle` INT NOT NULL,
  `IdVenta` INT NOT NULL,
  `IdProducto` INT NOT NULL,
  `Cantidad` INT NOT NULL,
  `Precio` DECIMAL(10,4) NOT NULL,
  `Descuento` FLOAT NOT NULL check (Descuento >= 0),
  `IdOferta` INT NOT NULL,
  PRIMARY KEY (`IdDetalle`, `IdVenta`),
  CONSTRAINT `fk_Detalles_OfertasDelProducto1`
    FOREIGN KEY (`IdOferta` , `IdProducto`)
    REFERENCES `lbd2017examen`.`OfertasDelProducto` (`IdOferta` , `IdProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Detalles_Ventas1`
    FOREIGN KEY (`IdVenta`)
    REFERENCES `lbd2017examen`.`Ventas` (`IdVenta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Detalles_OfertasDelProducto1_idx` ON `lbd2017examen`.`Detalles` (`IdOferta` ASC, `IdProducto` ASC) VISIBLE;

CREATE INDEX `fk_Detalles_Ventas1_idx` ON `lbd2017examen`.`Detalles` (`IdVenta` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
