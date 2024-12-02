-- ejercicio de no cycle

CREATE SEQUENCE PedidosSecuenciaNoCycle
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 100
    NO CYCLE;
go

-- Activar IDENTITY_INSERT para la tabla Ventas.Pedidos
SET IDENTITY_INSERT Ventas.Pedidos ON;

ALTER TABLE Ventas.Pedidos
ALTER COLUMN IdEmpleado INT NULL;
go

INSERT INTO Ventas.Pedidos (IdPedido, Fecha_De_Pedido, Cantidad_De_Pares, Lotes, Precio, IdProveedor, IdEmpleado)
VALUES (
    NEXT VALUE FOR PedidosSecuenciaNoCycle,  
    GETDATE(),  
    1, '4', 499, 1, 2         
);
go

SELECT *
FROM Ventas.Pedidos;
go

SET IDENTITY_INSERT Ventas.Pedidos OFF;
go


-- segundo ejercicio de no cycle

CREATE SEQUENCE DetalleDePedidoSecuenciaNoCycle
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 1000
    NO CYCLE;
GO

INSERT INTO Ventas.Detalles_De_Pedidos (IdDetalleDePedido, PrecioUnitario, SubTotal, Fecha_De_Compra, TotalPagarCompra, IdSucursal, IdPedido, IdZapato, IdFormaDepago)
VALUES (
    15, 100.00, 200.00, GETDATE(), 200.00, 1, 1, 3, 1 
);
go

SELECT *
FROM Ventas.Detalles_De_Pedidos;
go


-- ejercicio cycle

CREATE SEQUENCE DetallesSecuenciaCycle
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 10
    CYCLE; 
GO

SELECT IdDetalleDePedido
FROM Ventas.Detalles_De_Pedidos;
go

ALTER SEQUENCE DetallesSecuenciaCycle
INCREMENT BY 1
MINVALUE 1
MAXVALUE 100; 
go

ALTER SEQUENCE DetallesSecuenciaCycle
RESTART WITH 16; 
go

INSERT INTO Ventas.Detalles_De_Pedidos (IdDetalleDePedido, PrecioUnitario, SubTotal, Fecha_De_Compra, TotalPagarCompra, IdSucursal, IdPedido, IdZapato, IdFormaDePago)
VALUES (
    NEXT VALUE FOR DetallesSecuenciaCycle,
    50.00, 100.00, GETDATE(), 100.00, 1, 1, 3, 1 
);
go
SELECT *
FROM Ventas.Detalles_De_Pedidos;
