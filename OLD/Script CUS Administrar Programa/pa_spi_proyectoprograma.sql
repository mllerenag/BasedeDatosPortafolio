USE [DBINDRA]
GO

/****** Object:  StoredProcedure [dbo].[pa_spi_iniciativaportafolio]    Script Date: 10/08/2018 10:28:46 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pa_spi_proyectoprograma]
@vi_nid_programa int,
@vi_nid_proyecto int
as
begin
INSERT INTO [dbo].[TBL_PROGRAMA_PROYECTO](nid_programa,nid_proyecto)
VALUES(@vi_nid_programa,@vi_nid_proyecto)

SELECT 1 as nid_retorno;
end

GO


