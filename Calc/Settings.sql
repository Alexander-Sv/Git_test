if exists (select * from sysobjects where id = object_id('dbo.p711a2017_Part1') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure dbo.p711a2017_Part1
GO
-----------------------------------------
-- in Git newF branch merged with master branch!!!
-- in Git newF branch!!!
-- in Git master branch!!!
-----------------------------------------
Create Proc dbo.p711a2017_Part1(
      @Date      datetime
	, @PrintProt tinyint
    , @NumBranch smallint = 0
    )
as
 select '1'
 
 GO