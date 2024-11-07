/*NOTA: Correr en este orden: el DLL --> Secuencias --> DML -->  DCL 

  PROBAR SECUENCIAS: Hacer estas consultas y ver los resultados en los IDS de cada tabla: Select *from Cliente.HistorialDeComprasClientes; 
  Select *from Productos.ZapatosMasVendidos;  --->  Select *from Persona.Empleados;  --->  Select *from Ventas.Factura_De_Ventas;
*/

create database zapateria;
go

use zapateria;
go

--Esquemas
create Schema Departamento
go
create Schema Persona
go
create Schema Productos
go
create Schema Cliente
go
create Schema Ventas
go
create Schema Rol
go

create table Departamento.Departamentos(
	IdDepartamento char(2) primary key,
    Departamento varchar(25) not null,
    Pais varchar(25) not null
);

create table Departamento.Municipios(
	IdMunicipio char(3) primary key,
    Municipio varchar(50) not null,
    IdDepartamento char(2) not null
);

create table Departamento.Distritos(
	IdDistrito char(5) primary key,
    Distrito varchar(50) not null,
    IdMunicipio char(3) not null
);

create table Departamento.Direcciones(
	IdDireccion int primary key identity(1, 1),
    Linea1 varchar(100) not null,
    Linea2 varchar(100),
    CodigoPostal varchar(7) not null,
    IdDistrito char(5) not null
);

create table Persona.Cargos(
	IdCargo int primary key identity(1, 1),
    Cargo varchar(50) not null
);

create table Persona.Empleados(
	IdEmpleado varchar(20) primary key,   -- Cambio el tipo de dato del id empleado de int a varchar
    NombresEmpleado varchar(100) not null,
    ApellidosEmpleado varchar(100) not null,
    DuiEmpleado char(10) not null,
	ISSS_Empleado int not null,
    Fecha_NacEmpleado DATE not null,
    TelefonoEmpleado varchar(15) not null,
    CorreoEmpleado varchar(100),
    IdCargo int not null,
    IdDireccion int not null
);

create table Productos.Categoria(
	IdCategoria int primary key identity(1,1),
    Categoria varchar(60) not null
);

create table Productos.Tipo_De_Material(
	IdTipoDeMaterial int primary key identity(1,1),
    Material varchar(60) not null
);

create table Productos.Inventario(
	IdInventario int primary key identity (1,1),
    Inventario varchar(45) not null,
    Estante varchar(45) not null,
    Pasillo varchar(45) not null
);

create table Productos.Marca(
	IdMarca int primary key identity(1,1),
    Nombres varchar(100) not null,
    Modelo varchar(45) not null
);

create table Productos.Zapatos(
	IdZapato int primary key identity(1,1),
    Nombre varchar(100) not null,
    Descripcion varchar(100) not null,
    Color varchar(100) not null,
    Precio float not null,
    Stock int not null,
    IdMarca int not null,
    IdInventario int not null,
    IdTipoDeMaterial int not null,
    IdCategoria int not null,
	IdProveedor int not null -- nueva incorporacion
);


create table Cliente.Clientes(
	IdCliente int primary key identity(1,1),
    NombresCliente varchar(100) not null,
    ApellidosCliente varchar(100) not null,
    DuiCliente char(10) not null,
	FechaNacimientoCliente date not null, -- Agregue este cambio para poder realizar el trigger #3
    TelefonoCliente varchar(15) not null,
    CorreoCliente varchar(100),
    IdDireccion int not null
);

create table Ventas.Sucursales(
	IdSucursaL int primary key identity(1,1),
    TelefonoSucursal varchar(15) not null,
    IdDireccion int not null
);

create table Ventas.Proveedores(
	IdProveedor int primary key identity(1,1),
    NombresProveedor varchar(100) not null,
    TelefonoProveedor varchar(15) not null,
    CorreoProveedor varchar(100),
    IdDireccion int not null
);

create table Ventas.Ventas(
	IdVenta int primary key identity(1,1),
    Fecha_De_Venta date not null,
    Total_De_Venta int not null,
    Monto float not null,
    IdCliente int not null,
    IdEmpleado varchar(20) not null
);

create table Ventas.Pedidos(
	IdPedido int primary key identity(1,1),
    Fecha_De_Pedido date not null,
    Cantidad_De_Pares int not null,
    Lotes int not null,
    Precio float not null,
	IdEstadoPedido int not null, -- Agregue este cambio
    IdProveedor int not null,
    IdEmpleado varchar(20) not null
);

create table Ventas.Formas_De_Pagos(
	IdFormaDePago int primary key identity (1,1),
    Tipo varchar(60) not null
);

create table Ventas.Detalles_De_Ventas(
	IdDetalleDeVenta int primary key identity(1,1),
    IdVenta int not null,
    IdZapato int not null,
    IdSucursal int not null,
    Cantidad int not null,
    PrecioUnitario float not null,
    SubTotal float not null,
    IdFormaDePago int not null
);


create table Ventas.Detalles_De_Pedidos(
	IdDetalleDePedido int primary key identity(1,1),
    PrecioUnitario float not null,
    SubTotal float not null,
    Fecha_De_Compra date not null,
    TotalPagarCompra float not null,
    IdSucursal int not null,
    IdPedido int not null,
    IdZapato int not null,
    IdFormaDePago int not null
);

create table Ventas.Factura_De_Ventas(
	IdFacturaVenta int primary key identity(1,1),
	NumFactura varchar(15) null, -- Agregamos el campo para l numero de factura que llevara impreso la misma.
    TotalPagarVenta float not null,
    Fecha_Factura_Venta date not null,
	IdEstadoFactura int not null, -- Agregue este cambio para poder realizar el trigger #2
	FechaActualizacion datetime,
    IdDetalleDeVenta int not null,
    IdFormaDePago int not null,
	IdCliente int not null,
	IdEmpleado varchar(20) not null
);


create table Ventas.Factura_De_Compras(
	IdFacturaCompra int primary key identity(1,1),
    TotalPagarCompra float not null,
    Fecha_Factura_Compra date not null,
	IdEstadoFactura int not null,-- Agregue este cambio
	FechaActualizacion datetime,
    IdDetalleDePedido int not null,
    IdFormaDePago int not null
);


-- TABLA PARA MANEJAR LOS ESTADOS DE LOS PEDIDOS
create table Ventas.EstadosPedidos(
	IdEstadoPedido int primary key identity(1,1),
    Estado varchar(50) not null
);


-- TABLA PARA MANEJAR LOS ESTADOS DE LAS FACTURAS.
create table Ventas.EstadosFacturas (
    IdEstadoFactura int primary key identity(1,1),
    Estado varchar(50) not null
);


-- TABLAS DE ROLES
create table Rol.roles(
	IdRol int primary key identity (1,1),
    Rol varchar (50) not null
);

create table Rol.opciones(
	IdOpcion int primary key identity (1,1),
    Opcion varchar(50) not null
);

create table Rol.asignacionRolesOpciones(
	IdAsignacion int primary key identity(1,1),
    IdRol int not null,
    IdOpcion int not null
);

create table Rol.usuarios (
	Idusuario int primary key identity (1,1),
    Usuario varchar (50) not null,
    Contrasenia varchar(50) not null,
    IdRol int not null,
    IdEmpleado varchar(20) not null
);
go

create table Productos.ZapatosMasVendidos (
    IdZapatoMasVendido varchar(7) primary key,
    Nombre varchar(100) not null,
    Color varchar(50) not null,
    Precio decimal(10, 2) not null,
    CantidadVendidos int not null
);
go

create table Cliente.HistorialDeComprasClientes (
    Id varchar(15) primary key,
    Nombres varchar(100) not null,
    Apellidos varchar(100) not null,
    Dui char(10) not null,
    Compras decimal(10, 2) default 0,
    Telefono varchar(15) not null,
    Correo varchar(100) not null,
    IdDireccion int not null,
    IdCliente int not null
);
go

alter table Productos.Zapatos add foreign key (IdProveedor) references Ventas.Proveedores(IdProveedor);
alter table Ventas.Factura_De_Ventas add foreign key (IdCliente) references Cliente.Clientes(IdCliente);
alter table Ventas.Factura_De_Ventas add foreign key (IdEmpleado) references Persona.Empleados(IdEmpleado);

-- Relacion de llave foranea
alter table Cliente.HistorialDeComprasClientes add foreign key (IdCliente) references Cliente.Clientes(IdCliente);
go

-- LLAVES FORANEAS DE TABLA VENTAS.ESTADOS-PEDIDOS
alter table Ventas.Pedidos add foreign key (IdEstadoPedido) references Ventas.EstadosPedidos(IdEstadoPedido);

-- LLAVES FORANEAS DE TABLA VENTAS.ESTADOS-FACTURAS
alter table Ventas.Factura_De_Ventas add foreign key (IdEstadoFactura) references Ventas.EstadosFacturas(IdEstadoFactura);
alter table Ventas.Factura_De_Compras add foreign key (IdEstadoFactura) references Ventas.EstadosFacturas(IdEstadoFactura);

-- LLAVES FORANEAS DE ROLES
alter table Rol.asignacionRolesOpciones add foreign key (IdRol) references Rol.roles(IdRol);
alter table Rol.asignacionRolesOpciones add foreign key (IdOpcion) references Rol.opciones(IdOpcion);
alter table Rol.usuarios add foreign key (IdRol) references Rol.roles(IdRol);
alter table Rol.usuarios add foreign key (IdEmpleado) references Persona.Empleados(IdEmpleado);

-- LLAVES FORANEAS DE DIRECCIONES
alter table Departamento.Municipios add foreign key (IdDepartamento) references Departamento.Departamentos(IdDepartamento);
alter table Departamento.Distritos add foreign key (IdMunicipio) references Departamento.Municipios(IdMunicipio);
alter table Departamento.Direcciones add foreign key (IdDistrito) references Departamento.Distritos(IdDistrito);

