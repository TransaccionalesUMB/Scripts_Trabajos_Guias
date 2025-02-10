-- Creación de BDD
CREATE DATABASE Datos_masivos;
-- llamado de la BDD para utilizarla 
USE Datos_masivos;
-- Creación de tabla Factura
CREATE TABLE Factura (
    Numero INT PRIMARY KEY not null,
    Fecha DATE
);
-- Creación de tabla Producto
CREATE TABLE Producto (
    Codigo INT PRIMARY KEY not null,
    Nombre VARCHAR(100),
    Precio DECIMAL(10 , 2 )
);
-- Creación de tabla Detalle
CREATE TABLE Detalle (
    CodProducto INT not null,
    NumFactura INT not null,
    Item INT not null,
    Cantidad INT,
    PRIMARY KEY (CodProducto , NumFactura, Item ),
    FOREIGN KEY (CodProducto) REFERENCES Producto (Codigo),
    FOREIGN KEY (NumFactura) REFERENCES Factura (Numero)
);
-- Insercion de datos a la tabla Factura
INSERT INTO Factura (Numero, Fecha) VALUES
(1, 20240110),
(2, 20240215),
(3, 20240328),
(4, 20240507),
(5, 20240622),
(6, 20240819),
(7, 20241005),
(8, 20241130),
(9, 20250118),
(10, 20250310);
-- Insercion de datos a la tabla Producto
INSERT INTO Producto (Codigo, Nombre, Precio) VALUES
(1, 'Arroz', 10500),
(2, 'Frijoles', 15300),
(3, 'Azúcar', 19800),
(4, 'Sal', 5200),
(5, 'Harina', 8300),
(6, 'Aceite', 12200),
(7, 'Leche', 14800),
(8, 'Huevos', 18300),
(9, 'Pan', 22500),
(10, 'Pasta', 9100),
(11, 'Café', 11300),
(12, 'Té', 16200),
(13, 'Chocolate en polvo', 21300),
(14, 'Mantequilla', 6200),
(15, 'Queso', 7200),
(16, 'Yogur', 13250),
(17, 'Carne de res', 19200),
(18, 'Pollo', 24700),
(19, 'Pescado', 29250),
(20, 'Salchichas', 9300),
(21, 'Jamón', 14250),
(22, 'Lentejas', 20300),
(23, 'Garbanzo', 7300),
(24, 'Avena', 8200),
(25, 'Galletas', 10150),
(26, 'Jugo de naranja', 11200),
(27, 'Refresco', 13400),
(28, 'Agua embotellada', 17750),
(29, 'Verduras enlatadas', 21350),
(30, 'Atún enlatado', 23500),
(31, 'Mayonesa', 12250),
(32, 'Salsa de tomate', 14300),
(33, 'Vinagre', 16250),
(34, 'Mostaza', 18300),
(35, 'Pimienta', 22450),
(36, 'Comino', 24200),
(37, 'Canela', 26250),
(38, 'Clavo de olor', 28300),
(39, 'Laurel', 30200),
(40, 'Cebolla', 9700),
(41, 'Tomate', 12850),
(42, 'Papa', 15950),
(43, 'Zanahoria', 17850),
(44, 'Manzana', 19700),
(45, 'Plátano', 21350),
(46, 'Naranja', 23600),
(47, 'Uvas', 26150),
(48, 'Pera', 27500),
(49, 'Sandía', 29800),
(50, 'Melón', 31500);


-- 4. PROCEDIMIENTO ALMACENADO PARA INSERCIÓN MASIVA EN DETALLE
DELIMITER //

CREATE PROCEDURE InsertarDatosMasivosDetalle()
BEGIN
    DECLARE k INT DEFAULT 1;
    DECLARE CodProducto INT;
    DECLARE NumFactura INT;
    DECLARE Cantidad INT;
    
    -- Iniciar transacción
    START TRANSACTION;

    WHILE k <= 1000000 DO
        -- Seleccionar aleatoriamente una factura existente
        SELECT Numero INTO NumFactura FROM Factura ORDER BY RAND() LIMIT 1;

        -- Seleccionar aleatoriamente un producto existente
        SELECT Codigo INTO CodProducto FROM Producto ORDER BY RAND() LIMIT 1;

        -- Generar una cantidad aleatoria entre 1 y 100
        SET Cantidad = FLOOR(RAND() * 100) + 1;

        -- Insertar en la tabla Detalle
        INSERT INTO Detalle (CodProducto, NumFactura, Item, Cantidad) 
        VALUES (CodProducto, NumFactura, k, Cantidad);

        -- Incrementar el contador
        SET k = k + 1;
    END WHILE;

    -- Confirmar la transacción
    COMMIT;
END //

DELIMITER ;

-- LLamado de 1'000.000 de datos
CALL InsertarDatosMasivosDetalle();
-- vista del contador de datos
SELECT COUNT(*) FROM Detalle;
-- llamado de la tabla Detalle limitado a 10 registros aleatorios
SELECT * FROM Detalle ORDER BY RAND() LIMIT 10;
-- Eliminacion del Procedure en caso que se necesite volver a ejecutar
DROP PROCEDURE InsertarDatosMasivosDetalle;
