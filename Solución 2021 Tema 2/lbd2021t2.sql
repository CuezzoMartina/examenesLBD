-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema lbd2021t2
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `lbd2021t2` ;

-- -----------------------------------------------------
-- Schema lbd2021t2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lbd2021t2` DEFAULT CHARACTER SET utf8 ;
USE `lbd2021t2` ;

-- -----------------------------------------------------
-- Table `lbd2021t2`.`Peliculas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t2`.`Peliculas` ;

CREATE TABLE IF NOT EXISTS `lbd2021t2`.`Peliculas` (
  `idPelicula` INT NOT NULL,
  `titulo` VARCHAR(128) NOT NULL UNIQUE,
  `clasificacion` ENUM('G', 'PG', 'PG-13', 'R', 'NC-17') NOT NULL DEFAULT 'G',
  `estreno` INT NULL,
  `duracion` INT NULL,
  PRIMARY KEY (`idPelicula`),
  UNIQUE INDEX `titulo_UNIQUE` (`titulo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2021t2`.`Direcciones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t2`.`Direcciones` ;

CREATE TABLE IF NOT EXISTS `lbd2021t2`.`Direcciones` (
  `idDireccion` INT NOT NULL,
  `calleYNumero` VARCHAR(60) NOT NULL UNIQUE,
  `codigoPostal` VARCHAR(10) NULL,
  `telefono` VARCHAR(25) NOT NULL,
  `municipio` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`idDireccion`),
  UNIQUE INDEX `calleYNumero_UNIQUE` (`calleYNumero` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2021t2`.`Personal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t2`.`Personal` ;

