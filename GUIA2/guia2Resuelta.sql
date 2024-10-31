--Prevenir Actualización de Precios en Productos Antiguos: Crea un 
--INSTEAD OF UPDATE Trigger que impida actualizar los precios de productos 
--o tarifas que ya tienen más de 30 días en el sistemaa

CREATE TRIGGER trg_PrevenirActualizacionPrecios
ON Productos.Zapatos
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;  -- Evita que se devuelvan filas afectadas

    -- Actualiza los registros que no cambian el precio
    UPDATE p
    SET 
        p.Nombre = i.Nombre,
        p.Descripcion = i.Descripcion,
        p.Color = i.Color,
        p.Stock = i.Stock
    FROM Productos.Zapatos p
    INNER JOIN inserted i ON p.IdZapato = i.IdZapato
    WHERE i.Precio = p.Precio;  -- Solo actualiza si el precio no cambia

    -- Verifica si se está intentando cambiar el precio
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN deleted d ON i.IdZapato = d.IdZapato
        WHERE i.Precio <> d.Precio
    )
    BEGIN
        -- Si se intenta cambiar el precio, lanza un error
        RAISERROR('No se puede actualizar el precio de productos.', 16, 1);
    END
END;

SELECT 
    IdZapato,
    Nombre,
    Descripcion,
    Color,
    Precio,
    Stock
FROM 
    Productos.Zapatos;
go


-- segunda parte
-- Registrar Historial de Cambios en los Precios: Crea un AFTER UPDATE 
--Trigger que registre cada vez que se actualice el precio de un producto o tarifa

ALTER TABLE Productos.Zapatos
ADD HistorialPrecio VARCHAR(MAX); -- Esta columna almacenará el historial como texto
go

CREATE TRIGGER trg_RegistrarHistorialPrecio
ON Productos.Zapatos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON; -- Evita que se devuelvan filas afectadas

    -- Registra el cambio de precio si se actualiza
    UPDATE p
    SET HistorialPrecio = COALESCE(p.HistorialPrecio + '; ', '') +
                          'Cambio: Precio de ' + CAST(d.Precio AS VARCHAR) +
                          ' a ' + CAST(i.Precio AS VARCHAR) +
                          ' el ' + CONVERT(VARCHAR, GETDATE(), 120)
    FROM Productos.Zapatos p
    INNER JOIN inserted i ON p.IdZapato = i.IdZapato
    INNER JOIN deleted d ON p.IdZapato = d.IdZapato
    WHERE i.Precio <> d.Precio; -- Solo actualiza si el precio ha cambiado
END;

SELECT 
    IdZapato,
    Nombre,
    Descripcion,
    Color,
    Precio,
    Stock,
    HistorialPrecio
FROM 
    Productos.Zapatos;
go

--Registrar Fecha de Última Consulta/Compra/Reserva: Crea un AFTER 
--UPDATE Trigger en una tabla de pacientes (clínica), clientes (zapatería o 
--aerolínea), o usuarios (biblioteca) que actualice el campo FechaUltimaVisita
--cada vez que el cliente realiza una compra, consulta o reserva.ALTER TABLE Cliente.Clientes
ADD FechaUltimaVisita DATETIME;
go

CREATE TRIGGER trg_ActualizarFechaUltimaVisita
ON Cliente.Clientes
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON; -- Evita que se devuelvan filas afectadas

    -- Actualiza la fecha de la última visita
    UPDATE Cliente.Clientes
    SET FechaUltimaVisita = GETDATE()
    FROM Cliente.Clientes c
    INNER JOIN inserted i ON c.IdCliente = i.IdCliente; 
END;
go

SELECT 
    IdCliente,  
    NombresCliente,     
    FechaUltimaVisita
FROM 
    Cliente.Clientes;
