-- xxxxXXXX Cancelar un Pedido XXXXxxxx
BEGIN TRANSACTION;

DECLARE @IdPedido int
 
UPDATE Ventas.Pedidos
SET IdEstadoPedido = 3 -- Estado "Cancelado"
WHERE IdPedido = @IdPedido;

-- Restaurar el stock de los productos del pedido
UPDATE Productos.Zapatos
SET Stock = Stock + DP.TotalPagarCompra
FROM Productos.Zapatos Z
JOIN Ventas.Detalles_De_Pedidos DP ON Z.IdZapato = DP.IdZapato
WHERE DP.IdPedido = @IdPedido;

COMMIT TRANSACTION;


-- xxxxXXXX Procesar una Devolución de Venta XXXXxxxx
BEGIN TRANSACTION;

DECLARE @MontoDevolucion FLOAT
DECLARE @IdVenta INT
DECLARE @IdDetalleDeVenta INT
DECLARE @CantidadDevuelta INT 
DECLARE @IdZapato INT 

-- Actualizar la venta para reflejar la devolución
UPDATE Ventas.Ventas
SET Total_De_Venta = Total_De_Venta - @CantidadDevuelta
WHERE IdVenta = @IdVenta;

-- Actualizar los detalles de la venta
UPDATE Ventas.Detalles_De_Ventas
SET Cantidad = Cantidad - @CantidadDevuelta, SubTotal = SubTotal - (@CantidadDevuelta * PrecioUnitario)
WHERE IdDetalleDeVenta = @IdDetalleDeVenta;

-- Restaurar el stock del zapato devuelto
UPDATE Productos.Zapatos
SET Stock = Stock + @CantidadDevuelta
WHERE IdZapato = @IdZapato;

COMMIT TRANSACTION;



-- xxxxXXXX Registrar un Pedido Completo XXXXxxxx
BEGIN TRANSACTION;

DECLARE @IdPedido INT
DECLARE @IdProveedor INT = 1
DECLARE @IdEmpleado INT = 1
DECLARE @IdFormaPago INT = 1
DECLARE @IdSucursal INT = 1

-- Tabla temporal para detalles del pedido
DECLARE @DetallesPedidos TABLE (
    IdZapato INT,
    Cantidad INT,
    PrecioUnitario FLOAT
);
  
INSERT INTO @DetallesPedidos (IdZapato, Cantidad, PrecioUnitario)
VALUES (1, 10, 50.0), (2, 5, 80.0); -- Cambia según tus datos reales

DECLARE @CantidadTotal INT = (SELECT SUM(Cantidad) FROM @DetallesPedidos);
DECLARE @PrecioTotal FLOAT = (SELECT SUM(Cantidad * PrecioUnitario) FROM @DetallesPedidos);

INSERT INTO Ventas.Pedidos (Fecha_De_Pedido, Cantidad_De_Pares, Lotes, Precio, IdEstadoPedido, IdProveedor, IdEmpleado)
VALUES (GETDATE(), @CantidadTotal, 1, @PrecioTotal, 1, @IdProveedor, @IdEmpleado);

SET @IdPedido = SCOPE_IDENTITY();

INSERT INTO Ventas.Detalles_De_Pedidos (IdPedido, IdZapato, PrecioUnitario, SubTotal, Fecha_De_Compra, TotalPagarCompra, IdFormaDePago, IdSucursal)
SELECT @IdPedido, IdZapato, PrecioUnitario, Cantidad * PrecioUnitario, GETDATE(), Cantidad * PrecioUnitario, @IdFormaPago, @IdSucursal
FROM @DetallesPedidos;

COMMIT TRANSACTION;

