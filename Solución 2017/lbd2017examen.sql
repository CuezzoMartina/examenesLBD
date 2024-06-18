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
  `IdCategoria` INT NULL,
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


/**************************************************************************************************************/

/* Crear un SP, llamado sp_CargarProducto, que permita dar de alta un producto, efectuar las 
comprobaciones necesarias y devolver los mensajes de error correspondiente */

drop procedure if exists sp_CargarProducto;
DELIMITER //
create procedure sp_CargarProducto (
	pIdProducto int, 
	pNombre varchar(50), 
   	pColor varchar(15),  
   	pPrecio decimal(10,4), 
    pIdCategoria int,
	out mensaje varchar(100)
    )
salir: begin
-- Controlo que no haya un producto con el mismo nombre
    if exists (select * from Productos where Nombre=pNombre) then
		set mensaje = 'Error: Ya existe un producto con este nombre';
		leave salir;
    end if;
-- Controlo que columnas no sean null
	if pNombre is null or pIdProducto is null or pPrecio is null then
		set mensaje = 'Error: El producto debe tener un ID, nombre, precio y categoría';
		leave salir;
	end if;
-- Controlo que no haya un producto con el mismo ID
	if exists (select * from Productos where IdProducto = pIdProducto) then
		set mensaje = 'Error: Ya existe un producto con este ID';
		leave salir;
    else
		start transaction;
			insert into Productos values (pIdProducto, pNombre, pColor, pPrecio, pIdCategoria);
			set mensaje = 'Producto creado con éxito';
		commit;
	end if;
end //
DELIMITER ;

-- Ya existe producto con ese nombre
call sp_CargarProducto(100, 'Sport-100 Helmet, Red', null, 100, 1, @mensaje);
select @mensaje as Mensaje;

-- Valor no puede ser null
call sp_CargarProducto(100, null, null, 100, 1, @mensaje);
select @mensaje as Mensaje;

-- Ya existe id
call sp_CargarProducto(707, 'Nuevo Producto', null, 100, 1, @mensaje);
select @mensaje as Mensaje;

-- OK
call sp_CargarProducto(100, 'Nuevo Producto', null, 100, 1, @mensaje);
select @mensaje as Mensaje;

/**************************************************************************************************************************/

/* Realizar una vista, llamada VTotalVentas, en donde se muestre el número de venta, la fecha de venta  en el formato “dd/mm/aaaa”, 
el apellido y nombre del cliente, el nombre del producto, la categoría (NULL o vacío mostrar S/C), la cantidad de productos, 
el precio unitario y colocar en una nueva fila el “Total” de ventas recaudado */

drop view if exists VTotalVentas;
create view VTotalVentas as
select
	v.IdVenta as `Número de Venta`,
    date_format(date(v.Fecha), '%d/%m/%Y') as `Fecha de Venta`,
	concat(c.Apellidos, ' ', c.Nombres) as `Cliente`,
    p.Nombre as `Producto`,
    coalesce(cat.Nombre, 'S/C') as `Categoría`,
    d.Cantidad as `Cantidad`,
    d.Precio as `Precio Unitario`,
    (d.Precio * `Cantidad`) as `Total`
from
	Ventas v
    left join Clientes c on c.IdCliente = v.IdCliente
    left join Detalles d on d.IdVenta = v.IdVenta
    inner join Productos p on d.IdProducto = p.IdProducto
    inner join Categorias cat on cat.IdCategoria = p.IdCategoria
order by v.IdVenta;

select * from VTotalVentas;

/***************************************************************************************************************/

/* Realizar un trigger llamado AuditarOfertas el cual se dispare luego de insertar una oferta cuyo descuento tenga un 
valor mayor o igual al 10%, los datos se deben guardar en la tabla auditoria guardando el nuevo valor de id oferta, 
descuento, fecha inicio, fecha fin, cantidad mínima y la cantidad máxima, el usuario la fecha en que se realizó  */

drop table if exists `AuditoriasOfertas` ;
create table if not exists `AuditoriasOfertas` (
  `IdAuditoria` 	int not null auto_increment,
  `Usuario` 		varchar(45) not null,   
  `Fecha` 			datetime not null,
  `IdOferta` 		int not null,
  `Descuento`		float not null,
  `FechaInicio` 	datetime not null,
  `FechaFin` 		datetime not null,
  `CantidadMinima` 	int not null,
  `CantidadMaxima` 	int null,
  primary key (`IdAuditoria`)
) engine=INNODB;

drop trigger if exists AuditarOfertas;
DELIMITER //
create trigger AuditarOfertas 
after insert on Ofertas for each row
begin
	insert into AuditoriasOfertas values (
		default, 
		substring_index(user(), '@', 1),  -- Usuario
		now(),
		new.IdOferta,
		new.Descuento, 
		new.FechaInicio,
        new.FechaFin,
        new.CantidadMinima,
        new.CantidadMaxima
	);
end //
DELIMITER ;

insert into Ofertas values(100, 0.15, '2023-05-06','2023-06-14', 2, null);

select * from AuditoriasOfertas;

