USE [master]
GO
/****** Object:  Database [DBINDRA]    Script Date: 31/07/2018 08:51:15 p.m. ******/
CREATE DATABASE [DBINDRA]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DBINDRA', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS2012\MSSQL\DATA\DBINDRA.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DBINDRA_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS2012\MSSQL\DATA\DBINDRA_log.ldf' , SIZE = 1600KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [DBINDRA] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DBINDRA].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DBINDRA] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DBINDRA] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DBINDRA] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DBINDRA] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DBINDRA] SET ARITHABORT OFF 
GO
ALTER DATABASE [DBINDRA] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DBINDRA] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [DBINDRA] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DBINDRA] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DBINDRA] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DBINDRA] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DBINDRA] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DBINDRA] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DBINDRA] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DBINDRA] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DBINDRA] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DBINDRA] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DBINDRA] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DBINDRA] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DBINDRA] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DBINDRA] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DBINDRA] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DBINDRA] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DBINDRA] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DBINDRA] SET  MULTI_USER 
GO
ALTER DATABASE [DBINDRA] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DBINDRA] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DBINDRA] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DBINDRA] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'DBINDRA', N'ON'
GO
USE [DBINDRA]
GO
/****** Object:  StoredProcedure [dbo].[pa_spd_portafolio]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_spd_portafolio]
@vi_nid_portafolio int,
@vi_nid_usuario int
as
begin 
declare @contador int;
select @contador = COUNT(c.nid_componente)
  from TBL_COMPONENTE c
left join TBL_PROGRAMA prg
on c.nid_programa = prg.nid_programa
left join TBL_PROYECTO pry
on c.nid_proyecto = pry.nid_proyecto
where c.fl_activo = 1 
and ((pry.fe_inicio <= getdate() and pry.fe_fin >=  getdate() and pry.nid_proyecto is not null)
   or (prg.fe_inicio <= getdate() and prg.fe_fin >=  getdate() and prg.nid_programa is not null))
and c.nid_portafolio = @vi_nid_portafolio;
IF(@contador = 0)
BEGIN
	UPDATE TBL_PORTAFOLIO SET fl_activo = 0, nid_usuario_cambio = @vi_nid_usuario, fe_cambio = GETDATE()
	where nid_portafolio = @vi_nid_portafolio;
	select 1 as nid_retorno;
END
ELSE
BEGIN
	SELECT 0 AS nid_retorno;
END
end
GO
/****** Object:  StoredProcedure [dbo].[pa_spd_portafoliocomponente]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_spd_portafoliocomponente]
@vi_nid_componente int
as
begin
delete TBL_COMPONENTE where nid_componente = @vi_nid_componente;
SELECT 1 as nid_retorno;
end
GO
/****** Object:  StoredProcedure [dbo].[pa_spd_portafolioiniciativa]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_spd_portafolioiniciativa]
@vi_nid_relacion int
as
begin
delete TBL_PORTAFOLIO_INICIATIVA where nid_relacion = @vi_nid_relacion;
SELECT 1 as nid_retorno;
end
GO
/****** Object:  StoredProcedure [dbo].[pa_spi_componenteportafolio]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_spi_componenteportafolio]
@vi_nid_portafolio int,
@vi_nid_programa int = null,
@vi_nid_proyecto int = null
as
begin
INSERT INTO TBL_COMPONENTE(nid_portafolio,nid_programa,nid_proyecto)
VALUES(@vi_nid_portafolio,@vi_nid_programa,@vi_nid_proyecto)

SELECT 1 as nid_retorno;
end

GO
/****** Object:  StoredProcedure [dbo].[pa_spi_iniciativaportafolio]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_spi_iniciativaportafolio]
@vi_nid_portafolio int,
@vi_nid_iniciativa int
as
begin
INSERT INTO TBL_PORTAFOLIO_INICIATIVA(nid_portafolio,nid_iniciativa)
VALUES(@vi_nid_portafolio,@vi_nid_iniciativa)

SELECT 1 as nid_retorno;
end

GO
/****** Object:  StoredProcedure [dbo].[pa_spi_registrarBalanceo]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pa_spi_registrarBalanceo]
AS
BEGIN

	INSERT INTO TBL_BALANCEO(co_estado) values('001');
	SELECT CAST(SCOPE_IDENTITY() AS INT) as nid_retorno;
END


GO
/****** Object:  StoredProcedure [dbo].[pa_spi_registrarBalanceoDetalle]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_spi_registrarBalanceoDetalle]
@vi_nid_balanceo int,
@vi_nid_solicitud int,
@vi_nu_asignado int
AS
BEGIN
	INSERT INTO TBL_DETALLE_BALANCEO(nid_solicitud,nid_balanceo,no_balanceo)
	 values(@vi_nid_solicitud,@vi_nid_balanceo,@vi_nu_asignado)
	 SELECT 1;
END
GO
/****** Object:  StoredProcedure [dbo].[pa_sps_categoria]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_sps_categoria]
as
begin
select nid_categoria, no_nombre as no_nombre from MST_CATEGORIA
end
GO
/****** Object:  StoredProcedure [dbo].[pa_sps_componentesdisponibles]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_sps_componentesdisponibles]
@vi_nid_portafolio int,
@vi_co_tipo varchar(3),
@vi_no_nombre varchar(3)
as
begin
 IF(@vi_co_tipo = 'PRY')
	BEGIN
		SELECT
		pry.nid_proyecto as nid_codigo,
		 pry.no_codigo as no_codigo,
		pry.no_nombre as no_componente,
		'Proyecto' as no_tipo,
		CONVERT(VARCHAR,pry.fe_inicio,103) as no_fecha_inicio,
		CONVERT(VARCHAR,pry.fe_fin,103)  as no_fecha_fin,
		isnull(prio.no_nombre,'') as no_prioridad,
		isnull(usr.no_nombre + ' ' + usr.no_apepat,'') as no_responsable,
		(case when pry.fe_inicio >= getdate() then 'No Iniciado' 
				when pry.fe_inicio <= getdate() and pry.fe_fin >=  getdate() then 'En Ejecución' 
				else 'Finalizado' end) as co_estado
		  from  TBL_PROYECTO pry
		left join TBL_COMPONENTE c
		on c.nid_proyecto = pry.nid_proyecto and c.fl_activo = 1
		left join TBL_PROGRAMA_PROYECTO prpy
		on pry.nid_proyecto = prpy.nid_proyecto
		left join MST_PRIORIDAD prio
		on isnull(pry.nid_prioridad,0) = prio.nid_prioridad
		left join TBL_USUARIO usr
		on isnull(pry.nid_responsable,0) = usr.nid_usuario
		where prpy.nid_relacion is null and 
		c.nid_componente is null and (@vi_no_nombre = '' or pry.no_nombre like '%' + @vi_no_nombre + '%')
	END
ELSE
	BEGIN
	SELECT
		prg.nid_programa as nid_codigo,
		 prg.no_codigo as no_codigo,
		prg.no_nombre as no_componente,
		'Proyecto' as no_tipo,
		CONVERT(VARCHAR,prg.fe_inicio,103) as no_fecha_inicio,
		CONVERT(VARCHAR,prg.fe_fin,103)  as no_fecha_fin,
		isnull(prio.no_nombre,'') as no_prioridad,
		isnull(usr.no_nombre + ' ' + usr.no_apepat,'') as no_responsable,
		(case when prg.fe_inicio >= getdate() then 'No Iniciado' 
				when prg.fe_inicio <= getdate() and prg.fe_fin >=  getdate() then 'En Ejecución' 
				else 'Finalizado' end) as co_estado
		  from  TBL_PROGRAMA prg
		left join TBL_COMPONENTE c
		on c.nid_programa = prg.nid_programa and c.fl_activo = 1
		left join MST_PRIORIDAD prio
		on isnull(prg.nid_prioridad,0) = prio.nid_prioridad
		left join TBL_USUARIO usr
		on isnull(prg.nid_responsable,0) = usr.nid_usuario
		where c.nid_componente is null and (@vi_no_nombre = '' or prg.no_nombre like '%' + @vi_no_nombre + '%')
	END
end
GO
/****** Object:  StoredProcedure [dbo].[pa_sps_iniciativasdisponibles]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_sps_iniciativasdisponibles]
@vi_nid_portafolio int,
@vi_no_nombre varchar(100)
as
begin
select i.nid_iniciativa, i.no_nombre, i.no_codigo
from MST_INICIATIVA i
left join TBL_PORTAFOLIO_INICIATIVA pin
on i.nid_iniciativa = pin.nid_iniciativa
where pin.nid_relacion is null 
		and (@vi_no_nombre = '' or i.no_nombre like '%'  + @vi_no_nombre  + '%')

end
GO
/****** Object:  StoredProcedure [dbo].[pa_sps_loginusuario]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_sps_loginusuario]
@vi_usrlogin varchar(100),
@vi_pwdlogin varchar(100)
as
begin
declare @nombre varchar(100);
declare @apepat varchar(100);
declare @nid_perfil int;
declare @usr int;
declare @count int;

select  @usr = nid_usuario,@nombre = no_nombre, @apepat = no_apepat, @nid_perfil = nid_perfil
from TBL_USUARIO 
where no_password = @vi_pwdlogin and no_usrlogin = @vi_usrlogin and fl_activo = 1

IF(@usr is not null)
	BEGIN
		select  @usr as 'resultado', @nombre + ' ' + @apepat as 'mensaje', @nid_perfil as dato;
	END
ELSE
	BEGIN 
		select  0 as 'resultado', 'No se pudo logear al Sistema' as 'mensaje', 0 as dato;
	END
end
GO
/****** Object:  StoredProcedure [dbo].[pa_sps_portafoliocomponentes]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_sps_portafoliocomponentes]
@vi_nid_portafolio int
as
begin
select 
c.nid_componente,
case when c.nid_proyecto is not null then pry.no_codigo else prg.no_codigo end as no_codigo,
case when c.nid_proyecto is not null then pry.no_nombre else prg.no_nombre end as no_componente,
case when c.nid_proyecto is not null then 'Proyecto' else 'Programa' end as no_tipo,
case when c.nid_proyecto is not null then CONVERT(VARCHAR,pry.fe_inicio,103) else CONVERT(VARCHAR,prg.fe_inicio,103) end as no_fecha_inicio,
case when c.nid_proyecto is not null then CONVERT(VARCHAR,pry.fe_fin,103) else CONVERT(VARCHAR,prg.fe_fin,103) end as no_fecha_fin,
isnull(prio.no_nombre,'') as no_prioridad,
isnull(usr.no_nombre + ' ' + usr.no_apepat,'') as no_responsable,
case when c.nid_proyecto is not null then 
		(case when pry.fe_inicio >= getdate() then 'No Iniciado' 
		     when pry.fe_inicio <= getdate() and pry.fe_fin >=  getdate() then 'En Ejecución' 
			 else 'Finalizado' end)
		else
			(case when prg.fe_inicio >= getdate() then 'No Iniciado' 
		     when prg.fe_inicio <= getdate() and prg.fe_fin >=  getdate() then 'En Ejecución' 
			 else 'Finalizado' end)
		end as co_estado
  from TBL_COMPONENTE c
left join TBL_PROGRAMA prg
on c.nid_programa = prg.nid_programa
left join TBL_PROYECTO pry
on c.nid_proyecto = pry.nid_proyecto
left join MST_PRIORIDAD prio
on isnull(pry.nid_prioridad,prg.nid_prioridad) = prio.nid_prioridad
left join TBL_USUARIO usr
on isnull(pry.nid_responsable,prg.nid_responsable) = usr.nid_usuario
where c.nid_portafolio = @vi_nid_portafolio and c.fl_activo = 1
end
GO
/****** Object:  StoredProcedure [dbo].[pa_sps_portafolioindividual]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pa_sps_portafolioindividual]
@vi_nid_portafolio int
as
begin
select nid_portafolio,no_codigo,isnull(p.nid_responsable,0) as nid_responsable,
isnull(p.nid_responsable2,0) as nid_responsable2,
p.no_nombre,CONVERT(VARCHAR,fe_crea,103) as fe_crea, C.no_nombre as no_categoria,pr.no_nombre as no_prioridad,
u.no_nombre + ' ' + u.no_apepat as no_responsable,	case when co_estado = '001' then 'No Iniciado' 
													when co_estado = '002' then 'En Ejecución'
													when co_estado = '003' then 'Finalizado'
													else 'Cerrado' end as no_estado,
													tx_descripcion,
isnull(u2.no_nombre + ' ' + u2.no_apepat,'') as no_responsable2,p.nid_prioridad, p.nid_categoria
from TBL_PORTAFOLIO p
inner join MST_CATEGORIA C
on p.nid_categoria = C.nid_categoria
inner join MST_PRIORIDAD pr
on PR.nid_prioridad = P.nid_categoria
inner join TBL_USUARIO u
on p.nid_responsable = u.nid_usuario
left join TBL_USUARIO u2
on p.nid_responsable2 = u2.nid_usuario
where @vi_nid_portafolio = p.nid_portafolio
end
GO
/****** Object:  StoredProcedure [dbo].[pa_sps_portafolioiniciativas]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_sps_portafolioiniciativas]
@vi_nid_portafolio int
as
begin
select pin.nid_relacion, pin.nid_iniciativa, i.no_codigo, i.no_nombre from TBL_PORTAFOLIO_INICIATIVA pin
inner join MST_INICIATIVA i
on pin.nid_iniciativa = i.nid_iniciativa
where pin.nid_portafolio = @vi_nid_portafolio
end
GO
/****** Object:  StoredProcedure [dbo].[pa_sps_portafoliorecursos]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_sps_portafoliorecursos]
@vi_nid_portafolio int
as
begin
select r.nid_recurso, r.no_nombre,pr.nu_recursototal,pr.nu_recursoconsumido, 
pr.nu_recursodisponible - SUM(isnull(db.no_balanceo,0)) as nu_recursodisponible,
SUM(isnull(db.no_balanceo,0)) as nu_separado
from TBL_PORTAFOLIO_RECURSO pr
inner join MST_RECURSO r
on pr.nid_recurso = r.nid_recurso
left join TBL_COMPONENTE c
on pr.nid_portafolio = c.nid_portafolio and c.fl_activo = 1
left join TBL_SOLICITUD s
on s.nid_recurso = r.nid_recurso and c.nid_componente = s.nid_componente
left join TBL_DETALLE_BALANCEO db
on s.nid_solicitud = db.nid_solicitud
left join TBL_BALANCEO b
on b.nid_balanceo = db.nid_balanceo and co_estado = '001'
where @vi_nid_portafolio = pr.nid_portafolio
GROUP BY r.nid_recurso, r.no_nombre,pr.nu_recursototal,pr.nu_recursoconsumido, pr.nu_recursodisponible 
end

GO
/****** Object:  StoredProcedure [dbo].[pa_sps_portafolios]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_sps_portafolios]
@vi_codigo varchar(100),
@vi_nombre varchar(100),
@vi_categoria varchar(3),
@vi_fechaini varchar(10),
@vi_fechafin varchar(10)
as
begin
set dateformat dmy
declare @dt_fechaini datetime = @vi_fechaini + ' 00:00';
declare @dt_fechafin datetime = @vi_fechafin + ' 23:59';
select nid_portafolio,no_codigo,p.no_nombre,CONVERT(VARCHAR,fe_crea,103) as fe_crea, C.no_nombre as no_categoria,pr.no_nombre as no_prioridad,
u.no_nombre + ' ' + u.no_apepat as no_responsable, co_estado
from TBL_PORTAFOLIO p
inner join MST_CATEGORIA C
on p.nid_categoria = C.nid_categoria
inner join MST_PRIORIDAD pr
on PR.nid_prioridad = P.nid_categoria
inner join TBL_USUARIO u
on p.nid_responsable = u.nid_usuario
where (@vi_codigo = '' or p.no_codigo like '%' + @vi_codigo  +'%')
and (@vi_nombre = '' or p.no_nombre like '%' + @vi_nombre  +'%')
and (@vi_fechaini = '' or p.fe_crea >= @dt_fechaini)
and (@vi_fechafin = '' or p.fe_crea <= @dt_fechafin)
and (@vi_categoria = '' or p.nid_categoria = @vi_categoria)
and p.fl_activo = 1
and p.co_estado in ('001','002')
end

GO
/****** Object:  StoredProcedure [dbo].[pa_sps_portafoliosolicitudes]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_sps_portafoliosolicitudes]
@vi_nid_portafolio int
as
begin

-- exec [dbo].[pa_sps_portafoliosolicitudes]  2

DECLARE @T_RECOMENDACION TABLE(
nid_solicitud int,
co_solicitud varchar(8),
no_recurso varchar(50),
nid_recurso int,
fe_solicitud varchar(10),
no_componente varchar(50),
no_prioridad varchar(10) null,
nu_prioridad tinyint,
no_tipo_recurso varchar(50),
nu_solicitado int,
nu_recursodisponible int,
nu_recursototal int,
nu_recursorecomendado int
)

DECLARE @T_RECURSO TABLE(
nid_recurso int,
no_recurso varchar(50),
no_tipo_recurso varchar(50),
nu_solicitadototal int,
nu_recursodisponible int
)

DECLARE @T_SOLICITUD_IDS TABLE(
	nid_solicitud int,
	nu_prioridad int, 
	nu_solicitado int
)

/* REGLAS DE CALCULO DE CANTIDAD DE RECURSOS A OTORGAR (BALANCEO) */

