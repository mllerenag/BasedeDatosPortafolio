USE [DBINDRA]
GO
/****** Object:  StoredProcedure [dbo].[pa_sps_proyectoindividual]    Script Date: 10/08/2018 03:19:47 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pa_sps_proyectoindividual]
@vi_nid_proyecto int
as
begin

select 
nid_proyecto,
no_codigo,
isnull(p.nid_responsable,0) as nid_responsable,
CONVERT(VARCHAR,fe_crea,103) as fe_crea, 
pr.no_nombre as no_prioridad,
u.no_nombre + ' ' + u.no_apepat as no_responsable, 
case	when p.fe_inicio >= getdate() then 'No Iniciado' 
		when p.fe_inicio <= getdate() and p.fe_fin >=  getdate() then 'En Ejecución' 
		else 'Finalizado' end  as no_estado,
CONVERT(VARCHAR,p.fe_inicio,103) as no_fecha_inicio,
CONVERT(VARCHAR,p.fe_fin,103)  as no_fecha_fin,
p.no_nombre,
p.tx_descripcion,
p.nid_prioridad
from [TBL_PROYECTO] p
inner join MST_PRIORIDAD pr
on PR.nid_prioridad = P.nid_prioridad
inner join TBL_USUARIO u
on p.nid_responsable = u.nid_usuario
where  p.nid_proyecto = @vi_nid_proyecto
end