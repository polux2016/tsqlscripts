USE master
GO

IF OBJECT_ID('[dbo].[fn_splitstringtorows]') IS NOT NULL
BEGIN
    DROP FUNCTION [dbo].[fn_splitstringtorows]
END
GO

CREATE FUNCTION fn_splitstringtorows 
(
    @String NVARCHAR(4000),
    @Delimiter NCHAR(1) = ','
)
RETURNS TABLE
AS
RETURN
(
    WITH Split(stpos,endpos)
    AS(
        SELECT 0 AS position, CHARINDEX(@Delimiter,@String) AS endpos
        UNION ALL
        SELECT endpos+1, CHARINDEX(@Delimiter,@String,endpos+1)
            FROM Split
            WHERE endpos > 0
    )
    SELECT  ROW_NUMBER() OVER (ORDER BY (SELECT stpos)) as [Id],
        stpos as [StartFromIndex],
        SUBSTRING(@String, stpos ,
            COALESCE(
                NULLIF(endpos,0),
                LEN(@String) + 1
            ) - stpos
        ) as [Data]
    FROM Split
)
GO