/* SI LOS RECURSOS SON SUFICIENTES, SE DEBE OTORGAR A LOS COMPONENETES LO QUE SE SOLICITA */

/* SI LOS RECURSOS NO SON SUFICIENTES, SE DEBE ENTREGAR LOS RECURSOS DE ACUERDO A LA PRIORIDAD. 
	Si se tiene la misma prioridad, se debe cumplir con la solicitud minima a maxima.
 */

INSERT INTO @T_RECOMENDACION
select 
	s.nid_solicitud,
	co_solicitud,
	r.no_nombre as no_recurso,
	r.nid_recurso, 
	CONVERT(VARCHAR,fe_solicitud,103) as fe_solicitud, 
	case
		when c.nid_proyecto is not null then py.no_nombre 
		else pr.no_nombre 
	end as no_componente,
	prio.no_nombre as no_prioridad,
	case
		when c.nid_proyecto is not null then py.nid_prioridad
		else pr.nid_prioridad 
	end as nu_prioridad,
	case 
		when r.co_tipo = '001' then 'Material' 
		else 'Personal' 
	end as no_tipo_recurso,
	nu_solicitado,
	isnull(nu_recursodisponible,0) as nu_recursodisponible,
	isnull(cr.nu_recursototal,0) as nu_recursototal,
	0 AS nu_recursorecomendado
