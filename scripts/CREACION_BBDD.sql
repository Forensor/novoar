USE master;
GO

CREATE DATABASE NOVOAR
ON
(
	NAME = 'NOVOAR_DAT',
	FILENAME = 'D:\producción\proyectosBBDD\NOVOAR.mdf',
	SIZE = 10,
	MAXSIZE = 50,
	FILEGROWTH = 5
)
LOG ON
(
	NAME = 'NOVOAR_Log',
	FILENAME = 'D:\producción\proyectosBBDD\NOVOAR.ldf',
	SIZE = 5,
	MAXSIZE = 25,
	FILEGROWTH = 5
);
GO

USE NOVOAR
GO

--Localizacion > Investigador > Campamento > Colonia > Equipo > Cientifico > Monitor > Pinguino > Cientifico-Pinguino > Campo > Cientifico-Campo

CREATE TABLE dbo.Localizacion
(
	cod_Localizacion int identity(1, 1),
	nombre nvarchar(20) not null,
	coordenadas int not null,
	constraint LocalizacionPK primary key(cod_Localizacion),
	constraint nombreLocalizacionUnique unique (nombre),
	constraint coordenadasLocalizacionUnique unique (coordenadas)
);

CREATE TABLE dbo.Investigador
(
	cod_Investigador int identity(1, 1),
	nombre nvarchar(15) not null,
	dni numeric(8) not null,
	apellido1 nvarchar(25) not null,
	apellido2 nvarchar(20),
	tipo bit not null,
	constraint InvestigadorPK primary key(cod_Investigador),
	constraint dniInvestigadorUnique unique (dni)
);

CREATE TABLE dbo.Campamento
(
	cod_Campamento int identity(1, 1),
	nombre nvarchar(8) not null,
	localizacion int not null,
	constraint CampamentoPK primary key(cod_Campamento),
	constraint LocalizacionCampamentoFK foreign key (localizacion) references dbo.Localizacion(cod_Localizacion),
	constraint nombreCampamentoUnique unique (nombre)
);

CREATE TABLE dbo.Colonia
(
	cod_Colonia int identity(1, 1),
	descripcion nvarchar(100),
	nombre nvarchar(20) not null,
	localizacion int not null,
	constraint ColoniaPK primary key (cod_Colonia),
	constraint LocalizacionColoniaFK foreign key (localizacion) references dbo.Localizacion(cod_Localizacion),
	constraint nombreColoniaUnique unique (nombre),
	constraint localizacionColoniaUnique unique (localizacion)
);
CREATE TABLE dbo.Equipo
(
	cod_Equipo int identity(1, 1),
	nombre nvarchar(8) not null,
	descripcion nvarchar(100),
	campamento int not null,
	constraint EquipoPK primary key (cod_Equipo),
	constraint nombreEquipoUnique unique (nombre),
	constraint CampamentoEquipoFK foreign key (campamento) references dbo.Campamento(cod_Campamento)
);

CREATE TABLE dbo.Cientifico
(
	cod_Investigador int not null,
	titulo_Tesis nvarchar(15) not null,
	equipo int,
	constraint CientificoPK primary key (cod_Investigador),
	constraint equipoCientificoUnique unique (equipo),
	constraint EquipoCientificoFK foreign key (equipo) references dbo.Equipo (cod_Equipo),
	constraint InvestigadorCientificoFK foreign key (cod_Investigador) references dbo.Investigador(cod_Investigador)

);

CREATE TABLE dbo.Monitor
(
	cod_Investigador int not null,
	equipo_Avanzado bit not null,
	equipo int not null,
	constraint MonitorPK primary key (cod_Investigador),
	constraint EquipoMonitorFK foreign key (equipo) references dbo.Equipo (cod_Equipo),
	constraint InvestigadorMonitorFK foreign key (cod_Investigador) references dbo.Investigador(cod_Investigador)

);

CREATE TABLE dbo.Pinguino
(
	cod_Pinguino int identity(1, 1),
	nombre nvarchar(10),
	sexo char(1) not null,
	estado_Muda nvarchar(12) not null,
	pareja int,
	monitor int not null,
	colonia int not null,
	constraint PinguinoPK primary key (cod_Pinguino),
	constraint PinguinoFK foreign key (pareja) references dbo.Pinguino (cod_Pinguino),
	constraint MonitorPinguinoFK foreign key (monitor) references dbo.Monitor (cod_Investigador),
	constraint ColoniaPinguinoFK foreign key (colonia) references dbo.Colonia (cod_Colonia)
);

CREATE TABLE dbo.Cientifico_Pinguino
(
	cientifico int,
	pinguino int,
	fecha_Examen date not null,
	constraint Cientifico_PinguinoPK primary key (cientifico, pinguino),
	constraint CientificoCientifico_PinguinoFK foreign key (cientifico) references dbo.Cientifico (cod_Investigador),
	constraint PinguinoCientifico_PinguinoFK foreign key (pinguino) references dbo.Pinguino (cod_Pinguino)
);

CREATE TABLE dbo.Campo
(
	cod_Campo int identity(1, 1),
	nombre nvarchar(20) not null,
	constraint CampoNombreUnique unique (nombre),
	constraint CampoPK primary key (cod_Campo)
);

CREATE TABLE dbo.Cientifico_Campo
(
	cientifico int not null,
	campo int not null,
	constraint Cientifico_CampoPK primary key (cientifico, campo),
	constraint Cientifico_CampoCientificoFK foreign key (cientifico) references dbo.Cientifico (cod_Investigador),
	constraint Cientifico_CampoCampoFK foreign key (campo) references dbo.Campo (cod_Campo)
);

CREATE TABLE dbo.ErrLog
(
	id int identity(1, 1),
	fecha_Hora datetime not null,
	linea int not null,
	descripcion nvarchar(4000) not null,
	procedimiento nvarchar(128) not null,
	numero_Error int not null,
	gravedad_Error int not null,
	estado int not null,
	usuario nvarchar(128) not null,
	constraint ErrLogPK primary key (id)
);

CREATE VIEW vErroresHoy
AS
	SELECT
		*
	FROM
		ErrLog
	WHERE
		CAST(fecha_Hora AS date) = CAST(GETDATE() AS date);
		
CREATE PROCEDURE [dbo].[almacenar_error]
AS
	INSERT INTO ErrLog(fecha_Hora, linea, descripcion,
						 procedimiento, numero_Error, 
						 gravedad_Error, estado, usuario) 
	VALUES (GETDATE(), ERROR_LINE(), ERROR_MESSAGE(),
			 ERROR_PROCEDURE(), ERROR_NUMBER(), 
			 ERROR_SEVERITY(), ERROR_STATE(), USER);