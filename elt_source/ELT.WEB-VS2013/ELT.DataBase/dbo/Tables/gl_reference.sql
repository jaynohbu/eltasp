CREATE TABLE [dbo].[gl_reference] (
    [gl_id]          DECIMAL (18)   IDENTITY (1, 1) NOT NULL,
    [gl_master_type] NVARCHAR (128) NULL,
    [gl_type]        NVARCHAR (256) NULL,
    [remark]         NTEXT          NULL
);

