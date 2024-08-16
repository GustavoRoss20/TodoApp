--USE MASTER
--DROP DATABASE TodoDB

USE MASTER 
CREATE DATABASE TodoDB
COLLATE Modern_Spanish_CI_AI;
GO
USE TodoDB;


-- #################################################### --
-- #################################################### --
-- SECURITY
-- #################################################### --
-- #################################################### --

IF (1 = 1) BEGIN 

	-- ====================================================
	-- CatLogMovementType									
	-- ====================================================
	IF (1 = 1) BEGIN

		--DROP TABLE CatLogMovementType
		CREATE TABLE [dbo].[CatLogMovementType]
		(
			[Id]		TINYINT			NOT NULL,
			[Name]		VARCHAR(25)		NOT NULL,
			CONSTRAINT [PK_CatLogMovementType] PRIMARY KEY ([Id]),
			CONSTRAINT [UK_CatLogMovementType] UNIQUE ([Name])
		)

		INSERT INTO CatLogMovementType VALUES (1, 'RECORDED');
		INSERT INTO CatLogMovementType VALUES (2, 'MODIFIED');
		INSERT INTO CatLogMovementType VALUES (3, 'DELETED');
	END

	-- ====================================================
	-- CatTypeProfile									
	-- ====================================================
	IF (1 = 1) BEGIN

		-- DROP TABLE CatTypeProfile
		CREATE TABLE [dbo].[CatTypeProfile]
		(
			[Id]		TINYINT		NOT NULL,
			[Name]		VARCHAR(50)	NOT NULL,
			[Acronym]	CHAR(3)		NOT NULL,
			CONSTRAINT [PK_CatTypeProfile] PRIMARY KEY ([Id]),
			CONSTRAINT [UK_CatTypeProfile] UNIQUE ([Name])
		)

		INSERT INTO CatTypeProfile VALUES (0, 'SYSTEM', 'STM');
		INSERT INTO CatTypeProfile VALUES (1, 'ADMIN', 'ADM');
		INSERT INTO CatTypeProfile VALUES (2, 'USER', 'USR');

		SELECT * FROM CatTypeProfile ORDER BY Id;
		--DELETE FROM CatTypeProfile;
	END

	-- ====================================================
	-- CatUserSystem						
	-- ====================================================
	IF (1 = 1) BEGIN 

		--DROP TABLE CatUserSystem
		CREATE TABLE [dbo].[CatUserSystem]
		(
			[Id]				BIGINT			NOT NULL IDENTITY,
			[Deleted]			BIT				NOT NULL,
			[IdCatTypeProfile]	TINYINT			NOT NULL,
			[Name]				VARCHAR(50)		NOT NULL,
			[FirstLastName]		VARCHAR(50)		NOT NULL,
			[SecondLastName]	VARCHAR(50)		NOT NULL,
			[Email]				VARCHAR(100)	NOT NULL,
			[Password]			VARCHAR(100)	NOT NULL,
			[CreationDate]		DATETIME		NOT NULL DEFAULT GETDATE(),
			[LastAccessDate]	DATETIME		NULL,
			CONSTRAINT [PK_CatUserSystem] PRIMARY KEY ([Id]),
			CONSTRAINT [UK_CatUserSystem] UNIQUE ([Email]),
			CONSTRAINT [FK_CatUserSystem_CatTypeProfile]
				FOREIGN KEY([IdCatTypeProfile]) REFERENCES [CatTypeProfile]([Id])
		)

		--Email:	rosalianog.20@gmail.com
		--Password:	gusdev2009 
		INSERT INTO CatUserSystem ([Deleted], [IdCatTypeProfile], [Name], [FirstLastName], [SecondLastName], [Email], [Password], [CreationDate], [LastAccessDate])
			VALUES (0, 0, 'ADMIN', 'DEVELOPER', 'SYSTEM', 'ROSALIANOG.20@GMAIL.COM', '', GETDATE(), NULL);

		UPDATE CatUserSystem SET Password = '' WHERE Id = 1;

	END

	-- ====================================================
	-- LogUserSystem							
	-- ====================================================
	IF (1 = 1) BEGIN 

		--DROP TABLE LogUserSystem
		CREATE TABLE [dbo].[LogUserSystem]
		(
			[Id]							BIGINT			NOT NULL IDENTITY,
			[IdCatUserSystem]				BIGINT			NOT NULL, 
			[IdCatUserSystemPerfomedBy]		BIGINT			NULL,
			[Date]							DATETIME		NOT NULL,
			[Data]							VARCHAR(MAX)	NULL,
			[IdCatLogMovementType]			TINYINT			NOT NULL,
			[Justification]					VARCHAR(500)	NOT NULL
			CONSTRAINT [PK_LogUserSystem] PRIMARY KEY ([Id]),
			CONSTRAINT [FK_LogUserSystem_CatUserSystem] 
				FOREIGN KEY ([IdCatUserSystem]) REFERENCES [CatUserSystem]([Id]),
			CONSTRAINT [FK_LogUserSystem_CatUserSystem_2]
				FOREIGN KEY ([IdCatUserSystemPerfomedBy]) REFERENCES [CatUserSystem]([Id]),
			CONSTRAINT [FK_LogUserSystem_CatLogMovementType]
				FOREIGN KEY ([IdCatLogMovementType]) REFERENCES [CatLogMovementType]([Id]),
		)

	END

