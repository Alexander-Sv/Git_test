Create table #SECURITIES(
		  ID						int				identity
		, LAYER						tinyint			not null	default 0	-- 0 - ����������� ������, 1 - ��������������, 2 - ��� ����������� (�����������) �� ��������� ���������� ��� � �� ��������

		, BRANCH					smallint		not null
		, PART						tinyint			not null
		, SUBPART					varchar(3)		not null
		, NUM_ROW					int					null
		, NUM_COLUMN				smallint			null

		, ID_PAPER					int					null
		, ID_ACCOUNT				int					null
		, DEPO_TYPE_CODE			varchar(2)			null
		, ID_CLIENT_OWNER			int					null

		, TRADE_ID					int					null

		, PAPER_COUNT				decimal(28,12)		null
		, DEPO_ACC_TYPE				varchar(20)			null
		, DEPO_OWNER_SECTOR			varchar(5)			null

		, OWNER_NAME				varchar(160)		null   -- ��� 2
		, OWNER_INN					varchar(20)			null
		, OWNER_IS_REZIDENT			tinyint			null -- yudin 06/08/14
		, OWNER_KPP					varchar(20)			null
		, OWNER_OGRN				varchar(20)			null
		, OWNER_OKSM				varchar(3)			null
		, OWNER_LICENSE_NUM			varchar(20)			null
		, OWNER_INDICATION			varchar(1)			null
		, STR_ACCOUNT				varchar(30)			null

		, EMITENT_ID_CLIENT			int					null
		, EMITENT_NAME				varchar(255)		null
		, EMITENT_INN				varchar(20)			null
		, EMITENT_IS_REZIDENT		tinyint			null -- yudin 06/08/14
		, EMITENT_KPP				varchar(20)			null
		, EMITENT_OGRN				varchar(20)			null
		, EMITENT_OKSM				varchar(3)			null

		, PAPER_TYPE_CODE			varchar(5)			null
		, PAPER_REG_NUM				varchar(50)			null   ---- saa 08.11.16 �������� �������� ���� �� 50 (82694)
		, PAPER_CODE_ISIN			varchar(60)			null
		, PAPER_CURRENCY_CODE		varchar(3)			null
		, PAPER_NOMINAL				decimal(32,16)		null
		, PAPER_NOTE				varchar(255)		null

		-- ���������� ������ �����, � ��������� ������� ������������� ,  ����������� � (���) ����������� ������������, ��.         
		, ENCUMBRANCES_PAPER_COUNT  decimal(28,12)		null   -- ������ - ��� 21
		, PLEDGED_PAPER_COUNT		decimal(28,12)		null   -- ������ - ��� 22
		, IN_KLIRING				decimal(28,12)		null   -- ������ - ��� 23
		, WITH_CORP_ACTIONS			decimal(28,12)		null   -- ������ - ��� 24
		, BAN_ON_OPERATIONS			decimal(28,12)		null   -- ������ - ��� 25
		, UNDER_ARREST				decimal(28,12)		null   -- ������ - ��� 26 

		, DEPO_OWNER_OKSM			varchar(3)			null   -- ������ - ��� 55

		, REGISTRATOR_NAME			varchar(160)		null  --  ������ - �� ������� 21
		, REGISTRATOR_INDICATION	varchar(1)			null
		, REGISTRATOR_INN			varchar(20)			null
		, REGISTRATOR_IS_REZIDENT	tinyint			null -- yudin 06/08/14
		, REGISTRATOR_KPP			varchar(20)			null
		, REGISTRATOR_OGRN			varchar(20)			null
		, REGISTRATOR_OKSM			varchar(3)			null
		, REGISTRATOR_LICENSE_NUM	varchar(20)			null
		, NOSTRO_STR_ACCOUNT		varchar(30)			null   --  ������ ��������� ���� ������

		, SID_TRADE_TYPE			varchar(20)			null
		-- ������ 3

		, COL192					varchar(255)		null -- ������������ ��������
		, COL193					varchar(19)			null -- ���
		, COL193B					tinyint				null -- yudin 06/08/14 ��������, ��� ���
		, COL194					varchar(10)			null -- ���
		, COL195					varchar(20)			null -- ����
		, COL196					varchar(20)			null -- ����
		, COL197					varchar(5)			null -- ��� ���� �.�.
		, COL198					varchar(20)			null -- ��� ��� ����� ������� �.�.
		, COL199					varchar(20)			null -- ��� ISIN
		, COL200					varchar(3)			null -- ��� ������
		, COL201					money				null -- ������� ��������� ����� ��� ���

		, COL202					money				null -- ���������� � ���� ����
		, COL203					money				null -- �� ������� �����
		, COL204					money				null -- ������� �� ��� ���� 
		, COL205					money				null -- ������� �� ���� �����
		, COL206					money				null -- ���������� � ����� ���
		, COL207					money				null -- ����� ������� � ����� ���
		, COL208					money				null -- � ����� �� ������
		, COL209					money				null -- � ����� �� ������ 3� ���
		, COL210					money				null -- �������� � �����
		, COL211					money				null -- ���� �� ���� ������
		, COL212					money				null -- ���������� � ����� � �������� ����������
		, COL213					money				null -- ������ �� ���������� ����
		, COL214					money				null -- ��� �������

		, COL215					varchar(60)			null -- ����������

