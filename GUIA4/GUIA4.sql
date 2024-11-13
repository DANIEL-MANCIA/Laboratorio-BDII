-- ejercicio 1
CREATE VIEW VistaClientesConVentas AS
SELECT c.IdCliente, c.NombresCliente, dv.IdVenta, dv.Cantidad, dv.PrecioUnitario
FROM Cliente.Clientes c
INNER JOIN Ventas.Detalles_De_Ventas dv ON c.IdCliente = dv.IdVenta;
go

SELECT * FROM VistaClientesConVentas;
go


-- ejercicio 2
CREATE VIEW VistaEmpleadosConPedidos AS
SELECT e.IdEmpleado, e.NombresEmpleado, p.IdPedido, p.Fecha_De_Pedido, p.Precio
FROM Persona.Empleados e
LEFT JOIN Ventas.Pedidos p ON e.IdEmpleado = p.IdEmpleado;
go

SELECT * FROM VistaEmpleadosConPedidos
go


-- ejercicio 3
CREATE VIEW VistaInventarioConZapatos AS
SELECT i.IdInventario, i.Inventario, z.Nombre AS NombreZapato, z.Precio
FROM Productos.Inventario i
INNER JOIN Productos.Zapatos z ON i.IdInventario = z.IdZapato;
go

SELECT * FROM VistaInventarioConZapatos
go

-- ejercicio 4
CREATE VIEW VistaProveedoresFacturas AS
SELECT p.NombresProveedor, fc.IdFacturaCompra, fc.Fecha_Factura_Compra, fc.IdDetalleDePedido
FROM Ventas.Proveedores p
RIGHT JOIN Ventas.Factura_De_Compras fc ON p.IdProveedor = fc.IdFormaDePago;
go

SELECT * FROM VistaProveedoresFacturas
go


-- ejercicio 5

CREATE VIEW VistaDetallesYPagos AS
SELECT dp.IdDetalleDePedido, dp.TotalPagarCompra, fp.IdFormaDePago
FROM Ventas.Detalles_De_Pedidos dp
INNER JOIN Ventas.Formas_De_Pagos fp ON dp.IdFormaDePago = fp.IdFormaDePago;
go

SELECT * FROM VistaDetallesYPagos
go
