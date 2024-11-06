
USE zapateria;
GO

-- Secuencia para IdDepartamento en el esquema Departamento
CREATE SEQUENCE Departamento.Seq_IdDepartamento
    AS INT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 99
    CYCLE;
GO


-- Ejemplo de inserción con la secuencia formateada como CHAR(2)
INSERT INTO Departamento.Departamentos(IdDepartamento, Departamento,Pais)
VALUES (RIGHT('00' + CAST(NEXT VALUE FOR Departamento.Seq_IdDepartamento AS VARCHAR(2)), 2), 'Sonsonate', 'El Salvador');


-- Secuencia para IdMunicipio en el esquema Departamento
CREATE SEQUENCE Departamento.Seq_IdMunicipio
    AS INT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 99
    CYCLE;
GO

-- Ejemplo de inserción con la secuencia formateada como CHAR(2)
INSERT INTO Departamento.Municipios(IdMunicipio, Municipio,IdDepartamento)
VALUES (RIGHT('00' + CAST(NEXT VALUE FOR Departamento.Seq_IdDepartamento AS VARCHAR(2)), 2), 'San Antonio', '01');


-- Secuencia para IdEmpleado en el esquema Persona
CREATE SEQUENCE Departamento.Seq_IdDistrito
    AS INT
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999
    CYCLE;
GO

-- Ejemplo de inserción con la secuencia formateada como CHAR(2)
INSERT INTO Departamento.Distritos(IdDistrito, Distrito,IdMunicipio)
VALUES (RIGHT('00' + CAST(NEXT VALUE FOR Departamento.Seq_IdDepartamento AS VARCHAR(2)), 2), 'Distrito Este', '02');