-- ��������� ����� 2
		, ID_CLIENT int null
		, DATE_HISTORY datetime null
		, OKVED varchar(255) null
		, OKVED_OR_OKVED2 tinyint null

		)

if exists (select * from dbo.sysobjects where id = object_id(N'p711a2017_Part3') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure p711a2017_Part3
GO

create procedure p711a2017_Part3(
	  @Date datetime
	, @NumBranch smallint
) as 


Declare @SUB_ACC smallint
select @SUB_ACC = dbo.fn_OGO_READ_SETTING_SCALAR('�����������','������������� ��������� ���������')
select @SUB_ACC = isnull(@SUB_ACC,0)


-- ����� 202-205
-- (81000) - KVF, 01.09.2016 - ��������� ������������, �.�. � DLG_REST_SALDO_FR ������ ��������� � ������� �����, � �� �����
Insert into #SECURITIES(BRANCH, PART, SUBPART, ID_PAPER, TRADE_ID, COL202, COL203, COL204, COL205)
	Select 
		  T.NUMBRANCH BRANCH
		, 3 PART
		, '3.0' SUBPART
		, REST.NUMPAPER ID_PAPER
		, REST.TRADE_ID
		, case when TYP.SID_TRADE_TYPE = 'UBS_REPO' and REST.HOLDING_ID not in (100, 200) then Sum( S.REST ) else 0.0 end COL202
		, case when TYP.SID_TRADE_TYPE = 'UBS_LOAN' and REST.HOLDING_ID not in (100, 200) then Sum( S.REST ) else 0.0 end COL203
		, case when TYP.SID_TRADE_TYPE = 'UBS_REPO' and REST.HOLDING_ID in (100, 200) then Sum( S.REST ) else 0.0 end COL204
		, case when TYP.SID_TRADE_TYPE = 'UBS_LOAN' and REST.HOLDING_ID in (100, 200) then Sum( S.REST ) else 0.0 end COL205
	from DLG_REST_FR REST
		join DEPO_EMISSION PAPER on PAPER.ID_PAPER = REST.NUMPAPER
		join DEPO_PAPER_CLASS CLASS	on CLASS.ID_CLASS = PAPER.ID_CLASS
			and CLASS.SID_CLASS <> 'UBS_BILL'
		join DLG_REST_SALDO_FR S on S.ID_REST = REST.ID_REST
			and S.TYPE_REST = 0				-- ��� ���������� ����� ����� FIFO (������ ���� �� ������������)
			and S.DATE_FR < @Date and S.DATE_NEXT >= @Date
			and S.REST <> 0
		join DLG_TRADE T on T.TRADE_ID = REST.TRADE_ID
			and REST.HOLDING_ID >= 100		-- ������ ���� (� �����)
			and (T.NUMBRANCH = @NumBranch or @NumBranch = 0)
		join DLG_TRADE_TYPE TYP	on TYP.TRADE_TYPE = T.TRADE_TYPE
			and TYP.SID_TRADE_TYPE in ('UBS_REPO', 'UBS_LOAN')
	where REST.ID_CONTRACT = 0	-- �� ������ ������, ��� ������ ��, ���������� � ����, ������������� ����� (���� <> 0, �� ������ ����������)
	group by T.NUMBRANCH
		, REST.NUMPAPER
		, REST.TRADE_ID
		, TYP.SID_TRADE_TYPE
		, REST.HOLDING_ID


-- ����� 172 - 176
Declare @PartCodesTrust varchar(50)		Select @PartCodesTrust = CODE_TYPE_PART from #SETTING_DEPO_ACC_TYPES where NAME_TYPE = '�������� � ������������� ����������'
Declare @PartCodesPledge varchar(50)	Select @PartCodesPledge = CODE_TYPE_PART from #SETTING_DEPO_ACC_TYPES where NAME_TYPE = '�������� � �����'
Declare @PartCodesTakePledge varchar(50)	Select @PartCodesTakePledge = CODE_TYPE_PART from #SETTING_DEPO_ACC_TYPES where NAME_TYPE = '������� � �����'

Insert into #SECURITIES(BRANCH, PART, SUBPART, ID_PAPER, ID_ACCOUNT, ID_CLIENT_OWNER
					, PAPER_COUNT, NUM_COLUMN)
	Select D.NUMBRANCH BRANCH, 3 PART, '3.0' SUBPART, A.ID_PAPER, A.ID_ACCOUNT, D.ID_CLIENT ID_CLIENT_OWNER
		, case @SUB_ACC when 1 then sum(S_SUB.SALDO) else max(S.SALDO) end PAPER_COUNT
		,	172 + 
			case
				when @PartCodesTrust like '%,'+ltrim(rtrim(DPT.CODE))+',%' then 0
				when @PartCodesPledge like '%,'+ltrim(rtrim(DPT.CODE))+',%' then 2
				when @PartCodesTakePledge like '%,'+ltrim(rtrim(DPT.CODE))+',%' then 4
			end 
				+	case D.ID_CLIENT when 0 then 0 else 1 end NUM_COLUMN
	from DEPO_ACCOUNTS4 A
		left join OD_SALTRN4 S
		on S.ID_ACCOUNT = A.ID_ACCOUNT
		and S.DATE_TRN < @Date and S.DATE_NEXT >= @Date
		and S.SALDO <> 0

		left join DEPO_SUBACCOUNTS SA
			join DEPO_SUBSALTRN4 S_SUB
			on S_SUB.ID_SUBACCOUNT = SA.ID_SUBACCOUNT
			and S_SUB.DATE_TRN < @Date and S_SUB.DATE_NEXT >= @Date
			and S_SUB.SALDO <> 0
		on SA.ID_ACCOUNT_P = A.ID_ACCOUNT

		join DEPO_PART P
			join DEPO_ACC D
			on D.ID_ACC = P.ID_ACC
			and D.DATE_OPEN < @Date and D.DATE_CLOSE >= @Date
			and D.STATE <> 3 -- ���� ���� �� ��������������
			and (D.NUMBRANCH = @NumBranch or @NumBranch = 0)

			join DEPO_PART_TYPE DPT
			on DPT.ID_PART_TYPE = P.ID_PART_TYPE
			and (	@PartCodesTrust like '%,'+ltrim(rtrim(DPT.CODE))+',%'
				or	@PartCodesPledge like '%,'+ltrim(rtrim(DPT.CODE))+',%'
				or	@PartCodesTakePledge like '%,'+ltrim(rtrim(DPT.CODE))+',%'
				)
		on P.ID_PART = A.ID_PART

		join DEPO_EMISSION PAPER
			join DEPO_PAPER_CLASS CLASS
			on CLASS.ID_CLASS = PAPER.ID_CLASS
			and CLASS.SID_CLASS <> 'UBS_BILL'
		on PAPER.ID_PAPER = A.ID_PAPER
	group by D.NUMBRANCH, A.ID_PAPER, A.ID_ACCOUNT, D.ID_CLIENT, DPT.CODE
	having case @SUB_ACC when 1 then sum(S_SUB.SALDO) else max(S.SALDO) end <> 0

