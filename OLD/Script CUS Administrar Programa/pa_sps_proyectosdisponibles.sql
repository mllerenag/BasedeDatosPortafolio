USE [DBINDRA]
GO

/****** Object:  StoredProcedure [dbo].[pa_sps_iniciativasdisponibles]    Script Date: 10/08/2018 07:53:20 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pa_sps_proyectosdisponibles]
@vi_nid_programa int,
@vi_no_nombre varchar(100)
as
begin
select 
i.nid_proyecto, 
i.no_nombre, 
i.no_codigo
from [dbo].[TBL_PROYECTO] i
left join [dbo].[TBL_PROGRAMA_PROYECTO] pin
on i.nid_proyecto = pin.nid_proyecto
where pin.nid_relacion is null 
		and (@vi_no_nombre = '' or i.no_nombre like '%'  + @vi_no_nombre  + '%')

end
GO


