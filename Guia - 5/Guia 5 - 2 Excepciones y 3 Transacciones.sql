create table LogErrores (
  Id_Log int identity(1,1) primary key,
  MensajeError varchar(4000),
  NumeroError int,
  LineaError int,
  FechaError datetime default getdate()
);
go

create or alter procedure spInsertarZapato
    @Nombre varchar(100), @Descripcion varchar(100), @Color varchar(100), @Precio float, @Stock int, 
    @IdMarca int, @IdInventario int, @IdTipoDeMaterial int, @IdCategoria int, @IdProveedor int
as begin
    begin try
        if exists (select 1 from Productos.Zapatos where Nombre = @Nombre)
        begin
            throw 50001, 'El Modelo de zapato ya existe.', 1;
        end
        else
        begin
            insert into Productos.Zapatos (Nombre, Descripcion, Color, Precio, Stock, IdMarca, IdInventario, IdTipoDeMaterial, IdCategoria, IdProveedor)
            values (@Nombre, @Descripcion, @Color, @Precio, @Stock, @IdMarca, @IdInventario, @IdTipoDeMaterial, @IdCategoria, @IdProveedor);
        end
    end try
    begin catch
        insert into LogErrores (MensajeError, NumeroError, LineaError)
        values (error_message(), error_number(), error_line());
        
        print 'Error al insertar Zapato, revise la tabla LogError para verificar el error.';
        throw; 
    end catch
end;
go

-- PRUEBA: Dara error por que ya eiste ese modelo de zapato
exec spInsertarZapato
    @Nombre = 'Adidas Stan Smith',
    @Descripcion = 'Tenis de cuero y suela de goma',
    @Color = 'Blanco',
    @Precio = 130.00,
    @Stock = 50,
    @IdMarca = 1,
    @IdInventario = 1,
    @IdTipoDeMaterial = 1,
    @IdCategoria = 2,
    @IdProveedor = 1;
go

-- Excepcion 2: Prevenir precios negativos en los productos
create or alter trigger trgVerificarPrecioZapato
on Productos.Zapatos
after insert, update
as begin
    if exists (select 1 from inserted where Precio < 0)
    begin
        insert into LogErrores (MensajeError, NumeroError, LineaError)
        values ('El precio de un zapato no puede ser negativo.', 50005, 0);

        rollback transaction;
        throw 50005, 'El precio de un zapato no puede ser negativo.', 1;
    end
end;
go

-- PRUEBA: Insertar Precio Negativo = ERROR
insert into Productos.Zapatos (Nombre, Descripcion, Color, Precio, Stock, IdMarca, IdInventario, IdTipoDeMaterial, IdCategoria, IdProveedor)
values ('Prueba Negativa', 'Descripción', 'Negro', -10.00, 10, 1, 1, 1, 1, 1);

-- PRUEBA: Actualizar un Precio a Negativo = ERROR
update Productos.Zapatos set Precio = -5.00 where idZapato = 1;
go

-- ***************************************************************************************************************************
alter table Ventas.Factura_De_Ventas alter column NumFactura char(36) null;
go

-- Tranasaccion: compra de un zapato y se registran en facturas, ventas y detalles d ventas y se actulaiza le stock
begin transaction;
begin try
    declare @IdProducto int = 6;
    declare @Cantidad int = 1; 
    declare @IdCliente int = 1; 
    declare @IdEmpleado varchar(20) = 'EMP006-HF2024';
    declare @Fecha date = getdate();
    declare @PrecioUnitario float = 140.00;
    declare @TotalPagar float = @Cantidad * @PrecioUnitario;
    declare @IdSucursal int = 1; 
    declare @IdFormaDePago int = 1;
    declare @IdEstadoFactura int = 1; 

	-- Actualizar el stock de los zapatos
    update Productos.Zapatos set Stock = Stock - @Cantidad  where IdZapato = @IdProducto;

    -- Punto de guardado antes de la inserción
    save transaction BeforeSalesInsertion;

    -- Insertar la venta
    insert into Ventas.Ventas (Fecha_De_Venta, Total_De_Venta, Monto, IdCliente, IdEmpleado)
    values (@Fecha, @Cantidad, @TotalPagar, @IdCliente, @IdEmpleado);
    declare @IdVenta int = scope_identity();

    -- Insertar detalles de la venta
    insert into Ventas.Detalles_De_Ventas (IdVenta, IdZapato, IdSucursal, Cantidad, PrecioUnitario, SubTotal, IdFormaDePago)
    values (@IdVenta, @IdProducto, @IdSucursal, @Cantidad, @PrecioUnitario, @TotalPagar, @IdFormaDePago);
    declare @IdDetalleDeVenta int = scope_identity();

    -- Insertar factura de la venta
    insert into Ventas.Factura_De_Ventas (NumFactura, TotalPagarVenta, Fecha_Factura_Venta, IdEstadoFactura, FechaActualizacion, IdDetalleDeVenta, IdFormaDePago, IdCliente, IdEmpleado)
    values (newid(), @TotalPagar, @Fecha, @IdEstadoFactura, getdate(), @IdDetalleDeVenta, @IdFormaDePago, @IdCliente, @IdEmpleado);

    commit transaction;
end try
begin catch
    rollback transaction;
    throw;
end catch;
go

