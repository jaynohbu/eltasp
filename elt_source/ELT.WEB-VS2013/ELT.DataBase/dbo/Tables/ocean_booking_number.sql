CREATE TABLE [dbo].[ocean_booking_number] (
    [elt_account_number]   DECIMAL (8)    NULL,
    [booking_num]          NVARCHAR (32)  NULL,
    [mbol_num]             NVARCHAR (32)  NULL,
    [departure_date]       DATETIME       NULL,
    [arrival_date]         DATETIME       NULL,
    [receipt_place]        NVARCHAR (64)  NULL,
    [origin_port_id]       NVARCHAR (8)   NULL,
    [origin_port_aes_code] NVARCHAR (6)   NULL,
    [origin_port_location] NVARCHAR (64)  NULL,
    [origin_port_state]    NVARCHAR (8)   NULL,
    [origin_port_country]  NVARCHAR (64)  NULL,
    [dest_port_id]         NVARCHAR (8)   NULL,
    [dest_port_aes_code]   NVARCHAR (6)   NULL,
    [dest_port_location]   NVARCHAR (64)  NULL,
    [dest_port_country]    NVARCHAR (64)  NULL,
    [dest_country_code]    NVARCHAR (2)   NULL,
    [delivery_place]       NVARCHAR (64)  NULL,
    [carrier_desc]         NVARCHAR (64)  NULL,
    [carrier_code]         DECIMAL (5)    CONSTRAINT [DF_ocean_booking_number_carrier_code] DEFAULT (0) NULL,
    [scac]                 NVARCHAR (4)   NULL,
    [consolidator_name]    NVARCHAR (64)  NULL,
    [consolidator_code]    DECIMAL (7)    NULL,
    [voyage_no]            NVARCHAR (30)  NULL,
    [vsl_name]             NVARCHAR (64)  NULL,
    [move_type]            NVARCHAR (32)  NULL,
    [cutoff_time]          NVARCHAR (20)  NULL,
    [cutoff]               DATETIME       NULL,
    [fcl_lcl]              NVARCHAR (3)   NULL,
    [container_type]       NVARCHAR (32)  NULL,
    [file_no]              NVARCHAR (128) NULL,
    [status]               NCHAR (1)      NULL,
    [booking_date]         DATETIME       NULL
);


GO
CREATE CLUSTERED INDEX [PK_ocean_booking_number]
    ON [dbo].[ocean_booking_number]([elt_account_number] ASC, [booking_num] ASC, [file_no] ASC);

