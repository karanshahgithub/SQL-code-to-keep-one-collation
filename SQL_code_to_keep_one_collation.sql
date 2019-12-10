USE practice -- use your database name
GO

Declare @tableName as nvarchar(max)
Declare @columnName as nvarchar(max)
Declare @datatype as nvarchar(max)
Declare	@collationName as nvarchar(max)
Declare	@character_Maximum_Length as integer
Declare @numeric_Precision as integer
Declare @datetime_Precision as integer
Declare	@isNullable as nvarchar(max)
Declare @sqlString nvarchar(max)
Declare @sqlString2 nvarchar(max)
Declare @columnName2 as nvarchar(max)
Declare @indexName as nvarchar(max)


Declare primaryKeyInfo CURSOR
FOR
SELECT i.name AS IndexName,
       OBJECT_NAME(ic.OBJECT_ID),
       COL_NAME(ic.OBJECT_ID,ic.column_id) 
FROM   sys.indexes AS i INNER JOIN 
       sys.index_columns AS ic ON  i.OBJECT_ID = ic.OBJECT_ID
                                AND i.index_id = ic.index_id
WHERE   i.is_primary_key = 1

Open primaryKeyInfo
Fetch NEXT FROM primaryKeyInfo
INTO  @indexName,@tableName,@columnName2

  WHILE @@FETCH_STATUS = 0
   BEGIN

set @sqlString2 = N'ALTER TABLE' +' '+'['+@tableName+']' +' DROP CONSTRAINT' + ' ' + @indexName 
execute (@sqlString2)

   Declare collationChange CURSOR
   For
   SELECT TABLE_NAME,COLUMN_NAME,DATA_TYPE,COLLATION_NAME,CHARACTER_MAXIMUM_LENGTH,NUMERIC_PRECISION,DATETIME_PRECISION,IS_NULLABLE
   FROM INFORMATION_SCHEMA.COLUMNS 
   where COLLATION_NAME is not null and COLLATION_NAME <> 'Latin1_General_CS_AS' and TABLE_NAME = @tableName        -- use your collation name
   
   Open collationChange
   FETCH NEXT from collationChange
   INTO @tableName,@columnName,@dataType,@collationName,@character_Maximum_Length,@numeric_Precision,@datetime_Precision,@isNullable
   
   WHILE @@FETCH_STATUS = 0
   BEGIN
   
   if(@dataType = 'nvarchar' or @dataType = 'nchar' or  @dataType = 'varchar')
   BEGIN
      if(@isNullable = 'YES')
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +'(' + cast(@character_Maximum_Length as nvarchar(max)) +')'+ ' COLLATE Latin1_General_CS_AS;'
         execute (@sqlString)
         END
      else
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +'(' + cast(@character_Maximum_Length as nvarchar(max)) +')'+ ' COLLATE Latin1_General_CS_AS NOT NULL;'
         execute (@sqlString)
         END
   END
   
   else if(@dataType = 'decimal' or @dataType = 'numeric')
   BEGIN
      if(@isNullable = 'YES')
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +'(' + cast(@numeric_Precision as nvarchar(max)) +')'+ ' COLLATE Latin1_General_CS_AS;'
         execute (@sqlString)
         END
      else
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +'(' + cast(@numeric_Precision as nvarchar(max)) +')'+ ' COLLATE Latin1_General_CS_AS NOT NULL;'
         execute (@sqlString)
         END
   END
   
   else if(@dataType = 'datetime2')
   BEGIN
      if(@isNullable = 'YES')
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +'(' + cast(@datetime_Precision as nvarchar(max)) +')'+ ' COLLATE Latin1_General_CS_AS;'
         execute (@sqlString)
         END
      else
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +'(' + cast(@datetime_Precision as nvarchar(max)) +')'+ ' COLLATE Latin1_General_CS_AS NOT NULL;'
         execute (@sqlString)
         END
   END
   
   else 
   BEGIN
      if(@isNullable = 'YES')
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +' COLLATE Latin1_General_CS_AS;'
         execute (@sqlString)
         END
      else
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype + ' COLLATE Latin1_General_CS_AS NOT NULL;'
         execute (@sqlString)
         END 
   END
        
   FETCH NEXT from collationChange
   INTO @tableName,@columnName,@dataType,@collationName,@character_Maximum_Length,@numeric_Precision,@datetime_Precision,@isNullable
   END
   
   
   close collationChange
   deallocate collationChange

