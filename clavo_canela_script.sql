SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `clavo_canela` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `clavo_canela` ;

-- -----------------------------------------------------
-- Table `clavo_canela`.`tblbancos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblbancos` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblbancos` (
  `BancoID` INT(11) NOT NULL AUTO_INCREMENT ,
  `Nombre` VARCHAR(200) NULL ,
  `Telefono` VARCHAR(15) NULL ,
  `Comision` DECIMAL(10,2) NULL ,
  `Activo` TINYINT(1) NULL ,
  PRIMARY KEY (`BancoID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tbltipostarjeta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tbltipostarjeta` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tbltipostarjeta` (
  `TipoTarjetaID` INT(11) NOT NULL AUTO_INCREMENT ,
  `BancoID` INT(11) NOT NULL ,
  `Tipo` VARCHAR(50) NULL ,
  `Activa` VARCHAR(45) NULL ,
  PRIMARY KEY (`TipoTarjetaID`) ,
  INDEX `fk_tbltipostarjeta_tblbancos_idx` (`BancoID` ASC) ,
  CONSTRAINT `fk_tbltipostarjeta_tblbancos`
    FOREIGN KEY (`BancoID` )
    REFERENCES `clavo_canela`.`tblbancos` (`BancoID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tbltipofactura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tbltipofactura` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tbltipofactura` (
  `TipoFacturaID` INT(11) NOT NULL AUTO_INCREMENT ,
  `Tipo` VARCHAR(50) NULL ,
  `Activo` TINYINT(1) NULL ,
  PRIMARY KEY (`TipoFacturaID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblclientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblclientes` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblclientes` (
  `ClienteID` INT(11) NOT NULL AUTO_INCREMENT ,
  `Nombres` VARCHAR(50) NULL ,
  `Apellidos` VARCHAR(50) NULL ,
  `DUI` VARCHAR(15) NULL ,
  `FechaNacimiento` DATE NULL ,
  `Genero` VARCHAR(1) NULL ,
  `Direccion` VARCHAR(200) NULL ,
  `FechaRegistro` DATETIME NULL ,
  `Estado` VARCHAR(3) NULL ,
  PRIMARY KEY (`ClienteID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblfactura`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblfactura` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblfactura` (
  `FacturaID` INT(11) NOT NULL AUTO_INCREMENT ,
  `TipoFacturaID` INT(11) NOT NULL ,
  `ClienteID` INT(11) NOT NULL ,
  `EstadoFactura` VARCHAR(3) NULL ,
  `NoFactura` VARCHAR(20) NULL ,
  `RazonSocial` VARCHAR(100) NULL ,
  `Direccion` VARCHAR(200) NULL ,
  `Fecha` DATETIME NULL ,
  `Subtotal` DECIMAL(10,2) NULL ,
  `IVA` DECIMAL(10,2) NULL ,
  `Total` DECIMAL(10,2) NULL ,
  PRIMARY KEY (`FacturaID`) ,
  INDEX `fk_tblfactura_tbltipofactura1_idx` (`TipoFacturaID` ASC) ,
  INDEX `fk_tblfactura_tblclientes1_idx` (`ClienteID` ASC) ,
  CONSTRAINT `fk_tblfactura_tbltipofactura1`
    FOREIGN KEY (`TipoFacturaID` )
    REFERENCES `clavo_canela`.`tbltipofactura` (`TipoFacturaID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblfactura_tblclientes1`
    FOREIGN KEY (`ClienteID` )
    REFERENCES `clavo_canela`.`tblclientes` (`ClienteID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblpagos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblpagos` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblpagos` (
  `PagoID` INT(11) NOT NULL AUTO_INCREMENT ,
  `tblpagoscol` VARCHAR(45) NULL ,
  `FacturaID` INT(11) NOT NULL ,
  `TipoTarjetaID` INT(11) NOT NULL ,
  PRIMARY KEY (`PagoID`) ,
  INDEX `fk_tblpagos_tblfactura1_idx` (`FacturaID` ASC) ,
  INDEX `fk_tblpagos_tbltipostarjeta1_idx` (`TipoTarjetaID` ASC) ,
  CONSTRAINT `fk_tblpagos_tblfactura1`
    FOREIGN KEY (`FacturaID` )
    REFERENCES `clavo_canela`.`tblfactura` (`FacturaID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblpagos_tbltipostarjeta1`
    FOREIGN KEY (`TipoTarjetaID` )
    REFERENCES `clavo_canela`.`tbltipostarjeta` (`TipoTarjetaID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblordenes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblordenes` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblordenes` (
  `OredenID` INT(11) NOT NULL AUTO_INCREMENT ,
  `ClienteID` INT(11) NOT NULL ,
  `FacturaID` INT(11) NOT NULL ,
  `Estado` INT(11) NULL ,
  `FechaHoraOrden` DATETIME NULL ,
  PRIMARY KEY (`OredenID`) ,
  INDEX `fk_tblordenes_tblclientes1_idx` (`ClienteID` ASC) ,
  INDEX `fk_tblordenes_tblfactura1_idx` (`FacturaID` ASC) ,
  CONSTRAINT `fk_tblordenes_tblclientes1`
    FOREIGN KEY (`ClienteID` )
    REFERENCES `clavo_canela`.`tblclientes` (`ClienteID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblordenes_tblfactura1`
    FOREIGN KEY (`FacturaID` )
    REFERENCES `clavo_canela`.`tblfactura` (`FacturaID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblmenu`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblmenu` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblmenu` (
  `MenuID` INT(11) NOT NULL AUTO_INCREMENT ,
  `Nombre` VARCHAR(50) NULL ,
  `Descripcion` VARCHAR(100) NULL ,
  `Estado` VARCHAR(3) NULL ,
  `Costo` DECIMAL(10,2) NULL ,
  `PrecioVenta` DECIMAL(10,2) NULL ,
  `RutaImagen` VARCHAR(200) NULL ,
  PRIMARY KEY (`MenuID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblfacturadetalles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblfacturadetalles` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblfacturadetalles` (
  `FacturaDetalleID` INT(11) NOT NULL AUTO_INCREMENT ,
  `FacturaID` INT(11) NOT NULL ,
  `tblmenu_MenuID` INT NOT NULL ,
  `Catidad` DECIMAL(10,2) NULL ,
  `PrecioUnitario` DECIMAL(10,2) NULL ,
  `PrecioTotal` DECIMAL(10,2) NULL ,
  PRIMARY KEY (`FacturaDetalleID`) ,
  INDEX `fk_tblfacturadetalles_tblfactura1_idx` (`FacturaID` ASC) ,
  INDEX `fk_tblfacturadetalles_tblmenu1_idx` (`tblmenu_MenuID` ASC) ,
  CONSTRAINT `fk_tblfacturadetalles_tblfactura1`
    FOREIGN KEY (`FacturaID` )
    REFERENCES `clavo_canela`.`tblfactura` (`FacturaID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblfacturadetalles_tblmenu1`
    FOREIGN KEY (`tblmenu_MenuID` )
    REFERENCES `clavo_canela`.`tblmenu` (`MenuID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblordenesdetalles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblordenesdetalles` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblordenesdetalles` (
  `OrdenDetalleID` INT(11) NOT NULL AUTO_INCREMENT ,
  `OredenID` INT(11) NOT NULL ,
  `MenuID` INT(11) NOT NULL ,
  `Catidad` DECIMAL(10,2) NULL ,
  PRIMARY KEY (`OrdenDetalleID`) ,
  INDEX `fk_tblordenesdetalles_tblordenes1_idx` (`OredenID` ASC) ,
  INDEX `fk_tblordenesdetalles_tblmenu1_idx` (`MenuID` ASC) ,
  CONSTRAINT `fk_tblordenesdetalles_tblordenes1`
    FOREIGN KEY (`OredenID` )
    REFERENCES `clavo_canela`.`tblordenes` (`OredenID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblordenesdetalles_tblmenu1`
    FOREIGN KEY (`MenuID` )
    REFERENCES `clavo_canela`.`tblmenu` (`MenuID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`EstadoCivil`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`EstadoCivil` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`EstadoCivil` (
  `EstadiCivilID` INT(11) NOT NULL AUTO_INCREMENT ,
  `Nombre` VARCHAR(45) NULL ,
  `Descripcion` VARCHAR(45) NULL ,
  PRIMARY KEY (`EstadiCivilID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblempleados`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblempleados` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblempleados` (
  `EmpleadoID` INT(11) NOT NULL AUTO_INCREMENT ,
  `EstadiCivilID` INT(11) NOT NULL ,
  `Nombres` VARCHAR(50) NULL ,
  `Apellidos` VARCHAR(50) NULL ,
  `DUI` VARCHAR(15) NULL ,
  `Genero` VARCHAR(1) NULL ,
  `Direccion` VARCHAR(200) NULL ,
  `FechaNacimiento` DATE NULL ,
  `FechaIngreso` DATETIME NULL ,
  `FechaEgreso` DATETIME NULL ,
  `Estado` VARCHAR(3) NULL ,
  PRIMARY KEY (`EmpleadoID`) ,
  INDEX `fk_tblempleados_EstadoCivil1_idx` (`EstadiCivilID` ASC) ,
  CONSTRAINT `fk_tblempleados_EstadoCivil1`
    FOREIGN KEY (`EstadiCivilID` )
    REFERENCES `clavo_canela`.`EstadoCivil` (`EstadiCivilID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblusuarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblusuarios` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblusuarios` (
  `UsuarioID` INT NOT NULL AUTO_INCREMENT ,
  `EmpleadoID` INT(11) NOT NULL ,
  `ClienteID` INT(11) NOT NULL ,
  `NombreUsuario` VARCHAR(50) NULL ,
  `Activo` TINYINT(1) NULL ,
  PRIMARY KEY (`UsuarioID`) ,
  INDEX `fk_tblusuarios_tblempleados1_idx` (`EmpleadoID` ASC) ,
  INDEX `fk_tblusuarios_tblclientes1_idx` (`ClienteID` ASC) ,
  CONSTRAINT `fk_tblusuarios_tblempleados1`
    FOREIGN KEY (`EmpleadoID` )
    REFERENCES `clavo_canela`.`tblempleados` (`EmpleadoID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblusuarios_tblclientes1`
    FOREIGN KEY (`ClienteID` )
    REFERENCES `clavo_canela`.`tblclientes` (`ClienteID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblcontactos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblcontactos` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblcontactos` (
  `ContactoID` INT NOT NULL ,
  `ClienteID` INT(11) NOT NULL ,
  `EmpleadoID` INT(11) NOT NULL ,
  PRIMARY KEY (`ContactoID`) ,
  INDEX `fk_tblcontactos_tblclientes1_idx` (`ClienteID` ASC) ,
  INDEX `fk_tblcontactos_tblempleados1_idx` (`EmpleadoID` ASC) ,
  CONSTRAINT `fk_tblcontactos_tblclientes1`
    FOREIGN KEY (`ClienteID` )
    REFERENCES `clavo_canela`.`tblclientes` (`ClienteID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblcontactos_tblempleados1`
    FOREIGN KEY (`EmpleadoID` )
    REFERENCES `clavo_canela`.`tblempleados` (`EmpleadoID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblroles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblroles` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblroles` (
  `ROlID` INT(11) NOT NULL AUTO_INCREMENT ,
  `NombreRol` VARCHAR(45) NULL ,
  `Descripcion` VARCHAR(100) NULL ,
  `Estado` VARCHAR(3) NULL ,
  `Activo` TINYINT(1) NULL ,
  PRIMARY KEY (`ROlID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblrolesusuarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblrolesusuarios` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblrolesusuarios` (
  `UsuarioRolID` INT NOT NULL AUTO_INCREMENT ,
  `tblusuarios_UsuarioID` INT NOT NULL ,
  `tblroles_ROlID` INT(11) NOT NULL ,
  PRIMARY KEY (`UsuarioRolID`) ,
  INDEX `fk_tblrolesusuarios_tblusuarios1_idx` (`tblusuarios_UsuarioID` ASC) ,
  INDEX `fk_tblrolesusuarios_tblroles1_idx` (`tblroles_ROlID` ASC) ,
  CONSTRAINT `fk_tblrolesusuarios_tblusuarios1`
    FOREIGN KEY (`tblusuarios_UsuarioID` )
    REFERENCES `clavo_canela`.`tblusuarios` (`UsuarioID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblrolesusuarios_tblroles1`
    FOREIGN KEY (`tblroles_ROlID` )
    REFERENCES `clavo_canela`.`tblroles` (`ROlID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblencuestas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblencuestas` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblencuestas` (
  `EncuestaID` INT(11) NOT NULL AUTO_INCREMENT ,
  `URL` VARCHAR(250) NULL ,
  `FechaPublicacion` DATE NULL ,
  `Descripcion` VARCHAR(100) NULL ,
  `Activa` TINYINT(1) NULL ,
  PRIMARY KEY (`EncuestaID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblencuestasclientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblencuestasclientes` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblencuestasclientes` (
  `EncuestaClienteID` INT(11) NOT NULL AUTO_INCREMENT ,
  `EncuestaID` INT(11) NOT NULL ,
  `ClienteID` INT(11) NOT NULL ,
  `FechaRealizacion` DATE NULL ,
  PRIMARY KEY (`EncuestaClienteID`) ,
  INDEX `fk_tblencuestasclientes_tblencuestas1_idx` (`EncuestaID` ASC) ,
  INDEX `fk_tblencuestasclientes_tblclientes1_idx` (`ClienteID` ASC) ,
  CONSTRAINT `fk_tblencuestasclientes_tblencuestas1`
    FOREIGN KEY (`EncuestaID` )
    REFERENCES `clavo_canela`.`tblencuestas` (`EncuestaID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblencuestasclientes_tblclientes1`
    FOREIGN KEY (`ClienteID` )
    REFERENCES `clavo_canela`.`tblclientes` (`ClienteID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblpremisos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblpremisos` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblpremisos` (
  `PermisoID` INT(11) NOT NULL AUTO_INCREMENT ,
  `NombrePermiso` VARCHAR(45) NULL ,
  `Descripcion` VARCHAR(100) NULL ,
  `Activo` TINYINT(1) NULL ,
  PRIMARY KEY (`PermisoID`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `clavo_canela`.`tblrolespermisos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `clavo_canela`.`tblrolespermisos` ;

CREATE  TABLE IF NOT EXISTS `clavo_canela`.`tblrolespermisos` (
  `RolPermisoID` INT(11) NOT NULL AUTO_INCREMENT ,
  `ROlID` INT(11) NOT NULL ,
  `PermisoID` INT(11) NOT NULL ,
  PRIMARY KEY (`RolPermisoID`) ,
  INDEX `fk_tblrolespermisos_tblroles1_idx` (`ROlID` ASC) ,
  INDEX `fk_tblrolespermisos_tblpremisos1_idx` (`PermisoID` ASC) ,
  CONSTRAINT `fk_tblrolespermisos_tblroles1`
    FOREIGN KEY (`ROlID` )
    REFERENCES `clavo_canela`.`tblroles` (`ROlID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tblrolespermisos_tblpremisos1`
    FOREIGN KEY (`PermisoID` )
    REFERENCES `clavo_canela`.`tblpremisos` (`PermisoID` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `clavo_canela` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