from TBL_SOLICITUD s
inner join TBL_COMPONENTE c
	on s.nid_componente = c.nid_componente
left join TBL_PROGRAMA pr
	on c.nid_programa = pr.nid_programa
left join TBL_PROYECTO py
	on c.nid_proyecto = py.nid_proyecto
left join MST_PRIORIDAD prio
	on isnull(pr.nid_prioridad,py.nid_prioridad) = prio.nid_prioridad
left join TBL_COMPONENTE_RECURSO cr
	on c.nid_componente = cr.nid_componente and s.nid_recurso = cr.nid_recurso
left join MST_RECURSO r
	on r.nid_recurso = s.nid_recurso 
inner join TBL_PORTAFOLIO_RECURSO por
	on por.nid_recurso = s.nid_recurso and por.nid_portafolio = @vi_nid_portafolio
left join TBL_DETALLE_BALANCEO db
	on db.nid_solicitud = s.nid_solicitud
left join TBL_BALANCEO b
	on b.nid_balanceo = db.nid_balanceo
where c.nid_portafolio = @vi_nid_portafolio
	and (db.nid_detalle is null)
order by s.nid_solicitud,co_solicitud

/* Llenamos la tabla de recursos solicitados */
INSERT INTO @T_RECURSO(nid_recurso, no_recurso, no_tipo_recurso, nu_recursodisponible , nu_solicitadototal)
select nid_recurso, no_recurso, no_tipo_recurso , nu_recursodisponible, sum(nu_solicitado) from @T_RECOMENDACION
group by nid_recurso, no_recurso, no_tipo_recurso, nu_recursodisponible


--SELECT * FROM @T_RECOMENDACION
--order by nid_recurso, nu_prioridad, nu_solicitado

--select * from @T_RECURSO

declare @recorrer int = 1,
	@id_recurso int,
	@total_recursos int,
	-- Total acumulado por recurso
	@r_total_dispo int = 0,
	@r_total_soli int = 0,
	@id_solicitud int

declare @disponible int


-- Llenar la cantidad de tipo de recursos
select @total_recursos = count(*) from @T_RECURSO

WHILE @total_recursos > 0
BEGIN
	select TOP 1 @id_recurso = nid_recurso from @T_RECURSO
	-- Calcular recomendacion

	select  
		@r_total_soli = nu_solicitadototal, 
		@r_total_dispo = nu_recursodisponible
		from @T_RECURSO where nid_recurso = @id_recurso
	
	IF @r_total_soli <= @r_total_dispo
	BEGIN
		-- Actualizar recomendacion
		UPDATE @T_RECOMENDACION
		SET nu_recursorecomendado = nu_solicitado
		where nid_recurso = @id_recurso
	END
	ELSE
	BEGIN
		--select 'INSUFICIENTE'
		-- 
		set @disponible = @r_total_dispo 
		-- Insertamos los codigo del recurso en cuestion y lo ordenamos por prioridad y cantidad solicitada
		insert into @T_SOLICITUD_IDS(nid_solicitud, nu_prioridad, nu_solicitado)
		select 
		nid_solicitud, nu_prioridad, nu_solicitado
		from @T_RECOMENDACION
		where nid_recurso = @id_recurso
		order by nu_prioridad, nu_solicitado asc -- primero los que solicitan una cantidad menor
		
		WHILE @r_total_dispo > 0
		BEGIN
			-- Recorremos cada solicitud del tipo de recurso
			select top 1 @id_solicitud = nid_solicitud, @r_total_soli = nu_solicitado from @T_SOLICITUD_IDS
			IF @r_total_dispo > 0
			BEGIN
				IF @r_total_soli <= @r_total_dispo
				BEGIN
					UPDATE @T_RECOMENDACION
					SET nu_recursorecomendado = nu_solicitado
					where nid_solicitud = @id_solicitud
					
					DELETE FROM @T_SOLICITUD_IDS WHERE nid_solicitud = @id_solicitud
					
					set @r_total_dispo = @r_total_dispo - @r_total_soli
					
					--select @r_total_dispo, * from @T_RECOMENDACION where nid_solicitud = @id_solicitud
				END
				ELSE
				BEGIN
					UPDATE @T_RECOMENDACION
						SET nu_recursorecomendado = @r_total_dispo -- CANTIDAD RESTANTE
						where nid_solicitud = @id_solicitud
						
						DELETE FROM @T_SOLICITUD_IDS WHERE nid_solicitud = @id_solicitud
						
						set @r_total_dispo = 0
					--select @r_total_dispo, * from @T_RECOMENDACION where nid_solicitud = @id_solicitud
				END
			END
		END
		
	END

	
	-- Eliminar recuros de tabla temporal
	delete FROM @T_RECURSO where nid_recurso = @id_recurso
	select @total_recursos = count(*) from @T_RECURSO
	
