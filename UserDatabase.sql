USE [UserDatabase]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER TABLE [dbo].[Users] DROP CONSTRAINT [FK_Users_UserRoles]
GO

ALTER TABLE [dbo].[Users] DROP CONSTRAINT [FK_Users_UserDetails]
GO

DROP TABLE IF EXISTS [dbo].[Users]
GO

DROP TABLE IF EXISTS [dbo].[UserDetails]
GO

DROP TABLE IF EXISTS [dbo].[UserRoles]
GO

CREATE TABLE [dbo].[UserDetails](
	[userId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL
 CONSTRAINT [PK_UserDetails] PRIMARY KEY CLUSTERED 
(
	[userId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[UserRoles](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[roleName] [nvarchar](200) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id]  ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userRoleId] [int] NOT NULL,
	[userName] [nvarchar](50) NOT NULL,
	[email] [nvarchar](1000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_UserDetails] FOREIGN KEY([id])
REFERENCES [dbo].[UserDetails] ([userId])
GO

ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_UserDetails]
GO

ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_UserRoles] FOREIGN KEY([userRoleId])
REFERENCES [dbo].[UserRoles] ([id])
GO

ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_UserRoles]
GO

INSERT INTO [dbo].[UserRoles]
           ([roleName])
     VALUES
           ( 'admin'),
		   ( 'user')
GO

INSERT INTO [dbo].[UserDetails]
           ([FirstName], [LastName], [StartDate], [EndDate])
     VALUES
           ('Admin first', 'Admin last', '2017-10-03', '2022-10-03'),
		   ('User1 first', 'User1 last', '2017-10-03', '2022-10-03'),
		   ('User2 first', 'User2 last', '2017-10-03', '2022-10-03'),
		   ('User3 first', 'User3 last', '2017-10-03', '2022-10-03'),
		   ('User4 first', 'User4 last', '2017-10-03', '2022-10-03'),
		   ('User5 first', 'User5 last', '2017-10-03', '2022-10-03'),
		   ('User6 first', 'User6 last', '2017-10-03', '2022-10-03'),
		   ('User7 first', 'User7 last', '2017-10-03', '2022-10-03')
GO


INSERT INTO [dbo].[Users]
           ([userRoleId]
           ,[userName]
           ,[email])
     VALUES
           ( 1,'admin', 'admin@admin.test'),
		   ( 2,'user1','user1@user.test'),
		   ( 2,'user2','user2@user.test'),
		   ( 2,'user3','user3@user.test'),
		   ( 2,'user4','user4@user.test'),
		   ( 2,'user5', 'user5@user.test'),
		   ( 2,'user6', 'user6@user.test'),
		   ( 2,'user7','user7@user.test')
GO