END

-- #################################################### --
-- #################################################### --
-- Todo's
-- #################################################### --
-- #################################################### --

IF (1 = 1) BEGIN 

	-- ====================================================
	-- CatTodo					
	-- ====================================================
	IF (1 = 1) BEGIN 

		--DROP TABLE CatTodo
		CREATE TABLE [dbo].[CatTodo]
		(
			[Id]				INT				NOT NULL IDENTITY,
			[IdCatUserSystem]	BIGINT			NOT NULL,
			[Title]				VARCHAR(50)		NOT NULL,
			[Description]		VARCHAR(100)	NOT NULL,
			[Completed]			BIT				NOT NULL,
			[Deleted]			BIT				NOT NULL,
			[CreationDate]		DATETIME		NOT NULL DEFAULT GETDATE(),
			CONSTRAINT [PK_CatTodo] PRIMARY KEY ([Id]),
			CONSTRAINT [FK_CatTodo_CatUserSystem]
				FOREIGN KEY ([IdCatUserSystem]) REFERENCES [CatUserSystem]([Id])
		)

	END

	-- ====================================================
	-- LogTodo						
	-- ====================================================
	IF (1 = 1) BEGIN

		--DROP TABLE LogTodo
		CREATE TABLE [dbo].[LogTodo]
		(
			[Id]							BIGINT			NOT NULL IDENTITY,
			[IdCatTodo]						INT			NOT NULL, 
			[IdCatUserSystemPerfomedBy]		BIGINT			NULL,
			[Date]							DATETIME		NOT NULL,
			[Data]							VARCHAR(MAX)	NULL,
			[IdCatLogMovementType]			TINYINT			NOT NULL,
			[Justification]					VARCHAR(500)	NOT NULL,
			CONSTRAINT [PK_LogTodo] PRIMARY KEY ([Id]),
			CONSTRAINT [FK_LogTodo_CatTodo]
				FOREIGN KEY ([IdCatTodo]) REFERENCES [CatTodo]([Id]),
			CONSTRAINT [FK_LogTodo_CatUserSystem_PerfomedBy] 
				FOREIGN KEY ([IdCatUserSystemPerfomedBy]) REFERENCES [CatUserSystem]([Id]),
			CONSTRAINT [FK_LogTodo_CatLogMovementType]
				FOREIGN KEY ([IdCatLogMovementType]) REFERENCES [CatLogMovementType]([Id]),
		)

	END

END

