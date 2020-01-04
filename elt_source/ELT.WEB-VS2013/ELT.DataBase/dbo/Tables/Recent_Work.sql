CREATE TABLE [dbo].[Recent_Work] (
    [workid]             NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [elt_account_number] DECIMAL (8)    NULL,
    [user_id]            NCHAR (16)     NULL,
    [workdate]           NCHAR (20)     NULL,
    [docnum]             NVARCHAR (128) NULL,
    [title]              NVARCHAR (128) NULL,
    [surl]               NVARCHAR (128) NULL,
    [workdetail]         NVARCHAR (128) NULL,
    [remark]             NVARCHAR (128) NULL,
    [status]             NCHAR (1)      NULL,
    CONSTRAINT [PK_Recent_Wok] PRIMARY KEY CLUSTERED ([workid] ASC)
);


GO
CREATE NONCLUSTERED INDEX [recent_work_date]
    ON [dbo].[Recent_Work]([elt_account_number] ASC, [user_id] ASC, [workdate] ASC);

