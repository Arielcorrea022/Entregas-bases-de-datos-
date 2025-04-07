CREATE DATABASE Hospital;
USE Hospital;

                         /*creacion de tablas */

                              /*pacientes */
CREATE TABLE Pacientes (
    id_paciente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20)
);
                                /*doctores */
CREATE TABLE Doctores (
    id_doctor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100),
    telefono VARCHAR(20)
);

                                    /*citas*/

CREATE TABLE Citas (
    id_cita INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT,
    id_doctor INT,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    motivo VARCHAR(200),
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (id_doctor) REFERENCES Doctores(id_doctor)
);

                                    /*historial medico*/

CREATE TABLE HistorialMedico (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT,
    diagnostico VARCHAR(200),
    tratamiento VARCHAR(200),
    fecha DATE NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente)
);
                              /*inserccion de datos iniciales */

INSERT INTO Pacientes (nombre, fecha_nacimiento, direccion, telefono)
VALUES 
('Juan Pérez', '1985-06-15', 'Calle 123', '3001234567'),
('Ana Gómez', '1990-03-22', 'Carrera 45', '3107654321');

INSERT INTO Doctores (nombre, especialidad, telefono)
VALUES 
('Dr. Carlos López', 'Cardiología', '3209876543'),
('Dra. María Torres', 'Pediatría', '3101239876');

                             /*procedimiento almacenado*/

DELIMITER //

CREATE PROCEDURE RegistrarCita(
    IN p_id_paciente INT,
    IN p_id_doctor INT,
    IN p_fecha DATE,
    IN p_hora TIME,
    IN p_motivo VARCHAR(200)
)
BEGIN
    INSERT INTO Citas (id_paciente, id_doctor, fecha, hora, motivo)
    VALUES (p_id_paciente, p_id_doctor, p_fecha, p_hora, p_motivo);
END;
//

DELIMITER ;

                         /*llamada al procedimiento*/

CALL RegistrarCita(1, 2, '2025-04-05', '10:30:00', 'Chequeo general');