select *from Productos.Zapatos;
select *from Ventas.Ventas;
select *from Ventas.Detalles_De_Ventas;
select *from Ventas.Factura_De_Ventas;
go

-- Tranaccion: Resgistrar una nueva marca en todas las tablas que estan relacionadas a ellas y agregar un par de zapato de esa marca
begin transaction;
	declare @NombreProveedor varchar(100) = 'Vans';
	declare @TelProveedor varchar(15) = '+503 6734-3423';
	declare @CorreoProveedor varchar(100) = 'vans@gmail.com'; 
	declare @Direccion int = 7;

	-- nuevo proveedor
	insert into Ventas.Proveedores (NombresProveedor, TelefonoProveedor, CorreoProveedor, IdDireccion) 
	values (@NombreProveedor, @TelProveedor, @CorreoProveedor, @Direccion);
	declare @IdProveedor int = scope_identity(); 

	-- categoría
	declare @IdCategoria int;
	select @IdCategoria = IdCategoria from Productos.Categoria where Categoria = 'Deportivo';

	-- tipo de material
	declare @IdTipoDeMaterial int;
	select @IdTipoDeMaterial = IdTipoDeMaterial from Productos.Tipo_De_Material where Material = 'Lienzo o Lona';

	-- inventario
	declare @Inventario varchar(45) = 'Vans Skate Negros Old Skool';
	declare @Estante varchar(45) = 'E16';
	declare @Pasillo varchar(45) = 'P16';

	insert into Productos.Inventario (Inventario, Estante, Pasillo)
	values (@Inventario, @Estante, @Pasillo);
	declare @IdInventario int = scope_identity(); 

	-- punto de guardado antes de la inserción
	save transaction BeforeBrandInsertion;

	-- insertar marca
	declare @NombreMarca varchar(100) = 'Vans';
	declare @ModeloMarca varchar(45) = 'Skate Negros Old Skool Vans';

	insert into Productos.Marca (Nombres, Modelo)
	values (@NombreMarca, @ModeloMarca);
	declare @IdMarca int = scope_identity();

	-- insertar modelo de zapato
	declare @NombreModelo varchar(100) = 'Vans skate negros';
	declare @DescripcionModelo varchar(100) = 'Zapatos de skate negros para hombre';
	declare @ColorModelo varchar(100) = 'Negro';
	declare @PrecioModelo float = 129.90;
	declare @StockModelo int = 50;

	insert into Productos.Zapatos (Nombre, Descripcion, Color, Precio, Stock, IdMarca, IdInventario, IdTipoDeMaterial, IdCategoria, IdProveedor)
	values (@NombreModelo, @DescripcionModelo, @ColorModelo, @PrecioModelo, @StockModelo, @IdMarca, @IdInventario, @IdTipoDeMaterial, @IdCategoria, @IdProveedor);

	commit transaction;
	print 'Registro de la nueva marca y modelo completado exitosamente.';
go

select *from  Productos.Inventario;
select *from  Productos.Marca;
select *from Productos.Zapatos;
select *from Ventas.Proveedores;
go

-- Transaccion: Crear una nueva sucursal y insertar un nuevo empleado
begin transaction;
begin try
    declare @IdDireccion_1 int = 1; 
    declare @IdDireccion_2 int = 2; 

    -- insertar nueva sucursal
    declare @TelefonoSucursal varchar(15) = '+503 2290-5600';

    insert into Ventas.Sucursales (TelefonoSucursal, IdDireccion)
    values (@TelefonoSucursal, @IdDireccion_1);
    declare @IdSucursal int = scope_identity();

    -- insertar nuevo empleado
    declare @NombresEmpleado varchar(100) = 'Carlos Alberto';
    declare @ApellidosEmpleado varchar(100) = 'García Pérez';
    declare @DuiEmpleado char(10) = '12345678-9';
    declare @ISSS_Empleado int = 876543217;
    declare @Fecha_NacEmpleado date = '1990-05-15';
    declare @TelefonoEmpleado varchar(15) = '+503 7890-1234';
    declare @CorreoEmpleado varchar(100) = 'carlos.alberto@gmail.com';
    declare @IdCargo int = 5;

    insert into Persona.Empleados (NombresEmpleado, ApellidosEmpleado, DuiEmpleado, ISSS_Empleado, Fecha_NacEmpleado, TelefonoEmpleado, CorreoEmpleado, IdCargo, IdDireccion)
    values (@NombresEmpleado, @ApellidosEmpleado, @DuiEmpleado, @ISSS_Empleado, @Fecha_NacEmpleado, @TelefonoEmpleado, @CorreoEmpleado, @IdCargo, @IdDireccion_2);

    commit transaction;
    print 'Registro de la nueva sucursal y empleado completado exitosamente.';
end try
begin catch
    declare @ErrorMessage nvarchar(4000);
    declare @ErrorNumber int, @ErrorLine int;
    select @ErrorMessage = error_message(), @ErrorNumber = error_number(), @ErrorLine = error_line();

    insert into logerrores (MensajeError, NumeroError, LineaError, FechaError)
    values (@ErrorMessage, @ErrorNumber, @ErrorLine, getdate());

    rollback transaction;
    print 'Error en la transacción: ' + @ErrorMessage;
end catch;
go

select *from Persona.Empleados;
select *from Ventas.Sucursales;
go