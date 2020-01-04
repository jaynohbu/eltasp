USE [PRDDB]
GO

/****** Object:  Table [COMM].[AttachmentLog]    Script Date: 05/02/2014 09:04:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [COMM].[AttachmentLog](
	[ID] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[GID] [decimal](18, 0) NOT NULL,
	[RecipientEmail] [varchar](100) NOT NULL,
	[FileID] [decimal](18, 0) NOT NULL,
	[IsDelivered] [bit] NULL,
	[Name] [nvarchar](500) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