-- LLAVES FORANEAS EN LA TABLA CLIENTE
alter table Cliente.Clientes add foreign key (IdDireccion) references Departamento.Direcciones(IdDireccion);

-- LLAVES FORANEAS EN LA TABLA SUCURSALES
alter table Ventas.Sucursales add foreign key (IdDireccion) references Departamento.Direcciones(IdDireccion);

-- LLAVES FORANEAS EN LA TABLA PROVEEDOR
alter table Ventas.Proveedores add foreign key (IdDireccion) references Departamento.Direcciones(IdDireccion);

-- LLAVES FORANEAS EN LA TABLA EMPLEADOS
alter table Persona.Empleados add foreign key (IdDireccion) references Departamento.Direcciones(IdDireccion);
alter table Persona.Empleados add foreign key (IdCargo) references Persona.Cargos(IdCargo);

-- LLAVES FORANEAS EN LA TABLA PEDIDO
alter table Ventas.Pedidos add foreign key (IdEmpleado) references Persona.Empleados(IdEmpleado);
alter table Ventas.Pedidos add foreign key (IdProveedor) references Ventas.Proveedores(IdProveedor);

-- LLAVES FORANEAS EN LA TABLA VENTAS
alter table Ventas.Ventas add foreign key (IdEmpleado) references Persona.Empleados(IdEmpleado);
alter table Ventas.Ventas add foreign key (IdCliente) references Cliente.Clientes(IdCliente);

-- LLAVES FORANEAS EN LA TABLA ZAPATOS
alter table Productos.Zapatos add foreign key (IdCategoria) references Productos.Categoria(IdCategoria);
alter table Productos.Zapatos add foreign key (IdTipoDeMaterial) references Productos.Tipo_De_Material(IdTipoDeMaterial);
alter table Productos.Zapatos add foreign key (IdInventario) references Productos.Inventario(IdInventario);
alter table Productos.Zapatos add foreign key (IdMarca) references Productos.Marca(IdMarca);

-- LLAVES FORANEAS DETALLES DE VENTAS
alter table Ventas.Detalles_De_Ventas add foreign key (IdVenta) references Ventas.Ventas(IdVenta);
alter table Ventas.Detalles_De_Ventas add foreign key (IdZapato) references Productos.Zapatos(IdZapato);
alter table Ventas.Detalles_De_Ventas add foreign key (IdSucursal) references Ventas.Sucursales(IdSucursal);
alter table Ventas.Detalles_De_Ventas add foreign key (IdFormaDePago) references Ventas.Formas_De_pagos(IdFormaDePago);

-- LLAVES FORANEAS DETALLES DE PEDIDO
alter table Ventas.Detalles_De_Pedidos add foreign key (IdZapato) references Productos.Zapatos(IdZapato);
alter table Ventas.Detalles_De_Pedidos add foreign key (IdSucursal) references Ventas.Sucursales(IdSucursal);
alter table Ventas.Detalles_De_Pedidos add foreign key (IdPedido) references Ventas.Pedidos(IdPedido);
alter table Ventas.Detalles_De_Pedidos add foreign key (IdFormaDePago) references Ventas.Formas_De_pagos(IdFormaDePago);

-- LLAVES FORANEAS EN FACTURA DE COMPRAS
alter table Ventas.Factura_De_Compras add foreign key (IdDetalleDePedido) references Ventas.Detalles_De_Pedidos(IdDetalleDePedido);
alter table Ventas.Factura_De_Compras add foreign key (IdFormaDePago) references Ventas.Formas_De_Pagos(IdFormaDePago);

-- LLAVES FORANEAS EN FACTURA DE VENTAS
alter table Ventas.Factura_De_Ventas add foreign key (IdDetalleDeVenta) references Ventas.Detalles_De_Ventas(IdDetalleDeVenta);
alter table Ventas.Factura_De_Ventas add foreign key (IdFormaDePago) references Ventas.Formas_De_Pagos(IdFormaDePago);
go

-- AGREGO ESTO AQUI POR QUE SE TIENE QUE CORRER DESPUES DE LA CREACION DE TABLAS Y LLAVES FORANEAS PARA 
-- GENERAR LOS ID DE ALGUNAS TABLAS CUANDO SE HAGAN LAS INSERCIONES

-- Secuencia 1: SeqIdHistorialDeComprasClientes
create sequence SeqIdHistorialDeComprasClientes
    start with 1
    increment by 1
    minvalue 1
    maxvalue 9999
    no cycle;
go

-- Trigger: trg_ActualizarHistorialDeComprasClientes
create or alter trigger trgActualizarHistorialDeComprasClientes
on Ventas.Ventas
after insert
as begin
    declare @cliente_id int, @apellidos varchar(100), @nombres varchar(100), @dui char(10), @telefono varchar(15), @correo varchar(100),
            @idDireccion int, @totalcompras decimal(10, 2), @iniciales_apellidos char(2), @id varchar(15), @numero int;

    -- Iterar por cada nueva venta realizada
    declare cur cursor for
    select IdCliente, Total_De_Venta from inserted;

    open cur;
    fetch next from cur into @cliente_id, @totalcompras;

    while @@fetch_status = 0
    begin
        -- Agarrar info del cliente
        select @apellidos = ApellidosCliente, @nombres = NombresCliente, @dui = DuiCliente, @telefono = TelefonoCliente, @correo = CorreoCliente, 
		@idDireccion = IdDireccion from Cliente.Clientes where IdCliente = @cliente_id;

        -- Ver si el cliente ya est� en la tabla que creamos 
        if not exists (select 1 from Cliente.HistorialDeComprasClientes where IdCliente = @cliente_id)
        begin
            set @iniciales_apellidos = left(@apellidos, 1) + substring(@apellidos, charindex(' ', @apellidos) + 1, 1);

            set @numero = next value for SeqIdHistorialDeComprasClientes;
            set @id = @iniciales_apellidos + right('0000' + cast(@numero as varchar), 4);

            -- Agregar el cliente en Cliente.HistorialDeComprasClientes
            insert into Cliente.HistorialDeComprasClientes (Id, Nombres, Apellidos, Dui, Compras, Telefono, Correo, IdDireccion, IdCliente)
            values (@id, @nombres, @apellidos, @dui, @totalcompras, @telefono, @correo, @idDireccion, @cliente_id);
        end
        else
        begin
            -- Si el cliente existe, sumar el total de la venta al total de compras
            update Cliente.HistorialDeComprasClientes set Compras = Compras + @totalcompras where IdCliente = @cliente_id;
        end
        fetch next from cur into @cliente_id, @totalcompras;
    end
    close cur;
    deallocate cur;
end;
go

-- SECUENCIA 2: Crearemos una tabla para ver los zapatos mas vendidos, id de la tabla hecho con secuencia, trigger y cursores

create sequence SeqIdZapatosMasVendidos
	start with 1
	increment by 1
	minvalue 1
	maxvalue 9999
	no cycle;
go

create or alter trigger trgAsignarIDZapatoMasVendido
on Productos.ZapatosMasVendidos
after insert
as begin
    declare @correlativo int, @idProducto varchar(7);

    declare cur cursor for
    select IdZapatoMasVendido from inserted where IdZapatoMasVendido is null;

    open cur;
    fetch next from cur into @idProducto;

    while @@fetch_status = 0
    begin
        set @correlativo = next value for SeqIdZapatosMasVendidos;
        set @idProducto = 'ZA' + right('0000' + cast(@correlativo as varchar(4)), 4);

        update Productos.ZapatosMasVendidos set IdZapatoMasVendido = @idProducto where IdZapatoMasVendido is null;
        fetch next from cur into @idProducto;
    end
    close cur;
    deallocate cur;
end;
go

create or alter trigger trgActualizarZapatosMasVendidos
on Ventas.Detalles_De_Ventas
after insert
as begin
    declare @idZapato int, @nombre varchar(100), @color varchar(50), @precio decimal(10, 2), @cantidad int;
    
    declare cur_vendidos cursor for
    select IdZapato, sum(Cantidad) from inserted group by IdZapato;

    open cur_vendidos;
    fetch next from cur_vendidos into @idZapato, @cantidad;

    while @@fetch_status = 0
    begin
        select @nombre = Nombre, @color = Color, @precio = Precio from Productos.Zapatos where IdZapato = @idZapato;

        if exists (select 1 from Productos.ZapatosMasVendidos where Nombre = @nombre and Color = @color and Precio = @precio)
        begin
            update Productos.ZapatosMasVendidos set CantidadVendidos = CantidadVendidos + @cantidad
            where Nombre = @nombre and Color = @color and Precio = @precio;
        end
        else
        begin
            declare @correlativo int, @idProducto varchar(7);
            set @correlativo = next value for SeqIdZapatosMasVendidos;
            set @idProducto = 'ZA' + right('0000' + cast(@correlativo as varchar(4)), 4);
            insert into Productos.ZapatosMasVendidos (IdZapatoMasVendido, Nombre, Color, Precio, CantidadVendidos)
            values (@idProducto, @nombre, @color, @precio, @cantidad);
        end
        fetch next from cur_vendidos into @idZapato, @cantidad;
    end
    close cur_vendidos;
    deallocate cur_vendidos;
end;
go

-- SECUENCIA 3: Aca modificamos el idEmpleado de Int a varchar(20), crearemos el id con secuencia, trigger, Precdimiento almacenado.
create sequence SeqNumEmpleado
    start with 1
    increment by 1
    minvalue 1
    maxvalue 999
    cycle;
go

