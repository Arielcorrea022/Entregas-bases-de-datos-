CREATE DATABASE Supermercado;
USE Supermercado;

/*creacion de tablas*/

/*productos*/

CREATE TABLE Productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL
);

/*proveedores*/

CREATE TABLE Proveedores (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(200)
);

/*clientes*/

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(200)
);

/*ventas*/

CREATE TABLE Ventas (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    fecha DATE NOT NULL,
    total DECIMAL(10, 2),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

/*detalles ventas*/

CREATE TABLE DetalleVentas (
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    id_venta INT,
    id_producto INT,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10, 2),
    FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
);

/*inserccion de datos iniciales*/

INSERT INTO Productos (nombre, precio, stock)
VALUES 
('Arroz', 2.50, 100),
('Leche', 1.20, 50),
('Pan', 0.80, 200);

INSERT INTO Proveedores (nombre, telefono, direccion)
VALUES 
('Proveedor A', '3001234567', 'Calle 10 #5-67'),
('Proveedor B', '3107654321', 'Carrera 45 #30-20');

INSERT INTO Clientes (nombre, telefono, direccion)
VALUES 
('Juan Pérez', '3209876543', 'Calle 123'),
('Ana Gómez', '3101239876', 'Carrera 45');

/*procedimiento almacenado*/

DELIMITER //

CREATE PROCEDURE RegistrarVenta(
    IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE nuevo_stock INT;
    DECLARE precio_producto DECIMAL(10, 2);
    DECLARE subtotal DECIMAL(10, 2);

    -- Obtener el stock y precio del producto
    SELECT stock, precio INTO nuevo_stock, precio_producto
    FROM Productos
    WHERE id_producto = p_id_producto;

    IF nuevo_stock >= p_cantidad THEN
        -- Calcular subtotal
        SET subtotal = precio_producto * p_cantidad;

        -- Registrar la venta
        INSERT INTO Ventas (id_cliente, fecha, total)
        VALUES (p_id_cliente, CURDATE(), subtotal);

        -- Obtener el ID de la venta recién creada
        SET @id_venta = LAST_INSERT_ID();

        -- Registrar el detalle de la venta
        INSERT INTO DetalleVentas (id_venta, id_producto, cantidad, subtotal)
        VALUES (@id_venta, p_id_producto, p_cantidad, subtotal);

        -- Actualizar el stock del producto
        UPDATE Productos
        SET stock = stock - p_cantidad
        WHERE id_producto = p_id_producto;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;
END;
//

DELIMITER ;

/*llamda de procedimiento */

CALL RegistrarVenta(1, 1, 5); -- Cliente con ID 1 compra 5 unidades del producto con ID 1.
 



