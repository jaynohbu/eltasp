CREATE TABLE [dbo].[mawb_other_cost] (
    [auto_uid]           DECIMAL (18)    IDENTITY (1, 1) NOT NULL,
    [elt_account_number] DECIMAL (18)    NULL,
    [mawb_num]           NVARCHAR (50)   NULL,
    [vendor_no]          DECIMAL (18)    NULL,
    [cost_amt]           DECIMAL (18, 2) NULL,
    [item_no]            DECIMAL (18)    NULL,
    [cost_desc]          NVARCHAR (50)   NULL
);

