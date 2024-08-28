CREATE TABLE `estoque`.`Categorias` (
  `idCategoria` INT NOT NULL AUTO_INCREMENT,
  `categoriaDescr` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idCategoria`)
);

CREATE TABLE `estoque`.`Subcategorias` (
  `idSubcategoria` INT NOT NULL AUTO_INCREMENT,
  `subcategoriaDescr` VARCHAR(100) NOT NULL,
  `categoria` INT NOT NULL,
  PRIMARY KEY (`idSubcategoria`),
  INDEX `fk_Subcategorias_1_idx` (`categoria` ASC) VISIBLE,
  CONSTRAINT `fk_Subcategorias_1`
    FOREIGN KEY (`categoria`)
    REFERENCES `estoque`.`Categorias` (`idCategoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


