/*NOTA: Correr en este orden: el DLL --> Secuencias --> DML -->  DCL 

  PROBAR SECUENCIAS: Hacer estas consultas y ver los resultados en los IDS de cada tabla: Select *from Cliente.HistorialDeComprasClientes; 
  Select *from Productos.ZapatosMasVendidos;  --->  Select *from Persona.Empleados;  --->  Select *from Ventas.Factura_De_Ventas;
*/

-- Crear tabla Cliente.HistorialDeComprasClientes
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

-- Relacion de llave foranea
alter table Cliente.HistorialDeComprasClientes add foreign key (IdCliente) references Cliente.Clientes(IdCliente);
go

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

        -- Ver si el cliente ya está en la tabla que creamos 
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
create table Productos.ZapatosMasVendidos (
    IdZapatoMasVendido varchar(7) primary key,
    Nombre varchar(100) not null,
    Color varchar(50) not null,
    Precio decimal(10, 2) not null,
    CantidadVendidos int not null
);
go

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
as begin
    declare @anio int, @numeroGenerado varchar(15), @correlativo int, @IdFacturaVenta int, @TotalPagarVenta decimal(10, 2), 
			@Fecha_Factura_Venta date, @IdEstadoFactura int, @IdDetalleDeVenta int, @IdFormaDePago int;
    
    set @anio = year(getdate()); 

    -- Iterar sobre cada fila insertada para asignar un Numfactura único
    declare cur cursor for
    select TotalPagarVenta, Fecha_Factura_Venta, IdEstadoFactura, IdDetalleDeVenta, IdFormaDePago from inserted;

    open cur;
    fetch next from cur into @TotalPagarVenta, @Fecha_Factura_Venta, @IdEstadoFactura, @IdDetalleDeVenta, @IdFormaDePago;

    while @@fetch_status = 0
    begin  -- Agarrar el siguiente valor de la secuencia
        set @correlativo = next value for SeqNumeroFactura;

        set @numeroGenerado = 'FAC' + cast(@anio as varchar(4)) + '-' + right('0000' + cast(@correlativo as varchar(4)), 4);

        -- Agregar en la tabla Ventas.Factura_De_Ventas con el NumFactura hecho
        insert into Ventas.Factura_De_Ventas (NumFactura, TotalPagarVenta, Fecha_Factura_Venta, IdEstadoFactura, IdDetalleDeVenta, IdFormaDePago)
        values (@numeroGenerado, @TotalPagarVenta, @Fecha_Factura_Venta, @IdEstadoFactura, @IdDetalleDeVenta, @IdFormaDePago);

        fetch next from cur into @TotalPagarVenta, @Fecha_Factura_Venta, @IdEstadoFactura, @IdDetalleDeVenta, @IdFormaDePago;
    end
    close cur;
    deallocate cur;
end;
go
