USE [zapateria]
GO
/****** Object:  UserDefinedFunction [dbo].[VentasPorCliente]    Script Date: 13/10/2024 18:11:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marcos Enrique Ramos Hernandez
-- Create date: 13/10/2024
-- Description:	función con valores de tabla que reciba el ID de un cliente y devuelva 
				--todas las ventas realizadas por ese cliente, incluyendo la fecha y el total de cada venta.
-- =============================================
CREATE FUNCTION [dbo].[VentasPorCliente]
(
	@Id_Cliente INT
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
        v.IdVenta as 'ID VENTA',
        v.Fecha_De_Venta as 'FECHA DE LA VENTA',
        SUM(dv.Cantidad * dv.PrecioUnitario) AS 'TOTAL'
    FROM
        Ventas.Ventas v
    INNER JOIN
        Ventas.Detalles_De_Ventas dv ON v.IdVenta = dv.IdVenta
    WHERE
        v.IdCliente = @Id_Cliente
    GROUP BY
        v.IdVenta, v.Fecha_De_Venta
)