set @sqlString2 = N'ALTER TABLE' +' '+'['+@tableName+']' +' ADD CONSTRAINT'+' '+ @indexName +' ' +' PRIMARY KEY ('+ @columnName2 +');'  
execute (@sqlString2)

FETCH NEXT from primaryKeyInfo
INTO @indexName,@tableName,@columnName2
END

close primaryKeyInfo
deallocate primaryKeyInfo

Declare collationChange CURSOR
   For
   SELECT TABLE_NAME,COLUMN_NAME,DATA_TYPE,COLLATION_NAME,CHARACTER_MAXIMUM_LENGTH,NUMERIC_PRECISION,DATETIME_PRECISION,IS_NULLABLE
   FROM INFORMATION_SCHEMA.COLUMNS 
   where COLLATION_NAME is not null and COLLATION_NAME <> 'Latin1_General_CS_AS' -- use your collation name
   
   Open collationChange
   FETCH NEXT from collationChange
   INTO @tableName,@columnName,@dataType,@collationName,@character_Maximum_Length,@numeric_Precision,@datetime_Precision,@isNullable
   
   WHILE @@FETCH_STATUS = 0
   BEGIN
   
   if(@dataType = 'nvarchar' or @dataType = 'nchar' or  @dataType = 'varchar')
   BEGIN
      if(@isNullable = 'YES')
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +'(' + cast(@character_Maximum_Length as nvarchar(max)) +')'+ ' COLLATE Latin1_General_CS_AS;'
         execute (@sqlString)
         END
      else
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +'(' + cast(@character_Maximum_Length as nvarchar(max)) +')'+ ' COLLATE Latin1_General_CS_AS NOT NULL;'
         execute (@sqlString)
         END
   END
   
   else if(@dataType = 'decimal' or @dataType = 'numeric')
   BEGIN
      if(@isNullable = 'YES')
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +'(' + cast(@numeric_Precision as nvarchar(max)) +')'+ ' COLLATE Latin1_General_CS_AS;'
         execute (@sqlString)
         END
      else
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +'(' + cast(@numeric_Precision as nvarchar(max)) +')'+ ' COLLATE Latin1_General_CS_AS NOT NULL;'
         execute (@sqlString)
         END
   END
   
   else if(@dataType = 'datetime2')
   BEGIN
      if(@isNullable = 'YES')
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +'(' + cast(@datetime_Precision as nvarchar(max)) +')'+ ' COLLATE Latin1_General_CS_AS;'
         execute (@sqlString)
         END
      else
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +'(' + cast(@datetime_Precision as nvarchar(max)) +')'+ ' COLLATE Latin1_General_CS_AS NOT NULL;'
         execute (@sqlString)
         END
   END
   
   else 
   BEGIN
      if(@isNullable = 'YES')
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype +' COLLATE Latin1_General_CS_AS;'
         execute (@sqlString)
         END
      else
         BEGIN
         set @sqlString =N'ALTER TABLE'+ ' ' +'['+@tableName+']' + ' ALTER COLUMN' +' ' + @columnName +' ' + @datatype + ' COLLATE Latin1_General_CS_AS NOT NULL;'
         execute (@sqlString)
         END 
   END
        
   FETCH NEXT from collationChange
   INTO @tableName,@columnName,@dataType,@collationName,@character_Maximum_Length,@numeric_Precision,@datetime_Precision,@isNullable
   END
   
   
close collationChange
deallocate collationChange




