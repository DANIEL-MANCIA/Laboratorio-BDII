-- xxxxXXXX EJERCCIO 3 XXXXxxx
-- Actualizar Stock Después de una Venta/Préstamo/Reserva: Crea un 
-- AFTER INSERT Trigger que, después de insertar un pedido o reserva, 
-- actualice el stock en la tabla de inventario y la fecha en la que se hizo
USE zapateria;
GO
CREATE TRIGGER trg_UpdateStockAfterSale
ON Ventas.Detalles_De_Ventas
AFTER INSERT
AS
BEGIN
    DECLARE @IdZapato INT, @Cantidad INT;
	 
    SELECT @IdZapato = IdZapato, @Cantidad = Cantidad
    FROM inserted;
	 
    UPDATE Productos.Zapatos
    SET Stock = Stock - @Cantidad
    WHERE IdZapato = @IdZapato;
END;
GO

-- xxxxXXXX EJERCCIO 4 XXXXxxx
-- Registrar Cambios en Información del Cliente/Paciente: Crea un AFTER 
-- UPDATE Trigger en una tabla de clientes o pacientes que registre cualquier 
-- cambio de información (nombre, dirección, teléfono) en una tabla de 
-- auditoría.
USE zapateria;
GO
CREATE TABLE Cliente.ClientesAudit (
    AuditId INT PRIMARY KEY IDENTITY(1,1),
    IdCliente INT,
    OldNombresCliente VARCHAR(100),
    OldApellidosCliente VARCHAR(100),
    OldTelefonoCliente VARCHAR(15),
    OldCorreoCliente VARCHAR(100),
    ChangeDate DATETIME DEFAULT GETDATE()
);
GO
CREATE TRIGGER trg_LogClientChanges
ON Cliente.Clientes
AFTER UPDATE
AS
BEGIN
    INSERT INTO Cliente.ClientesAudit (IdCliente, OldNombresCliente, OldApellidosCliente, OldTelefonoCliente, OldCorreoCliente)
    SELECT 
        i.IdCliente,
        d.NombresCliente,
        d.ApellidosCliente,
        d.TelefonoCliente,
        d.CorreoCliente
    FROM inserted i
    INNER JOIN deleted d ON i.IdCliente = d.IdCliente
    WHERE i.NombresCliente <> d.NombresCliente
       OR i.ApellidosCliente <> d.ApellidosCliente
       OR i.TelefonoCliente <> d.TelefonoCliente
       OR i.CorreoCliente <> d.CorreoCliente;
END;
GO

-- xxxxXXXX EJERCCIO 5 XXXXxxx
-- Actualizar el Total de una Factura Después de Insertar Detalles: Crea un 
-- AFTER INSERT Trigger que actualice el total de una factura en la tabla de 
-- facturas después de que se inserte un nuevo detalle de factura
USE zapateria;
GO    
CREATE TRIGGER trg_UpdateTotalFactura
ON Ventas.Detalles_De_Ventas
AFTER INSERT
AS
BEGIN

	DECLARE @total FLOAT;
    DECLARE @IdVenta INT;
	 DECLARE @IdDetalleVenta INT;

	SELECT @IdDetalleVenta = IdDetalleDeVenta FROM inserted; 

    SELECT @IdVenta = IdVenta
    FROM Ventas.Detalles_De_Ventas
    WHERE IdDetalleDeVenta = @IdDetalleVenta;

    SELECT @total = SUM(SubTotal)
    FROM Ventas.Detalles_De_Ventas
    WHERE IdVenta = @IdVenta;

    
    UPDATE Ventas.Factura_De_Ventas
    SET TotalPagarVenta = @total
    WHERE IdDetalleDeVenta = @IdDetalleVenta; 
END
GO
