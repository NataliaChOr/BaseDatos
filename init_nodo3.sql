DROP DATABASE IF EXISTS db_hospital_3;
CREATE DATABASE db_hospital_3;
USE db_hospital_3;

CREATE TABLE HOSPITALES (
    ID_Hospital INT NOT NULL PRIMARY KEY,
    Nombre_Sede VARCHAR(150) NOT NULL,
    Ciudad VARCHAR(100),
    Direccion VARCHAR(250)
);

CREATE TABLE MEDICAMENTOS (
    ID_Medicamento INT NOT NULL PRIMARY KEY,
    Nombre_Activo VARCHAR(180) NOT NULL,
    Presentacion VARCHAR(80),
    Gramaje VARCHAR(40)
);

CREATE TABLE MEDICOS (
    ID_Medico INT NOT NULL PRIMARY KEY,
    Nombre_Completo VARCHAR(180) NOT NULL,
    Especialidad VARCHAR(120),
    ID_Hospital INT NOT NULL,
    CONSTRAINT fk_medico_hospital FOREIGN KEY (ID_Hospital) REFERENCES HOSPITALES(ID_Hospital),
    CONSTRAINT chk_medico_nodo3 CHECK (ID_Hospital = 3)
);

CREATE TABLE PACIENTES (
    ID_Paciente INT NOT NULL PRIMARY KEY,
    Nombre_Completo VARCHAR(180) NOT NULL,
    CURP VARCHAR(18) NOT NULL UNIQUE,
    Fecha_Nacimiento DATE,
    ID_Hospital INT NOT NULL,
    CONSTRAINT fk_paciente_hospital FOREIGN KEY (ID_Hospital) REFERENCES HOSPITALES(ID_Hospital),
    CONSTRAINT chk_paciente_nodo3 CHECK (ID_Hospital = 3)
);

CREATE TABLE INVENTARIO_FARMACIA (
    ID_Hospital INT NOT NULL,
    ID_Medicamento INT NOT NULL,
    Stock_Actual INT NOT NULL,
    Punto_Reorden INT NOT NULL,
    PRIMARY KEY (ID_Hospital, ID_Medicamento),
    CONSTRAINT fk_inv_hospital FOREIGN KEY (ID_Hospital) REFERENCES HOSPITALES(ID_Hospital),
    CONSTRAINT fk_inv_medicamento FOREIGN KEY (ID_Medicamento) REFERENCES MEDICAMENTOS(ID_Medicamento),
    CONSTRAINT chk_inventario_nodo3 CHECK (ID_Hospital = 3)
);

CREATE TABLE EXPEDIENTE_OPERATIVO (
    ID_Expediente INT NOT NULL PRIMARY KEY,
    ID_Paciente INT NOT NULL UNIQUE,
    Estatus_Hospitalizacion VARCHAR(40),
    CONSTRAINT fk_exp_paciente FOREIGN KEY (ID_Paciente) REFERENCES PACIENTES(ID_Paciente)
);

CREATE TABLE EXPEDIENTE_CLINICO_CRITICO (
    ID_Expediente INT NOT NULL PRIMARY KEY,
    Tipo_Sangre VARCHAR(5),
    Alergias TEXT,
    CONSTRAINT fk_exp_critico FOREIGN KEY (ID_Expediente) REFERENCES EXPEDIENTE_OPERATIVO(ID_Expediente)
);

CREATE VIEW EXPEDIENTES_MEDICOS AS
SELECT 
    o.ID_Expediente,
    o.ID_Paciente,
    c.Tipo_Sangre,
    c.Alergias,
    o.Estatus_Hospitalizacion
FROM EXPEDIENTE_OPERATIVO o
INNER JOIN EXPEDIENTE_CLINICO_CRITICO c ON o.ID_Expediente = c.ID_Expediente;

CREATE TABLE CITAS_MEDICAS (
    ID_Cita INT NOT NULL PRIMARY KEY,
    Fecha_Hora DATETIME NOT NULL,
    Motivo_Consulta TEXT,
    ID_Paciente INT NOT NULL,
    ID_Medico INT NOT NULL,
    ID_Hospital INT NOT NULL,
    CONSTRAINT fk_cita_paciente FOREIGN KEY (ID_Paciente) REFERENCES PACIENTES(ID_Paciente),
    CONSTRAINT fk_cita_medico FOREIGN KEY (ID_Medico) REFERENCES MEDICOS(ID_Medico),
    CONSTRAINT fk_cita_hospital FOREIGN KEY (ID_Hospital) REFERENCES HOSPITALES(ID_Hospital),
    CONSTRAINT chk_cita_nodo3 CHECK (ID_Hospital = 3)
);

CREATE TABLE RECETAS (
    ID_Receta INT NOT NULL PRIMARY KEY,
    Fecha_Emision DATE NOT NULL,
    Estatus VARCHAR(30) NOT NULL,
    ID_Cita INT NOT NULL,
    ID_Paciente INT NOT NULL,
    CONSTRAINT fk_receta_cita FOREIGN KEY (ID_Cita) REFERENCES CITAS_MEDICAS(ID_Cita),
    CONSTRAINT fk_receta_paciente FOREIGN KEY (ID_Paciente) REFERENCES PACIENTES(ID_Paciente)
);

CREATE TABLE DETALLE_RECETA (
    ID_Receta INT NOT NULL,
    ID_Medicamento INT NOT NULL,
    Cantidad_Recetada INT NOT NULL,
    Dosis_Instrucciones TEXT,
    PRIMARY KEY (ID_Receta, ID_Medicamento),
    CONSTRAINT fk_detalle_receta FOREIGN KEY (ID_Receta) REFERENCES RECETAS(ID_Receta),
    CONSTRAINT fk_detalle_medicamento FOREIGN KEY (ID_Medicamento) REFERENCES MEDICAMENTOS(ID_Medicamento)
);