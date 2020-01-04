USE [PRDDB]
GO

/****** Object:  Table [dbo].[Messages]    Script Date: 05/02/2014 09:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Messages](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Subject] [nvarchar](128) NOT NULL,
	[From] [nvarchar](50) NOT NULL,
	[To] [nvarchar](max) NOT NULL,
	[Text] [nvarchar](max) NULL,
	[Folder] [nvarchar](32) NULL,
	[Unread] [bit] NOT NULL,
	[HasAttachment] [bit] NOT NULL,
	[IsReply] [bit] NOT NULL,
	[org_account_number] [decimal](18, 0) NULL,
 CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

