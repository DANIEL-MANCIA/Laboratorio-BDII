-- EJERCICIO 1: Función Escalar para Calcular la Edad de un Empleado

create function dbo.CalcularEdadEmpleado (@Fecha_NacEmpleado date)
returns int
as begin
    declare @Edad int;
    
    -- Calcular la diferencia en años entre la fecha actual y la fecha de nacimiento
    set @Edad = datediff(year, @Fecha_NacEmpleado, getdate());
    
    -- Ajustar si la persona aún no ha cumplido años este año
    if (month(@Fecha_NacEmpleado) > month(getdate())) OR 
       (month(@Fecha_NacEmpleado) = month(getdate()) AND day(@Fecha_NacEmpleado) > day(getdate()))
    begin
        set @Edad = @Edad - 1;
    end
    
    return @Edad;
end;
go

-- Prueba de la funcion: La edad del bodeguero Edgar Edgardo Del Valle Garcia FecNac: 1980-03-03
select dbo.CalcularEdadEmpleado('1980-03-03') as EdadEmpleado;
go

-- EJERCICIO 3: Función con Valores de Tabla para Listar los Productos por Categoría

create function ListarProductosPorCategoria( @categoriaid int)
returns @ProductosConInfo table(
	Nombre varchar(100),
	Descripcion varchar(100),
	Color varchar(100),
	Precio float,
	Marca varchar(100),
	Modelo varchar(100),
	TipoDeMaterial varchar(100))
as 
	begin
		insert into @ProductosConInfo
		select 
		pp.Nombre, pp.Descripcion, pp.Color, pp.Precio,
		pm.Nombres as Marca, pm.Modelo,
		ptm.Material
		from  Productos.Zapatos pp
		inner join Productos.Marca pm on pp.IdMarca = pm.IdMarca
		inner join Productos.Tipo_De_Material ptm on pp.IdTipoDeMaterial = ptm.IdTipoDeMaterial
		where IdCategoria = @categoriaid

		return
	end;
go

-- Prueba de la funcion: categoria 2
select *from ListarProductosPorCategoria(2);
go

-- ********* PROCESOS ALMACENADOS - CRUD *********

-- ******************************
-- ****** INSERT CLIENTE ********
-- ******************************

create or alter procedure InsertarCliente
    @NombresCliente varchar(100),
    @ApellidosCliente varchar(100),
    @DuiCliente char(10),
    @TelefonoCliente varchar(15),
    @CorreoCliente varchar(100),
    @IdDireccion int
as
begin
	insert into
	Cliente.Clientes 
	(NombresCliente, ApellidosCliente, DuiCliente, TelefonoCliente, CorreoCliente, IdDireccion) values 
	(@NombresCliente, @ApellidosCliente, @DuiCliente, @TelefonoCliente, @CorreoCliente, @IdDireccion);
end;
go

exec InsertarCliente 
    'Rodrigo Alejandro',     -- NombresCliente
    'Valencia Ruiz',         -- ApellidosCliente
    '01234321-9',            -- DuiCliente
    '+503 77378286',         -- TelefonoCliente
    'alevalencia@gmail.com', -- Correo
    4;                       -- Id_Direccion
go

select *from Cliente.Clientes;
go

-- ***************************
-- ****** UPDATE CLIENTE *****
-- ***************************

create or alter procedure ActualizarCliente(
    @IdCliente int,
	@NombresCliente varchar(100),
    @ApellidosCliente varchar(100),
    @DuiCliente char(10),
    @TelefonoCliente varchar(15),
    @CorreoCliente varchar(100),
    @IdDireccion int
)as
begin
	update Cliente.Clientes 
	set NombresCliente = @NombresCliente, 
		ApellidosCliente = @ApellidosCliente, 
		@DuiCliente = DuiCliente, 
		TelefonoCliente = @TelefonoCliente, 
		CorreoCliente = @CorreoCliente, 
		IdDireccion = @IdDireccion
	where IdCliente = @IdCliente;
end;
go

-- Prueba: Actualizar el primer nombre, segundo apellido, la direccion al cliente que agg recientemente.
exec ActualizarCliente 
	9,						 -- IdCliente
    'Lucas Alejandro',       -- NombresCliente
    'Valencia Calderon',     -- ApellidosCliente
    '01234321-9',            -- DuiCliente
    '+503 77378286',         -- TelefonoCliente
    'alevalencia@gmail.com', -- Correo
    2;                       -- Id_Direccion
go

select *from Cliente.Clientes;
go

-- ********************************
-- ****** ELIMINAR CLIENTE ********
-- ********************************

create or alter procedure EliminarCliente(
	@id int
) as
begin
	delete from Cliente.Clientes
	where IdCliente = @id;
end;
go

-- Prueba: Eliminar el cliente que hemos actualizado en el paso anterior
exec EliminarCliente 
	9;		-- IdCliente a eliminar
go

select *from Cliente.Clientes;
go

-- ********************************
-- ****** SELECT CLIENTE ********
-- ********************************
create or alter procedure ObtenerClientesConFiltro
    @Filtro nvarchar(50)
as
begin
    select IdCliente, NombresCliente, ApellidosCliente, TelefonoCliente, CorreoCliente
    from Cliente.Clientes
	-- Recupera los clientes donde nombre o apellido coincidan con el texto que pasaremos en la variables @filtro
    where NombresCliente like '%' + @Filtro + '%' or ApellidosCliente like '%' + @Filtro + '%'
    order by NombresCliente;
end;
go

-- Prueba: Apellido: Rodriguez = Ro.
exec ObtenerClientesConFiltro 'Ro';
go