create or alter procedure spObtenerSiguienteNumEmpleado
as begin
    declare @correlativo int;
    set @correlativo = next value for SeqNumEmpleado;
    return @correlativo;
end;
go

create or alter trigger Persona.AsignarIdEmpleado
on Persona.Empleados
instead of insert
as begin
    declare @IdEmpleado varchar(20), @Correlativo int, @AnioActual char(4) = year(getdate()), @InicialesApellidos char(2);

    -- Variables columnas de la tabla
    declare @NombresEmpleado varchar(100), @ApellidosEmpleado varchar(100), @DuiEmpleado char(10), @ISSS_Empleado int, 
			@Fecha_NacEmpleado date, @TelefonoEmpleado varchar(15), @CorreoEmpleado varchar(100), @IdCargo int, @IdDireccion int;

    -- Iterar sobre cada fila insertada
    declare cur cursor for
    select NombresEmpleado, ApellidosEmpleado, DuiEmpleado, ISSS_Empleado, Fecha_NacEmpleado, TelefonoEmpleado, CorreoEmpleado, 
	IdCargo, IdDireccion from inserted;

    open cur;
    fetch next from cur into @NombresEmpleado, @ApellidosEmpleado, @DuiEmpleado, @ISSS_Empleado, @Fecha_NacEmpleado, 
							 @TelefonoEmpleado, @CorreoEmpleado, @IdCargo, @IdDireccion;

    while @@fetch_status = 0
    begin  -- Siguiente valor de la secuencia
        exec @Correlativo = spObtenerSiguienteNumEmpleado;

        set @InicialesApellidos = left(@ApellidosEmpleado, 1) + coalesce(substring(@ApellidosEmpleado, charindex(' ', @ApellidosEmpleado) + 1, 1), '');

        set @IdEmpleado = concat('EMP', right('000' + cast(@Correlativo as varchar), 3), '-', @InicialesApellidos, @AnioActual);

        -- Agregar en la tabla Persona.Empleados con el IdEmpleado hecho antes de esto
        insert into Persona.Empleados (IdEmpleado, NombresEmpleado, ApellidosEmpleado, DuiEmpleado, ISSS_Empleado, 
                                       Fecha_NacEmpleado, TelefonoEmpleado, CorreoEmpleado, IdCargo, IdDireccion)
        values (@IdEmpleado, @NombresEmpleado, @ApellidosEmpleado, @DuiEmpleado, @ISSS_Empleado, @Fecha_NacEmpleado, 
                @TelefonoEmpleado, @CorreoEmpleado, @IdCargo, @IdDireccion);

        fetch next from cur into @NombresEmpleado, @ApellidosEmpleado, @DuiEmpleado, @ISSS_Empleado, 
                                @Fecha_NacEmpleado, @TelefonoEmpleado, @CorreoEmpleado, @IdCargo, @IdDireccion;
    end
    close cur;
    deallocate cur;
end;
go

-- SECUENCIA 4: Hacer el Numero de factura que llevara impreso la misma, secuencia, trigger, funcionEscalar,
create sequence SeqNumeroFactura
    start with 1
    increment by 1
    minvalue 1
    maxvalue 999999
    no cycle;
go

create or alter procedure spObtenerSiguienteNumFactura
as begin
    declare @correlativo int;
    set @correlativo = next value for SeqNumeroFactura;
    return @correlativo;
end;
go


create or alter function fnGenerarNumFactura(@anio int)
returns varchar(15)
as begin
    declare @numeroFactura varchar(15), @correlativo int;
    exec @correlativo = spObtenerSiguienteNumFactura;
    set @numeroFactura = 'FAC' + cast(@anio as varchar(4)) + '-' + right('0000' + cast(@correlativo as varchar(4)), 4);
    return @numeroFactura;
end;
go

create or alter trigger trgAsignarNumFactura
on Ventas.Factura_De_Ventas
instead of insert
as
begin
    declare @anio int, @numeroGenerado varchar(15), @correlativo int;
    declare @TotalPagarVenta float, @Fecha_Factura_Venta date, @IdEstadoFactura int,
            @IdDetalleDeVenta int, @IdFormaDePago int, @IdCliente int, @IdEmpleado varchar(20);

    set @anio = year(getdate());

    -- Iterar sobre cada fila insertada para asignar un Numfactura �nico
    declare cur cursor for
    select TotalPagarVenta, Fecha_Factura_Venta, IdEstadoFactura, IdDetalleDeVenta, IdFormaDePago, IdCliente, IdEmpleado from inserted;

    open cur;
    fetch next from cur into @TotalPagarVenta, @Fecha_Factura_Venta, @IdEstadoFactura, @IdDetalleDeVenta, @IdFormaDePago, @IdCliente, @IdEmpleado;

    while @@fetch_status = 0
    begin
        -- Obtener el siguiente valor de la secuencia
        set @correlativo = next value for SeqNumeroFactura;

        -- Generar el n�mero de factura
        set @numeroGenerado = 'FAC' + cast(@anio as varchar(4)) + '-' + right('0000' + cast(@correlativo as varchar(4)), 4);

        -- Insertar en la tabla Ventas.Factura_De_Ventas con el NumFactura generado y otros valores
        insert into Ventas.Factura_De_Ventas (NumFactura, TotalPagarVenta, Fecha_Factura_Venta, IdEstadoFactura, IdDetalleDeVenta, IdFormaDePago, IdCliente, IdEmpleado)
        values (@numeroGenerado, @TotalPagarVenta, @Fecha_Factura_Venta, @IdEstadoFactura, @IdDetalleDeVenta, @IdFormaDePago, @IdCliente, @IdEmpleado);

        fetch next from cur into @TotalPagarVenta, @Fecha_Factura_Venta, @IdEstadoFactura, @IdDetalleDeVenta, @IdFormaDePago, @IdCliente, @IdEmpleado;
    end

    close cur;
    deallocate cur;
end;
go

-- *****************************
-- ****** DML DB ZAPATERIA *****
-- *****************************

use Zapateria;

insert into Departamento.Departamentos values
	('AH', 'Ahuachap�n', 'El Salvador'),
	('CA', 'Caba�as', 'El Salvador'),
	('CH', 'Chalatenango', 'El Salvador'),
	('CU', 'Cuscatl�n', 'El Salvador'),
	('LL', 'La Libertad', 'El Salvador'),
	('LP', 'La Paz', 'El Salvador'),
	('LU', 'La Uni�n', 'El Salvador'),
	('MO', 'Moraz�n', 'El Salvador'),
	('SA', 'Santa Ana', 'El Salvador'),
	('SM', 'San Miguel', 'El Salvador'),
	('SS', 'San Salvador', 'El Salvador'),
	('SV', 'San Vicente', 'El Salvador'),
	('SO', 'Sonsonate', 'El Salvador'),
	('US', 'Usulut�n', 'El Salvador');

insert into Departamento.Municipios values
-- idMunicipio, municipio, idDepartamento
	('AHN', 'Ahuachap�n Norte', 'AH'),
	('AHC', 'Ahuachap�n Centro', 'AH'),
	('AHS', 'Ahuachap�n Sur', 'AH'),
	('CAE', 'Caba�as Este', 'CA'),
	('CAO', 'Caba�as Oeste', 'CA'),
	('CHN', 'Chalatenango Norte', 'CH'),
	('CHC', 'Chalatenango Centro', 'CH'),
	('CHS', 'Chalatenango Sur', 'CH'),
	('CUN', 'Cuscatl�n Norte', 'CU'),
	('CUS', 'Cuscatl�n Sur', 'CU'),
	('LLN', 'La Libertad Norte', 'LL'),
	('LLC', 'La Libertad Centro', 'LL'),
	('LLO', 'La Libertad Oeste', 'LL'),
	('LLE', 'La Libertad Este', 'LL'),
	('LLS', 'La Libertad Sur', 'LL'),
	('LLT', 'La Libertad Costa', 'LL'),
	('LPO', 'La Paz Oeste', 'LP'),
	('LPC', 'La Paz Centro', 'LP'),
	('LPE', 'La Paz Este', 'LP'),
	('LUN', 'La Uni�n Norte', 'LU'),
	('LUS', 'La Uni�n Sur', 'LU'),
	('MON', 'Moraz�n Norte', 'MO'),
	('MOS', 'Moraz�n Sur', 'MO'),
	('SAN', 'Santa Ana Norte', 'SA'),
	('SAC', 'Santa Ana Centro', 'SA'),
	('SAE', 'Santa Ana Este', 'SA'),
	('SAO', 'Santa Ana Oeste', 'SA'),
	('SMN', 'San Miguel Norte', 'SM'),
	('SMC', 'San Miguel Centro', 'SM'),
	('SMO', 'San Miguel Oeste', 'SM'),
	('SSN', 'San Salvador Norte', 'SS'),
	('SSO', 'San Salvador Oeste', 'SS'),
	('SSE', 'San Salvador Este', 'SS'),
	('SSC', 'San Salvador Centro', 'SS'),
	('SSS', 'San Salvador Sur', 'SS'),
	('SVN', 'San Vicente Norte', 'SV'),
	('SVS', 'San Vicente Sur', 'SV'),
	('SON', 'Sonsonate Norte', 'SO'),
	('SOC', 'Sonsonate Centro', 'SO'),
	('SOE', 'Sonsonate Este', 'SO'),
	('SOO', 'Sonsonate Oeste', 'SO'),
	('USN', 'Usulut�n Norte', 'US'),
	('USE', 'Usulut�n Este', 'US'),
	('USO', 'Usulut�n Oeste', 'US');

