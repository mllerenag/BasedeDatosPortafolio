USE [DBINDRA]
GO

/****** Object:  StoredProcedure [dbo].[pa_spu_portafolio]    Script Date: 10/08/2018 10:42:05 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pa_spu_programa]
@vi_nid_programa int,
@vi_no_nombre varchar(100),
@vi_nid_prioridad int,
@vi_nid_responsable int,
@vi_tx_descripcion varchar(8000),
@vi_dt_fecha_fin varchar(10),
@vi_dt_fecha_inicio varchar(10)
as 
begin
set dateformat dmy
declare @dt_fechaini datetime = @vi_dt_fecha_inicio + ' 00:00';
declare @dt_fechafin datetime = @vi_dt_fecha_fin + ' 23:59';

set @vi_nid_responsable = case when @vi_nid_responsable = 0 then null else @vi_nid_responsable end;

IF(@vi_nid_programa = 0)
BEGIN

INSERT INTO [dbo].[TBL_PROGRAMA]
           ([no_nombre]
           ,[tx_descripcion]
           ,[fe_crea]
           ,[fe_fin]
           ,[fe_inicio]
           ,[nid_responsable]
           ,[nid_prioridad]
           ,[fl_activo])
     VALUES
           (@vi_no_nombre,
		   @vi_tx_descripcion,
		   GETDATE(),
		   CONVERT(VARCHAR,@dt_fechafin,103),
		   CONVERT(VARCHAR,@dt_fechaini,103),
		   @vi_nid_responsable,
		   @vi_nid_prioridad,
		   1);

	set @vi_nid_programa = (select SCOPE_IDENTITY());
	UPDATE [dbo].[TBL_PROGRAMA] set no_codigo = 'PR' + REPLACE(STR(@vi_nid_programa, 4), SPACE(1), '0')  where nid_programa = @vi_nid_programa

	select nid_programa, no_codigo from [dbo].[TBL_PROGRAMA] WHERE nid_programa = @vi_nid_programa
END
ELSE
BEGIN 
	UPDATE [dbo].[TBL_PROGRAMA]
	   SET [no_nombre] = @vi_no_nombre
		  ,[nid_prioridad] = @vi_nid_prioridad
		  ,[nid_responsable] = @vi_nid_responsable
		  ,[tx_descripcion] = @vi_tx_descripcion
		  ,[fe_fin] = CONVERT(VARCHAR,@dt_fechafin,103)
		  ,[fe_inicio] =  CONVERT(VARCHAR,@dt_fechaini,103)
	 WHERE nid_programa = @vi_nid_programa

	 select nid_programa, no_codigo from [dbo].[TBL_PROGRAMA] WHERE nid_programa = @vi_nid_programa
END
end
GO


