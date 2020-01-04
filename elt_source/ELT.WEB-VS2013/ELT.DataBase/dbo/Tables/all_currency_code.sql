CREATE TABLE [dbo].[all_currency_code] (
    [auto_uid]      DECIMAL (18)   IDENTITY (1, 1) NOT NULL,
    [country_name]  NVARCHAR (512) NULL,
    [country_code]  NVARCHAR (8)   NULL,
    [currency_name] NVARCHAR (128) NULL,
    [currency_code] NVARCHAR (8)   NULL
);