insert into Departamento.Distritos values
-- idDistrito, distrito, idMunicipio
-- Ahuachapan
	('AHN01', 'Atiquizaya', 'AHN'),
	('AHN02', 'El Refugio', 'AHN'),
	('AHN03', 'San Lorenzo', 'AHN'),
	('AHN04', 'Tur�n', 'AHN'),
	('AHC01', 'Ahuachap�n', 'AHC'),
	('AHC02', 'Apaneca', 'AHC'),
	('AHC03', 'Concepci�n de Ataco', 'AHC'),
	('AHC04', 'Tacuba', 'AHC'),
	('AHS01', 'Guaymango', 'AHS'),
	('AHS02', 'Jujutla', 'AHS'),
	('AHS03', 'San Francisco Men�ndez', 'AHS'),
	('AHS04', 'San Pedro Puxtla', 'AHS'),
-- Caba�as
	('CAE01', 'Sensuntepeque', 'CAE'),
	('CAE02', 'Victoria', 'CAE'),
	('CAE03', 'Dolores', 'CAE'),
	('CAE04', 'Guacotecti', 'CAE'),
	('CAE05', 'San Isidro', 'CAE'),
	('CAO01', 'Ilobasco', 'CAO'),
	('CAO02', 'Tejutepeque', 'CAO'),
	('CAO03', 'Jutiapa', 'CAO'),
	('CAO04', 'Cinquera', 'CAO'),
-- Chalatenango
	('CHN01', 'La Palma', 'CHN'),
	('CHN02', 'Cital�', 'CHN'),
	('CHN03', 'San Ignacio', 'CHN'),
	('CHC01', 'Nueva Concepci�n', 'CHC'),
	('CHC02', 'Tejutla', 'CHC'),
	('CHC03', 'La Reina', 'CHC'),
	('CHC04', 'Agua Caliente', 'CHC'),
	('CHC05', 'Dulce Nombre de Mar�a', 'CHC'),
	('CHC06', 'El Para�so', 'CHC'),
	('CHC07', 'San Fernando', 'CHC'),
	('CHC08', 'San Francisco Moraz�n', 'CHC'),
	('CHC09', 'San Rafael', 'CHC'),
	('CHC10', 'Santa Rita', 'CHC'),
	('CHS01', 'Chalatenango', 'CHS'),
	('CHS02', 'Arcatao', 'CHS'),
	('CHS03', 'Azacualpa', 'CHS'),
	('CHS04', 'Comalapa', 'CHS'),
	('CHS05', 'Concepci�n Quezaltepeque', 'CHS'),
	('CHS06', 'El Carrizal', 'CHS'),
	('CHS07', 'La Laguna', 'CHS'),
	('CHS08', 'Las Vueltas', 'CHS'),
	('CHS09', 'Nombre de Jes�s', 'CHS'),
	('CHS10', 'Nueva Trinidad', 'CHS'),
	('CHS11', 'Ojos de Agua', 'CHS'),
	('CHS12', 'Potonico', 'CHS'),
	('CHS13', 'San Antonio de La Cruz', 'CHS'),
	('CHS14', 'San Antonio Los Ranchos', 'CHS'),
	('CHS15', 'San Francisco Lempa', 'CHS'),
	('CHS16', 'San Isidro Labrador', 'CHS'),
	('CHS17', 'San Jos� Cancasque', 'CHS'),
	('CHS18', 'San Miguel de Mercedes', 'CHS'),
	('CHS19', 'San Jos� Las Flores', 'CHS'),
	('CHS20', 'San Luis del Carmen', 'CHS'),
-- Cuscatl�n
	('CUN01', 'Suchitoto', 'CUN'),
	('CUN02', 'San Jos� Guayabal', 'CUN'),
	('CUN03', 'Oratorio de Concepci�n', 'CUN'),
	('CUN04', 'San Bartolom� Perulap�a', 'CUN'),
	('CUN05', 'San Pedro Perulap�n', 'CUN'),
	('CUS01', 'Cojutepeque', 'CUS'),
	('CUS02', 'San Rafael Cedros', 'CUS'),
	('CUS03', 'Candelaria', 'CUS'),
	('CUS04', 'Monte San Juan', 'CUS'),
	('CUS05', 'El Carmen', 'CUS'),
	('CUS06', 'San Cristobal', 'CUS'),
	('CUS07', 'Santa Cruz Michapa', 'CUS'),
	('CUS08', 'San Ram�n', 'CUS'),
	('CUS09', 'El Rosario', 'CUS'),
	('CUS10', 'Santa Cruz Analquito', 'CUS'),
	('CUS11', 'Tenancingo', 'CUS'),
-- La Libertad
	('LLN01', 'Quezaltepeque', 'LLN'),
	('LLN02', 'San Mat�as', 'LLN'),
	('LLN03', 'San Pablo Tacachico', 'LLN'),
	('LLC01', 'San Juan Opico', 'LLC'),
	('LLC02', 'Ciudad Arce', 'LLC'),
	('LLO01', 'Col�n', 'LLO'),
	('LLO02', 'Jayaque', 'LLO'),
	('LLO03', 'Sacacoyo', 'LLO'),
	('LLO04', 'Tepecoyo', 'LLO'),
	('LLO05', 'Talnique', 'LLO'),
	('LLE01', 'Antiguo Cuscatl�n', 'LLE'),
	('LLE02', 'Huiz�car', 'LLE'),
	('LLE03', 'Nuevo Cuscatl�n', 'LLE'),
	('LLE04', 'San Jos� Villanueva', 'LLE'),
	('LLE05', 'Zaragoza', 'LLE'),
	('LLS01', 'Comasagua', 'LLS'),
	('LLS02', 'Santa Tecla', 'LLS'),
	('LLT01', 'Chiltiup�n', 'LLT'),
	('LLT02', 'Jicalapa', 'LLT'),
	('LLT03', 'La Libertad', 'LLT'),
	('LLT04', 'Tamanique', 'LLT'),
	('LLT05', 'Teotepeque', 'LLT'),
-- La Paz
	('LPO01', 'Cuyultitan', 'LPO'),
	('LPO02', 'Olocuilta', 'LPO'),
	('LPO03', 'San Juan Talpa', 'LPO'),
	('LPO04', 'San Luis Talpa', 'LPO'),
	('LPO05', 'San Pedro Masahuat', 'LPO'),
	('LPO06', 'Tapalhuaca', 'LPO'),
	('LPO07', 'San Francisco Chinameca', 'LPO'),
	('LPC01', 'El Rosario', 'LPC'),
	('LPC02', 'Jerusal�n', 'LPC'),
	('LPC03', 'Mercedes La Ceiba', 'LPC'),
	('LPC04', 'Para�so de Osorio', 'LPC'),
	('LPC05', 'San Antonio Masahuat', 'LPC'),
	('LPC06', 'San Emigdio', 'LPC'),
	('LPC07', 'San Juan Tepezontes', 'LPC'),
	('LPC08', 'San Lu�s La Herradura', 'LPC'),
	('LPC09', 'San Miguel Tepezontes', 'LPC'),
	('LPC10', 'San Pedro Nonualco', 'LPC'),
	('LPC11', 'Santa Mar�a Ostuma', 'LPC'),
	('LPC12', 'Santiago Nonualco', 'LPC'),
	('LPE01', 'San Juan Nonualco', 'LPE'),
	('LPE02', 'San Rafael Obrajuelo', 'LPE'),
	('LPE03', 'Zacatecoluca', 'LPE'),
-- La Uni�n
	('LUN01', 'Anamor�s', 'LUN'),
	('LUN02', 'Bolivar', 'LUN'),
	('LUN03', 'Concepci�n de Oriente', 'LUN'),
	('LUN04', 'El Sauce', 'LUN'),
	('LUN05', 'Lislique', 'LUN'),
	('LUN06', 'Nueva Esparta', 'LUN'),
	('LUN07', 'Pasaquina', 'LUN'),
	('LUN08', 'Polor�s', 'LUN'),
	('LUN09', 'San Jos� La Fuente', 'LUN'),
	('LUN10', 'Santa Rosa de Lima', 'LUN'),
	('LUS01', 'Conchagua', 'LUS'),
	('LUS02', 'El Carmen', 'LUS'),
	('LUS03', 'Intipuc�', 'LUS'),
	('LUS04', 'La Uni�n', 'LUS'),
	('LUS05', 'Meanguera del Golfo', 'LUS'),
	('LUS06', 'San Alejo', 'LUS'),
	('LUS07', 'Yayantique', 'LUS'),
	('LUS08', 'Yucuaiqu�n', 'LUS'),
-- Moraz�n
	('MON01', 'Arambala', 'MON'),
	('MON02', 'Cacaopera', 'MON'),
	('MON03', 'Corinto', 'MON'),
	('MON04', 'El Rosario', 'MON'),
	('MON05', 'Joateca', 'MON'),
	('MON06', 'Jocoaitique', 'MON'),
	('MON07', 'Meanguera', 'MON'),
	('MON08', 'Perqu�n', 'MON'),
	('MON09', 'San Fernando', 'MON'),
	('MON10', 'San Isidro', 'MON'),
	('MON11', 'Torola', 'MON'),
	('MOS01', 'Chilanga', 'MOS'),
	('MOS02', 'Delicias de Concepci�n', 'MOS'),
	('MOS03', 'El Divisadero', 'MOS'),
	('MOS04', 'Gualococti', 'MOS'),
	('MOS05', 'Guatajiagua', 'MOS'),
	('MOS06', 'Jocoro', 'MOS'),
	('MOS07', 'Lolotiquillo', 'MOS'),
	('MOS08', 'Osicala', 'MOS'),
	('MOS09', 'San Carlos', 'MOS'),
	('MOS10', 'San Francisco Gotera', 'MOS'),
	('MOS11', 'San Sim�n', 'MOS'),
	('MOS12', 'Sensembra', 'MOS'),
	('MOS13', 'Sociedad', 'MOS'),
	('MOS14', 'Yamabal', 'MOS'),
	('MOS15', 'Yoloaiqu�n', 'MOS'),
