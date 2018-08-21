USE [DBINDRA]
GO

/****** Object:  StoredProcedure [dbo].[pa_spd_portafolioiniciativa]    Script Date: 10/08/2018 10:32:23 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pa_spd_programaproyecto]
@vi_nid_relacion int
as
begin
delete [dbo].[TBL_PROGRAMA_PROYECTO] where nid_relacion = @vi_nid_relacion;
SELECT 1 as nid_retorno;
end
GO


