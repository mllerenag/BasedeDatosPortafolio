USE [DBINDRA]
GO

/****** Object:  StoredProcedure [dbo].[pa_spd_portafolio]    Script Date: 10/08/2018 10:33:35 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pa_spd_programa]
@vi_nid_programa int,
@vi_nid_usuario int
as
begin 

	UPDATE [dbo].[TBL_PROGRAMA] SET fl_activo = 0--, nid_usuario_cambio = @vi_nid_usuario, fe_cambio = GETDATE()
	where nid_programa = @vi_nid_programa;
	select 1 as nid_retorno;

end
GO


