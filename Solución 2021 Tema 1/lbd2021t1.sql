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

/***********************************************************************************************************/

/* Realizar un procedimiento almacenado llamado NuevaDireccion para dar de alta una dirección, incluyendo 
el control de errores lógicos y mensajes de error necesarios (implementar la lógica del manejo de errores 
empleando parámetros de salida). Incluir el código con la llamada al procedimiento probando todos los casos 
con datos incorrectos y uno con datos correctos. */

drop procedure if exists NuevaDireccion;
DELIMITER //
create procedure NuevaDireccion (
	pidDireccion int,
    pcalleYNumero varchar(50),
    pmunicipio varchar(20),
    pcodigoPostal varchar(10),
    ptelefono varchar(20),
    out mensaje varchar(60)
    )
salir: begin
	if exists (select * from Direcciones where calleYNumero = pcalleYNumero) then
		set mensaje = 'Ya existe una dirección con esta calle y número';
        leave salir;
	end if;
    if exists (select * from Direcciones where idDireccion = pidDireccion) then
		set mensaje = 'Ya existe una dirección con este ID';
        leave salir;
	end if;
    if pidDireccion = null or pidDireccion = 0 then
		set mensaje = 'El ID no es válido';
        leave salir;
	end if;
    if pmunicipio = null then
		set mensaje = 'La dirección debe tener un municipio';
        leave salir;
	end if;
    if pcalleYNumero = null or length(pcalleYNumero) < 5 then
		set mensaje = 'La calle y el número deben tener por lo menos 5 caracteres';
        leave salir;
	else
		start transaction;
		insert into Direcciones values (pidDireccion, pcalleYNumero, pmunicipio, pcodigoPostal, ptelefono);
        set mensaje = 'Dirección creada con éxito';
		commit;
	end if;
end //
DELIMITER ;

-- Ya existe dirección con esta calle y nro
call NuevaDireccion(1000, '47 MySakila Drive', 'Alberta', null, null, @mensaje);
select @mensaje as Mensaje;

-- Ya existe direccin con este ID
call NuevaDireccion(1, 'Calle 1 Nro 1', 'Alberta', null, null, @mensaje);
select @mensaje as Mensaje;

-- El ID no es válido
call NuevaDireccion(0, 'Calle 1 Nro 1', 'Alberta', null, null, @mensaje);
select @mensaje as Mensaje;

-- La calle y el número deben tener por lo menos 5 caracteres
call NuevaDireccion(1000, 'C', 'Alberta', null, null, @mensaje);
select @mensaje as Mensaje;

-- Debe tener municipio
call NuevaDireccion(1000, 'Calle 1 Nro 1', null, null, null, @mensaje);
select @mensaje as Mensaje;

-- OK
call NuevaDireccion(1000, 'Calle 1 Nro 1', 'Alberta', null, null, @mensaje);
select @mensaje as Mensaje;

select * from direcciones;