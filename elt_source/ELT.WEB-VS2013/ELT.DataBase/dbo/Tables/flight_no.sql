CREATE TABLE [dbo].[flight_no] (
    [elt_account_number] DECIMAL (8)   CONSTRAINT [DF_flight_no_elt_account_number] DEFAULT (0) NULL,
    [airline_name]       NVARCHAR (64) NULL,
    [airline_code]       NVARCHAR (2)  CONSTRAINT [DF_flight_no_airline_code] DEFAULT (0) NULL,
    [flight_no]          NVARCHAR (16) NULL,
    [pod]                NVARCHAR (16) NULL,
    [poa]                NVARCHAR (16) NULL
);

