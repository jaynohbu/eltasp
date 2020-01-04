
CREATE TABLE [dbo].[rate_table] (
    [id]                 DECIMAL (18)    IDENTITY (1, 1) NOT NULL,
    [elt_account_number] INT             NOT NULL,
    [customer_no]        INT             NULL,
    [agent_no]           INT             NULL,
    [origin_port]        NVARCHAR (50)   NOT NULL,
    [dest_port]          NVARCHAR (50)   NOT NULL,
    [airline]            INT             NOT NULL,
    [kg_lb]              CHAR (1)        NOT NULL,
    [share]              DECIMAL (18, 2) NULL,
    [min]                DECIMAL (18, 2) NULL,
    [minPlus]            DECIMAL (18, 2) NULL,
    [breaks]             VARCHAR (1000)  NULL,
    [rates]              VARCHAR (1000)  NULL,
    [rate_type]          SMALLINT        NOT NULL,
    [enabled]            BIT             NULL,
    CONSTRAINT [PK_rate.ratetable] PRIMARY KEY CLUSTERED ([id] ASC)
);



GO


CREATE TRIGGER [dbo].[Populate_all_rate_table]
   ON  [dbo].[rate_table]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
   DECLARE @DELETEDCOUNT INT
   DECLARE @INSERTEDCOUNT INT
   SELECT @DELETEDCOUNT = COUNT(*) FROM deleted
   SELECT @INSERTEDCOUNT = COUNT(*) FROM inserted

   --CustomerSellingRate=4,
   --     AgentBuyingRate=1,
   --     IataRate=5,
   --     AirlineBuyingRate=3
   DECLARE  @elt_account_number decimal
           ,@item_no decimal
           ,@rate_type int
           ,@agent_no int
           ,@customer_no int
           ,@airline nvarchar(50)
           ,@origin_port nvarchar(50)
           ,@dest_port nvarchar(50)
           ,@weight_break decimal
           ,@rate decimal(8,2)
           ,@kg_lb nchar(1)
           ,@share decimal(8,2)         
           ,@rate_table_id decimal
		   ,@breaks nvarchar(MAX)
		   ,@rates nvarchar(MAX)
		   ,@enabled bit
   IF( @INSERTEDCOUNT > 0 ) 
   BEGIN

		SELECT @rate_table_id=id,@enabled=[enabled]
		From inserted	 
		DELETE FROM all_rate_table WHERE rate_table_id=@rate_table_id

		SELECT @rate_type= rate_type,@airline=airline,@origin_port=origin_port,@dest_port=dest_port,@kg_lb=kg_lb,@share=share,
		@breaks=breaks,@rates=rates,@elt_account_number=elt_account_number , @customer_no= customer_no,@agent_no=  agent_no,@rate_table_id=id,@enabled=[enabled]
		From inserted
		DECLARE @t_break TABLE(id int, data nvarchar(20));
		DECLARE @t_rate TABLE(id int, data nvarchar(20));
		IF @breaks IS NOT NULL AND @rates IS NOT NULL
		BEGIN
			INSERT INTO @t_break select * from dbo.Split(@breaks,',');
			INSERT INTO @t_rate select * from dbo.Split(@rates,',');
			DECLARE @current_index int= (SELECT TOP 1 id FROM @t_break ORDER BY ID);
			DECLARE @last_index int= (SELECT TOP 1 id FROM @t_break ORDER BY  ID DESC);	
			SET @item_no = 1
			PRINT 'Trigger by insert or update action'  
			PRINT  @enabled

			WHILE @current_index <= @last_index
			BEGIN
				SET  @rate =NULL;
				SET @weight_break=NULL;
				UPDATE @t_break 
				SET data = NULL 
				WHERE data = ''
				UPDATE @t_rate 
				SET data = NULL 
				WHERE data = ''
				SET  @rate = Convert(DECIMAL(8,2),(SELECT TOP 1 data FROM  @t_rate WHERE ID= @current_index));
				SET  @weight_break =Convert(INT,(SELECT TOP 1 data FROM  @t_break WHERE ID= @current_index));
				IF @enabled =1 
					EXEC	[dbo].[Insert_all_rate_table]
				@elt_account_number ,
				@item_no ,
				@rate_type ,
				@agent_no ,
				@customer_no ,
				@airline ,
				@origin_port ,
				@dest_port ,
				@weight_break ,
				@rate ,
				@kg_lb ,
				@share ,
				@rate_table_id
				SET @current_index = (SELECT TOP 1 id FROM @t_break WHERE ID > @current_index  ORDER BY ID);
				SET @item_no = @item_no + 1

			END 
		END
	END
END