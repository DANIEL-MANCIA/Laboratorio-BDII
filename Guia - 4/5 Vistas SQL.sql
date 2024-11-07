-- VISTA SQL 1: Mostrar info detallada de las facturas donde mostrara datos del cliente y del empleado que gestionó la factura
create view InformacionDetalladaDeFacturas as
    select 
           vfv.IdFacturaVenta, vfv.Fecha_Factura_Venta as FechaDeCompra, vfv.TotalPagarVenta as TotalAPagar, 
           concat(cc.NombresCliente, ' ', cc.ApellidosCliente) as NombreCliente, cc.TelefonoCliente, cc.CorreoCliente,
           concat(pe.NombresEmpleado, ' ', pe.ApellidosEmpleado) as NombreEmpleado, vfp.Tipo
    from Ventas.Factura_De_Ventas vfv
    inner join Cliente.Clientes cc on vfv.IdCliente = cc.IdCliente
    inner join Ventas.Formas_De_Pagos vfp on vfv.IdFormaDePago = vfp.IdFormaDePago
    inner join Persona.Empleados pe on vfv.IdEmpleado = pe.IdEmpleado;
go

select *from InformacionDetalladaDeFacturas;
go

-- VISTA SQL 2: Total de ventas por producto(zapato) y su categoríaa a la que pertenece el zapato
create view TotalDeVentasPorProducto as
	select 
		pz.Nombre, sum(vdv.cantidad) as ParesVendidos, sum(vdv.SubTotal * vdv.cantidad) as MontoTotalDeVentas, pc.Categoria
	from Ventas.Detalles_De_Ventas vdv
	inner join Productos.Zapatos pz on vdv.IdZapato = pz.IdZapato
	inner join Productos.Categoria pc on pz.IdCategoria = pc.IdCategoria
	group by pz.Nombre, pc.Categoria;
go

select *from TotalDeVentasPorProducto;
go

-- VISTA SQL 3: Ver clientes sin facturas, mostrando su direccion completa
create view InformacionDeClientesSinCompras as
	select 
		cc.IdCliente, concat(cc.NombresCliente, ' ', cc.ApellidosCliente) as NombreCliente, cc.TelefonoCliente, 
		dd.linea1 as direccion_linea1, dd.linea2 as direccion_linea2, ddis.Distrito, dm.municipio, ddepar.departamento, dd.codigopostal
	from Cliente.Clientes cc
	left join Ventas.Factura_De_Ventas vfv on cc.IdCliente = vfv.IdCliente
	left join Departamento.Direcciones dd on cc.IdDireccion = dd.IdDireccion 
	left join Departamento.Distritos ddis on dd.IdDistrito = ddis.IdDistrito 
	left join Departamento.Municipios dm on ddis.IdMunicipio = dm.IdMunicipio 
	left join Departamento.Departamentos ddepar on dm.IdDepartamento = ddepar.IdDepartamento
	where vfv.IdFacturaVenta is null;
go

select *from InformacionDeClientesSinCompras;
go

--Agregaremos 3 clientes mas por que hasta el momento a todos los clientes en la base han hecho compras.
insert into Cliente.Clientes (NombresCliente, ApellidosCliente, DuiCliente, FechaNacimientoCliente, TelefonoCliente, CorreoCliente, IdDireccion) values
    ('Oscar Luis', 'García Menjivar', '52389672-2', '1990-05-28', '+503 7075-9364', 'oscar@hotmail.com', '3'), 
    ('Jose María', 'Nuila López', '34574890-4', '1988-05-09', '+503 7235-5560', 'nuila34@gmail.com', '2'),
    ('Raul Carlos', 'Hernandez González', '23258089-2', '1994-11-11', '+503 7854-4278', 'gonzales@hotmail.com', '1');
go

select *from Cliente.Clientes;
select *from InformacionDeClientesSinCompras; -- Los clientes insertados apareceran ya que no han realizado ninguna compra.
go

-- VISTA SQL 4: Mostrar los Zapatos con sus proveedores y la categoría a la que pertenecen
create view ZapatosConTodaSuInformacion as
	select 
		pz.Nombre as Zapato, pz.Precio, vp.NombresProveedor as Proveedor, vp.CorreoProveedor, vp.TelefonoProveedor, pc.Categoria
	from Productos.Zapatos pz
	inner join Ventas.Proveedores vp on pz.IdProveedor = vp.IdProveedor
	inner join Productos.Categoria pc on pz.IdCategoria = pc.IdCategoria
go

select *from ZapatosConTodaSuInformacion;
go

-- VISTA SQL 5: Listar los empleados y sus cargos correspondientes
	create view ListadoDeEmpleadosConSusCargos as
	select  
		concat(pe.NombresEmpleado, ' ', pe.ApellidosEmpleado) as NombreDelEmpleado, pc.Cargo
	from Persona.Empleados pe
	left join Ventas.Factura_De_Ventas vfv on pe.IdEmpleado = vfv.IdEmpleado
	left join Persona.Cargos pc on pe.IdCargo = pc.IdCargo
	group by pe.NombresEmpleado, pe.ApellidosEmpleado, pc.Cargo;
go

select *from ListadoDeEmpleadosConSusCargos;
go