-- Santa Ana
	('SAN01', 'Masahuat', 'SAN'),
	('SAN02', 'Metap�n', 'SAN'),
	('SAN03', 'Santa Rosa Guachipil�n', 'SAN'),
	('SAN04', 'Texistepeque', 'SAN'),
	('SAC01', 'Santa Ana', 'SAC'),
	('SAE01', 'Coatepeque', 'SAE'),
	('SAE02', 'El Congo', 'SAE'),
	('SAO01', 'Candelaria de la Frontera', 'SAO'),
	('SAO02', 'Chalchuapa', 'SAO'),
	('SAO03', 'El Porvenir', 'SAO'),
	('SAO04', 'San Antonio Pajonal', 'SAO'),
	('SAO05', 'San Sebasti�n Salitrillo', 'SAO'),
	('SAO06', 'Santiago de La Frontera', 'SAO'),
-- San Miguel
	('SMN01', 'Ciudad Barrios', 'SMN'),
	('SMN02', 'Sesori', 'SMN'),
	('SMN03', 'Nuevo Ed�n de San Juan', 'SMN'),
	('SMN04', 'San Gerardo', 'SMN'),
	('SMN05', 'San Luis de La Reina', 'SMN'),
	('SMN06', 'Carolina', 'SMN'),
	('SMN07', 'San Antonio del Mosco', 'SMN'),
	('SMN08', 'Chapeltique', 'SMN'),
	('SMC01', 'San Miguel', 'SMC'),
	('SMC02', 'Comacar�n', 'SMC'),
	('SMC03', 'Uluazapa', 'SMC'),
	('SMC04', 'Moncagua', 'SMC'),
	('SMC05', 'Quelepa', 'SMC'),
	('SMC06', 'Chirilagua', 'SMC'),
	('SMO01', 'Chinameca', 'SMO'),
	('SMO02', 'Nueva Guadalupe', 'SMO'),
	('SMO03', 'Lolotique', 'SMO'),
	('SMO04', 'San Jorge', 'SMO'),
	('SMO05', 'San Rafael Oriente', 'SMO'),
	('SMO06', 'El Tr�nsito', 'SMO'),
-- San Salvador
	('SSN01', 'Aguilares', 'SSN'),
	('SSN02', 'El Paisnal', 'SSN'),
	('SSN03', 'Guazapa', 'SSN'),
	('SSO01', 'Apopa', 'SSO'),
	('SSO02', 'Nejapa', 'SSO'),
	('SSE01', 'Ilopango', 'SSE'),
	('SSE02', 'San Mart�n', 'SSE'),
	('SSE03', 'Soyapango', 'SSE'),
	('SSE04', 'Tonacatepeque', 'SSE'),
	('SSC01', 'Ayutuxtepeque', 'SSC'),
	('SSC02', 'Mejicanos', 'SSC'),
	('SSC03', 'San Salvador', 'SSC'),
	('SSC04', 'Cuscatancingo', 'SSC'),
	('SSC05', 'Ciudad Delgado', 'SSC'),
	('SSS01', 'Panchimalco', 'SSS'),
	('SSS02', 'Rosario de Mora', 'SSS'),
	('SSS03', 'San Marcos', 'SSS'),
	('SSS04', 'Santo Tom�s', 'SSS'),
	('SSS05', 'Santiago Texacuangos', 'SSS'),
-- San Vicente
	('SVN01', 'Apastepeque', 'SVN'),
	('SVN02', 'Santa Clara', 'SVN'),
	('SVN03', 'San Ildefonso', 'SVN'),
	('SVN04', 'San Esteban Catarina', 'SVN'),
	('SVN05', 'San Sebasti�n', 'SVN'),
	('SVN06', 'San Lorenzo', 'SVN'),
	('SVN07', 'Santo Domingo', 'SVN'),
	('SVS01', 'San Vicente', 'SVS'),
	('SVS02', 'Guadalupe', 'SVS'),
	('SVS03', 'Verapaz', 'SVS'),
	('SVS04', 'Tepetit�n', 'SVS'),
	('SVS05', 'Tecoluca', 'SVS'),
	('SVS06', 'San Cayetano Istepeque', 'SVS'),
-- Sonsonate
	('SON01', 'Juay�a', 'SON'),
	('SON02', 'Nahuizalco', 'SON'),
	('SON03', 'Salcoatit�n', 'SON'),
	('SON04', 'Santa Catarina Masahuat', 'SON'),
	('SOC01', 'Sonsonate', 'SOC'),
	('SOC02', 'Sonzacate', 'SOC'),
	('SOC03', 'Nahulingo', 'SOC'),
	('SOC04', 'San Antonio del Monte', 'SOC'),
	('SOC05', 'Santo Domingo de Guzm�n', 'SOC'),
	('SOE01', 'Izalco', 'SOE'),
	('SOE02', 'Armenia', 'SOE'),
	('SOE03', 'Caluco', 'SOE'),
	('SOE04', 'San Juli�n', 'SOE'),
	('SOE05', 'Cuisnahuat', 'SOE'),
	('SOE06', 'Santa Isabel Ishuat�n', 'SOE'),
	('SOO01', 'Acajutla', 'SOO'),
-- Usulut�n
	('USN01', 'Santiago de Mar�a', 'USN'),
	('USN02', 'Alegr�a', 'USN'),
	('USN03', 'Berl�n', 'USN'),
	('USN04', 'Mercedes Uma�a', 'USN'),
	('USN05', 'Jucuapa', 'USN'),
	('USN06', 'El triunfo', 'USN'),
	('USN07', 'Estanzuelas', 'USN'),
	('USN08', 'San Buenaventura', 'USN'),
	('USN09', 'Nueva Granada', 'USN'),
	('USE01', 'Usulut�n', 'USE'),
	('USE02', 'Jucuar�n', 'USE'),
	('USE03', 'San Dionisio', 'USE'),
	('USE04', 'Concepci�n Batres', 'USE'),
	('USE05', 'Santa Mar�a', 'USE'),
	('USE06', 'Ozatl�n', 'USE'),
	('USE07', 'Tecap�n', 'USE'),
	('USE08', 'Santa Elena', 'USE'),
	('USE09', 'California', 'USE'),
	('USE10', 'Ereguayqu�n', 'USE'),
	('USO01', 'Jiquilisco', 'USO'),
	('USO02', 'Puerto El Triunfo', 'USO'),
	('USO03', 'San Agust�n', 'USO'),
	('USO04', 'San Francisco Javier', 'USO');
    
insert into Departamento.Direcciones (Linea1, Linea2, CodigoPostal, IdDistrito) values
	('Col Madera, Calle 1, #1N', 'Frente al parque', '02311', 'SON02'),  -- 1					
	('Barrio El Caldero, Av 2, #2I', 'Frente al amate', '02306', 'SOE01'), -- 2
	('Res El Cangrejo, Av 3, #3A', 'Frente a la playa', '02302', 'SOO01'), -- 3
	('Barrio El Centro, Av 4, #4S', 'Frente a catedral', '02301', 'SOC01'), -- 4
	('Col La Frontera, Calle 5, #5G', 'Km 10', '02113', 'AHS03'), -- 5
	('Res Buenavista, Calle 6, #6A', 'Contiguo a Alcaldia', '02201', 'SAC01'), -- 6
	('Res Altavista, Av 7, #7S', 'Contiguo al ISSS', '01101', 'SSC03'), -- 7
	('Col Las Margaritas, Pje 20, #2-4', 'Junto a ANDA', '02114', 'AHS01'),-- 8
	('Urb Las Magnolias, Pol 21, #2-6', 'Casa de esquina', '01115', 'LLO01'),-- 9
	('Caserio Florencia, 3era Calle, #5', 'Casa rosada', '02305', 'SON01');-- 10
    

insert into Cliente.Clientes (NombresCliente, ApellidosCliente, DuiCliente, FechaNacimientoCliente, TelefonoCliente, CorreoCliente, IdDireccion) values
    ('Jos� Luis', 'Garc�a P�rez', '56789012-3', '2000-05-14', '+503 7895-5368', 'garcia@hotmail.com', '1'), 
    ('Ana Mar�a', 'Rodr�guez L�pez', '34567890-1', '1998-09-20', '+503 7775-5590', 'anarodr�guez@gmail.com', '2'),
    ('Juan Carlos', 'Mart�nez Gonz�lez', '23456789-0', '1999-08-10', '+503 7654-3210', 'martinez@hotmail.com', '3'),
    ('Luis Ernesto', 'Rodr�guez Torres', '45678901-2', '1997-07-30', '+503 7894-5678', 'luis.rodriguez@hotmail.com', '9'),
    ('Mar�a Fernanda', 'P�rez Guti�rrez', '45678901-2', '1995-06-18', '+503 7695-2488', 'perez@gmail.com', '4'),
    ('Carlos Eduardo', 'L�pez Rodr�guez', '78901234-5', '1996-12-25', '+503 7215-5658', 'eduardo@hotmail.com', '5'),
    ('Natalia Sof�a', 'Mart�nez �lvarez', '90123456-7', '2001-02-15', '+503 7899-0123', 'sofia.martinez@gmail.com', '6'),
    ('Elena Fernanda', 'Gonz�lez Ruiz', '56789012-3', '2002-03-27', '+503 7895-6789', 'elena.gonzalez@gmail.com', '8');


insert into Ventas.Sucursales (TelefonoSucursal, IdDireccion) values
	('+503 7685-4568','1'),
	('+503 7275-5783', '2'),
	('+503 7155-9538', '5'),
	('+503 7955-4588', '8'),
    ('+503 7252-3567', '7'),
	('+503 7805-5085', '10');
 
