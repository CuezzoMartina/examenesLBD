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

CREATE UNIQUE INDEX ui_PersonaConocimiento ON lbd2019examen.Habilidades (persona ASC, conocimiento ASC) VISIBLE;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/*****************************************************************************************************************/

/* Crear una vista llamada VHabilidades que muestre las personas, nombre del puesto, nombre del conocimiento y nombre 
del nivel. El formato de salida deberá ser Apellidos, Nombres, Puesto, Conocimiento, Nivel, y la lista deberá estar 
ordenada por apellidos y nombres. Incluir el código con la consulta a la vista. */

drop view if exists VHabilidades;
create view VHabilidades as
select
	p.apellidos as `Apellidos`,
    p.nombres as `Nombres`,
    pu.nombre as `Puesto`,
    c.nombre as `Conocimiento`,
    n.nombre as `Nivel`
from
	Habilidades h 
	left join Personas p on p.persona = h.persona
    inner join Puestos pu on pu.puesto = p.puesto
    inner join Conocimientos c on c.conocimiento = h.conocimiento
    inner join Niveles n on n.nivel = h.nivel
order by 
	p.apellidos, p.nombres asc;

select * from VHabilidades;

/*****************************************************************************************************************/

/* Realizar un procedimiento almacenado llamado NuevaPersona para dar de alta una persona, incluyendo el control 
de errores lógicos y mensajes de error necesarios (puesto, apellidos, nombres y fecha de ingreso no deben ser nulos, 
el puesto debe existir, no debe existir otra persona con el identificador de la persona que se quiere agregar). */

drop procedure if exists NuevaPersona;
DELIMITER //
create procedure NuevaPersona (
	ppersona int, 
	pnombres varchar(25), 
   	papellidos varchar(25),  
   	ppuesto int, 
    pfechaIngreso date,
    pfechaBaja date,
	out mensaje varchar(100)
    )
salir: begin
-- Controlo que el puesto exista
    if not exists (select * from Puestos where puesto = ppuesto) then
		set mensaje = 'Error: No existe el puesto.';
		leave salir;
    end if;
-- Controlo que atributos no sean null
	if ppersona is null or pnombres is null or papellidos is null or ppuesto is null or pfechaIngreso is null then
		set mensaje = 'Error: La persona debe tener identificador, nombre, apellido, puesto y fecha de ingreso.';
		leave salir;
	end if;
-- Controlo que no haya persona con la misma ID
	if exists (select * from Personas where persona = ppersona) then
		set mensaje = 'Error: Ya existe una persona con este ID.';
		leave salir;
    else
		start transaction;
			insert into Personas values (ppersona, pnombres, papellidos, ppuesto, pfechaIngreso, pfechaBaja);
			set mensaje = 'Persona creada con éxito';
		commit;
	end if;
end //
DELIMITER ;

-- No existe puesto
call NuevaPersona(100,'Nombre', 'Apellido', 4, '2023-01-02', null, @mensaje);
select @mensaje as Mensaje;

-- Nombre no puede ser null
call NuevaPersona(100, null, 'Apellido', 3, '2023-01-02', null, @mensaje);
select @mensaje as Mensaje;

-- fecha de ingreso no puede ser null
call NuevaPersona(100,'Nombre', 'Apellido', 3, null, null, @mensaje);
select @mensaje as Mensaje;

-- El id ya existe
call NuevaPersona(1,'Nombre', 'Apellido', 3, '2023-01-02', null, @mensaje);
select @mensaje as Mensaje;

-- OK
call NuevaPersona(100,'Nombre', 'Apellido', 3, '2023-01-02', null, @mensaje);
select @mensaje as Mensaje;

/***************************************************************************************************/

/* Realizar un procedimiento almacenado llamado PersonasConConocimiento que reciba el identificador 
de una categoría y de un conocimiento, y devuelva la cantidad de personas con el conocimiento y categoría 
especificados, y el nivel de los mismos. El formato de salida deberá ser Categoría (el nombre), 
Conocimiento (el nombre), Nivel (el nombre) y Personas (la cantidad). */

drop procedure if exists PersonasConConocimiento;
DELIMITER //
create procedure PersonasConConocimiento (
	pcategoria int,
    pconocimiento int
    )
salir: begin
	select 
		cat.nombre as `Categoría`,
		c.nombre as `Conocimiento`,
		n.nombre as `Nivel`,
		count(h.persona) as `Cantidad`
	from
		Habilidades h 
        join Conocimientos c on c.conocimiento = h.conocimiento
        join Categorias cat on c.categoria = cat.categoria
        join Niveles n on n.nivel = h.nivel
	where h.conocimiento = pconocimiento and c.categoria = pcategoria
	group by `Categoría`,`Conocimiento`,`Nivel`;
end //
DELIMITER ;

call PersonasConConocimiento(1,1);

/**********************************************************************************************************/

/* Utilizando triggers, implementar la lógica para que en caso que se quiera borrar un nivel, y exista alguna 
habilidad con el mismo, se informe mediante un mensaje de error que no se puede. Incluir el código con el borrado 
de un nivel para el cual no hay habilidades, y otro para el que sí. */ 

drop trigger if exists trigger_borrado_nivel;
DELIMITER //
create trigger trigger_borrado_nivel
before delete on Niveles for each row
begin
	if exists (select * from Habilidades where nivel = old.nivel) then
		signal sqlstate '45000' 
		set message_text = "El nivel no puede ser borrado ya que está referenciado por una habilidad";
	end if;
end //
DELIMITER ;

delete from Niveles where nivel = 4;