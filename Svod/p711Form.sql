if exists (select * from sysobjects where id = object_id('dbo.p711Form') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure dbo.p711Form
GO

Create Proc dbo.p711Form(
      @Date      datetime
    , @NumBranch smallint = 0
	, @Unload tinyint = 0 -- 1-âûãðóçêà â ÏÒÊ ÏÑÄ,2-âûãðóçêà â ÊËÈÊÎ,0-èíà÷å
    )
As

SET NOCOUNT ON
set transaction isolation level read uncommitted


declare @SidVersion varchar(50)
select @SidVersion = dbo.fn_OGO_GET_VERSION('UBS_FORMA711',@Date,'')

If @SidVersion >= 'CB_4212U'
	begin 
		if @Unload = 2 
			exec p711cbForm_2017  @Date
		else 
			exec p711Form_2017 @Date, @SidVersion, @NumBranch, @Unload

		return
	end


If @SidVersion >= 'CB_3129U'
	if @Unload = 2 
		exec p711cbForm_2014 @Date
	else 
		exec p711Form_2014 @Date, @SidVersion, @NumBranch, @Unload
Else
	if @Unload = 2 
		exec p711cbForm_2009 @Date
	else 
		exec p711Form_2009 @Date, @NumBranch, @Unload
GO
