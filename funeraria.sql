CREATE DATABASE Funeraria;
USE Funeraria;

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(200)
);

CREATE TABLE Difuntos (
    id_difunto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    fecha_defuncion DATE NOT NULL,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Servicios (
    id_servicio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2)
);

CREATE TABLE Ventas (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_servicio INT,
    fecha_venta DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio)
);

/*inserccion de datos iniciales*/
 
INSERT INTO Clientes (nombre, telefono, direccion)
VALUES 
('Carlos Pérez', '3001234567', 'Calle 10 #5-67'),
('Laura Gómez', '3107654321', 'Carrera 45 #30-20');

INSERT INTO Difuntos (nombre, fecha_defuncion, id_cliente)
VALUES 
('Juan Pérez', '2025-03-15', 1),
('Ana Gómez', '2025-03-18', 2);

INSERT INTO Servicios (nombre, precio)
VALUES 
('Cremación', 1500.00),
('Entierro', 2500.00);

INSERT INTO Ventas (id_cliente, id_servicio, fecha_venta)
VALUES 
(1, 1, '2025-04-01'),
(2, 2, '2025-04-02');

/*procedimiento almacenado*/

DELIMITER //

CREATE PROCEDURE RegistrarVenta(
    IN p_id_cliente INT,
    IN p_id_servicio INT
)
BEGIN
    DECLARE existe INT;

    -- Verificar si el cliente existe
    SELECT COUNT(*) INTO existe
    FROM Clientes
    WHERE id_cliente = p_id_cliente;

    IF existe > 0 THEN
        -- Registrar la venta
        INSERT INTO Ventas (id_cliente, id_servicio, fecha_venta)
        VALUES (p_id_cliente, p_id_servicio, CURDATE());
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente no existe';
    END IF;
END;
//

DELIMITER ;
/*Llamda a el procedimieneto almacenado*/ 
CALL RegistrarVenta(1, 2); -- Vender el servicio con ID 2 al cliente con ID 1.
