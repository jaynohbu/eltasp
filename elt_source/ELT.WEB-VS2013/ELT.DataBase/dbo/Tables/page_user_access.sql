CREATE TABLE [dbo].[page_user_access] (
    [elt_account_number] DECIMAL (18) NOT NULL,
    [user_id]            DECIMAL (18) NOT NULL,
    [page_id]            INT          NOT NULL,
    [is_bloked]          BIT          CONSTRAINT [DF_PageUserAccess_is_bloked] DEFAULT ((0)) NOT NULL
);

