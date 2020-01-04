USE [PRDDB]
GO

/****** Object:  Table [COMM].[AttachmentFileGroup]    Script Date: 05/02/2014 09:04:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [COMM].[AttachmentFileGroup](
	[GID] [decimal](18, 0) IDENTITY(1,1) NOT NULL,
	[OriginatorID] [decimal](18, 0) NOT NULL,
	[SentDate] [datetime] NOT NULL,
	[ReferenceNo] [nvarchar](100) NULL,
	[ReferenceType] [tinyint] NULL
) ON [PRIMARY]

GO