CREATE TABLE IF NOT EXISTS `lbd2021t2`.`Personal` (
  `idPersonal` INT NOT NULL,
  `apellidos` VARCHAR(50) NOT NULL,
  `nombres` VARCHAR(50) NOT NULL,
  `correo` VARCHAR(50) NULL UNIQUE,
  `estado` ENUM('E', 'D') NOT NULL DEFAULT 'E',
  `idDireccion` INT NOT NULL,
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
-- Table `lbd2021t2`.`Sucursales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t2`.`Sucursales` ;

CREATE TABLE IF NOT EXISTS `lbd2021t2`.`Sucursales` (
  `idSucursal` CHAR(10) NOT NULL,
  `idDireccion` INT NOT NULL,
  `idGerente` INT NOT NULL,
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
-- Table `lbd2021t2`.`Inventario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t2`.`Inventario` ;

CREATE TABLE IF NOT EXISTS `lbd2021t2`.`Inventario` (
  `idInventario` INT NOT NULL,
  `idPelicula` INT NOT NULL,
  `idSucursal` CHAR(10) NOT NULL,
  PRIMARY KEY (`idInventario`),
  INDEX `fk_Inventario_Sucursales1_idx` (`idSucursal` ASC) VISIBLE,
  INDEX `fk_Inventario_Peliculas1_idx` (`idPelicula` ASC) VISIBLE,
  CONSTRAINT `fk_Inventario_Sucursales1`
    FOREIGN KEY (`idSucursal`)
    REFERENCES `lbd2021t2`.`Sucursales` (`idSucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Inventario_Peliculas1`
    FOREIGN KEY (`idPelicula`)
    REFERENCES `lbd2021t2`.`Peliculas` (`idPelicula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2021t2`.`Generos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t2`.`Generos` ;

CREATE TABLE IF NOT EXISTS `lbd2021t2`.`Generos` (
  `idGenero` CHAR(10) NOT NULL,
  `nombre` VARCHAR(30) NOT NULL UNIQUE,
  PRIMARY KEY (`idGenero`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2021t12.`GenerosDePeliculas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2021t2`.`GenerosDePeliculas` ;

CREATE TABLE IF NOT EXISTS `lbd2021t2`.`GenerosDePeliculas` (
  `idGenero` CHAR(10) NOT NULL,
  `idPelicula` INT NOT NULL,
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

/* Crear una vista llamada VRankingPeliculas que muestre un ranking con las 10 películas que más cantidad se tenga 
en inventario. Por cada película se deberá mostrar su código, título y la cantidad total entre las distintas sucursales. 
La salida deberá estar ordenada descendentemente según la cantidad de películas, y para el caso de 2 películas con la
misma cantidad, alfabéticamente según el título. Incluir el código con la consulta a la vista. */

drop view if exists VRankingPeliculas;
create view VRankingPeliculas as
select 
	p.idPelicula as `Id Película`,
    p.titulo as `Título`,
    count(*) as `Cantidad`
from 
	Peliculas p
    left join inventario i on i.idPelicula = p.idPelicula
group by p.idPelicula
order by `Cantidad` desc, p.titulo asc
limit 10;

select * from VRankingPeliculas;

/***********************************************************************************************************/

/* Realizar un procedimiento almacenado llamado NuevaPelicula para dar de alta una película, incluyendo el 
control de errores lógicos y mensajes de error necesarios (implementar la lógica del manejo de errores 
empleando parámetros de salida). Incluir el código con la llamada al procedimiento probando todos los casos 
con datos incorrectos y uno con datos correctos. */

drop procedure if exists NuevaPelicula;
DELIMITER //
create procedure NuevaPelicula (
	pidPelicula int,
    ptitulo varchar(128),
    pclasificacion enum('G','PG','PG-13','R','NC-17'),
    pestreno int,
    pduracion int,
    out mensaje varchar(60)
    )
salir: begin
	if exists (select * from Peliculas where titulo = ptitulo) then
		set mensaje = 'Ya existe una película con este título';
        leave salir;
	end if;
    if exists (select * from Peliculas where idPelicula = pidPelicula) then
		set mensaje = 'Ya existe una película con este ID';
        leave salir;
	end if;
    if pidPelicula is null or pidPelicula = 0 then
		set mensaje = 'El ID no es válido';
        leave salir;
	end if;
    if ptitulo is null then
		set mensaje = 'La película debe tener un título';
        leave salir;
	else
		start transaction;
		insert into Peliculas values (pidPelicula, ptitulo, pclasificacion, pestreno, pduracion);
        set mensaje = 'Película creada con éxito';
		commit;
	end if;
end //
DELIMITER ;

select * from peliculas order by idPelicula desc;

-- Ya existe una película con este título
call NuevaPelicula(2000, 'ZORRO ARK', 'PG', null, null, @mensaje);
select @mensaje as Mensaje;

-- Ya existe película con este ID
call NuevaPelicula(1000, 'pelicula', 'PG', null, null, @mensaje);
select @mensaje as Mensaje;

-- El ID no es válido
call NuevaPelicula(0, 'Película', 'PG', null, null, @mensaje);
select @mensaje as Mensaje;

-- Debe tener titulo
call NuevaPelicula(2000, null, 'PG', null, null, @mensaje);
select @mensaje as Mensaje;

-- OK
call NuevaPelicula(2000, 'Película', 'PG', null, null, @mensaje);
select @mensaje as Mensaje;

select * from Peliculas where idPelicula = 2000;

/************************************************************************************************************/

/* Realizar un procedimiento almacenado llamado TotalPeliculas que muestre por cada género de película su código, 
nombre y cantidad de películas con el mismo. Al final del listado deberá mostrar también la cantidad de películas 
en total para todos los géneros. La salida deberá estar ordenada alfabéticamente según el nombre del género. */

drop procedure if exists TotalPeliculas;
DELIMITER //
create procedure TotalPeliculas ()
begin
	start transaction;
		select 
			g.idGenero as `Id Género`,
			g.nombre as `Nombre`,
			count(*) as `Cantidad`
		from 
			Generos g
			left join GenerosDePeliculas gp on g.idGenero = gp.idGenero
        group by g.idGenero
		union all 
        select
			"---" as `Id Género`,
			"---" as `Nombre`,
			count(gp.idPelicula) as `Cantidad`
		from
			GenerosDePeliculas as gp
        order by `Nombre` asc;
	commit;
end //
DELIMITER ;

call TotalPeliculas();

/******************************************************************************************************************/

/* Utilizando triggers, implementar la lógica para que en caso que se quiera borrar una película referenciada en 
un inventario o catalogada con algún género informe mediante un mensaje de error que no se puede. Incluir el código 
con los borrados de una película para la cual no hay un inventario ni tiene un género, y otro para la que sí. */

drop trigger if exists TBorrarPelicula;
DELIMITER //
create trigger TBorrarPelicula
before delete on Peliculas for each row
begin
	if exists (select * from Inventario where idPelicula=old.idPelicula) then
		signal sqlstate '45000' 
		set message_text = "La película no se puede borrar porque está referenciada en un inventario";
	end if;
    if exists (select * from GenerosDePeliculas where idPelicula=old.idPelicula) then
		signal sqlstate '45001' 
		set message_text = "La película no se puede borrar porque está catalogada con algún género";
	end if;
end //
DELIMITER ;

/* Referenciada en un inventario */
delete from Peliculas where idPelicula = 1;

/* Catalogada con algún género */
delete from Inventario where idPelicula = 100;
delete from Peliculas where idPelicula = 100;

/* Dirección sin referenciar */
insert into Peliculas values (1001, 'Película de prueba', 'G', null, null);
delete from Peliculas where idPelicula = 1001;