Update #SECURITIES set NUM_COLUMN = 176 where PART = 3 and NUM_COLUMN = 177

---------------------------------------------------------------------------------------------------------------------------
-- �������� ������ � ����� �� �� ��������� �����������
---------------------------------------------------------------------------------------------------------------------------
-- Id ������� �������� ����������� '�������������� �������� ������'
declare @id_field_zalog_objects int
select @id_field_zalog_objects= ID_FIELD from GUAR_CONTR_ADDFL_DIC where NAME_FIELD = '�������������� �������� ������'

-- ������� ������
declare @C_Branch smallint
select @C_Branch = dbo.fn_OGO_READ_SETTING_SCALAR('�������� ���������','������������� �������')

Insert into #SECURITIES (BRANCH, PART, SUBPART, ID_PAPER, ID_ACCOUNT, ID_CLIENT_OWNER, PAPER_COUNT, NUM_COLUMN)
select @C_Branch, 3, 3.0, a_id.FIELD_INT, 0, 0, a_qty.FIELD_INT, 176
from 
	VW_GUAR_CONTR_BALANCE c
	inner join GUAR_CONTR_ADDFL_ARRAY a_id on
		a_id.ID_FIELD = @id_field_zalog_objects
		and c.GUAR_CONTRACT = a_id.ID_OBJECT
		and a_id.INDEX_COLUMN = 1
	inner join GUAR_CONTR_ADDFL_ARRAY a_qty on
		a_qty.ID_FIELD = @id_field_zalog_objects
		and c.GUAR_CONTRACT = a_qty.ID_OBJECT
		and a_qty.INDEX_COLUMN = 2
		and a_qty.INDEX_ROW = a_id.INDEX_ROW
