CREATE DATABASE Colegio;
USE Colegio;

/*creacion de tablas*/

CREATE TABLE Estudiantes (
    id_estudiante INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    grado VARCHAR(50)
);

CREATE TABLE Profesores (
    id_profesor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100)
);

CREATE TABLE Materias (
    id_materia INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    id_profesor INT,
    FOREIGN KEY (id_profesor) REFERENCES Profesores(id_profesor)
);

CREATE TABLE Calificaciones (
    id_calificacion INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT,
    id_materia INT,
    nota DECIMAL(5,2),
    FOREIGN KEY (id_estudiante) REFERENCES Estudiantes(id_estudiante),
    FOREIGN KEY (id_materia) REFERENCES Materias(id_materia)
);

/*inserccion de datos iniciales*/

INSERT INTO Estudiantes (nombre, fecha_nacimiento, grado)
VALUES 
('Ana López', '2010-05-15', '5to'),
('Carlos Gómez', '2009-08-20', '6to');

INSERT INTO Profesores (nombre, especialidad)
VALUES 
('María Pérez', 'Matemáticas'),
('Juan Rodríguez', 'Ciencias');

INSERT INTO Materias (nombre, id_profesor)
VALUES 
('Álgebra', 1),
('Biología', 2);

INSERT INTO Calificaciones (id_estudiante, id_materia, nota)
VALUES 
(1, 1, 85.50),
(2, 2, 90.00);

/*procedimiento almacenado */

DELIMITER //

CREATE PROCEDURE RegistrarCalificacion(
    IN p_id_estudiante INT,
    IN p_id_materia INT,
    IN p_nota DECIMAL(5,2)
)
BEGIN
    INSERT INTO Calificaciones (id_estudiante, id_materia, nota)
    VALUES (p_id_estudiante, p_id_materia, p_nota);
END;
//

DELIMITER ;

/*llamada a el procedimiento*/

CALL RegistrarCalificacion(1, 2, 95.00); -- Registrar una calificación de 95 para el estudiante con ID 1 en la materia con ID 2.
