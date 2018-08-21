USE [DBINDRA]
GO

/****** Object:  StoredProcedure [dbo].[pa_sps_programas]    Script Date: 08/08/2018 10:56:33 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pa_sps_programas]
@vi_codigo varchar(100),
@vi_nombre varchar(100),
@vi_fechaini varchar(10),
@vi_fechafin varchar(10)
as
begin
set dateformat dmy
declare @dt_fechaini datetime = @vi_fechaini + ' 00:00';
declare @dt_fechafin datetime = @vi_fechafin + ' 23:59';

select 
nid_programa,
no_codigo,
p.no_nombre,
p.tx_descripcion,
CONVERT(VARCHAR,fe_crea,103) as fe_crea, 
CONVERT(VARCHAR,p.fe_inicio,103) as no_fecha_inicio,
CONVERT(VARCHAR,p.fe_fin,103)  as no_fecha_fin,
pr.no_nombre as no_prioridad,
u.no_nombre + ' ' + u.no_apepat as no_responsable, 
case	when p.fe_inicio >= getdate() then 'No Iniciado' 
		when p.fe_inicio <= getdate() and p.fe_fin >=  getdate() then 'En Ejecución' 
		else 'Finalizado' end  as co_estado
from [TBL_PROGRAMA] p
inner join MST_PRIORIDAD pr
on PR.nid_prioridad = P.nid_prioridad
inner join TBL_USUARIO u
on p.nid_responsable = u.nid_usuario
where (@vi_codigo = '' or p.no_codigo like '%' + @vi_codigo  +'%')
and (@vi_nombre = '' or p.no_nombre like '%' + @vi_nombre  +'%')
and (@vi_fechaini = '' or p.fe_inicio >= @dt_fechaini)
and (@vi_fechafin = '' or p.fe_fin <= @dt_fechafin)
and p.fl_activo = 1
end

GO


