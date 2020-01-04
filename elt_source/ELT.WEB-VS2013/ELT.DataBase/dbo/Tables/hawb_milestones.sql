CREATE TABLE [dbo].[hawb_milestones] (
    [auto_uid]           DECIMAL (18)   IDENTITY (1, 1) NOT NULL,
    [elt_account_number] DECIMAL (18)   NULL,
    [hawb_num]           NVARCHAR (128) NULL,
    [location_id]        NVARCHAR (8)   NULL,
    [seq_id]             DECIMAL (18)   NULL,
    [job_type]           NVARCHAR (128) NULL,
    [status]             NVARCHAR (32)  NULL,
    [remark]             NTEXT          NULL,
    [update_date]        DATETIME       NULL
);

