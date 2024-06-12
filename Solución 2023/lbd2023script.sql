-- MySQL Script generated by MySQL Workbench
-- Wed Jun 12 00:41:06 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema lbd2023examen
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `lbd2023examen` ;

-- -----------------------------------------------------
-- Schema lbd2023examen
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lbd2023examen` DEFAULT CHARACTER SET utf8 ;
USE `lbd2023examen` ;

-- -----------------------------------------------------
-- Table `lbd2023examen`.`BandasHorarias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2023examen`.`BandasHorarias` ;

CREATE TABLE IF NOT EXISTS `lbd2023examen`.`BandasHorarias` (
  `idBandaHoraria` INT NOT NULL,
  `nombre` VARCHAR(13) NOT NULL,
  PRIMARY KEY (`idBandaHoraria`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `lbd2023examen`.`Clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2023examen`.`Clientes` ;

CREATE TABLE IF NOT EXISTS `lbd2023examen`.`Clientes` (
  `idCliente` INT NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `apellido` VARCHAR(50) NOT NULL,
  `dni` VARCHAR(10) NOT NULL,
  `domicilio` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idCliente`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `lbd2023examen`.`Pedidos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2023examen`.`Pedidos` ;

CREATE TABLE IF NOT EXISTS `lbd2023examen`.`Pedidos` (
  `idPedido` INT NOT NULL,
  `idCliente` INT NOT NULL,
  `fecha` DATETIME NOT NULL,
  PRIMARY KEY (`idPedido`),
  CONSTRAINT `idCliente`
    FOREIGN KEY (`idCliente`)
    REFERENCES `lbd2023examen`.`clientes` (`idCliente`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

CREATE INDEX `IX_idCliente` ON `lbd2023examen`.`Pedidos` (`idCliente` ASC) VISIBLE;

CREATE INDEX `fk_Pedidos_Clientes1_idx` ON `lbd2023examen`.`Pedidos` (`idCliente` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `lbd2023examen`.`Sucursales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2023examen`.`Sucursales` ;

CREATE TABLE IF NOT EXISTS `lbd2023examen`.`Sucursales` (
  `idSucursal` INT NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `domicilio` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idSucursal`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `lbd2023examen`.Entregas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2023examen`.`Entregas` ;

CREATE TABLE IF NOT EXISTS `lbd2023examen`.`Entregas` (
  `idEntrega` INT NOT NULL,
  `idSucursal` INT NOT NULL,
  `idPedido` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATETIME NOT NULL,
  `idBandaHoraria` INT NOT NULL,
  PRIMARY KEY (`idEntrega`),
  CONSTRAINT `fk_Entregas_BandasHorarias1`
    FOREIGN KEY (`idBandaHoraria`)
    REFERENCES `lbd2023examen`.`BandasHorarias` (`idBandaHoraria`),
  CONSTRAINT `fk_Entregas_Pedidos1`
    FOREIGN KEY (`idPedido`)
    REFERENCES `lbd2023examen`.`Pedidos` (`idPedido`),
  CONSTRAINT `fk_Entregas_Sucursales1`
    FOREIGN KEY (`idSucursal`)
    REFERENCES `lbd2023examen`.`Sucursales` (`idSucursal`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

CREATE INDEX `fk_Entregas_Sucursales1_idx` ON `lbd2023examen`.`Entregas` (`idSucursal` ASC) VISIBLE;

CREATE INDEX `fk_Entregas_BandasHorarias1_idx` ON `lbd2023examen`.`Entregas` (`idBandaHoraria` ASC) VISIBLE;

CREATE INDEX `fk_Entregas_Pedidos1_idx` ON `lbd2023examen`.`Entregas` (`idPedido` ASC) VISIBLE;

-- -----------------------------------------------------
-- Table `lbd2023examen`.`Productos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2023examen`.`Productos` ;

CREATE TABLE IF NOT EXISTS `lbd2023examen`.`Productos` (
  `idProductos` INT NOT NULL,
  `nombre` VARCHAR(150) NOT NULL,
  `precio` FLOAT NOT NULL,
  PRIMARY KEY (`idProductos`),
  CHECK (`precio` > 0))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- -----------------------------------------------------
-- Table `lbd2023examen`.`ProductoDelPedido`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2023examen`.`ProductoDelPedido` ;

CREATE TABLE IF NOT EXISTS `lbd2023examen`.`ProductoDelPedido` (
  `idProducto` INT NOT NULL,
  `idPedido` INT NOT NULL,
  `cantidad` FLOAT NOT NULL,
  `precio` FLOAT NOT NULL,
  PRIMARY KEY (`idProducto`, `idPedido`),
  CONSTRAINT `idPedido`
    FOREIGN KEY (`idPedido`)
    REFERENCES `lbd2023examen`.`Pedidos` (`idPedido`),
  CONSTRAINT `idProducto`
    FOREIGN KEY (`idProducto`)
    REFERENCES `lbd2023examen`.`Productos` (`idProductos`),
    CHECK (`precio` > 0))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

CREATE INDEX `IX_idProducto` ON `lbd2023examen`.`ProductoDelPedido` (`idPedido` ASC) VISIBLE;

CREATE INDEX `IX_idPedido` ON `lbd2023examen`.`ProductoDelPedido` (`idProducto` ASC) VISIBLE;

CREATE INDEX `fk_ProductoDelPedido_Productos_idx` ON `lbd2023examen`.`ProductoDelPedido` (`idProducto` ASC) VISIBLE;

CREATE INDEX `fk_ProductoDelPedido_Pedidos_idx` ON `lbd2023examen`.`ProductoDelPedido` (`idPedido` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
