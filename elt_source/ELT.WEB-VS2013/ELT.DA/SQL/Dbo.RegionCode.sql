
/****** Object:  Table [dbo].[RegionCode]    Script Date: 8/7/2014 3:23:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[RegionCode](
	[CountryCode] [nchar](10) NOT NULL,
	[Type] [nchar](10) NOT NULL,
	[Code] [nchar](10) NOT NULL,
	[Name] [nvarchar](50) NOT NULL
) ON [PRIMARY]

GO

