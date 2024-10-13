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