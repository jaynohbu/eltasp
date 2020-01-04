USE [PRDDB]
GO

/****** Object:  Table [dbo].[Files]    Script Date: 05/02/2014 09:06:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Files](
	[LastWriteTime] [datetime] NULL,
	[Name] [nvarchar](100) NULL,
	[ID] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[ParentID] [decimal](18, 0) NOT NULL,
	[IsFolder] [bit] NULL,
	[Data] [varbinary](max) NULL,
	[OptimisticLockField] [int] NULL,
	[GCRecord] [int] NULL,
	[SSMA_TimeStamp] [timestamp] NOT NULL,
	[OrgId] [decimal](18, 0) NULL,
	[OwnerEmail] [varchar](100) NULL,
	[ContentID] [decimal](18, 0) NULL,
 CONSTRAINT [PK_Files] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

