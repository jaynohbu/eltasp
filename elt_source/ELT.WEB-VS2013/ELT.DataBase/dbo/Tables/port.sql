CREATE TABLE [dbo].[port] (
    [elt_account_number] DECIMAL (8)   NOT NULL,
    [port_code]          NVARCHAR (8)  NOT NULL,
    [port_desc]          NVARCHAR (50) NULL,
    [port_id]            NVARCHAR (50) NULL,
    [port_city]          NVARCHAR (50) NULL,
    [port_state]         NVARCHAR (10) NULL,
    [port_country]       NVARCHAR (50) NULL,
    [port_country_code]  NVARCHAR (2)  NULL,
    CONSTRAINT [PK_port] PRIMARY KEY CLUSTERED ([elt_account_number] ASC, [port_code] ASC)
);

