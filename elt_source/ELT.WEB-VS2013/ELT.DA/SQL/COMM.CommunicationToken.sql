USE [PRDDB]
GO

/****** Object:  Table [COMM].[CommunicationToken]    Script Date: 05/02/2014 09:04:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [COMM].[CommunicationToken](
	[ID] [decimal](18, 0) NULL,
	[Token] [varchar](500) NOT NULL,
	[TokenType] [tinyint] NOT NULL,
	[TimeStart] [datetime] NULL,
	[TimeEnd] [datetime] NULL,
	[Period] [int] NULL,
	[Expired] [bit] NULL,
	[RecipientEmail] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