insert into Ventas.Proveedores (NombresProveedor, TelefonoProveedor, CorreoProveedor, IdDireccion) values
	('Adidas', '+503 7656-2488', 'adidas@hotmail.com', '4'),
	('Nike', '+503 7125-5678', 'nike@gmail.com', '6'),
	('Puma', '+503 7475-5308', 'puma@hotmail.com', '7'),
	('Gucchi', '+503 7424-1658', 'gucchi@gmail.com', '9'),
    ('Reebok', '+503 7227-2308', 'reebok@gmail.com', '3'),
	('Converse', '+503 7765-9878', 'converse@hotmail.com', '10'),
	('New Balance', '+503 7865-3423', 'newbalance@hotmail.com', '9');

insert into Persona.Cargos (Cargo) values
	('SysAdmin'), -- 1
    ('Gerente'), -- 2
    ('Bodeguero'), -- 3
	('Cajero'), -- 4
    ('Vendedor'), -- 5
    ('RRHH'); -- 6

insert into Persona.Empleados (NombresEmpleado, ApellidosEmpleado, DuiEmpleado, ISSS_Empleado,Fecha_NacEmpleado, TelefonoEmpleado, CorreoEmpleado, IdCargo, IdDireccion) values
	('Alejandro David', 'Sanchez Castro', '04321098-7','906325698', '1995-01-01','+503 7895-7693', 'david@gmail.com', '1', '1'), -- SysAdmin
    ('Carlos Raul', 'Rodas Gonzalez', '04523695-5','963852741', '1990-02-02','+503 6552-4927', 'raul@hotmail.com', '2', '2'), -- Gerente
	('Edgar Edgardo', 'Del Valle Garcia', '03210987-4','321654987','1980-03-03', '+503 6598-2346', 'edgar@outlook.com', '3', '3'), -- Bodeguero 
	('Maria Jose', 'Perez de Hernandez', '06789012-1', '951753258','1985-04-04','+503 7985-2516', 'maria@gmail.com', '4', '4'), -- Cajera
    ('Luc�a Alexandra', 'Ram�rez Flores', '78901234-5','987654321','2000-04-22', '+503 7897-8901', 'lucia.ramirez@outlook.com', '4', '9'), -- Cajera
	('Jose Miguel', 'Hernandez Figueroa', '07567012-2', '906325699','1996-02-02','+503 7785-2416', 'jose@hotmail.com', '5', '5'), -- Vendedor
    ('Katia Alejandra', 'Rivera Mejia', '03376911-4','906325700','1997-03-03', '+503 6785-2196', 'katia@gmail.com', '5', '7'), -- Vendedor
    ('David Alejandro', 'Fern�ndez D�az', '89012345-6','754278785', '1999-11-02', '+503 7898-9012', 'david.fernandez@gmail.com', '5', '8'), -- Vendedor
    ('Owen Bladimir', 'Gomez Hernandez', '96459012-3','245712483', '1985-03-03', '+503 7985-2516', 'owen@gmail.com', '6', '6'); -- RRHH

insert into Ventas.Ventas (Fecha_De_Venta, Total_De_Venta, Monto, IdCliente, IdEmpleado) values
	('2024-02-01', 1, 130.00, 1, 'EMP006-HF2024'),
	('2024-04-11', 1, 695.00, 2, 'EMP007-RM2024'),
	('2024-04-18', 1, 110.00, 3, 'EMP008-FD2024'),
	('2024-07-21', 1, 90.00, 4, 'EMP008-FD2024'),
	('2024-11-14', 1, 750.00, 5, 'EMP007-RM2024'),
    ('2024-12-03', 1, 800.00, 6, 'EMP006-HF2024'),
    ('2024-12-15', 1, 950.00, 7, 'EMP007-RM2024'),
    ('2024-12-24', 1, 70.00, 8, 'EMP008-FD2024'),

	('2024-10-31', 1, 110.00, 1, 'EMP006-HF2024'),
	('2024-11-01', 1, 130.00, 3, 'EMP007-RM2024'),
	('2024-11-04', 1, 140.00, 1, 'EMP007-RM2024');


insert into Ventas.EstadosPedidos(Estado) values
	('Enviado'),
    ('En Proceso'),
    ('Cancelado'),
    ('Devuelto');


insert into Ventas.EstadosFacturas (Estado) values
    ('Pagada'),
	('Pendiente'),
    ('Enviada'),
    ('Anulada');


insert into Ventas.Pedidos (Fecha_De_Pedido, Cantidad_De_Pares, Lotes, Precio, IdEstadoPedido, IdProveedor, IdEmpleado) VALUES
    ('2024-01-22', 50, 1, 6.500, 1, 2, 'EMP002-RG2024'),
    ('2024-01-22', 50, 1, 6.000, 1, 2, 'EMP002-RG2024'),
    ('2024-02-14', 50, 1, 5.500, 1, 2, 'EMP002-RG2024'),
    ('2024-02-18', 50, 1, 4.500, 1, 2, 'EMP002-RG2024'),
    ('2024-03-12', 50, 1, 7.500, 2, 2, 'EMP002-RG2024'),
    ('2024-04-01', 50, 1, 7.000, 2, 2, 'EMP002-RG2024'),
    ('2024-05-04', 50, 1, 6.500, 1, 2, 'EMP002-RG2024'),
    ('2024-06-20', 50, 1, 3.500, 2, 2, 'EMP002-RG2024'),
    ('2024-07-29', 50, 1, 37.500, 2, 2, 'EMP002-RG2024'),
    ('2024-07-16', 50, 1, 34.750, 2, 2, 'EMP002-RG2024'),
    ('2024-08-22', 50, 1, 3.750, 2, 2, 'EMP002-RG2024'),
    ('2024-09-02', 50, 1, 3.500, 1, 2, 'EMP002-RG2024'),
    ('2024-10-30', 50, 1, 40.000, 2, 2, 'EMP002-RG2024'),
    ('2024-10-24', 50, 1, 47.500, 2, 2, 'EMP002-RG2024');


insert into Productos.Categoria (Categoria) values
	('Deportivo'),
	('Casual'),
	('Ni�o'),
	('Ni�a'),
	('Masculino'),
    ('Femenino'),
    ('Formal'),
    ('Sandalias');

insert into Productos.Tipo_De_Material (Material) values
	('Cuero'),
	('Cuero sintetico'),
	('Lienzo o Lona'),
	('Sinteticos'),
	('Textiles'),
    ('Goma'),
    ('Neopreno'),
    ('Poli�ster'); 

insert into Productos.Inventario (Inventario, Estante, Pasillo) values
	('Adidas Stan Smith','E1','P1'),
	('Adidas Superstar','E2','P2'),
	('Puma RS-X� Puzzle','E3','P3'),
	('Puma Future Rider','E4','P4'),
	('Nike Air Max 270','E5','P5'),
    ('Nike Air Force 1','E6','P6'), 
    ('Reebok Classic','E7','P7'),
    ('Converse Chuck Taylor','E8','P8'),
    ('Gucci Marmont Sandal','E9','P9'),
    ('Gucci Horsebit Sandal','E10','P10'),
    ('Nike Air Max Kids','E11','P11'),
    ('Adidas Superstar Kids','E12','P12'),
    ('Gucci Leather Loafers','E13','P13'),
    ('Gucci Leather Pumps','E14','P14'),
	('New Balance 574', 'E15', 'P15');


insert into Productos.Marca (Nombres, Modelo) values
    ('Adidas', 'Adidas Stan Smith'),
	('Adidas', 'Adidas Superstar'),
	('Puma', 'Puma RS-X� Puzzle'),
	('Puma', 'Puma Future Rider'),
	('Nike', 'Nike Air Max 270'),
    ('Nike', 'Nike Air Force 1'),
    ('Reebok', 'Reebok Classic'),
    ('Converse', 'Converse Chuck Taylor'),
    ('Gucci', 'Marmont Sandal'),
    ('Gucci', 'Horsebit Sandal'),
    ('Nike', 'Nike Air Max Kids'),
    ('Adidas', 'Adidas Superstar Kids'),
    ('Gucci', 'Gucci Leather Loafers'),
    ('Gucci', 'Gucci Leather Pumps'),
	('New Balance', 'New Balance 574');
    
insert into Ventas.Formas_De_Pagos (Tipo) values
	('Efectivo'),
	('Credito'),
	('Devito'),
	('Transferencia'),
    ('Bitcoin'); 

