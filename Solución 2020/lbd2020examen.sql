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


/***********************************************************************************************************/

/* Realizar un procedimiento almacenado, llamado BorrarMateriaPrima, para borrar una materia prima. El mismo deberá 
incluir el control de errores lógicos y mensajes de error necesarios. Incluir el código con la llamada al 
procedimiento probando todos los casos con datos incorrectos y uno con datos correctos. */

drop procedure if exists BorrarMateriaPrima;
DELIMITER //
create procedure BorrarMateriaPrima (
	pIDMateriaPrima int, 
    out mensaje varchar(100)
    )
salir: begin
	if not exists (select * from MateriaPrima where IDMateriaPrima = pIDMateriaPrima) then
		set mensaje = 'No existe la materia prima';
        leave salir;
	elseif exists (select * from Composicion where IDMateriaPrima = pIDMateriaPrima) then
		set mensaje = 'No se puede eliminar la materia prima porque está referenciada en una composición';
        leave salir;
	else
		start transaction;
			delete from MateriaPrima where IDMateriaPrima = pIDMateriaPrima;
            set mensaje = 'Materia prima borrada con éxito';
		commit;
	end if;
end //
DELIMITER ;

-- No existe
call BorrarMateriaPrima(100, @mensaje);
select @mensaje as Mensaje;

-- Está referenciada
call BorrarMateriaPrima(2, @mensaje);
select @mensaje as Mensaje;

-- OK
call BorrarMateriaPrima(18, @mensaje);
select @mensaje as Mensaje;

/*********************************************************************************************************/

/* Realizar un procedimiento almacenado, llamado VerReceta, para que muestre una receta dada. Se deberá 
mostrar el nombre, rendimiento, unidades, categoría, composición y cantidad (tanto de materia prima como de 
otra receta que forme parte de la misma) y procedimiento. Al mostrar la composición (tanto de una materia prima
como de otra receta) mostrar el nombre de la materia prima o de la receta. */

drop procedure if exists VerReceta;
DELIMITER //
create procedure VerReceta (
	pIDReceta int, 
    out mensaje varchar(100)
    )
salir: begin
	if not exists (select * from Recetas where IDReceta = pIDReceta) then
		set mensaje = 'No existe la receta';
        leave salir;
	else
		start transaction;
			select 
				r.IDReceta,
				r.Nombre,
				r.Rendimiento,
				r.Unidad,
				r.Categoria,
				rc.Nombre as`Componente`,
				rr.Cantidad as `Componente Cantidad`,
				r.Procedimiento
			from
				Recetas r
				left join RecetasRecetas rr on r.IDReceta = rr.IDReceta
				inner join Recetas rc on rc.IDReceta = rr.IDComponente
			where r.IDReceta = 3
			union all
			select
				r.IDReceta,
				r.Nombre,
				r.Rendimiento,
				r.Unidad,
				r.Categoria,
				mp.Nombre as`Componente`,
				c.Cantidad as `Componente Cantidad`,
				r.Procedimiento
			from
				Recetas r
				left join Composicion c on r.IDReceta = c.IDReceta
				inner join MateriaPrima mp on mp.IDMateriaPrima = c.IDMateriaPrima
			where pIDReceta = r.IDReceta;
            set mensaje = 'Se encontró la receta con éxito';
		commit;
	end if;
end //
DELIMITER ;

call VerReceta(3,@mensaje);

/******************************************************************************************************************/

/* Crear una vista, llamada RankingMateriasPrimas, para que muestre un ranking con las materias primas que se emplean 
en mayor cantidad en las distintas recetas.  */

drop view if exists RankingMateriasPrimas;
create view RankingMateriasPrimas as
select
	mp.Nombre as `Materia Prima`,
    count(*) as `Cantidad de veces usada`
from
	MateriaPrima mp
    left join Composicion c on c.IDMateriaPrima = mp.IDMateriaPrima
group by mp.IDMateriaPrima
order by `Cantidad de veces usada` desc
limit 5;

select * from RankingMateriasPrimas;

/*******************************************************************************************************************/

