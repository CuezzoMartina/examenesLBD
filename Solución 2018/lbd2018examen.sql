-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema lbd2018examen
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `lbd2018examen` ;

-- -----------------------------------------------------
-- Schema lbd2018examen
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `lbd2018examen` DEFAULT CHARACTER SET utf8 ;
USE `lbd2018examen` ;

-- -----------------------------------------------------
-- Table `lbd2018examen`.`Trabajos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2018examen`.`Trabajos` ;

CREATE TABLE IF NOT EXISTS `lbd2018examen`.`Trabajos` (
  `idTrabajo` INT NOT NULL,
  `titulo` VARCHAR(100) NOT NULL,
  `duracion` INT NOT NULL DEFAULT 6,
  `area` ENUM('Hardware', 'Redes', 'Software') NOT NULL,
  `fechaPresentacion` DATE NOT NULL,
  `fechaAprobacion` DATE NOT NULL,
  `fechaFinalizacion` DATE,
  PRIMARY KEY (`idTrabajo`),
  UNIQUE INDEX `titulo_UNIQUE` (`titulo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2018examen`.`Personas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2018examen`.`Personas` ;

CREATE TABLE IF NOT EXISTS `lbd2018examen`.`Personas` (
  `dni` INT NOT NULL,
  `apellidos` VARCHAR(40) NOT NULL,
  `nombres` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`dni`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2018examen`.`Cargos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2018examen`.`Cargos` ;

CREATE TABLE IF NOT EXISTS `lbd2018examen`.`Cargos` (
  `idCargo` INT NOT NULL,
  `cargo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idCargo`),
  UNIQUE INDEX `cargo_UNIQUE` (`cargo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2018examen`.`Profesores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2018examen`.`Profesores` ;

CREATE TABLE IF NOT EXISTS `lbd2018examen`.`Profesores` (
  `dni` INT NOT NULL,
  `idCargo` INT NOT NULL,
  PRIMARY KEY (`dni`),
  INDEX `fk_Profesores_Cargos1_idx` (`idCargo` ASC) VISIBLE,
  CONSTRAINT `fk_Profesores_Personas`
    FOREIGN KEY (`dni`)
    REFERENCES `lbd2018examen`.`Personas` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Profesores_Cargos1`
    FOREIGN KEY (`idCargo`)
    REFERENCES `lbd2018examen`.`Cargos` (`idCargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2018examen`.`Alumnos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2018examen`.`Alumnos` ;

CREATE TABLE IF NOT EXISTS `lbd2018examen`.`Alumnos` (
  `dni` INT NOT NULL,
  `cx` CHAR(7) NOT NULL,
  PRIMARY KEY (`dni`),
  CONSTRAINT `fk_Alumnos_Personas1`
    FOREIGN KEY (`dni`)
    REFERENCES `lbd2018examen`.`Personas` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2018examen`.`AlumnosEnTrabajos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2018examen`.`AlumnosEnTrabajos` ;

CREATE TABLE IF NOT EXISTS `lbd2018examen`.`AlumnosEnTrabajos` (
  `idTrabajo` INT NOT NULL,
  `dni` INT NOT NULL,
  `desde` DATE NOT NULL,
  `hasta` DATE NULL,
  `razon` VARCHAR(100) NULL,
  PRIMARY KEY (`idTrabajo`, `dni`),
  INDEX `fk_AlumnosEnTrabajos_Trabajos1_idx` (`idTrabajo` ASC) VISIBLE,
  INDEX `fk_AlumnosEnTrabajos_Alumnos1_idx` (`dni` ASC) VISIBLE,
  CONSTRAINT `fk_AlumnosEnTrabajos_Alumnos1`
    FOREIGN KEY (`dni`)
    REFERENCES `lbd2018examen`.`Alumnos` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AlumnosEnTrabajos_Trabajos1`
    FOREIGN KEY (`idTrabajo`)
    REFERENCES `lbd2018examen`.`Trabajos` (`idTrabajo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `lbd2018examen`.`RolesEnTrabajos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `lbd2018examen`.`RolesEnTrabajos` ;

CREATE TABLE IF NOT EXISTS `lbd2018examen`.`RolesEnTrabajos` (
  `idTrabajo` INT NOT NULL,
  `dni` INT NOT NULL,
  `rol` ENUM('Tutor', 'Cotutor', 'Jurado') NOT NULL,
  `desde` DATE NOT NULL,
  `hasta` DATE NULL,
  `razon` VARCHAR(100) NULL,
  PRIMARY KEY (`idTrabajo`, `dni`),
  INDEX `fk_RolesEnTrabajos_Trabajos1_idx` (`idTrabajo` ASC) VISIBLE,
  INDEX `fk_RolesEnTrabajos_Profesores1_idx` (`dni` ASC) VISIBLE,
  CONSTRAINT `fk_RolesEnTrabajos_Profesores1`
    FOREIGN KEY (`dni`)
    REFERENCES `lbd2018examen`.`Profesores` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RolesEnTrabajos_Trabajos1`
    FOREIGN KEY (`idTrabajo`)
    REFERENCES `lbd2018examen`.`Trabajos` (`idTrabajo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/************************************************************************************************************/

/* Crear un procedimiento llamado DetalleRoles, que reciba un rango de años y que muestre: Año, DNI, Apellidos, 
Nombres, Tutor, Cotutor y Jurado, donde Tutor, Cotutor y Jurado muestran la cantidad de trabajos en los que un 
profesor participó en un trabajo con ese rol entre el rango de fechas especificado. El listado se mostrará ordenado 
por el año, apellidos, nombres y DNI (se pueden emplear vistas u otras estructuras para lograr la funcionalidad solicitada. 
Para obtener el año de una fecha se puede emplear la función YEAR()) */

drop procedure if exists DetalleRoles;
DELIMITER //
create procedure DetalleRoles (
	anio1 int, 
	anio2 int
    )
begin
	select 
		year(rt.desde) as `Año`,
        p.dni as `DNI`,
        pe.apellidos as `Apellidos`,
        pe.nombres as `Nombres`,
        (select count(*) from RolesEnTrabajos where rol = 'Tutor' and p.dni = dni and year(desde) between anio1 and anio2) as `Tutor`,
        (select count(*) from RolesEnTrabajos where rol = 'Cotutor' and p.dni = dni and year(desde) between anio1 and anio2) as `Cotutor`,
        (select count(*) from RolesEnTrabajos where rol = 'Jurado' and p.dni = dni and year(desde) between anio1 and anio2) as `Jurado`
	from
		RolesEnTrabajos rt 
        left join Profesores p on p.dni = rt.dni
        inner join Personas pe on p.dni = pe.dni
	where year(rt.desde) between anio1 and anio2
	group by 
		rt.dni, year(rt.desde)
	order by
		year(rt.desde), pe.apellidos, pe.nombres, p.dni;	
end //
DELIMITER ;

call DetalleRoles(2015, 2017);