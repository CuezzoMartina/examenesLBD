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
  `telefono` CHAR(12) NOT NULL DEFAULT ('UNKNOWN'),
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
  `nombre` VARCHAR(40) NOT NULL UNIQUE,
  `ciudad` VARCHAR(20) NULL,
  `estado` CHAR(2) NULL,
  `pais` VARCHAR(30) NOT NULL DEFAULT 'USA',
  PRIMARY KEY (`idEditorial`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2022examen`.`Titulos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2022examen`.`Titulos` ;

CREATE TABLE IF NOT EXISTS `lbd2022examen`.`Titulos` (
  `idTitulo` VARCHAR(6) NOT NULL,
  `titulo` VARCHAR(80) NOT NULL,
  `genero` CHAR(12) NOT NULL DEFAULT 'UNDECIDED',
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

/* Crear una vista llamada VCantidadVentas que muestre por cada tienda su código, cantidad total de ventas y el importe total 
de todas esas ventas. La salida, mostrada en la siguiente tabla, deberá estar ordenada descendentemente según la cantidad total 
de ventas y el importe de las mismas. Incluir el código con la consulta a la vista. */

drop view if exists VCantidadVentas;
create view VCantidadVentas as
select 
    t.idTienda as `Id Tienda`,
    count(d.cantidad) as `Cantidad de Ventas`,
    sum(d.cantidad*ti.precio) as `Importe Total de Ventas`
from 
	Tiendas t 
    left join Ventas v on t.idTienda=v.idTienda
    left join Detalles d on v.codigoVenta=d.codigoVenta
    left join Titulos ti on ti.idTitulo=d.idTitulo
group by
	t.idTienda
order by 
	`Cantidad de Ventas`desc,
    `Importe Total de Ventas` desc;

select * from VCantidadVentas;

/*********************************************************************************************************************/

/* Realizar un procedimiento almacenado llamado NuevaEditorial para dar de alta una editorial, incluyendo el control
 de errores lógicos y mensajes de error necesarios (implementar la lógica del manejo de errores empleando parámetros de salida). 
 Incluir el código con la llamada al procedimiento probando todos los casos con datos incorrectos y uno con datos correctos. */

drop procedure if exists NuevaEditorial;
DELIMITER //
create procedure NuevaEditorial (
	pidEditorial char(4), 
    pnombre varchar(40), 
    pciudad varchar(20), 
    pestado char(2), 
    ppais varchar(30), 
    out mensaje varchar(60)
    )
salir: begin
/*
    -- Verificar si ppais es nulo o no
    if ppais is null then
        set ppais = 'USA'; -- Si ppais es nulo, usar el valor por defecto
    end if;
*/
-- Controlo que no haya una editorial con el mismo nombre
    if exists (select * from Editoriales where nombre=pnombre) then
		set mensaje = 'Error: Ya existe una editorial con este nombre';
		leave salir;
    end if;
-- Controlo que el nombre de la editorial no sea null
	if pnombre is null then
		set mensaje = 'Error: La editorial debe tener un nombre';
		leave salir;
	end if;
-- Controlo que no haya una editorial con la misma iD
	if exists (select * from Editoriales where idEditorial = pidEditorial) then
		set mensaje = 'Error: El Id de la editorial ya existe';
		leave salir;
	end if;
-- Controlo que el id no sea nulo
	if pidEditorial is null then
		set mensaje = 'Error: La editorial debe tener un Id';
		leave salir;
    else
		start transaction;
			insert into Editoriales values (pidEditorial, pnombre, pciudad, pestado, ppais);
			set mensaje = 'Editorial creada con éxito';
		commit;
	end if;
end //
DELIMITER ;

-- Ya existe editorial con este nombre
call NuevaEditorial('1000', 'New Moon Books', null, null, null, @mensaje);
select @mensaje as Mensaje;

-- Nombre null
call NuevaEditorial('1000', 'H', null, null, null, @mensaje);
select @mensaje as Mensaje;

-- idEditorial ya existe
call NuevaEditorial('0736', 'New Editorial', null, null, null, @mensaje);
select @mensaje as Mensaje;

-- No tiene id
call NuevaEditorial(null, 'New Editorial', null, null, null, @mensaje);
select @mensaje as Mensaje;

delete from Editoriales where idEditorial='1000';
-- Éxito
call NuevaEditorial('1000', 'New Editorial', null, null, 'USA', @mensaje);
select @mensaje as Mensaje;

select * from Editoriales where idEditorial='1000';

/************************************************************************************************************************/

/* */
