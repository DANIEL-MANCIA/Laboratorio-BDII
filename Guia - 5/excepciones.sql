-- Excepción al intentar insertar una factura con una fecha en el futuro
-- Trigger: Previene la inserción de facturas con fechas inválidas.
CREATE TRIGGER PreventFutureFacturaDate
ON Ventas.Factura_De_Ventas
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Inserted WHERE Fecha_Factura_Venta > GETDATE())
    BEGIN
        RAISERROR('La fecha de la factura no puede ser en el futuro.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO


-- Excepción al intentar borrar una categoría que tiene zapatos asociados
-- Trigger: Previene la eliminación de una categoría si existen zapatos asociados.

CREATE TRIGGER PreventDeleteCategoria
ON Productos.Categoria
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Productos.Zapatos WHERE IdCategoria IN (SELECT IdCategoria FROM DELETED))
    BEGIN
        RAISERROR('No se puede eliminar la categoría porque tiene zapatos asociados.', 16, 1);
        RETURN;
    END

    DELETE FROM Productos.Categoria WHERE IdCategoria IN (SELECT IdCategoria FROM DELETED);
END;
GO

-- Excepción al intentar insertar una venta con un cliente inexistente
-- Procedimiento almacenado: Verifica si el cliente existe antes de registrar la venta.

-- CREATE PROCEDURE Ventas.InsertarVenta
--     @Fecha_De_Venta DATE,
--     @Total_De_Venta INT,
--     @Monto FLOAT,
--     @IdCliente INT,
--     @IdEmpleado INT
-- AS
-- BEGIN
--     IF NOT EXISTS (SELECT 1 FROM Cliente.Clientes WHERE IdCliente = @IdCliente)
--     BEGIN
--         RAISERROR('El cliente no existe.', 16, 1);
--         RETURN;
--     END

--     INSERT INTO Ventas.Ventas (Fecha_De_Venta, Total_De_Venta, Monto, IdCliente, IdEmpleado)
--     VALUES (@Fecha_De_Venta, @Total_De_Venta, @Monto, @IdCliente, @IdEmpleado);
-- END;
-- GO

