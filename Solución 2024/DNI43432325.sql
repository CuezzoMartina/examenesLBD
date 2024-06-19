-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema DNI43432325
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `DNI43432325` ;

-- -----------------------------------------------------
-- Schema DNI43432325
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `DNI43432325` DEFAULT CHARACTER SET utf8 ;
USE `DNI43432325` ;

-- -----------------------------------------------------
-- Table `DNI43432325`.`Categorias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DNI43432325`.`Categorias` ;

CREATE TABLE IF NOT EXISTS `DNI43432325`.`Categorias` (
  `IdCategoria` INT NOT NULL,
  `Categoria` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`IdCategoria`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `Categoria_UNIQUE` ON `DNI43432325`.`Categorias` (`Categoria` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `DNI43432325`.`Puestos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DNI43432325`.`Puestos` ;

CREATE TABLE IF NOT EXISTS `DNI43432325`.`Puestos` (
  `IdPuesto` INT NOT NULL,
  `Puesto` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`IdPuesto`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `Puesto_UNIQUE` ON `DNI43432325`.`Puestos` (`Puesto` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `DNI43432325`.`Personas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DNI43432325`.`Personas` ;

CREATE TABLE IF NOT EXISTS `DNI43432325`.`Personas` (
  `IdPersona` INT NOT NULL,
  `IdPuesto` INT NOT NULL,
  `Nombres` VARCHAR(25) NOT NULL,
  `Apellidos` VARCHAR(25) NOT NULL,
  `FechaIngreso` DATE NOT NULL,
  `FechaBaja` DATE NULL,
  PRIMARY KEY (`IdPersona`),
  CHECK (`FechaIngreso` < `FechaBaja`),
  CONSTRAINT `fk_Personas_Puestos1`
    FOREIGN KEY (`IdPuesto`)
    REFERENCES `DNI43432325`.`Puestos` (`IdPuesto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Personas_Puestos1_idx` ON `DNI43432325`.`Personas` (`IdPuesto` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `DNI43432325`.`Conocimientos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DNI43432325`.`Conocimientos` ;

CREATE TABLE IF NOT EXISTS `DNI43432325`.`Conocimientos` (
  `IdConocimiento` INT NOT NULL,
  `IdCategoria` INT NOT NULL,
  `Conocimiento` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`IdConocimiento`, `IdCategoria`),
  CONSTRAINT `fk_Conocimientos_Categorias1`
    FOREIGN KEY (`IdCategoria`)
    REFERENCES `DNI43432325`.`Categorias` (`IdCategoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Conocimientos_Categorias1_idx` ON `DNI43432325`.`Conocimientos` (`IdCategoria` ASC) VISIBLE;

CREATE UNIQUE INDEX `Conocimiento_UNIQUE` ON `DNI43432325`.`Conocimientos` (`Conocimiento` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `DNI43432325`.`Niveles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DNI43432325`.`Niveles` ;

CREATE TABLE IF NOT EXISTS `DNI43432325`.`Niveles` (
  `IdNivel` INT NOT NULL,
  `Nivel` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`IdNivel`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `Nivel_UNIQUE` ON `DNI43432325`.`Niveles` (`Nivel` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `DNI43432325`.`Habilidades`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DNI43432325`.`Habilidades` ;

CREATE TABLE IF NOT EXISTS `DNI43432325`.`Habilidades` (
  `IdHabilidad` INT NOT NULL,
  `IdPersona` INT NOT NULL,
  `IdConocimiento` INT NOT NULL,
  `IdCategoria` INT NOT NULL,
  `IdNivel` INT NOT NULL DEFAULT 1,
  `FechaUltimaModificacion` DATE NOT NULL DEFAULT (CURRENT_DATE),
  `Observaciones` VARCHAR(144) NULL,
  PRIMARY KEY (`IdHabilidad`),
  CONSTRAINT `fk_Habilidades_Niveles`
    FOREIGN KEY (`IdNivel`)
    REFERENCES `DNI43432325`.`Niveles` (`IdNivel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Habilidades_Personas1`
    FOREIGN KEY (`IdPersona`)
    REFERENCES `DNI43432325`.`Personas` (`IdPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Habilidades_Conocimientos1`
    FOREIGN KEY (`IdConocimiento` , `IdCategoria`)
    REFERENCES `DNI43432325`.`Conocimientos` (`IdConocimiento` , `IdCategoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Habilidades_Niveles_idx` ON `DNI43432325`.`Habilidades` (`IdNivel` ASC) VISIBLE;

CREATE INDEX `fk_Habilidades_Personas1_idx` ON `DNI43432325`.`Habilidades` (`IdPersona` ASC) VISIBLE;

CREATE INDEX `fk_Habilidades_Conocimientos1_idx` ON `DNI43432325`.`Habilidades` (`IdConocimiento` ASC, `IdCategoria` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


/***********************************************************************************************************************/

/* Crear una vista llamada vista_conocimientos_por_empleado, que muestre la categoría, conocimiento, empleado (apellidos y nombres) 
y nivel de los empleados, ordenados por categoría y conocimiento. En caso que el empleado no estuviera en actividad, 
en el nivel se mostrará “Dado de baja”. */

drop view if exists vista_conocimientos_por_empleado;
create view vista_conocimientos_por_empleado as
select
	cat.Categoria as `Categoría`,
    c.Conocimiento as `Conociemiento`,
    concat(p.Apellidos, ', ', p.Nombres) as `Empleado`,
	if(p.FechaBaja is null, n.Nivel, 'Dado de baja') as `Nivel`
from
	Habilidades h 
    left join Personas p on p.IdPersona = h.IdPersona
    inner join Niveles n on n.IdNivel = h.IdNivel
    inner join Conocimientos c on c.IdConocimiento = h.IdConocimiento
    inner join Categorias cat on cat.IdCategoria = c.IdCategoria
order by cat.Categoria asc, c.Conocimiento asc;

select * from vista_conocimientos_por_empleado;


/****************************************************************************************************************/

/* Realizar un procedimiento almacenado, llamado rsp_borrar_habilidad, para borrar una habilidad, efectuando las 
comprobaciones necesarias (devolver los mensajes de error correspondientes empleando parámetros de salida). */

drop procedure if exists rsp_borrar_habilidad;
DELIMITER //
create procedure rsp_borrar_habilidad (
	pIdHabilidad int,
	out mensaje varchar(100)
)
salir: begin
-- Controlo que el ID proporcionado no sea null
	if pIdHabilidad is null then
		set mensaje = 'Error: Se debe indicar el ID de la habilidad que se quiere borrar.';
		leave salir;
	end if;
-- Controlo que la habilidad exista
-- Controlo que el ID proporcionado no sea null
	if not exists (select * from Habilidades where IdHabilidad = pIdHabilidad) then
		set mensaje = concat('Error: No existe una habilidad con el ID ', pIdHabilidad, '.');
		leave salir;
	else
		start transaction;
			delete from Habilidades where IdHabilidad = pIdHabilidad;
			set mensaje = concat('Habilidad ID ', pIdHabilidad, ' borrada con éxito.');
		commit;
	end if;
end //
DELIMITER ;

-- No existe habilidad
call rsp_borrar_habilidad(100, @mensaje);
select @mensaje as Mensaje;

-- Se debe indicar ID
call rsp_borrar_habilidad(null, @mensaje);
select @mensaje as Mensaje;

-- OK
insert into Habilidades values(100, 1, 1, 1, 1, default, null);
call rsp_borrar_habilidad(100, @mensaje);
select @mensaje as Mensaje;

/*******************************************************************************************************************/

/* Realizar un procedimiento almacenado, llamado rsp_cantidades que muestre la cantidad de empleados que hay de cada 
conocimiento, ordenados por categoría y conocimiento de forma descendente, de la forma: Categoría, Conocimiento, Cantidad.
También se deberá mostrar, al final, una fila que muestre la cantidad total de categorías (distintas), la cantidad total de conocimientos 
y la cantidad total de empleados (tomar sólo las categorías y conocimientos que formen parte de las habilidades de los empleados) */

drop procedure if exists rsp_cantidades;
DELIMITER //
create procedure rsp_cantidades ()
salir: begin
	select 
		cat.Categoria as `Categoría`,
		c.Conocimiento as `Conocimiento`,
		count(h.IdPersona) as `Cantidad`
	from
		Habilidades h 
        join Conocimientos c on c.IdConocimiento = h.IdConocimiento
        join Categorias cat on c.IdCategoria = cat.IdCategoria
        join Personas p on h.IdPersona = p.IdPersona
	where p.FechaBaja is null
	group by cat.Categoria, c.Conocimiento
    union
    select
		count(distinct cat.Categoria),
        count(distinct c.Conocimiento),
		count(h.IdPersona)
	from
		Habilidades h 
        join Conocimientos c on c.IdConocimiento = h.IdConocimiento
        join Categorias cat on c.IdCategoria = cat.IdCategoria
        join Niveles n on n.IdNivel = h.IdNivel
		join Personas p on h.IdPersona = p.IdPersona
	where p.FechaBaja is null
	order by `Categoría` desc, `Conocimiento` desc
;
end //
DELIMITER ;

call rsp_cantidades;

/*********************************************************************************************************************************/

/* Utilizando triggers, implementar la lógica para que en caso que se quiera borrar un puesto que sea de alguna persona se informe 
mediante un mensaje de error que no se puede. Incluir el código con los borrados de un puesto que no tenga ninguna persona, y otro
de uno que sí.  */

drop trigger if exists trigger_borrado_puesto;
DELIMITER //
create trigger trigger_borrado_puesto
before delete on Puestos for each row
begin
	if exists (select * from Personas where IdPuesto = old.IdPuesto) then
	signal sqlstate '45000'
	set message_text = "El puesto no puede ser borrado ya que existe una persona con este puesto.";
	end if;
end //
DELIMITER ;

-- Puesto 3 está usado por una persona
delete from Puestos where IdPuesto = 3;

insert into Puestos values (4, 'Puesto 4');
delete from Puestos where IdPuesto = 4;