where 
	c.GUAR_DATE_SET < @date and c.GUAR_DATE_CLOSE >= @date
	and c.GUAR_DATE_TRN < @date and c.GUAR_DATE_NEXT >= @date
	and c.GUAR_QUALITY_DATE_SET < @date and c.GUAR_QUALITY_DATE_NEXT >= @date
	and c.GUAR_BALANCE <> 0
---------------------------------------------------------------------------------------------------------------------------

--- ����������� 
--- ����������! 172-176 - ����� ���� ������ ���� �� 4212-�
Insert into #SECURITIES(LAYER, BRANCH, PART, SUBPART, ID_PAPER, COL202, COL203, COL204, COL205
					, COL206, COL207, COL208, COL209, COL210)
	Select 1 LAYER, BRANCH, PART, SUBPART, ID_PAPER, sum(COL202) COL202, sum(COL203) COL203, sum(COL204) COL204, sum(COL205) COL205
		, sum( case NUM_COLUMN when 172 then PAPER_COUNT else 0.0 end ) COL206
		, sum( case NUM_COLUMN when 173 then PAPER_COUNT else 0.0 end ) COL207
		, sum( case NUM_COLUMN when 174 then PAPER_COUNT else 0.0 end ) COL208
		, sum( case NUM_COLUMN when 175 then PAPER_COUNT else 0.0 end ) COL209
		, sum( case NUM_COLUMN when 176 then PAPER_COUNT else 0.0 end ) COL210
	from #SECURITIES SEC
	where SEC.PART = 3
	group by BRANCH, PART, SUBPART, ID_PAPER

GO
drop table #SECURITIES
Go