
-- excepciones y procedimientos almacenados
--ejercicio 1
CREATE PROCEDURE InsertarCliente
    @NombresCliente NVARCHAR(50),
    @ApellidosCliente NVARCHAR(50),
    @DuiCliente NVARCHAR(10),
    @TelefonoCliente NVARCHAR(15),
    @IdDireccion INT,
    @FechaUltimaVisita DATE
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Cliente.Clientes WHERE DuiCliente = @DuiCliente)
        BEGIN
            THROW 50001, 'El DUI ya está registrado en el sistema.', 1;
        END

        INSERT INTO Cliente.Clientes 
            (NombresCliente, ApellidosCliente, DuiCliente, TelefonoCliente, IdDireccion, FechaUltimaVisita)
        VALUES 
            (@NombresCliente, @ApellidosCliente, @DuiCliente, @TelefonoCliente, @IdDireccion, @FechaUltimaVisita);

        PRINT 'Cliente insertado con éxito.';
    END TRY
    BEGIN CATCH
        PRINT 'Ocurrió un error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC InsertarCliente 
    @NombresCliente = 'Juan', 
    @ApellidosCliente = 'Pérez', 
    @DuiCliente = '12345678-9', 
    @TelefonoCliente = '1234-5678', 
    @IdDireccion = 1, 
    @FechaUltimaVisita = '2024-11-18';
go

SELECT * FROM Cliente.Clientes
go

EXEC InsertarCliente 
    @NombresCliente = 'Ana', 
    @ApellidosCliente = 'López', 
    @DuiCliente = '12345678-9', 
    @TelefonoCliente = '8765-4321', 
    @IdDireccion = 2, 
    @FechaUltimaVisita = '2024-11-19';
go


--ejercicio 2

CREATE TRIGGER trg_NoEliminarEmpleadoConCargo
ON Persona.Empleados
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted d
        WHERE d.IdCargo IS NOT NULL
    )
    BEGIN
        THROW 50002, 'No se puede eliminar al empleado porque tiene un cargo asociado.', 1;
    END

    DELETE FROM Persona.Empleados
    WHERE IdEmpleado IN (SELECT IdEmpleado FROM deleted);
END;
GO

SELECT * FROM Persona.Empleados
go

DELETE FROM Persona.Empleados WHERE IdEmpleado = 1; 
go

INSERT INTO Persona.Empleados 
    (NombresEmpleado, apellidosEmpleado, DuiEmpleado, ISSS_Empleado, Fecha_NacEmpleado, TelefonoEmpleado, CorreoEmpleado, IdCargo, IdDireccion)
VALUES 
    ('Pedro', 'Gómez', '12345678-9', '00112233', '1990-01-01', '1234-5678', 'pedro@example.com', NULL, 2);
go

DELETE FROM Persona.Empleados WHERE IdEmpleado = (SELECT MAX(IdEmpleado) FROM Persona.Empleados);
go

--segunda parte transacciones
--ejercicio 3

BEGIN TRANSACTION;

BEGIN TRY
    DECLARE @IdPedido INT;
    
    INSERT INTO Ventas.Pedidos 
        (Fecha_De_Pedido, Cantidad_De_Pares, Lotes, Precio, IdProveedor, IdEmpleado)
    VALUES 
        ('2024-11-18', 50, 5, 1000.00, 1, 2);

    SET @IdPedido = SCOPE_IDENTITY();

    INSERT INTO Ventas.Detalles_De_Pedidos 
        (PrecioUnitario, SubTotal, Fecha_De_Compra, TotalPagarCompra, IdSucursal, IdPedido, IdZapato, IdFormaDePago)
    VALUES 
        (20.00, 100.00, '2024-11-18', 100.00, 1, @IdPedido, 3, 2);

    INSERT INTO Ventas.Detalles_De_Pedidos 
        (PrecioUnitario, SubTotal, Fecha_De_Compra, TotalPagarCompra, IdSucursal, IdPedido, IdZapato, IdFormaDePago)
    VALUES 
        (40.00, 200.00, '2024-11-18', 200.00, 1, @IdPedido, 4, 2);

    COMMIT;
    PRINT 'Pedido y detalles registrados con éxito.';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Ocurrió un error: ' + ERROR_MESSAGE();
END CATCH;
go

SELECT * FROM Ventas.Pedidos WHERE Fecha_De_Pedido = '2024-11-18';
go

SELECT * FROM Ventas.Detalles_De_Pedidos WHERE Fecha_De_Compra = '2024-11-18';
go


--ejercicio 4

BEGIN TRANSACTION;

BEGIN TRY

    DECLARE @IdVenta INT;
    
    INSERT INTO Ventas.Ventas 
        (Fecha_De_Venta, Total_De_Venta, Monto, IdCliente, IdEmpleado)
    VALUES 
        ('2024-11-18', 1000.00, 1000.00, 1, 2);

    SET @IdVenta = SCOPE_IDENTITY();

    INSERT INTO Ventas.Detalles_De_Ventas 
        (IdVenta, IdZapato, IdSucursal, Cantidad, PrecioUnitario, SubTotal, IdFormaDePago)
    VALUES 
        (@IdVenta, 3, 1, 2, 200.00, 400.00, 1);

    INSERT INTO Ventas.Detalles_De_Ventas 
        (IdVenta, IdZapato, IdSucursal, Cantidad, PrecioUnitario, SubTotal, IdFormaDePago)
    VALUES 
        (@IdVenta, 5, 1, 3, 200.00, 600.00, 2);

    COMMIT;
    PRINT 'Venta y detalles registrados con éxito.';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Ocurrió un error: ' + ERROR_MESSAGE();
END CATCH;
go

SELECT * FROM Ventas.Ventas WHERE Fecha_De_Venta = '2024-11-18';
go

SELECT * FROM Ventas.Detalles_De_Ventas WHERE IdVenta = (SELECT MAX(IdVenta) FROM Ventas.Ventas);
go


--ejercicio 5

BEGIN TRANSACTION;

BEGIN TRY
    INSERT INTO Ventas.Factura_De_Compras (TotalPagarCompra, Fecha_Factura_Compra, IdDetalleDePedido, IdFormaDePago)
    VALUES (500.00, '2024-11-18', 1, 1); 

    DECLARE @IdFacturaCompra INT;
    SET @IdFacturaCompra = SCOPE_IDENTITY();

    UPDATE Productos.Inventario
    SET Inventario = Inventario + 50
    WHERE IdInventario = 1;

    COMMIT;
    PRINT 'Transacción completada con éxito.';
END TRY
BEGIN CATCH
    ROLLBACK;
    PRINT 'Error en la transacción: ' + ERROR_MESSAGE();
END CATCH;
GO

SELECT * FROM Ventas.Factura_De_Compras
go