insert into Productos.Zapatos (Nombre, Descripcion, Color, Precio, Stock, IdMarca, IdInventario, IdTipoDeMaterial, IdCategoria, IdProveedor) values
	('Adidas Stan Smith','Tenis de cuero y suela de goma', 'Blanco', 130.00, 50, 1, 1, 1, 2, 1),
	('Adidas Superstar','Zapatilla cl�sica de cuero', 'Blanco', 120.00 , 50, 2, 2, 1, 2, 1),
	('Puma RS-X� Puzzle','Zapatilla estilo retro de malla y cuero sint�tico', 'Varios Colores', 110.00, 50, 3, 3, 2, 1, 3),
	('Puma Future Rider','Inspiradas en estilo de los 80, con malla y una suela de goma ligera', 'Varios Colores', 90.00 , 50, 4, 4, 4, 2, 3),
	('Nike Air Max 270','Estilo urbano con unidad Air Max grande en el tal�n para una amortiguaci�n y malla transpirable','Varios Colores', 150.00 ,50, 5, 5, 2, 1, 2),
    ('Nike Air Force 1','Dise�o cl�sico y amortiguaci�n de aire', 'Blanco', 140.00, 50, 6, 6, 2, 2, 2),
    ('Reebok Classic','Estilo cl�sico con parte superior de cuero', 'Blanco', 130.00, 50, 7, 7, 2, 5, 5),
    ('Converse Chuck Taylor','Zapatillas altas de lona', 'Negro', 70.00, 50, 8, 8, 3, 6, 6),
    ('Gucci Marmont Sandal', 'Sandalia de cuero con tac�n', 'Negro', 750.00, 50, 9, 9, 1, 8, 4),
	('Gucci Horsebit Sandal', 'Sandalia de cuero con adorno Horsebit', 'Rojo', 695.00, 50, 10, 10, 1, 8, 4),
	('Nike Air Max Kids', 'Tenis deportivos para ni�os con unidad de aire visible', 'Azul', 75.00, 50, 11, 11, 1, 3, 2),
	('Adidas Superstar Kids', 'Tenis de cuero para ni�as con punta de goma', 'Rosa', 70.00, 50, 12, 12, 2, 4, 1),
    ('Gucci Leather Loafers', 'Mocasines de cuero para hombre', 'Negro', 800.00, 50, 13, 13, 1, 7, 4),
	('Gucci Leather Pumps', 'Zapatos de tac�n de cuero para mujer', 'Rojo', 950.00, 50, 14, 14, 1, 7, 4),
	('New Balance 574', 'Zapatillas deportivas de estilo retro con buena amortiguaci�n', 'Gris', 110.00, 50, 15, 15, 2, 5, 7);


insert into Ventas.Detalles_De_Ventas (IdVenta, IdZapato, IdSucursal, Cantidad, PrecioUnitario, SubTotal, IdFormaDePago) values
	(1, 1, 1, 1, 130.00, 130.00,1),
	(2, 10, 2, 1, 695.00, 695.00,4),
	(3, 3, 3, 1, 110.00, 110.00,2),
	(4, 4, 4, 1, 90.00, 90.00,3),
	(5, 9, 5, 1, 750.00, 750.00,5),
	(6, 13, 6, 1, 800.00, 800.00,4),
	(7, 14, 3, 1, 950.00, 950.00,4),
	(8, 8, 6, 1, 70.00, 70.00,1),

	(9, 3, 1, 1, 110.00, 110.00,2),
	(10, 1, 3, 1, 130.00, 130.00,1),
	(11, 6, 1, 1, 140.00, 140.00,2);

insert into Ventas.Detalles_De_Pedidos (PrecioUnitario, SubTotal, Fecha_De_Compra, TotalPagarCompra, IdSucursal, IdPedido, IdZapato, IdFormaDePago) values
	(130.00, 6.500, '2024-01-22', 6.500, 1, 1, 1, 4),
	(120.00, 6.000, '2024-01-22', 6.000, 2, 2, 2, 4),
	(110.00, 5.500, '2024-02-14', 5.500, 3, 3, 3, 4),
	(90.00, 4.500, '2024-02-18', 4.500, 4, 4, 4, 4),
	(150.00, 7.500, '2024-05-12', 7.500, 5, 5, 5, 4),
    (140.00, 7.000, '2024-04-01', 7.000, 6, 6, 6, 4),
    (130.00, 6.500, '2024-05-04', 6.500, 1, 7, 7, 4),
    (70.00, 3.500, '2024-06-20', 3.500, 2, 8, 8, 4),
    (750.00, 37.500, '2024-07-29', 37.500, 3, 9, 9, 4),
    (695.00, 34.750, '2024-07-16', 34.750, 4, 10, 10, 4),
    (75.00, 3.750, '2024-08-22', 3.750, 4, 11, 11, 4),
    (70.00, 3.500, '2024-09-02', 3.500, 4, 12, 12, 4),
    (800.00, 40.500, '2024-10-30', 40.500, 1, 13, 13, 4),
    (950.00, 47.500, '2024-10-24', 47.500, 2, 14, 14, 4);
    
insert into Ventas.Factura_De_Ventas (TotalPagarVenta, Fecha_Factura_Venta, IdEstadoFactura, IdDetalleDeVenta, IdFormaDePago, IdCliente, IdEmpleado) values
	(130.00, '2024-02-01', 1, 1, 1, 1, 'EMP006-HF2024'),
	(695.00, '2024-04-11', 1, 2, 4, 2, 'EMP007-RM2024'),
	(110.00, '2024-04-18', 2, 3, 2, 3, 'EMP008-FD2024'),
	(90.00, '2024-07-21', 3, 4, 3, 4, 'EMP008-FD2024'),
	(750.00, '2024-11-14', 3, 5, 5, 5, 'EMP007-RM2024'),
    (800.00, '2024-12-03', 2, 6, 4, 6, 'EMP006-HF2024'),
    (950.00, '2024-12-15', 1, 7, 4, 7, 'EMP007-RM2024'),
    (70.00, '2024-12-24',2, 8, 1, 8, 'EMP008-FD2024'),

	(110.00, '2024-10-31', 1, 9, 4, 1, 'EMP006-HF2024'),
	(130.00, '2024-11-01', 1, 10, 1, 3, 'EMP007-RM2024'),
	(140.00, '2024-11-04', 1, 11, 4, 1, 'EMP007-RM2024');

insert into Ventas.Factura_De_Compras (TotalPagarCompra, Fecha_Factura_Compra, IdEstadoFactura, IdDetalleDePedido, IdFormaDePago) values
	(6.500, '2024-01-22', 1, 1, 4),
	(6.000, '2024-01-22',2, 2, 4),
	(5.500, '2024-02-14', 3, 3, 4),
	(4.500, '2024-02-18', 1, 4, 4),
	(7.500, '2024-05-12', 2, 5, 4),
    (7.000, '2024-04-01', 3, 6, 4),
    (6.500, '2024-05-04', 3, 7, 4),
    (3.500, '2024-06-20', 2, 8, 4),
    (37.500, '2024-07-29', 2, 9, 4),
    (34.750, '2024-07-16', 1, 10, 4),
    (3.750, '2024-08-22' , 1, 11, 4),
    (3.500, '2024-09-02', 1, 12, 4),
    (40.000, '2024-10-30', 1, 13, 4),
    (47.500, '2024-10-24', 1, 14, 4);

insert into Rol.roles (Rol) values
	('SysAdmin'), -- 1
    ('Gerente'), -- 2
    ('Bodeguero'), -- 3
	('Cajero'),	-- 4
    ('Vendedor'), -- 5
    ('RRHH'); -- 6

insert into Rol.opciones (Opcion) values
	('Gestionar Cuentas'), -- 1
    ('Gestionar Departamentos'), -- 2
    ('Gestionar Municipios'), -- 3
    ('Gestionar Distritos'), -- 4
    ('Gestionar Direcciones'), -- 5
    ('Gestionar Cargos'), -- 6
    ('Gestionar Empleados'), -- 7
    ('Gestionar Clientes'), -- 8
	('Gestionar Sucursales'), -- 9
    ('Gestionar Proveedores'), -- 10
    ('Gestionar Pedidos'), -- 11
    ('Gestionar Ventas'), -- 12
	('Gestionar Formas_De_Pagos'), -- 13
	('Gestionar Marca'), -- 14
    ('Gestionar Categoria'), -- 15
    ('Gestionar Tipo_De_Material'), -- 16
    ('Gestionar Inventario'), -- 17
    ('Gestionar Zapatos'), -- 18
    ('Gestionar Detalles_De_Ventas'), -- 19
    ('Gestionar Detalles_De_Pedidos'), -- 20
    ('Gestionar Factura_De_Ventas'), -- 21
	('Gestionar Factura_De_Compras'), -- 22
	('Gestionar roles'), -- 23
    ('Gestionar opciones'), -- 24
    ('Gestionar asignacionRolesOpciones'), -- 25
    ('Gestionar usuarios'), -- 26
	('Gestionar EstadosPedidos'), --27
	('Gestionar EstadosFacturas'), -- 28
	('Gestionar HistorialDeComprasClientes'), -- 29
	('Gestionar ZapatosMasVendidos'); -- 30


-- **********************
-- ****** SysAdmin ******
-- **********************
insert into Rol.asignacionRolesOpciones (IdRol, IdOpcion) values
-- PERMISO SOBRE TODAS LAS TABLAS LECTURAS Y MODIFICACION
('1', '1'), ('1', '2'), ('1', '3'), ('1', '4'), ('1', '5'), ('1', '6'),('1', '7'),('1', '8'),('1', '9'), ('1', '10'),
('1', '11'), ('1', '12'), ('1', '13'), ('1', '14'), ('1', '15'),('1', '16'),('1', '17'),('1', '18'),('1', '19'),
('1', '20'), ('1', '21'), ('1', '22'), ('1', '23'), ('1', '24'), ('1', '25'), ('1', '26'), ('1', '27'), ('1', '28'),
('1', '29'), ('1', '30'),

-- *********************
-- ****** GERENTE ******
-- *********************
-- PERMISO DE MODIFICACION Y LECTURA
('2', '2'), 
('2', '3'), 
('2', '4'), 
('2', '5'), 
('2', '7'), 
('2', '8'),
('2', '9'),
('2', '10'),
('2', '11'),
('2', '12'), 
('2', '18'), 
('2', '19'), 
('2', '20'), 
('2', '21'), 
('2', '22'),
('2', '27'), 
('2', '28'),
('2', '29'),
('2', '30'),

-- PERMISO SOLO LECTURA
('2', '13'),
('2', '14'), 
('2', '15'), 
('2', '16'), 
('2', '17'),
('2', '23'),
('2', '24'),
('2', '25'),
('2', '26'),

-- ***********************
-- ****** BODEGUERO ******
-- ***********************
-- PERMISO DE MODIFICACION Y LECTURA: Inventario.
('3', '17'), 

-- PERMISO DE LECTURA: Zapatos, Detalles de venta, Detalle de pedidos
('3', '18'), ('3', '19'), ('3', '20'),('3', '27'),


