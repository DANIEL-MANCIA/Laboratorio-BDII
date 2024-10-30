-- PARTE 1: EJERCICIOS 1, 2, 3, 4.

-- EJERCICIO 1:

create or alter trigger trg_VerificarDisponibilidad
on Ventas.Detalles_De_Ventas
instead of insert
as
begin
    set nocount on;
    -- Verificar stock 
    if exists (
        select 1 from inserted i join Productos.Zapatos p on i.IdZapato = p.IdZapato where p.Stock < i.Cantidad
		)
    begin
        raiserror ('No hay suficiente stock para el tipo de Zapato solicitado.', 16, 1);
        rollback transaction;
        return;
    end
    -- stock suficiente:
    insert into Ventas.Detalles_De_Ventas (IdVenta, IdZapato, IdSucursal, Cantidad, PrecioUnitario, SubTotal, IdFormaDePago)
    select IdVenta, IdZapato, IdSucursal, Cantidad, PrecioUnitario, SubTotal, IdFormaDePago
    from inserted;
end;
go
 
-- ERROR:
insert into Ventas.Detalles_De_Ventas (IdVenta, IdZapato, IdSucursal, Cantidad, PrecioUnitario, SubTotal, IdFormaDePago)
values (1, 1, 1, 100, 50.00, 750.00, 1);

-- EXITO:
insert into Ventas.Detalles_De_Ventas (IdVenta, IdZapato, IdSucursal, Cantidad, PrecioUnitario, SubTotal, IdFormaDePago)
values (9, 1, 1, 5, 50.00, 250.00, 1);

select *from Ventas.Detalles_De_Ventas;
go


-- EJERCICIO 2: 

create or alter trigger trg_PrevenirActualizacionFactura
on Ventas.Factura_De_Ventas
instead of update
as
begin
    set nocount on;
    -- Tenemos que verificar l estado de la factura
    if exists (select 1 from inserted i join Ventas.EstadosFacturas ef on i.IdEstadoFactura = ef.IdEstadoFactura 
	where ef.Estado in ('Pagada')) 
    begin
        raiserror ('No se puede actualizar una factura que ya está Pagada.', 16, 1);
        rollback transaction;
        return;
    end
    -- Sino esta pagada la podeos actualizar
    update Ventas.Factura_De_Ventas
    set IdEstadoFactura = i.IdEstadoFactura, FechaActualizacion = getdate() from inserted i
    where Ventas.Factura_De_Ventas.IdFacturaVenta = i.IdFacturaVenta;
end;
go

-- ERROR:
update Ventas.Factura_De_Ventas
set IdEstadoFactura = (select IdEstadoFactura from Ventas.EstadosFacturas where Estado = 'Pagada') where IdFacturaVenta = 1;

-- EXITO:
update Ventas.Factura_De_Ventas
set IdEstadoFactura = (select IdEstadoFactura from Ventas.EstadosFacturas where Estado = 'Anulada') where IdFacturaVenta = 3; 

select *from  Ventas.Factura_De_Ventas;
go


-- EJERCICIO 3: 

create or alter trigger trg_ValidarEdadCliente
on Cliente.Clientes
instead of insert
as
begin
    set nocount on;
    -- Verificar si en los datos a insertar hay clientes menores de 18 años
    if exists (
        select 1 from inserted where datediff(year, FechaNacimientoCliente, getdate()) < 18
    )
    begin
        raiserror ('El cliente debe ser mayor de 18 años.', 16, 1);
        rollback transaction;
        return;
    end
    -- si no hay clientes menores se insertan los clientes
    insert into Cliente.Clientes ( NombresCliente, ApellidosCliente, DuiCliente, FechaNacimientoCliente, TelefonoCliente, CorreoCliente, IdDireccion)
    select NombresCliente, ApellidosCliente, DuiCliente, FechaNacimientoCliente, TelefonoCliente, CorreoCliente, IdDireccion
    from inserted;
end;
go

-- ERROR:
insert into Cliente.Clientes (NombresCliente, ApellidosCliente, DuiCliente, FechaNacimientoCliente, TelefonoCliente, CorreoCliente, IdDireccion) values
    ('Juan Perez3', 'Menjivar Pérez', '52147012-3', '2010-01-15', '+503 6495-5328', 'perez3@hotmail.com', '1'); 

-- EXITO:
insert into Cliente.Clientes (NombresCliente, ApellidosCliente, DuiCliente, FechaNacimientoCliente, TelefonoCliente, CorreoCliente, IdDireccion) values
    ('Juan Perez3', 'Menjivar Pérez', '52147012-3', '1990-06-20', '+503 6495-5328', 'perez3@hotmail.com', '1'); 

select *from Cliente.Clientes;
go

-- EJERCICIO 4:

create or alter trigger trg_PrevenirEliminacionProducto
on Productos.Zapatos
instead of delete
as
begin
    set nocount on;
    if exists (
        select 1from deleted d inner join Ventas.Detalles_De_Pedidos dp on d.IdZapato = dp.IdZapato
        union
        select 1from deleted d inner join Ventas.Detalles_De_Ventas dv on d.IdZapato = dv.IdZapato
    )
    begin
        raiserror ('No se puede eliminar un Zapato que está asociado a un pedido o venta.', 16, 1);
        rollback transaction;
        return;
    end
    delete from Productos.Zapatos where IdZapato in (select IdZapato from deleted);
end;
go

-- ERROR:
delete from Productos.Zapatos where IdZapato = 1;  

-- EXITO:
delete from Productos.Zapatos where IdZapato = 15; 

select *from Productos.Zapatos;
go