END

--WHILE @recorrer  = 1
--BEGIN
--END



select * FROM @T_RECOMENDACION ORDER BY nid_recurso

-- exec [dbo].[pa_sps_portafoliosolicitudes]  6

end


GO
/****** Object:  StoredProcedure [dbo].[pa_sps_posiblesresponsables]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_sps_posiblesresponsables]
@vi_no_nombre varchar(100)
as
begin 
SELECT no_usrlogin, nid_usuario, no_nombre + ' ' + no_apepat + ' ' + no_apemat as no_nombre
from TBL_USUARIO usr
where usr.fl_activo = 1
and (@vi_no_nombre = '' or no_nombre + ' ' + no_apepat + ' ' + no_apemat like '%' + @vi_no_nombre  + '%')
end

GO
/****** Object:  StoredProcedure [dbo].[pa_sps_prioridad]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_sps_prioridad]
as
begin
select nid_prioridad, no_nombre as no_nombre from MST_PRIORIDAD
end
GO
/****** Object:  StoredProcedure [dbo].[pa_spu_portafolio]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_spu_portafolio]
@vi_nid_portafolio int,
@vi_no_nombre varchar(100),
@vi_nid_categoria int,
@vi_nid_prioridad int,
@vi_nid_responsable int,
@vi_nid_responsable2 int,
@vi_tx_descripcion varchar(8000),
@vi_nid_usuario int
as 
begin
set @vi_nid_responsable = case when @vi_nid_responsable = 0 then null else @vi_nid_responsable end;
set @vi_nid_responsable2 = case when @vi_nid_responsable2 = 0 then null else @vi_nid_responsable2 end;
IF(@vi_nid_portafolio = 0)
BEGIN
INSERT INTO [dbo].[TBL_PORTAFOLIO]
           ([no_nombre],[nid_categoria],[nid_prioridad],[nid_responsable]
           ,[nid_responsable2],[tx_descripcion],[fl_activo],[fe_crea],[nid_usuario_crea]
           ,[co_estado])
     VALUES
           (@vi_no_nombre,@vi_nid_categoria,@vi_nid_prioridad,@vi_nid_responsable,
		   @vi_nid_responsable2,@vi_tx_descripcion,1,GETDATE(),@vi_nid_usuario,
		   '001');
	set @vi_nid_portafolio = (select SCOPE_IDENTITY());
	UPDATE TBL_PORTAFOLIO set no_codigo = 'P' + REPLACE(STR(@vi_nid_portafolio, 5), SPACE(1), '0')  where nid_portafolio = @vi_nid_portafolio

	select nid_portafolio, no_codigo from TBL_PORTAFOLIO WHERE nid_portafolio = @vi_nid_portafolio
END
ELSE
BEGIN 
	UPDATE [dbo].[TBL_PORTAFOLIO]
	   SET [no_nombre] = @vi_no_nombre
		  ,[nid_categoria] = @vi_nid_categoria
		  ,[nid_prioridad] = @vi_nid_prioridad
		  ,[nid_responsable] = @vi_nid_responsable
		  ,[nid_responsable2] = @vi_nid_responsable2
		  ,[tx_descripcion] = @vi_tx_descripcion
		  ,[fe_cambio] = getdate()
		  ,[nid_usuario_cambio] = @vi_nid_usuario
	 WHERE nid_portafolio = @vi_nid_portafolio

	 select nid_portafolio, no_codigo from TBL_PORTAFOLIO WHERE nid_portafolio = @vi_nid_portafolio
END
end
GO
/****** Object:  StoredProcedure [dbo].[pa_spu_resetdata]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pa_spu_resetdata]
as
begin
	delete from TBL_DETALLE_BALANCEO;
	delete from TBL_BALANCEO;
	delete from TBL_PORTAFOLIO_INICIATIVA;
	delete from TBL_COMPONENTE where nid_componente > 10
	delete from TBL_PORTAFOLIO where nid_portafolio > 10
	update TBL_COMPONENTE set fl_activo = 1;
	update TBL_PORTAFOLIO set fl_activo = 1;
end


GO
/****** Object:  Table [dbo].[MST_CATEGORIA]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MST_CATEGORIA](
	[nid_categoria] [int] IDENTITY(1,1) NOT NULL,
	[no_nombre] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_categoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MST_INICIATIVA]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MST_INICIATIVA](
	[nid_iniciativa] [int] IDENTITY(1,1) NOT NULL,
	[no_nombre] [varchar](100) NULL,
	[tx_descripcion] [varchar](8000) NULL,
	[no_codigo] [varchar](6) NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_iniciativa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MST_PRIORIDAD]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MST_PRIORIDAD](
	[nid_prioridad] [int] IDENTITY(1,1) NOT NULL,
	[no_nombre] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_prioridad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MST_RECURSO]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MST_RECURSO](
	[nid_recurso] [int] IDENTITY(1,1) NOT NULL,
	[co_tipo] [varchar](3) NULL,
	[no_nombre] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_recurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_BALANCEO]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_BALANCEO](
	[nid_balanceo] [int] IDENTITY(1,1) NOT NULL,
	[co_estado] [varchar](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_balanceo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_COMPONENTE]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_COMPONENTE](
	[nid_componente] [int] IDENTITY(1,1) NOT NULL,
	[nid_portafolio] [int] NULL,
	[nid_programa] [int] NULL,
	[nid_proyecto] [int] NULL,
	[fl_activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_componente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TBL_COMPONENTE_RECURSO]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_COMPONENTE_RECURSO](
	[nid_relacion] [int] IDENTITY(1,1) NOT NULL,
	[nid_componente] [int] NULL,
	[nid_recurso] [int] NULL,
	[nu_recursototal] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_relacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TBL_DETALLE_BALANCEO]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_DETALLE_BALANCEO](
	[nid_detalle] [int] IDENTITY(1,1) NOT NULL,
	[nid_solicitud] [int] NOT NULL,
	[nid_balanceo] [int] NOT NULL,
	[no_balanceo] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_detalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TBL_PORTAFOLIO]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_PORTAFOLIO](
	[nid_portafolio] [int] IDENTITY(1,1) NOT NULL,
	[no_codigo] [varchar](6) NULL,
	[no_nombre] [varchar](100) NULL,
	[nid_categoria] [int] NULL,
	[nid_prioridad] [int] NULL,
	[nid_responsable] [int] NULL,
	[nid_responsable2] [int] NULL,
	[tx_descripcion] [varchar](8000) NULL,
	[fl_activo] [bit] NOT NULL,
	[no_usuario_red] [varchar](100) NULL,
	[no_estacion_red] [varchar](100) NULL,
	[fe_crea] [datetime] NULL,
	[nid_usuario_crea] [int] NULL,
	[fe_cambio] [datetime] NULL,
	[nid_usuario_cambio] [int] NULL,
	[co_estado] [varchar](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_portafolio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_PORTAFOLIO_INICIATIVA]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_PORTAFOLIO_INICIATIVA](
	[nid_relacion] [int] IDENTITY(1,1) NOT NULL,
	[nid_portafolio] [int] NULL,
	[nid_iniciativa] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_relacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TBL_PORTAFOLIO_RECURSO]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_PORTAFOLIO_RECURSO](
	[nid_relacion] [int] IDENTITY(1,1) NOT NULL,
	[nid_portafolio] [int] NULL,
	[nid_recurso] [int] NULL,
	[nu_recursototal] [int] NOT NULL,
	[nu_recursodisponible] [int] NOT NULL,
	[nu_recursoconsumido] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_relacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TBL_PROGRAMA]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_PROGRAMA](
	[nid_programa] [int] IDENTITY(1,1) NOT NULL,
	[no_codigo] [varchar](6) NULL,
	[no_nombre] [varchar](100) NULL,
	[tx_descripcion] [varchar](8000) NULL,
	[fe_crea] [datetime] NOT NULL,
	[fe_fin] [datetime] NOT NULL,
	[fe_inicio] [datetime] NULL,
	[nid_responsable] [int] NULL,
	[nid_prioridad] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_programa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_PROGRAMA_PROYECTO]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_PROGRAMA_PROYECTO](
	[nid_relacion] [int] IDENTITY(1,1) NOT NULL,
	[nid_programa] [int] NULL,
	[nid_proyecto] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_relacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TBL_PROYECTO]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_PROYECTO](
	[nid_proyecto] [int] IDENTITY(1,1) NOT NULL,
	[no_codigo] [varchar](6) NULL,
	[no_nombre] [varchar](100) NULL,
	[tx_descripcion] [varchar](8000) NULL,
	[fe_crea] [datetime] NOT NULL,
	[fe_fin] [datetime] NOT NULL,
	[fe_inicio] [datetime] NULL,
	[nid_responsable] [int] NULL,
	[nid_prioridad] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_proyecto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_SOLICITUD]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_SOLICITUD](
	[nid_solicitud] [int] IDENTITY(1,1) NOT NULL,
	[no_nombre] [varchar](100) NULL,
	[nid_componente] [int] NOT NULL,
	[nid_recurso] [int] NULL,
	[nu_solicitado] [int] NOT NULL,
	[fe_solicitud] [datetime] NULL,
	[co_solicitud] [varchar](6) NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_solicitud] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_USUARIO]    Script Date: 31/07/2018 08:51:15 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_USUARIO](
	[nid_usuario] [int] IDENTITY(1,1) NOT NULL,
	[nid_perfil] [int] NOT NULL,
	[no_nombre] [varchar](100) NOT NULL,
	[no_apepat] [varchar](100) NOT NULL,
	[no_apemat] [varchar](100) NOT NULL,
	[no_imagen] [varchar](100) NOT NULL,
	[no_usrlogin] [varchar](30) NOT NULL,
	[no_password] [varchar](30) NOT NULL,
	[no_correo] [varchar](100) NOT NULL,
	[fl_activo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[nid_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[MST_CATEGORIA] ON 

INSERT [dbo].[MST_CATEGORIA] ([nid_categoria], [no_nombre]) VALUES (1, N'Interno')
INSERT [dbo].[MST_CATEGORIA] ([nid_categoria], [no_nombre]) VALUES (2, N'Externo')
SET IDENTITY_INSERT [dbo].[MST_CATEGORIA] OFF
SET IDENTITY_INSERT [dbo].[MST_INICIATIVA] ON 

INSERT [dbo].[MST_INICIATIVA] ([nid_iniciativa], [no_nombre], [tx_descripcion], [no_codigo]) VALUES (1, N'Scrum Moviles', NULL, N'INI001')
INSERT [dbo].[MST_INICIATIVA] ([nid_iniciativa], [no_nombre], [tx_descripcion], [no_codigo]) VALUES (2, N'Reuniones Diarias', NULL, N'INI002')
INSERT [dbo].[MST_INICIATIVA] ([nid_iniciativa], [no_nombre], [tx_descripcion], [no_codigo]) VALUES (3, N'Nuevas Tecnologias', NULL, N'INI003')
INSERT [dbo].[MST_INICIATIVA] ([nid_iniciativa], [no_nombre], [tx_descripcion], [no_codigo]) VALUES (4, N'Trabajo in House', NULL, N'INI004')
INSERT [dbo].[MST_INICIATIVA] ([nid_iniciativa], [no_nombre], [tx_descripcion], [no_codigo]) VALUES (5, N'Mantenimiento Equipos', NULL, N'INI005')
INSERT [dbo].[MST_INICIATIVA] ([nid_iniciativa], [no_nombre], [tx_descripcion], [no_codigo]) VALUES (6, N'Medio Dia Laboral', NULL, N'INI006')
INSERT [dbo].[MST_INICIATIVA] ([nid_iniciativa], [no_nombre], [tx_descripcion], [no_codigo]) VALUES (7, N'Capacitaciones de Excel', NULL, N'INI007')
INSERT [dbo].[MST_INICIATIVA] ([nid_iniciativa], [no_nombre], [tx_descripcion], [no_codigo]) VALUES (8, N'Sprints Modulares', NULL, N'INI008')
INSERT [dbo].[MST_INICIATIVA] ([nid_iniciativa], [no_nombre], [tx_descripcion], [no_codigo]) VALUES (9, N'Seguimiento Diario', NULL, N'INI009')
SET IDENTITY_INSERT [dbo].[MST_INICIATIVA] OFF
SET IDENTITY_INSERT [dbo].[MST_PRIORIDAD] ON 

INSERT [dbo].[MST_PRIORIDAD] ([nid_prioridad], [no_nombre]) VALUES (1, N'Baja')
INSERT [dbo].[MST_PRIORIDAD] ([nid_prioridad], [no_nombre]) VALUES (2, N'Media')
INSERT [dbo].[MST_PRIORIDAD] ([nid_prioridad], [no_nombre]) VALUES (3, N'Alta')
SET IDENTITY_INSERT [dbo].[MST_PRIORIDAD] OFF
SET IDENTITY_INSERT [dbo].[MST_RECURSO] ON 

INSERT [dbo].[MST_RECURSO] ([nid_recurso], [co_tipo], [no_nombre]) VALUES (1, N'001', N'Laptop')
INSERT [dbo].[MST_RECURSO] ([nid_recurso], [co_tipo], [no_nombre]) VALUES (2, N'001', N'Licencia Office')
INSERT [dbo].[MST_RECURSO] ([nid_recurso], [co_tipo], [no_nombre]) VALUES (3, N'001', N'Proyector')
SET IDENTITY_INSERT [dbo].[MST_RECURSO] OFF
SET IDENTITY_INSERT [dbo].[TBL_COMPONENTE] ON 

INSERT [dbo].[TBL_COMPONENTE] ([nid_componente], [nid_portafolio], [nid_programa], [nid_proyecto], [fl_activo]) VALUES (1, 2, 1, NULL, 1)
INSERT [dbo].[TBL_COMPONENTE] ([nid_componente], [nid_portafolio], [nid_programa], [nid_proyecto], [fl_activo]) VALUES (2, 2, NULL, 1, 1)
INSERT [dbo].[TBL_COMPONENTE] ([nid_componente], [nid_portafolio], [nid_programa], [nid_proyecto], [fl_activo]) VALUES (3, 2, NULL, 2, 1)
INSERT [dbo].[TBL_COMPONENTE] ([nid_componente], [nid_portafolio], [nid_programa], [nid_proyecto], [fl_activo]) VALUES (4, 5, NULL, 5, 1)
INSERT [dbo].[TBL_COMPONENTE] ([nid_componente], [nid_portafolio], [nid_programa], [nid_proyecto], [fl_activo]) VALUES (5, 5, NULL, 6, 1)
INSERT [dbo].[TBL_COMPONENTE] ([nid_componente], [nid_portafolio], [nid_programa], [nid_proyecto], [fl_activo]) VALUES (6, 5, NULL, 7, 1)
INSERT [dbo].[TBL_COMPONENTE] ([nid_componente], [nid_portafolio], [nid_programa], [nid_proyecto], [fl_activo]) VALUES (7, 6, NULL, 8, 1)
INSERT [dbo].[TBL_COMPONENTE] ([nid_componente], [nid_portafolio], [nid_programa], [nid_proyecto], [fl_activo]) VALUES (8, 6, NULL, 9, 1)
INSERT [dbo].[TBL_COMPONENTE] ([nid_componente], [nid_portafolio], [nid_programa], [nid_proyecto], [fl_activo]) VALUES (9, 9, NULL, 10, 1)
INSERT [dbo].[TBL_COMPONENTE] ([nid_componente], [nid_portafolio], [nid_programa], [nid_proyecto], [fl_activo]) VALUES (10, 9, NULL, 11, 1)
SET IDENTITY_INSERT [dbo].[TBL_COMPONENTE] OFF
SET IDENTITY_INSERT [dbo].[TBL_COMPONENTE_RECURSO] ON 

INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (1, 1, 1, 3)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (2, 2, 1, 6)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (5, 3, 2, 1)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (7, 1, 2, 1)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (10, 4, 1, 1)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (11, 5, 2, 10)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (16, 7, 1, 6)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (17, 8, 1, 2)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (18, 7, 2, 3)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (19, 8, 2, 1)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (20, 8, 3, 0)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (22, 9, 1, 1)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (27, 10, 1, 1)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (28, 9, 2, 1)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (29, 10, 2, 1)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (30, 9, 3, 0)
INSERT [dbo].[TBL_COMPONENTE_RECURSO] ([nid_relacion], [nid_componente], [nid_recurso], [nu_recursototal]) VALUES (31, 9, 3, 0)
SET IDENTITY_INSERT [dbo].[TBL_COMPONENTE_RECURSO] OFF
SET IDENTITY_INSERT [dbo].[TBL_PORTAFOLIO] ON 

INSERT [dbo].[TBL_PORTAFOLIO] ([nid_portafolio], [no_codigo], [no_nombre], [nid_categoria], [nid_prioridad], [nid_responsable], [nid_responsable2], [tx_descripcion], [fl_activo], [no_usuario_red], [no_estacion_red], [fe_crea], [nid_usuario_crea], [fe_cambio], [nid_usuario_cambio], [co_estado]) VALUES (2, N'P00001', N'Graña y Montero', 2, 3, 3, 6, N'Portafolio, de Proyectos con Graña y Monterio', 1, NULL, NULL, CAST(0x0000A9100181AE78 AS DateTime), NULL, CAST(0x0000A91801538E4B AS DateTime), 6, N'002')
INSERT [dbo].[TBL_PORTAFOLIO] ([nid_portafolio], [no_codigo], [no_nombre], [nid_categoria], [nid_prioridad], [nid_responsable], [nid_responsable2], [tx_descripcion], [fl_activo], [no_usuario_red], [no_estacion_red], [fe_crea], [nid_usuario_crea], [fe_cambio], [nid_usuario_cambio], [co_estado]) VALUES (4, N'P00002', N'Gildemeister', 2, 2, 3, NULL, N'Portafolio, de Proyectos y/o Programas de Gildemeister', 1, NULL, NULL, CAST(0x0000A9100181AE78 AS DateTime), NULL, NULL, NULL, N'004')
INSERT [dbo].[TBL_PORTAFOLIO] ([nid_portafolio], [no_codigo], [no_nombre], [nid_categoria], [nid_prioridad], [nid_responsable], [nid_responsable2], [tx_descripcion], [fl_activo], [no_usuario_red], [no_estacion_red], [fe_crea], [nid_usuario_crea], [fe_cambio], [nid_usuario_cambio], [co_estado]) VALUES (5, N'P00003', N'Capacitaciones Sistemas', 1, 2, 3, NULL, N'Portafolio, de Capacitaciones', 1, NULL, NULL, CAST(0x0000A9100181AE78 AS DateTime), NULL, NULL, NULL, N'002')
INSERT [dbo].[TBL_PORTAFOLIO] ([nid_portafolio], [no_codigo], [no_nombre], [nid_categoria], [nid_prioridad], [nid_responsable], [nid_responsable2], [tx_descripcion], [fl_activo], [no_usuario_red], [no_estacion_red], [fe_crea], [nid_usuario_crea], [fe_cambio], [nid_usuario_cambio], [co_estado]) VALUES (6, N'P00004', N'Pruebas', 2, 1, 3, NULL, N'Portafolio. de Pruebas', 1, NULL, NULL, CAST(0x0000A9100181AE78 AS DateTime), NULL, NULL, NULL, N'002')
INSERT [dbo].[TBL_PORTAFOLIO] ([nid_portafolio], [no_codigo], [no_nombre], [nid_categoria], [nid_prioridad], [nid_responsable], [nid_responsable2], [tx_descripcion], [fl_activo], [no_usuario_red], [no_estacion_red], [fe_crea], [nid_usuario_crea], [fe_cambio], [nid_usuario_cambio], [co_estado]) VALUES (9, N'P00005', N'Pruebas v2', 2, 1, 3, NULL, N'Portafolio de Pruebas Fase 2', 1, NULL, NULL, CAST(0x0000A9100181AE78 AS DateTime), NULL, NULL, NULL, N'002')
SET IDENTITY_INSERT [dbo].[TBL_PORTAFOLIO] OFF
SET IDENTITY_INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] ON 

INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] ([nid_relacion], [nid_portafolio], [nid_recurso], [nu_recursototal], [nu_recursodisponible], [nu_recursoconsumido]) VALUES (4, 2, 1, 14, 5, 9)
INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] ([nid_relacion], [nid_portafolio], [nid_recurso], [nu_recursototal], [nu_recursodisponible], [nu_recursoconsumido]) VALUES (6, 2, 2, 10, 3, 2)
INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] ([nid_relacion], [nid_portafolio], [nid_recurso], [nu_recursototal], [nu_recursodisponible], [nu_recursoconsumido]) VALUES (7, 2, 3, 3, 3, 0)
INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] ([nid_relacion], [nid_portafolio], [nid_recurso], [nu_recursototal], [nu_recursodisponible], [nu_recursoconsumido]) VALUES (8, 5, 1, 7, 6, 1)
INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] ([nid_relacion], [nid_portafolio], [nid_recurso], [nu_recursototal], [nu_recursodisponible], [nu_recursoconsumido]) VALUES (9, 5, 2, 8, 4, 1)
INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] ([nid_relacion], [nid_portafolio], [nid_recurso], [nu_recursototal], [nu_recursodisponible], [nu_recursoconsumido]) VALUES (11, 5, 3, 2, 2, 0)
INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] ([nid_relacion], [nid_portafolio], [nid_recurso], [nu_recursototal], [nu_recursodisponible], [nu_recursoconsumido]) VALUES (14, 6, 1, 15, 7, 8)
INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] ([nid_relacion], [nid_portafolio], [nid_recurso], [nu_recursototal], [nu_recursodisponible], [nu_recursoconsumido]) VALUES (15, 6, 2, 10, 6, 4)
INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] ([nid_relacion], [nid_portafolio], [nid_recurso], [nu_recursototal], [nu_recursodisponible], [nu_recursoconsumido]) VALUES (16, 6, 3, 3, 2, 1)
INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] ([nid_relacion], [nid_portafolio], [nid_recurso], [nu_recursototal], [nu_recursodisponible], [nu_recursoconsumido]) VALUES (17, 9, 1, 10, 8, 2)
INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] ([nid_relacion], [nid_portafolio], [nid_recurso], [nu_recursototal], [nu_recursodisponible], [nu_recursoconsumido]) VALUES (18, 9, 2, 8, 6, 2)
INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] ([nid_relacion], [nid_portafolio], [nid_recurso], [nu_recursototal], [nu_recursodisponible], [nu_recursoconsumido]) VALUES (19, 9, 3, 1, 1, 0)
SET IDENTITY_INSERT [dbo].[TBL_PORTAFOLIO_RECURSO] OFF
SET IDENTITY_INSERT [dbo].[TBL_PROGRAMA] ON 

INSERT [dbo].[TBL_PROGRAMA] ([nid_programa], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (1, N'PR0001', N'Desarrollo Movil', N' ', CAST(0x0000A9170143E10B AS DateTime), CAST(0x0000A98001446947 AS DateTime), CAST(0x0000A9170143E10B AS DateTime), 3, 1)
INSERT [dbo].[TBL_PROGRAMA] ([nid_programa], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (3, N'PR0002', N'Migraciones BCP', NULL, CAST(0x0000A91700000000 AS DateTime), CAST(0x0000A98000000000 AS DateTime), CAST(0x0000A91700000000 AS DateTime), 3, 2)
SET IDENTITY_INSERT [dbo].[TBL_PROGRAMA] OFF
SET IDENTITY_INSERT [dbo].[TBL_PROGRAMA_PROYECTO] ON 

INSERT [dbo].[TBL_PROGRAMA_PROYECTO] ([nid_relacion], [nid_programa], [nid_proyecto]) VALUES (1, 1, 3)
INSERT [dbo].[TBL_PROGRAMA_PROYECTO] ([nid_relacion], [nid_programa], [nid_proyecto]) VALUES (2, 1, 4)
INSERT [dbo].[TBL_PROGRAMA_PROYECTO] ([nid_relacion], [nid_programa], [nid_proyecto]) VALUES (3, 3, 17)
INSERT [dbo].[TBL_PROGRAMA_PROYECTO] ([nid_relacion], [nid_programa], [nid_proyecto]) VALUES (4, 3, 19)
SET IDENTITY_INSERT [dbo].[TBL_PROGRAMA_PROYECTO] OFF
SET IDENTITY_INSERT [dbo].[TBL_PROYECTO] ON 

INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (1, N'PY0001', N'Integracion Datos Clientes', N' ', CAST(0x0000A9170143EED3 AS DateTime), CAST(0x0000A980014471CD AS DateTime), CAST(0x0000A9170143EED3 AS DateTime), 3, 2)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (2, N'PY0002', N'OutSourcing Julio', N'', CAST(0x0000A9170143EED3 AS DateTime), CAST(0x0000A980014471CD AS DateTime), CAST(0x0000A9170143EED3 AS DateTime), 3, 2)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (3, N'PY0003', N'Movil Despacho', N'', CAST(0x0000A9170143EED3 AS DateTime), CAST(0x0000A980014471CD AS DateTime), CAST(0x0000A9550143EED3 AS DateTime), 3, 1)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (4, N'PY0004', N'Movil Capacitacion', N'', CAST(0x0000A9170143EED3 AS DateTime), CAST(0x0000A980014471CD AS DateTime), CAST(0x0000A9170143EED3 AS DateTime), 3, 3)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (5, N'PY0005', N'Capacitacion Spring', N'', CAST(0x0000A9170143EED3 AS DateTime), CAST(0x0000A980014471CD AS DateTime), CAST(0x0000A9170143EED3 AS DateTime), 3, 1)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (6, N'PY0006', N'Capacitacion SST', N'', CAST(0x0000A9170143EED3 AS DateTime), CAST(0x0000A980014471CD AS DateTime), CAST(0x0000A9170143EED3 AS DateTime), 3, 2)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (7, N'PY0007', N'Capacitacion Ipad', NULL, CAST(0x0000A9170143EED3 AS DateTime), CAST(0x0000A980014471CD AS DateTime), CAST(0x0000A9170143EED3 AS DateTime), 3, 2)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (8, N'PY0008', N'Desarrollo App Movil Banco del Comerciao', NULL, CAST(0x0000A9170143EED3 AS DateTime), CAST(0x0000A980014471CD AS DateTime), CAST(0x0000A9170143EED3 AS DateTime), 3, 1)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (9, N'PY0009', N'Desarrollo App Comercial Banco del Comercio', NULL, CAST(0x0000A9170143EED3 AS DateTime), CAST(0x0000A980014471CD AS DateTime), CAST(0x0000A9170143EED3 AS DateTime), 3, 2)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (10, N'PY0010', N'Intranet Ausa', NULL, CAST(0x0000A9170143EED3 AS DateTime), CAST(0x0000A980014471CD AS DateTime), CAST(0x0000A9170143EED3 AS DateTime), 3, 1)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (11, N'PY0011', N'ELearning KN', NULL, CAST(0x0000A9170143EED3 AS DateTime), CAST(0x0000A980014471CD AS DateTime), CAST(0x0000A9170143EED3 AS DateTime), 3, 3)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (17, N'PY0012', N'Migracion Reporting Service', NULL, CAST(0x0000A92100000000 AS DateTime), CAST(0x0000A92D00000000 AS DateTime), CAST(0x0000A91B00000000 AS DateTime), 3, 2)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (19, N'PY0014', N'Migracion SQL Server', NULL, CAST(0x0000A91600000000 AS DateTime), CAST(0x0000A91900000000 AS DateTime), CAST(0x0000A91400000000 AS DateTime), 3, 1)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (20, N'PY0015', N'Envio de SMS', NULL, CAST(0x0000A91600000000 AS DateTime), CAST(0x0000A94200000000 AS DateTime), CAST(0x0000A91B00000000 AS DateTime), 3, 2)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (21, N'PY0016', N'Facturacion Electronica', NULL, CAST(0x0000A91600000000 AS DateTime), CAST(0x0000A92300000000 AS DateTime), CAST(0x0000A91B00000000 AS DateTime), 3, 1)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (23, N'PY0018', N'Migracion Amazon DataImagenes', NULL, CAST(0x0000A91600000000 AS DateTime), CAST(0x0000A92300000000 AS DateTime), CAST(0x0000A91E00000000 AS DateTime), 3, 2)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (24, N'PY0017', N'Dashboard Aduanas', NULL, CAST(0x0000A91600000000 AS DateTime), CAST(0x0000A91900000000 AS DateTime), CAST(0x0000A91400000000 AS DateTime), 3, 2)
INSERT [dbo].[TBL_PROYECTO] ([nid_proyecto], [no_codigo], [no_nombre], [tx_descripcion], [fe_crea], [fe_fin], [fe_inicio], [nid_responsable], [nid_prioridad]) VALUES (25, N'PY0019', N'Migracion Office 365', NULL, CAST(0x0000A91600000000 AS DateTime), CAST(0x0000A92800000000 AS DateTime), CAST(0x0000A91900000000 AS DateTime), 3, 1)
SET IDENTITY_INSERT [dbo].[TBL_PROYECTO] OFF
SET IDENTITY_INSERT [dbo].[TBL_SOLICITUD] ON 

INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (4, N'Solicito Laptops', 2, 1, 3, CAST(0x0000A910018B1D95 AS DateTime), N'S00001')
INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (6, N'Solicito Office', 3, 2, 3, CAST(0x0000A910018B3A9D AS DateTime), N'S00002')
INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (8, N'Solicito Laptops', 1, 1, 3, CAST(0x0000A911000023F4 AS DateTime), N'S00003')
INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (9, N'Solicito Laptops', 5, 1, 4, CAST(0x0000A911000061AA AS DateTime), N'S00004')
INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (10, N'Solicto Proyector', 6, 3, 1, CAST(0x0000A91100008580 AS DateTime), N'S00005')
INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (11, N'Solicitud', 7, 1, 3, CAST(0x0000A9120182E0FF AS DateTime), N'S00006')
INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (12, N'Solicitud', 8, 1, 6, CAST(0x0000A9120182EE92 AS DateTime), N'S00007')
INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (13, N'Solicitud', 7, 2, 1, CAST(0x0000A912018303AB AS DateTime), N'S00008')
INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (15, N'Solicitud', 8, 3, 1, CAST(0x0000A91201832722 AS DateTime), N'S00009')
INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (16, N'Solicitud', 9, 1, 4, CAST(0x0000A912018330E0 AS DateTime), N'S00010')
INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (17, N'Solicitud', 9, 2, 3, CAST(0x0000A91201833C8B AS DateTime), N'S00011')
INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (19, N'Solicitud', 10, 2, 5, CAST(0x0000A9120183504A AS DateTime), N'S00012')
INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (20, N'Solicitud', 4, 2, 6, CAST(0x0000A91C0133E967 AS DateTime), N'S00013')
INSERT [dbo].[TBL_SOLICITUD] ([nid_solicitud], [no_nombre], [nid_componente], [nid_recurso], [nu_solicitado], [fe_solicitud], [co_solicitud]) VALUES (21, NULL, 4, 1, 3, CAST(0x0000A91C0134864A AS DateTime), N'S00014')
SET IDENTITY_INSERT [dbo].[TBL_SOLICITUD] OFF
SET IDENTITY_INSERT [dbo].[TBL_USUARIO] ON 

INSERT [dbo].[TBL_USUARIO] ([nid_usuario], [nid_perfil], [no_nombre], [no_apepat], [no_apemat], [no_imagen], [no_usrlogin], [no_password], [no_correo], [fl_activo]) VALUES (3, 1, N'Manuel', N'Monge', N'Parra ', N' ', N'mmonge', N'123456', N'manuel.ox29@gmail.com', 1)
INSERT [dbo].[TBL_USUARIO] ([nid_usuario], [nid_perfil], [no_nombre], [no_apepat], [no_apemat], [no_imagen], [no_usrlogin], [no_password], [no_correo], [fl_activo]) VALUES (6, 2, N'Luis', N'Iman', N' ', N' ', N'liman', N'123456', N' ', 1)
INSERT [dbo].[TBL_USUARIO] ([nid_usuario], [nid_perfil], [no_nombre], [no_apepat], [no_apemat], [no_imagen], [no_usrlogin], [no_password], [no_correo], [fl_activo]) VALUES (7, 2, N'Freddy', N'Ramos', N' ', N' ', N'framos', N'123456', N' ', 1)
SET IDENTITY_INSERT [dbo].[TBL_USUARIO] OFF
ALTER TABLE [dbo].[TBL_COMPONENTE] ADD  DEFAULT ((1)) FOR [fl_activo]
GO
ALTER TABLE [dbo].[TBL_PROGRAMA] ADD  DEFAULT (getdate()) FOR [fe_crea]
GO
ALTER TABLE [dbo].[TBL_PROYECTO] ADD  DEFAULT (getdate()) FOR [fe_crea]
GO
ALTER TABLE [dbo].[TBL_SOLICITUD] ADD  DEFAULT (getdate()) FOR [fe_solicitud]
GO
ALTER TABLE [dbo].[TBL_COMPONENTE]  WITH CHECK ADD FOREIGN KEY([nid_portafolio])
REFERENCES [dbo].[TBL_PORTAFOLIO] ([nid_portafolio])
GO
ALTER TABLE [dbo].[TBL_COMPONENTE]  WITH CHECK ADD FOREIGN KEY([nid_programa])
REFERENCES [dbo].[TBL_PROGRAMA] ([nid_programa])
GO
ALTER TABLE [dbo].[TBL_COMPONENTE]  WITH CHECK ADD FOREIGN KEY([nid_proyecto])
REFERENCES [dbo].[TBL_PROYECTO] ([nid_proyecto])
GO
ALTER TABLE [dbo].[TBL_COMPONENTE_RECURSO]  WITH CHECK ADD FOREIGN KEY([nid_componente])
REFERENCES [dbo].[TBL_COMPONENTE] ([nid_componente])
GO
ALTER TABLE [dbo].[TBL_COMPONENTE_RECURSO]  WITH CHECK ADD FOREIGN KEY([nid_recurso])
REFERENCES [dbo].[MST_RECURSO] ([nid_recurso])
GO
ALTER TABLE [dbo].[TBL_DETALLE_BALANCEO]  WITH CHECK ADD FOREIGN KEY([nid_balanceo])
REFERENCES [dbo].[TBL_BALANCEO] ([nid_balanceo])
GO
ALTER TABLE [dbo].[TBL_DETALLE_BALANCEO]  WITH CHECK ADD FOREIGN KEY([nid_solicitud])
REFERENCES [dbo].[TBL_SOLICITUD] ([nid_solicitud])
GO
ALTER TABLE [dbo].[TBL_PORTAFOLIO]  WITH CHECK ADD FOREIGN KEY([nid_categoria])
REFERENCES [dbo].[MST_CATEGORIA] ([nid_categoria])
GO
ALTER TABLE [dbo].[TBL_PORTAFOLIO]  WITH CHECK ADD FOREIGN KEY([nid_prioridad])
REFERENCES [dbo].[MST_PRIORIDAD] ([nid_prioridad])
GO
ALTER TABLE [dbo].[TBL_PORTAFOLIO]  WITH CHECK ADD FOREIGN KEY([nid_responsable])
REFERENCES [dbo].[TBL_USUARIO] ([nid_usuario])
GO
ALTER TABLE [dbo].[TBL_PORTAFOLIO]  WITH CHECK ADD FOREIGN KEY([nid_responsable2])
REFERENCES [dbo].[TBL_USUARIO] ([nid_usuario])
GO
ALTER TABLE [dbo].[TBL_PORTAFOLIO_INICIATIVA]  WITH CHECK ADD FOREIGN KEY([nid_iniciativa])
REFERENCES [dbo].[MST_INICIATIVA] ([nid_iniciativa])
GO
ALTER TABLE [dbo].[TBL_PORTAFOLIO_INICIATIVA]  WITH CHECK ADD FOREIGN KEY([nid_portafolio])
REFERENCES [dbo].[TBL_PORTAFOLIO] ([nid_portafolio])
GO
ALTER TABLE [dbo].[TBL_PORTAFOLIO_RECURSO]  WITH CHECK ADD FOREIGN KEY([nid_portafolio])
REFERENCES [dbo].[TBL_PORTAFOLIO] ([nid_portafolio])
GO
ALTER TABLE [dbo].[TBL_PORTAFOLIO_RECURSO]  WITH CHECK ADD FOREIGN KEY([nid_recurso])
REFERENCES [dbo].[MST_RECURSO] ([nid_recurso])
GO
ALTER TABLE [dbo].[TBL_PROGRAMA_PROYECTO]  WITH CHECK ADD FOREIGN KEY([nid_programa])
REFERENCES [dbo].[TBL_PROGRAMA] ([nid_programa])
GO
ALTER TABLE [dbo].[TBL_PROGRAMA_PROYECTO]  WITH CHECK ADD FOREIGN KEY([nid_proyecto])
REFERENCES [dbo].[TBL_PROYECTO] ([nid_proyecto])
GO
ALTER TABLE [dbo].[TBL_SOLICITUD]  WITH CHECK ADD FOREIGN KEY([nid_componente])
REFERENCES [dbo].[TBL_COMPONENTE] ([nid_componente])
GO
ALTER TABLE [dbo].[TBL_SOLICITUD]  WITH CHECK ADD FOREIGN KEY([nid_recurso])
REFERENCES [dbo].[MST_RECURSO] ([nid_recurso])
GO
USE [master]
GO
ALTER DATABASE [DBINDRA] SET  READ_WRITE 
GO