-- ********************
-- ****** CAJERO ******
-- ********************
-- PERMISO DE MODIFICACION Y LECTURA: Ventas, Formas de pago.
('4', '12'), ('4', '13'), ('4', '27'), ('4', '28'),

-- PERMISO DE LECTURA: Detalles de ventas
('4', '19'),('4', '28'), ('4', '29'),('4', '30'),


-- **********************
-- ****** VENDEDOR ******
-- **********************
-- PERMISO DE MODIFICACION Y LECTURA: Clientes, Ventas, Detalles de ventas.
('5', '8'), ('5', '12'), ('5', '19'), 

-- PERMISO DE LECTURA: Pedidos
('5', '11'), ('5', '27'), ('5', '28'), ('5', '29'), ('5', '30'),


-- ******************
-- ****** RRHH ******
-- ******************
-- PERMISO DE MODIFICACION Y LECTURA: Empleados, Roles, Opciones, asignacion roles opciones, Usuarios.
('6', '7'), ('6', '23'), ('6', '24'), ('6', '25'), ('6', '26'),

-- PERMISO DE LECTURA: Cargos, Departamentos, Municipio, Distrito, Direcciones
('6', '2'), ('6', '3'), ('6', '4'), ('6', '5'), ('6', '6');

insert into Rol.usuarios(usuario, Contrasenia, IdRol,IdEmpleado)values
('sys_AlejandroSanchez', 'root', '1','EMP001-SC2024'), -- SysAdmin
('geren_CarlosRodas', '2020', '2', 'EMP002-RG2024'), -- Gerente
('bode_EdgarDelValle', '3030', '3', 'EMP003-DV2024'), -- Bodeguero
('caje_MariaPerez', '4040', '4', 'EMP004-Pd2024'), -- Cajero
('vende_Jos�Hernandez', '5050', '5', 'EMP006-HF2024'), -- Vendedor
('rrhh_OwenGomez', '6060', '6', 'EMP009-GH2024'); -- RRHH
go


-- *************
-- **** DCL ****
-- *************

-- CREACION DE ROLES
create role SysAdmin
go
create role Gerente
go
create role Bodeguero
go
create role Cajero
go
create role Vendedor
go
create role RRHH
go

-- LOGINS
create login login_sys_AlejandroSanchez
with password = 'root';
go

create login login_geren_CarlosRodas
with password = 'geren123';
go

create login login_bode_EdgarDelValle
with password = 'bode123';
go

create login login_caje_MariaPerez
with password = 'caje123';
go

create login login_vende_Jos�Hernandez
with password = 'vende123';
go

create login login_rrhh_OwenGomez
with password = 'rrhh123';
go

-- CREACION DE USUARIOS
create user sys_AlejandroSanchez
for login login_sys_AlejandroSanchez;
go

create user geren_CarlosRodas
for login login_geren_CarlosRodas;
go

create user bode_EdgarDelValle
for login login_bode_EdgarDelValle
go

create user caje_MariaPerez
for login login_caje_MariaPerez;
go

create user vende_Jos�Hernandez
for login login_vende_Jos�Hernandez;
go

create user rrhh_OwenGomez
for login login_rrhh_OwenGomez;
go

-- AGREGAR USUARIOS A ROLES
alter role SysAdmin add member sys_AlejandroSanchez;
go
alter role Gerente add member geren_CarlosRodas;
go
alter role Bodeguero add member bode_EdgarDelValle;
go
alter role Cajero add member caje_MariaPerez;
go
alter role Vendedor add member vende_Jos�Hernandez;
go
alter role RRHH add member rrhh_OwenGomez;
go

-- *************************************************
-- ASIGNACION DE PRIVILEGIOS A ROLES: ADMINISTRADOR
-- *************************************************
grant control on database:: zapateria to SysAdmin;

-- **********************************************
-- ASIGNACION DE PRIVILEGIOS A ROLES: GERENTE
-- **********************************************
grant select, insert, update, delete on Departamento.Departamentos to Gerente;
grant select, insert, update, delete on Departamento.Municipios to Gerente;
grant select, insert, update, delete on Departamento.Distritos to Gerente;
grant select, insert, update, delete on Departamento.Direcciones to Gerente;
grant select, insert, update, delete on Cliente.Clientes to Gerente;
grant select, insert, update, delete on Ventas.Sucursales to Gerente;
grant select, insert, update, delete on Ventas.Proveedores to Gerente;
grant select, insert, update, delete on Persona.Empleados to Gerente;
grant select, insert, update, delete on Ventas.Ventas to Gerente;
grant select, insert, update, delete on Ventas.Pedidos to Gerente;
grant select, insert, update, delete on Productos.Zapatos to Gerente;
grant select, insert, update, delete on Ventas.Detalles_De_Ventas to Gerente;
grant select, insert, update, delete on Ventas.Detalles_De_Pedidos to Gerente;
grant select, insert, update, delete on Ventas.Factura_De_Ventas to Gerente;
grant select, insert, update, delete on Ventas.Factura_De_Compras to Gerente;
grant select, insert, update, delete on Ventas.EstadosPedidos to Gerente;
grant select, insert, update, delete on Ventas.EstadosFacturas to Gerente;
grant select, insert, update, delete on Cliente.HistorialDeComprasClientes to Gerente;
grant select, insert, update, delete on Productos.ZapatosMasVendidos to Gerente;


grant select on Productos.Categoria to Gerente;
grant select on Productos.Tipo_De_Material to Gerente;
grant select on Productos.Inventario to Gerente;
grant select on Productos.Marca to Gerente;
grant select on Ventas.Formas_De_Pagos to Gerente;
grant select on Rol.roles to Gerente;
grant select on Rol.opciones to Gerente;
grant select on Rol.asignacionRolesOpciones to Gerente;
grant select on Rol.usuarios to Gerente;

-- **********************************************
-- ASIGNACION DE PRIVILEGIOS A ROLES: BODEGUERO
-- **********************************************
grant select, insert, update, delete on Productos.Inventario to Bodeguero;

grant select on Productos.Zapatos to Bodeguero;
grant select on Ventas.Detalles_De_Ventas to Bodeguero;
grant select on Ventas.Detalles_De_Pedidos to Bodeguero;
grant select on Ventas.EstadosPedidos to Bodeguero;

-- **********************************************
-- ASIGNACION DE PRIVILEGIOS A ROLES: CAJERO
-- **********************************************
grant select, insert, update, delete on Ventas.Ventas to Cajero;
grant select, insert, update, delete on Ventas.Formas_De_Pagos to Cajero;
grant select, insert, update, delete on Ventas.EstadosPedidos to Cajero;
grant select, insert, update, delete on Ventas.EstadosFacturas to Cajero;


grant select on Ventas.Detalles_De_Ventas to Cajero;
grant select on  Cliente.HistorialDeComprasClientes to Cajero;
grant select on Productos.ZapatosMasVendidos to Cajero;

-- **********************************************
-- ASIGNACION DE PRIVILEGIOS A ROLES: VENDEDOR
-- **********************************************
grant select, insert, update, delete on Cliente.Clientes to Vendedor;
grant select, insert, update, delete on Ventas.Ventas to Vendedor;
grant select, insert, update, delete on Ventas.Detalles_De_Ventas to Vendedor;

grant select on Ventas.Pedidos to Vendedor;
grant select on Ventas.EstadosPedidos to Vendedor;
grant select on Ventas.EstadosFacturas to Vendedor;
grant select on Cliente.HistorialDeComprasClientes to Vendedor;
grant select on Productos.ZapatosMasVendidos to Vendedor;

-- **********************************************
-- ASIGNACION DE PRIVILEGIOS A ROLES: RRHH
-- **********************************************
grant select, insert, update, delete on Persona.Empleados to RRHH;
grant select, insert, update, delete on Rol.roles to RRHH;
grant select, insert, update, delete on Rol.opciones to RRHH;
grant select, insert, update, delete on Rol.asignacionRolesOpciones to RRHH;
grant select, insert, update, delete on Rol.usuarios to RRHH;

grant select on Persona.Cargos to RRHH;
grant select on Departamento.Departamentos to RRHH;
grant select on Departamento.Municipios to RRHH;
grant select on Departamento.Distritos to RRHH;
grant select on Departamento.Direcciones to RRHH;

-- Consulta para obtener una lista de logins en la instancia de SQL Server
select name from sys.server_principals where type_desc = 'SQL_LOGIN';
go
-- Consulta para obtener una lista de usuarios en la instancia de SQL Server
select name from sys.database_principals where type_desc = 'SQL_USER';
go
-- Consulta para obtener una lista de roles en la instancia de SQL Server
select name from sys.database_principals where type_desc = 'DATABASE_ROLE';
go

-- **** Verificacion del contenido de las tablas ***
-- Departamento
select * from departamento.departamentos;
select * from departamento.municipios;
select * from departamento.distritos;
select * from departamento.direcciones;

-- Persona
select * from persona.cargos;
select * from persona.empleados;

-- Productos
select * from productos.categoria;
select * from productos.tipo_de_material;
select * from productos.inventario;
select * from productos.marca;
select * from productos.zapatos;

-- Cliente
select * from cliente.clientes;

-- Ventas
select * from ventas.sucursales;
select * from ventas.proveedores;
select * from ventas.ventas;
select * from ventas.pedidos;
select * from ventas.formas_de_pagos;
select * from ventas.detalles_de_ventas;
select * from ventas.detalles_de_pedidos;
select * from ventas.factura_de_ventas;
select * from ventas.factura_de_compras;

-- Rol
select * from rol.roles;
select * from rol.opciones;
select * from rol.asignacionrolesopciones;
select * from rol.usuarios;