CREATE TABLE [dbo].[iocean_booking_number] (
    [elt_account_number]   DECIMAL (8)   NULL,
    [booking_num]          NVARCHAR (32) NULL,
    [mbol_num]             NVARCHAR (32) NULL,
    [departure_date]       DATETIME      NULL,
    [arrival_date]         DATETIME      NULL,
    [origin_port_id]       NVARCHAR (8)  NULL,
    [origin_port_location] NVARCHAR (64) NULL,
    [origin_port_state]    NVARCHAR (8)  NULL,
    [origin_port_country]  NVARCHAR (32) NULL,
    [dest_port_id]         NVARCHAR (8)  NULL,
    [dest_port_location]   NVARCHAR (64) NULL,
    [dest_port_country]    NVARCHAR (32) NULL,
    [exporting_carrier]    NVARCHAR (32) NULL,
    [move_type]            NVARCHAR (32) NULL,
    [status]               NCHAR (1)     NULL
);

