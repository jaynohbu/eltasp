USE [PRDDB]
GO

/****** Object:  Table [dbo].[FileContent]    Script Date: 05/02/2014 09:06:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[FileContent](
	[LastWriteTime] [datetime] NULL,
	[Data] [varbinary](max) NULL,
	[CreatorEmail] [varchar](100) NULL,
	[ContentID] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_FileContent] PRIMARY KEY CLUSTERED 
(
	[ContentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

