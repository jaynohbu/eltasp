CREATE TABLE [dbo].[certificate_origin_air_items] (
    [cert_id]           DECIMAL (18)   NOT NULL,
    [doc_num]           NVARCHAR (32)  NULL,
    [desc1]             NVARCHAR (512) NULL,
    [desc2]             NVARCHAR (512) NULL,
    [desc3]             NVARCHAR (512) NULL,
    [gross_weight]      FLOAT (53)     CONSTRAINT [DF_certificate_origin_air_items_gross_weight] DEFAULT (0) NULL,
    [measurement]       FLOAT (53)     CONSTRAINT [DF_certificate_origin_air_items_measurement] DEFAULT (0) NULL,
    [weight_scale]      NVARCHAR (3)   NULL,
    [measurement_scale] NVARCHAR (3)   NULL
);

