USE [DBINDRA]
GO

/****** Object:  StoredProcedure [dbo].[pa_sps_programaproyectos]    Script Date: 10/08/2018 04:09:26 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pa_sps_programaproyectos]
@vi_nid_programa int
as
begin

SELECT 
PP.nid_relacion, 
PP.nid_programa, 
P.no_codigo, 
P.no_nombre 
FROM [dbo].[TBL_PROGRAMA_PROYECTO] PP 
INNER JOIN [dbo].[TBL_PROYECTO] P 
ON PP.nid_proyecto = P.nid_proyecto 
WHERE PP.nid_programa = @vi_nid_programa 

end
GO


