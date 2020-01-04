
/****** Object:  User Defined Function dbo.DeleteAllTableRowsByELT    Script Date: 7/31/2008 11:07:36 AM ******/

/****** Object:  User Defined Function dbo.DeleteAllTableRowsByELT    Script Date: 5/5/2008 2:56:02 PM ******/

/****** Object:  User Defined Function dbo.DeleteAllTableRowsByELT    Script Date: 5/5/2008 2:47:35 PM ******/

/****** Object:  User Defined Function dbo.DeleteAllTableRowsByELT    Script Date: 5/5/2008 2:24:42 PM ******/

CREATE FUNCTION dbo.DeleteAllTableRowsByELT
(
	@elt_account_number nvarchar(32)
)
RETURNS INT
AS
BEGIN

IF @elt_account_number IS NULL 
RETURN 0

ELSE

DECLARE my_cursor CURSOR FOR 
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME LIKE 'elt_account_number' 
DECLARE @table_name nvarchar(128)

BEGIN 

OPEN my_cursor
FETCH NEXT FROM my_cursor INTO @table_name

WHILE @@FETCH_STATUS=0
BEGIN
DECLARE @statement nVARCHAR(1024)

SET @statement = 'DELETE FROM  '+@table_name+' WHERE CAST(elt_account_number AS nvarchar(32))=@elt_account_number'
exec sp_executesql @statement,N'@elt_account_number nvarchar(32)', @elt_account_number

FETCH NEXT FROM my_cursor INTO @table_name
END

SET @statement = 'DELETE FROM greetMessage  WHERE CAST(AgentID AS nvarchar(32))=@elt_account_number'
exec sp_executesql @statement,N'@elt_account_number nvarchar(32)', @elt_account_number

CLOSE my_cursor
DEALLOCATE my_cursor

END 

RETURN 1
END










