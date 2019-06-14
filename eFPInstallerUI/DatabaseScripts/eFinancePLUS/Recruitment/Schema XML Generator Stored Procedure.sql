-- Stored procedure to generate the contents for a .schema.xml file 
-- based on existing SQL Server database tables

IF EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[financeSchemaGenerator]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [financeSchemaGenerator]
GO

CREATE PROCEDURE [financeSchemaGenerator]
	@TableLike varchar(50), 
	@TableIn varchar(500) = null
AS
	DECLARE @xml nvarchar(max)
	DECLARE @tableXml nvarchar(max)
	DECLARE @columnXml nvarchar(1000)
	DECLARE @indexXml nvarchar(1000)
	DECLARE @currentTable varchar(100)
	DECLARE @LF AS nvarchar(2)
	DECLARE @CurrentEnd BIGINT
	DECLARE @offset tinyint
	DECLARE @TableInXml AS XML

	SET @xml = ''
	SET @LF = CHAR(10)
	SET @TableInXml = cast(('<A>'+replace(@TableIn,',' ,'</A><A>')+'</A>') AS XML)	-- Trick to handle a list of values as a parameter for "IN"

	DECLARE tabCursor CURSOR FOR
		SELECT TABLE_NAME,
			   '<Table Class="' + TABLE_NAME + '" Table="' + TABLE_NAME + '"' + 
			    CASE WHEN NOT EXISTS 
					(SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=T.TABLE_NAME and COLUMN_NAME='unique_key') 
				THEN ' DisableUniqueKey="true"'
				END +
			   '>' + @LF +
			   '	<Table.Documentation></Table.Documentation>' + @LF +
			   '	<Table.Columns>' + @LF
			FROM INFORMATION_SCHEMA.TABLES T
			WHERE TABLE_NAME like @TableLike ESCAPE '\' OR
			      TABLE_NAME in (SELECT A.value('.', 'varchar(max)') AS [Column] FROM @TableInXml.nodes('A') AS FN(A))
			
	OPEN tabCursor
	FETCH NEXT FROM tabCursor INTO @currentTable, @tableXml
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @xml += @tableXml

		DECLARE colCursor CURSOR FOR
			SELECT '		<Table.Column Property="' + COLUMN_NAME + '" Column="' + COLUMN_NAME + 
				   '" Title="" Type="' +
				   CASE
						WHEN DATA_TYPE in ('char','varchar') THEN DATA_TYPE + '" Length="' + 
							CASE CHARACTER_MAXIMUM_LENGTH 
								WHEN -1 THEN '4000' /* or MAX */
								ELSE RTRIM(CAST(CHARACTER_MAXIMUM_LENGTH as char))
							END
						WHEN DATA_TYPE = 'int' THEN 'integer'
						ELSE DATA_TYPE
				   END +
				   '" Nullable="' + 
				   CASE IS_NULLABLE
						WHEN 'YES' THEN 'true' ELSE 'false'
				   END +
				   '"/>' + @LF
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_NAME = @currentTable
				ORDER BY TABLE_NAME

		OPEN colCursor
		FETCH NEXT FROM colCursor INTO @columnXml
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @xml += @columnXml
			FETCH NEXT FROM colCursor INTO @columnXml
		END
		CLOSE colCursor
		DEALLOCATE colCursor

		SET @xml += '	</Table.Columns>' + @LF
		SET @xml += '	<PrimaryKey>' + @LF
		
		DECLARE indexCursor CURSOR FOR
			SELECT '		<PrimaryKey.Column Column="' + Col.COLUMN_NAME + '"/>' 
			from 
				INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, 
				INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
			WHERE 
				Col.CONSTRAINT_NAME = Tab.CONSTRAINT_NAME
				AND Col.TABLE_NAME = Tab.TABLE_NAME
				AND CONSTRAINT_TYPE = 'PRIMARY KEY'
				AND Col.TABLE_NAME = @currentTable
		OPEN indexCursor
		FETCH NEXT FROM indexCursor INTO @indexXml
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @xml += @indexXml + @LF
			FETCH NEXT FROM indexCursor INTO @indexXml
		END
		CLOSE indexCursor
		DEALLOCATE indexCursor

		SET @xml += '	</PrimaryKey>' + @LF
		SET @xml += '</Table>' + @LF + @LF
		FETCH NEXT FROM tabCursor INTO @currentTable, @tableXml
	END

	CLOSE tabCursor
	DEALLOCATE tabCursor
	SET @xml += @LF

	-- The following is just "PRINT @xml", but due to the size limit we need to print in chunks
	WHILE LEN(@xml) > 1
	BEGIN
		IF CHARINDEX(CHAR(10), @xml) between 1 AND 4000
		BEGIN
			   SET @CurrentEnd = CHARINDEX(char(10), @xml) - 1
			   SET @offset = 2
		END
		ELSE
		BEGIN
			   SET @CurrentEnd = 4000
			   SET @offset = 1
		END   
		PRINT SUBSTRING(@xml, 1, @CurrentEnd) 
		SET @xml = SUBSTRING(@xml, @CurrentEnd+@offset, 1073741822)   
	END
GO

-- Usage Examples: Table LIKE, or table IN:
--exec financeSchemaGenerator 'tablePrefix\_%'
--exec financeSchemaGenerator '', 'table1,table2,table2'
