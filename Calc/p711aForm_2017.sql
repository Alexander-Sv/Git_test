if exists (select * from sysobjects where id = object_id('dbo.p711aForm_2017') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure dbo.p711aForm_2017
GO

Create Proc dbo.p711aForm_2017(
      @Date      datetime
	, @PrintProt tinyint
    , @NumBranch smallint = 0
	, @SidVersion varchar(50)
    )
as



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

		--- ���-�� ������ ����� �� ������ ��
		, COL74						decimal(28,12)		not null  default 0 -- ���-�� �.�.
		, COL75						decimal(28,12)		not null  default 0
		, COL76						decimal(28,12)		not null  default 0
		, COL77						decimal(28,12)		not null  default 0
		, COL78						decimal(28,12)		not null  default 0
		, COL79						decimal(28,12)		not null  default 0
		, COL80						decimal(28,12)		not null  default 0
		, COL81						decimal(28,12)		not null  default 0
		, COL82						decimal(28,12)		not null  default 0
		, COL83						decimal(28,12)		not null  default 0
		, COL84						decimal(28,12)		not null  default 0
		, COL85						decimal(28,12)		not null  default 0

		, COL102					money				null  -- ����� ��������� � �.�.
		, COL103                    varchar(5)          null  -- ����� ���. ����� 2-�� ������� 

		--- ������ 2
		-- ��������� 2.1
		, COL105					varchar(255)		null -- �������������
		, COL106					varchar(19)			null -- ���
		, COL106B					tinyint				null -- yudin 06/08/14 ��������, ��� ���
		, COL107					varchar(20)			null -- ����
		, COL108					varchar(20)			null -- ����
		, COL109					varchar(5)			null -- ��� ���� �.�.
		, COL110					varchar(10)			null -- ����� ����
		, COL111					varchar(30)			null -- ����� ����
		, COL112					varchar(255)		null -- ����� ������
		, COL113					datetime			null -- ���� �����������
		, COL114					int					null -- ��� �������
		, COL115					datetime			null -- ���� 1
		, COL116					datetime			null -- ���� 2
		, COL117					decimal(28,12)		null -- ���������� ������ 
		, COL118					money				null -- ���������� ����� 
		, COL119					varchar(3)			null -- ��� ������ ���������� ����� 
		, COL120					money				null -- ���. ��������� ������� �� ���� ���� �� ���.
		, COL121					money				null -- ���. ��������� ������� �� ������ ����.
		, COL122					money				null -- ����������� �������
		, COL123					int					null -- ��������� ��������
		, COL124					money				null -- �������������� ������
		, COL125					datetime			null -- ���� �������� �� ������
		, COL126					varchar(255)		null -- ��������� ������������
		, COL127					varchar(160)		null -- ����������
		, COL128					varchar(19)			null -- ���
		, COL128B					tinyint				null --  yudin 06/08/14 ��������, ��� ���
		, COL129					varchar(20)			null -- ����
		, COL130					varchar(20)			null -- ����
		, COL131					varchar(5)			null -- ���. ���� 2�� ���.
		, COL132					varchar(160)		null -- ��������������� �������
		, COL133					varchar(19)			null -- ���
		, COL133B					tinyint				null -- yudin 06/08/14 ��������, ��� ���
		, COL134					varchar(20)			null -- ����
		, COL135					varchar(20)			null -- ����
		, COL136					varchar(255)		null -- ��������� ��������. ����. � ��. �������.
		, COL137					money				null -- ��������� ����������
		, COL138					datetime			null -- ���� ��������
		, COL139					varchar(255)		null -- ��������� �������
		, COL140					varchar(160)		null -- ����������
		, COL141					varchar(19)			null -- ���
		, COL141B					tinyint				null --  yudin 06/08/14 ��������, ��� ���
		, COL142					varchar(20)			null -- ����
		, COL143					varchar(20)			null -- ����
		, COL144					varchar(255)		null -- ����������

		-- ��������� 2.2
		, COL146					varchar(10)			null -- ����� 
		, COL147					varchar(30)			null -- ����� �������
		, COL148					varchar(255)		null -- ����� ������ 
		, COL149					datetime			null -- ���� �����������
		, COL150					int					null -- ��� �������
		, COL151					datetime			null -- ���� 1
		, COL152					datetime			null -- ���� 2
		, COL153					decimal(28,4)		null -- ���������� ������ % �������
		, COL154					money				null -- ���������� �����
		, COL155					varchar(3)			null -- ��� ������
		, COL156					money				null -- ��������� ����������
		, COL157					varchar(255)		null -- ������ �������������
		, COL158					varchar(19)			null -- ���
		, COL158B					tinyint				null -- yudin 06/08/14 ��������, ��� ���
		, COL159					varchar(20)			null -- ����
		, COL160					varchar(3)			null -- ����
		, COL161					varchar(255)		null -- ��������� ������� �� �������� ����
		, COL162					datetime			null -- ���� ����. ���������
		, COL163					varchar(255)		null -- ����������������
		, COL164					varchar(19)			null -- ���
		, COL164B					tinyint				null -- yudin 06/08/14 ��������, ��� ���
		, COL165					varchar(20)			null -- ����
		, COL166					varchar(3)			null -- ����
		, COL167					varchar(255)		null -- ����������

		-- ��������� 2.3
		, COl169					varchar(255)		null -- ������������������
		, COl170					varchar(19)			null -- ���
		, COl170B					tinyint				null -- yudin 06/08/14 ��������, ��� ���
		, COl171					varchar(20)			null -- ����
		, COL172					varchar(3)			null -- ����
		, COL173					varchar(5)			null -- ��� ���� �.�.
		, COL174					varchar(10)			null -- ����� ����.
		, COL175					varchar(20)			null -- ����� ����.
		, COL176					varchar(20)			null -- ����� ������ 
		, COL177					datetime			null -- ���� �����������
		, COL178					int					null -- ��� ������� �������
		, COL179					datetime			null -- ���� 1
		, COL180					datetime			null -- ���� 2
		, COL181					money				null -- ���������� �����
		, COL182					varchar(3)			null -- ��� ������
		, COL183					datetime			null -- ���� �����������
		, COL184					varchar(255)		null -- ���������
		, COL185					varchar(255)		null -- ����������������
		, COL186					tinyint				null -- ������ ����������������
		, COL187					varchar(19)			null -- ���
		, COL187B					tinyint				null -- yudin 06/08/14 ��������, ��� ���
		, COL188					varchar(20)			null -- ����
		, COL189					varchar(20)			null -- ����
		, COL190					varchar(60)			null -- ����������

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


Select T1.VALUE NAME_TYPE
	, ','+ltrim(rtrim(T2.VALUE))+',' CODE_TYPE
	, ','+ltrim(rtrim(T3.VALUE))+',' CODE_TYPE_PART
	, T4.VALUE TYPE_ACC
into #SETTING_DEPO_ACC_TYPES
from fn_OGO_READ_SETTING_TABLE('���������� ��������������� �������','��������� ����� ������ ��� ����� 711') T1
		join fn_OGO_READ_SETTING_TABLE('���������� ��������������� �������','��������� ����� ������ ��� ����� 711') T2
			join fn_OGO_READ_SETTING_TABLE('���������� ��������������� �������','��������� ����� ������ ��� ����� 711') T3
				join fn_OGO_READ_SETTING_TABLE('���������� ��������������� �������','��������� ����� ������ ��� ����� 711') T4
				on T4.INDEX_ROW = T3.INDEX_ROW
				and T4.INDEX_COLUMN = 3
			on T3.INDEX_ROW = T2.INDEX_ROW
			and T3.INDEX_COLUMN = 2
		on T2.INDEX_ROW = T1.INDEX_ROW
		and T2.INDEX_COLUMN = 1
		and T1.INDEX_COLUMN = 0


exec p711a2017_Part1 @Date, @PrintProt, @NumBranch				-- ������ 1

-- ������ 2

CREATE TABLE #GET_ACC_PAPER_SALDO(
    ID_BALANCE           int          not null,
    ID_PAPER             int          not null,
    SUMMA_BALANCE        money        not null,
    DATE_BALANCE_IN      datetime     not null,
    ID_TRADE_IN          int          not null,

    ID_ACC_OSN           int          not null,
    ID_ACC_PRC           int          null,
    ID_ACC_DISC          int          null,

    SALDO_OSN            money        not null,
    SALDO_PRC            money        null,
    SALDO_DISC           money        null,

    ID_EMITENT           int          not null,
    DATE_EMISSION        datetime     not null,
    DATE_PAYING          datetime     not null,

    PAYOFF_MEANING       varchar(255) null       -- ���� � ������� �������
    , BRANCH			 smallint	  not null 
    )
---------------------------------------------------------------------------------------
exec OGO_GET_ACC_BILL @Date, @NumBranch -- ���������� ���� ��������
---------------------------------------------------------------------------------------

	exec p711aForm_fbill_1_2017 @Date, @SidVersion				-- ������ ���������� 2.1 - �������� �������
	exec p711aForm_fbill_2_2017 @Date, @SidVersion				-- ������ ���������� 2.2 - ����������� �������
	exec p711aForm_fbill_3_2017 @Date,@NumBranch, @SidVersion	-- ������ ���������� 2.3 - ������� �� ��������

DROP TABLE #GET_ACC_PAPER_SALDO

exec p711a2017_Part3 @Date, @NumBranch						-- ������ 3


-- ������ ������ ������, �������� � ������������
Declare @FIELD_OKSM int	select @FIELD_OKSM = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = '��� ������ �����������/�����������')
Declare @FIELD_INDICATION int	select @FIELD_INDICATION = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = '������� �����������')
Declare @FIELD_LICENSE int	select @FIELD_LICENSE = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = '�������� ����������������� ��������� ���')
Declare @FIELD_ACC_NOSTRO_PAPER int	select @FIELD_ACC_NOSTRO_PAPER = (select ID_FIELD from DEPO_EMISSION_ADDFL_DIC where NAME_FIELD = '���. ���� ������ � ����������� �����������')
Declare @FIELD_TIN int	select @FIELD_TIN = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = '����������� ��������� �����.����� (TIN)')

Update SEC 
	  set EMITENT_ID_CLIENT = EMITENT.ID_CLIENT
	, EMITENT_NAME = DEPO_EMITENT.EMITENT_NAME
	, EMITENT_INN =		case isnull(case EMITENT.IS_REZIDENT when 0 then EMITENT_TIN.FIELD else EMITENT.INN end, '')
							when '' then case EMITENT.IS_REZIDENT when 0 then '000' else '0000000000' end + case EMITENT.KIND_CLIENT when 1 then '' else '00' end
							else case EMITENT.IS_REZIDENT when 0 then EMITENT_TIN.FIELD else EMITENT.INN end
						end
	, EMITENT_IS_REZIDENT = case	when EMITENT.KIND_CLIENT = 1 and EMITENT.IS_REZIDENT = 1 then 1
									when EMITENT.KIND_CLIENT = 1 and EMITENT.IS_REZIDENT = 0 then 2
									when EMITENT.KIND_CLIENT = 2 and EMITENT.IS_REZIDENT = 1 then 3
									when EMITENT.KIND_CLIENT = 2 and EMITENT.IS_REZIDENT = 0 then 4
									else 0  end
	, EMITENT_KPP = case EMITENT.IS_REZIDENT when 1 then isnull(EMITENT.KPPU, '') else '' end
	, EMITENT_OGRN = case EMITENT.IS_REZIDENT when 1 then isnull(EMITENT.OGRN, '') else '' end
	, EMITENT_OKSM = case when EMITENT.ID_CLIENT = 0 then '643' when isnull(left(EMITENT_KOD.FIELD, 3), '') = '' then '999' else EMITENT_KOD.FIELD end

	, PAPER_TYPE_CODE = isnull(PAPER_TYPE.SID_TYPE_CB,'OTHER')
	, PAPER_REG_NUM  = case EMITENT.IS_REZIDENT when 1 then isnull(PAPER.PAPER_NUMBER, '') else '' end
	, PAPER_CODE_ISIN = case PAPER_CLASS.SID_CLASS when 'UBS_BILL' then '' else isnull(ISIN.UID_PAPER, '') end
	, PAPER_CURRENCY_CODE = VL.CURRENCY_CB
	, PAPER_NOMINAL = PAPER.NOMINAL
	, PAPER_NOTE = PAPER.PAPER_NOTE
	
	--- ���������� ������ ������������ ����������� ��  ������. ���� �� ����� � ����� �� ����� �� ������, ����� ������ �� ������.
	/*
	, REGISTRATOR_NAME = case when isnull(SEC.REGISTRATOR_NAME, '' ) = '' then  isnull(REGISTRATOR.REDUCE_NAME, '') else SEC.REGISTRATOR_NAME end
	, REGISTRATOR_INDICATION = case when  isnull(SEC.REGISTRATOR_INDICATION,'') = '' then 
								 case when REGISTRATOR.BIC = '044525060' then '�' else left(REGISTRATOR_INDICATION.SENSE_STRING, 1) end 
								 else SEC.REGISTRATOR_INDICATION end	-- ��������� ��������������
	, REGISTRATOR_INN =	case when (LEFT(isnull(SEC.REGISTRATOR_INN, ''), 3) IN ('', '000'))then 
							case isnull(case REGISTRATOR.IS_REZIDENT when 0 then REGISTRATOR_TIN.FIELD else REGISTRATOR.INN end, '')
								when '' then case REGISTRATOR.IS_REZIDENT when 0 then '000' else '0000000000' end + case REGISTRATOR.KIND_CLIENT when 1 then '' else '00' end
								else case REGISTRATOR.IS_REZIDENT when 0 then REGISTRATOR_TIN.FIELD else REGISTRATOR.INN end
							end 
							else SEC.REGISTRATOR_INN end
	, REGISTRATOR_IS_REZIDENT = isnull(REGISTRATOR_IS_REZIDENT,
								case	when REGISTRATOR.KIND_CLIENT = 1 and REGISTRATOR.IS_REZIDENT = 1 then 1
										when REGISTRATOR.KIND_CLIENT = 1 and REGISTRATOR.IS_REZIDENT = 0 then 2
										when REGISTRATOR.KIND_CLIENT = 2 and REGISTRATOR.IS_REZIDENT = 1 then 3
										when REGISTRATOR.KIND_CLIENT = 2 and REGISTRATOR.IS_REZIDENT = 0 then 4
										else 0  
								end )
	, REGISTRATOR_KPP = case when isnull(SEC.REGISTRATOR_KPP,'') = '' 
		 then case REGISTRATOR.IS_REZIDENT when 1 then isnull(REGISTRATOR.KPPU, '') else '' end 
		 else SEC.REGISTRATOR_KPP end
	, REGISTRATOR_OGRN = case when  isnull(SEC.REGISTRATOR_OGRN, '') = '' 
		 then  case REGISTRATOR.IS_REZIDENT when 1 then isnull(REGISTRATOR.OGRN, '') else '' end 
		 else SEC.REGISTRATOR_OGRN end
	, REGISTRATOR_OKSM = case when isnull(SEC.REGISTRATOR_OKSM, '') = ''
			then  case isnull(left(REGISTRATOR_KOD.FIELD, 3), '') when '' then '999' else REGISTRATOR_KOD.FIELD end 
			else SEC.REGISTRATOR_OKSM end
	*/

	, REGISTRATOR_NAME = case when isnull(SEC.REGISTRATOR_NAME, '' ) = '' then  isnull(REGISTRATOR.REDUCE_NAME, '') else SEC.REGISTRATOR_NAME end
	, REGISTRATOR_INDICATION = case when  isnull(SEC.REGISTRATOR_INDICATION,'') = '' then 
								 case when REGISTRATOR.BIC = '044525060' then '�' else left(REGISTRATOR_INDICATION.SENSE_STRING, 1) end 
								 else SEC.REGISTRATOR_INDICATION end	-- ��������� ��������������
	, REGISTRATOR_INN =	case when isnull(SEC.REGISTRATOR_NAME, '' ) = '' then 
							case isnull(case REGISTRATOR.IS_REZIDENT when 0 then REGISTRATOR_TIN.FIELD else REGISTRATOR.INN end, '')
								when '' then case REGISTRATOR.IS_REZIDENT when 0 then '000' else '0000000000' end + case REGISTRATOR.KIND_CLIENT when 1 then '' else '00' end
								else case REGISTRATOR.IS_REZIDENT when 0 then REGISTRATOR_TIN.FIELD else REGISTRATOR.INN end
							end 
							else SEC.REGISTRATOR_INN end
	, REGISTRATOR_IS_REZIDENT = isnull(REGISTRATOR_IS_REZIDENT,
								case	when REGISTRATOR.KIND_CLIENT = 1 and REGISTRATOR.IS_REZIDENT = 1 then 1
										when REGISTRATOR.KIND_CLIENT = 1 and REGISTRATOR.IS_REZIDENT = 0 then 2
										when REGISTRATOR.KIND_CLIENT = 2 and REGISTRATOR.IS_REZIDENT = 1 then 3
										when REGISTRATOR.KIND_CLIENT = 2 and REGISTRATOR.IS_REZIDENT = 0 then 4
										else 0  
								end )
	, REGISTRATOR_KPP = case when isnull(SEC.REGISTRATOR_NAME, '' ) = '' 
		 then case REGISTRATOR.IS_REZIDENT when 1 then isnull(REGISTRATOR.KPPU, '') else '' end 
		 else SEC.REGISTRATOR_KPP end
	, REGISTRATOR_OGRN = case when  isnull(SEC.REGISTRATOR_NAME, '' ) = ''
		 then  case REGISTRATOR.IS_REZIDENT when 1 then isnull(REGISTRATOR.OGRN, '') else '' end 
		 else SEC.REGISTRATOR_OGRN end
	, REGISTRATOR_OKSM = case when isnull(SEC.REGISTRATOR_NAME, '' ) = ''
			then  case isnull(left(REGISTRATOR_KOD.FIELD, 3), '') when '' then '999' else REGISTRATOR_KOD.FIELD end 
			else SEC.REGISTRATOR_OKSM end


	, REGISTRATOR_LICENSE_NUM = case when isnull(SEC.REGISTRATOR_LICENSE_NUM, '') = ''
			then isnull(left(REGISTRATOR_LICENSE_ARRAY.FIELD_STRING, 20), '') 
			else SEC.REGISTRATOR_LICENSE_NUM end
	, NOSTRO_STR_ACCOUNT = case when isnull(SEC.NOSTRO_STR_ACCOUNT,'') = '' then  ACC_REGISTRATOR.STR_ACCOUNT else SEC.NOSTRO_STR_ACCOUNT end
from #SECURITIES SEC
	join DEPO_EMISSION PAPER
		join DEPO_PAPER_TYPES PAPER_TYPE
			join DEPO_PAPER_CLASS PAPER_CLASS
			on PAPER_CLASS.ID_CLASS = PAPER_TYPE.ID_CLASS
		on PAPER_TYPE.ID_PAPER_TYPE = PAPER.ID_PAPER_TYPE

		join DEPO_EMITENT DEPO_EMITENT
			join CLIENTS EMITENT
				left join CLIENTS_ADDFL_STRING EMITENT_KOD 
				on EMITENT_KOD.ID_OBJECT = EMITENT.ID_CLIENT
				and EMITENT_KOD.ID_FIELD = @FIELD_OKSM

				left join CLIENTS_ADDFL_STRING EMITENT_TIN
				on EMITENT_TIN.ID_OBJECT = EMITENT.ID_CLIENT
				and EMITENT_TIN.ID_FIELD = @FIELD_TIN
			on EMITENT.ID_CLIENT=  DEPO_EMITENT.ID_CLIENT
		on DEPO_EMITENT.ID_EMITENT = PAPER.ID_EMITENT

		join COM_CURRENCY VL
		on VL.ID_CURRENCY = PAPER.ID_CURRENCY

		left join DEPO_EMISSION_CODE ISIN
		on ISIN.ID_PAPER = PAPER.ID_PAPER

		left join DEPO_EMISSION_ADDFL_STRING ACC_NOSTRO
			join DEPO_ACCOUNTS4 ACC_REGISTRATOR
				join DEPO_PART PART_REGISTRATOR
					join DEPO_ACC DEPO_REGISTRATOR
						join CLIENTS REGISTRATOR
							left join CLIENTS_ADDFL_STRING REGISTRATOR_KOD 
							on REGISTRATOR_KOD.ID_OBJECT = REGISTRATOR.ID_CLIENT
							and REGISTRATOR_KOD.ID_FIELD = @FIELD_OKSM

							left join CLIENTS_ADDFL_STRING REGISTRATOR_TIN
							on REGISTRATOR_TIN.ID_OBJECT = REGISTRATOR.ID_CLIENT
							and REGISTRATOR_TIN.ID_FIELD = @FIELD_TIN

							left join CLIENTS_ADDFL_INT REGISTRATOR_I
								join CLIENTS_ADDFL_SENSE REGISTRATOR_INDICATION
								on REGISTRATOR_INDICATION.ID_FIELD = REGISTRATOR_I.ID_FIELD
								and REGISTRATOR_INDICATION.SENSE_INT = REGISTRATOR_I.FIELD
							on REGISTRATOR_I.ID_FIELD = @FIELD_INDICATION 
							and REGISTRATOR_I.ID_OBJECT = REGISTRATOR.ID_CLIENT

							left join CLIENTS_ADDFL_ARRAY REGISTRATOR_LICENSE_ARRAY
							on REGISTRATOR_LICENSE_ARRAY.ID_OBJECT = REGISTRATOR.ID_CLIENT
							and REGISTRATOR_LICENSE_ARRAY.ID_FIELD = @FIELD_LICENSE
							and REGISTRATOR_LICENSE_ARRAY.INDEX_COLUMN = 0 and REGISTRATOR_LICENSE_ARRAY.INDEX_ROW = 0
						on REGISTRATOR.ID_CLIENT = DEPO_REGISTRATOR.ID_CLIENT
					on DEPO_REGISTRATOR.ID_ACC = PART_REGISTRATOR.ID_ACC
				on PART_REGISTRATOR.ID_PART = ACC_REGISTRATOR.ID_PART
			on ACC_REGISTRATOR.STR_ACCOUNT = ACC_NOSTRO.FIELD
		on ACC_NOSTRO.ID_OBJECT = PAPER.ID_PAPER
		and ACC_NOSTRO.ID_FIELD = @FIELD_ACC_NOSTRO_PAPER
	on PAPER.ID_PAPER = SEC.ID_PAPER
where PART in (1,3) -- and LAYER = 1

-- ��� ���� �������������� ������ - ����������
Update SEC set DEPO_OWNER_SECTOR = 'S124'
	, EMITENT_INN =		case isnull(case UK_CLIENT.IS_REZIDENT when 0 then UK_CLIENT_TIN.FIELD else UK_CLIENT.INN end, '')
							when '' then case UK_CLIENT.IS_REZIDENT when 0 then '000' else '0000000000' end + case UK_CLIENT.KIND_CLIENT when 1 then '' else '00' end
							else case UK_CLIENT.IS_REZIDENT when 0 then UK_CLIENT_TIN.FIELD else UK_CLIENT.INN end
						end
	, EMITENT_IS_REZIDENT = case	when UK_CLIENT.KIND_CLIENT = 1 and UK_CLIENT.IS_REZIDENT = 1 then 1
									when UK_CLIENT.KIND_CLIENT = 1 and UK_CLIENT.IS_REZIDENT = 0 then 2
									when UK_CLIENT.KIND_CLIENT = 2 and UK_CLIENT.IS_REZIDENT = 1 then 3
									when UK_CLIENT.KIND_CLIENT = 2 and UK_CLIENT.IS_REZIDENT = 0 then 4
									else 0  end
	, EMITENT_KPP = case UK_CLIENT.IS_REZIDENT when 1 then isnull(UK_CLIENT.KPPU, '') else '' end
	, EMITENT_OGRN = case UK_CLIENT.IS_REZIDENT when 1 then isnull(UK_CLIENT.OGRN, '') else '' end
from #SECURITIES SEC
	left join DEPO_EMISSION_ADDFL_INT UK
		join CLIENTS UK_CLIENT
			left join CLIENTS_ADDFL_STRING UK_CLIENT_TIN
			on UK_CLIENT_TIN.ID_OBJECT = UK_CLIENT.ID_CLIENT
			and UK_CLIENT_TIN.ID_FIELD = @FIELD_TIN
		on UK_CLIENT.ID_CLIENT = UK.FIELD
	on UK.ID_OBJECT = SEC.ID_PAPER
	and UK.ID_FIELD = (Select ID_FIELD from DEPO_EMISSION_ADDFL_DIC where NAME_FIELD = '����������� ��������')
where SEC.PAPER_TYPE_CODE = 'SHS8'

-------------------------------------------- -------------------------------------------- 
--- {85726} ���� �� ����� ������������ ����������� (�. 86-91), �� ������ ������
UPDATE #SECURITIES
    SET REGISTRATOR_INN = '',
    REGISTRATOR_KPP = '',
    REGISTRATOR_OGRN = '',
    REGISTRATOR_OKSM = ''
WHERE REGISTRATOR_NAME = ''
-------------------------------------------- �����������-------------------------------------------

-- ���������� ��������� ���������� ���
Insert into #SECURITIES(LAYER, BRANCH, PART, SUBPART, PAPER_TYPE_CODE, PAPER_CURRENCY_CODE ,EMITENT_OKSM
		,REGISTRATOR_NAME,REGISTRATOR_INN,REGISTRATOR_IS_REZIDENT,REGISTRATOR_INDICATION,REGISTRATOR_KPP
		,REGISTRATOR_LICENSE_NUM, REGISTRATOR_OGRN,REGISTRATOR_OKSM
	, PAPER_NOMINAL, PAPER_COUNT, COL74, COL75, COl76, COl79,COL80, COL81, COl82, COl83, COl84, COl85,
	COl102, COl202, COl203, COl204, COl205)
	Select 2 LAYER, BRANCH, PART, SUBPART, PAPER_TYPE_CODE, PAPER_CURRENCY_CODE, EMITENT_OKSM
		,REGISTRATOR_NAME,REGISTRATOR_INN,REGISTRATOR_IS_REZIDENT,REGISTRATOR_INDICATION,REGISTRATOR_KPP
		,REGISTRATOR_LICENSE_NUM, REGISTRATOR_OGRN,REGISTRATOR_OKSM
		, SUM(PAPER_NOMINAL) as PAPER_NOMINAL, sum(PAPER_COUNT) PAPER_COUNT
		, sum(COL74) COL74, sum(COL75) COL75, sum(COl76) COl76, sum(COl79) COl79, sum(COL80) COL80,sum(COL81) COL81, sum(COl82) COl82, 
		  sum(COl83) COl83, sum(COl84) COl84, sum(COl85) COl85,
		 sum(COl102) COl102, sum(COl202) COl202, sum(COl203) COl203, sum(COl204) COl204, sum(COl205) COl205
	from #SECURITIES SEC
	where SEC.PAPER_TYPE_CODE = 'ENC'
	and LAYER = 1
	group by BRANCH, PART, SUBPART, PAPER_TYPE_CODE, PAPER_CURRENCY_CODE,EMITENT_OKSM
	,REGISTRATOR_NAME,REGISTRATOR_INN,REGISTRATOR_IS_REZIDENT,REGISTRATOR_INDICATION,REGISTRATOR_KPP
		,REGISTRATOR_LICENSE_NUM, REGISTRATOR_OGRN,REGISTRATOR_OKSM

Delete #SECURITIES
where PAPER_TYPE_CODE = 'ENC'
and LAYER = 1 


Insert into #SECURITIES(LAYER, BRANCH, PART, SUBPART, PAPER_TYPE_CODE, PAPER_CURRENCY_CODE, EMITENT_OKSM
		,REGISTRATOR_NAME,REGISTRATOR_INN,REGISTRATOR_IS_REZIDENT,REGISTRATOR_INDICATION,REGISTRATOR_KPP
		,REGISTRATOR_LICENSE_NUM, REGISTRATOR_OGRN,REGISTRATOR_OKSM
	, PAPER_NOMINAL, PAPER_COUNT, COl74, COl75, COl76, COl79,COL80, COL81, COl82, COl83, COl84, COl85,COl102
	, COl202, COl203, COl204, COl205
	, EMITENT_NAME
	, EMITENT_INN, EMITENT_IS_REZIDENT)
Select 1 LAYER, BRANCH, PART, SUBPART, PAPER_TYPE_CODE, PAPER_CURRENCY_CODE ,EMITENT_OKSM
		,REGISTRATOR_NAME,REGISTRATOR_INN,REGISTRATOR_IS_REZIDENT,REGISTRATOR_INDICATION,REGISTRATOR_KPP
		,REGISTRATOR_LICENSE_NUM, REGISTRATOR_OGRN,REGISTRATOR_OKSM
	, PAPER_NOMINAL, PAPER_COUNT, COl74, COl75, COl76, COl79,COL80, COL81, COl82, COl83, COl84, COl85,COl102
	, COl202, COl203, COl204, COl205
	, '���������� ����' EMITENT_NAME
	, '000000000000' EMITENT_INN, 3 EMITENT_IS_REZIDENT
from #SECURITIES SEC where SEC.LAYER = 2

-- ���������� �������
Insert into #SECURITIES(LAYER, BRANCH, PART, SUBPART, DEPO_OWNER_SECTOR, EMITENT_ID_CLIENT, EMITENT_NAME, EMITENT_INN, EMITENT_IS_REZIDENT, EMITENT_KPP
		,REGISTRATOR_NAME,REGISTRATOR_INN,REGISTRATOR_IS_REZIDENT,REGISTRATOR_INDICATION,REGISTRATOR_KPP
		,REGISTRATOR_LICENSE_NUM, REGISTRATOR_OGRN,REGISTRATOR_OKSM
		, EMITENT_OGRN, EMITENT_OKSM, PAPER_TYPE_CODE, PAPER_CURRENCY_CODE, PAPER_NOMINAL, PAPER_COUNT
		, COl74, COl75, COl76, COl77, COl79,COL80, COL81, COl82, COl83, COl84, COl85, COl102, COl202, COl203, COl204, COl205 )
	Select 2 LAYER, BRANCH, PART, SUBPART, DEPO_OWNER_SECTOR, EMITENT_ID_CLIENT, EMITENT_NAME, EMITENT_INN, EMITENT_IS_REZIDENT, EMITENT_KPP
		,REGISTRATOR_NAME,REGISTRATOR_INN,REGISTRATOR_IS_REZIDENT,REGISTRATOR_INDICATION,REGISTRATOR_KPP
		,REGISTRATOR_LICENSE_NUM, REGISTRATOR_OGRN,REGISTRATOR_OKSM
		, EMITENT_OGRN, EMITENT_OKSM, PAPER_TYPE_CODE
		, PAPER_CURRENCY_CODE, PAPER_NOMINAL
		, sum(PAPER_COUNT) PAPER_COUNT
		, sum(COl74) COl74, sum(COl75) COl75, sum(COl76) COl76, sum(COl77), sum(COl79) COl79,sum(COL80) COL80,sum(COL81) COL81, sum(COl82) COl82, 
		  sum(COl83) COl83, sum(COl84) COl84, sum(COl85) COl85
		, sum(COl102) COl102, sum(COl202) COl202, sum(COl203) COl203, sum(COl204) COl204, sum(COl205) COl205
	from #SECURITIES SEC
	where left(SEC.PAPER_TYPE_CODE, 3) = 'BIL'
	and LAYER = 1
	group by BRANCH, PART, SUBPART, DEPO_OWNER_SECTOR, EMITENT_ID_CLIENT, EMITENT_NAME, EMITENT_INN, EMITENT_IS_REZIDENT, EMITENT_KPP
		,REGISTRATOR_NAME,REGISTRATOR_INN,REGISTRATOR_IS_REZIDENT,REGISTRATOR_INDICATION,REGISTRATOR_KPP
		,REGISTRATOR_LICENSE_NUM, REGISTRATOR_OGRN,REGISTRATOR_OKSM
		, EMITENT_OGRN, EMITENT_OKSM, PAPER_TYPE_CODE
		, PAPER_CURRENCY_CODE, PAPER_NOMINAL

Delete #SECURITIES
where left(PAPER_TYPE_CODE, 3) = 'BIL'
and LAYER = 1

Insert into #SECURITIES(LAYER, BRANCH, PART, SUBPART, DEPO_OWNER_SECTOR, EMITENT_ID_CLIENT, EMITENT_NAME, EMITENT_INN, EMITENT_IS_REZIDENT, EMITENT_KPP
		,REGISTRATOR_NAME,REGISTRATOR_INN,REGISTRATOR_IS_REZIDENT,REGISTRATOR_INDICATION,REGISTRATOR_KPP
		,REGISTRATOR_LICENSE_NUM, REGISTRATOR_OGRN,REGISTRATOR_OKSM
		, EMITENT_OGRN, EMITENT_OKSM, PAPER_TYPE_CODE, PAPER_CURRENCY_CODE, PAPER_NOMINAL, PAPER_COUNT
		, COl74, COl75, COl76, COl77, COl79,COL80, COL81, COl82, COl83, COl84, COl85, COl102, COl202, COl203, COl204, COl205)
	Select 1 LAYER, BRANCH, PART, SUBPART, DEPO_OWNER_SECTOR, EMITENT_ID_CLIENT, EMITENT_NAME, EMITENT_INN, EMITENT_IS_REZIDENT, EMITENT_KPP
		,REGISTRATOR_NAME,REGISTRATOR_INN,REGISTRATOR_IS_REZIDENT,REGISTRATOR_INDICATION,REGISTRATOR_KPP
		,REGISTRATOR_LICENSE_NUM, REGISTRATOR_OGRN,REGISTRATOR_OKSM
		, EMITENT_OGRN, EMITENT_OKSM, PAPER_TYPE_CODE, PAPER_CURRENCY_CODE, PAPER_NOMINAL, PAPER_COUNT
		, COl74, COl75, COl76, COl77, COl79,COL80, COL81, COl82, COl83, COl84, COl85, COl102, COl202, COl203, COl204, COl205
	from #SECURITIES SEC
	where SEC.LAYER = 2 and left(SEC.PAPER_TYPE_CODE, 3) = 'BIL'

----------------------------------------------------------------------------------------------------------------------------

-- ��������� ����������� �������� ������ �����
Update P set P.PAPER_NOMINAL = isnull((
	Select top 1 cast(AMORT_VALUE.FIELD_DECIMAL as money) NOMINAL_AMORTIZATED
	from #SECURITIES P_IN
		join DEPO_EMISSION_ADDFL_ARRAY AMORT_DATE
			join DEPO_EMISSION_ADDFL_ARRAY AMORT_VALUE
			on AMORT_VALUE.ID_OBJECT = AMORT_DATE.ID_OBJECT
			and AMORT_VALUE.ID_FIELD = AMORT_DATE.ID_FIELD
			and AMORT_VALUE.INDEX_ROW = AMORT_DATE.INDEX_ROW
			AND AMORT_VALUE.INDEX_COLUMN = 1
		on AMORT_DATE.ID_OBJECT = P_IN.ID_PAPER
		and AMORT_DATE.INDEX_COLUMN = 0
		and AMORT_DATE.ID_FIELD = (Select ID_FIELD from DEPO_EMISSION_ADDFL_DIC where NAME_FIELD = '����������� ��������')
		AND AMORT_DATE.FIELD_DATE < @Date
	where P_IN.ID_PAPER = P.ID_PAPER
	order by P_IN.ID_PAPER, AMORT_DATE.FIELD_DATE desc, AMORT_VALUE.FIELD_DECIMAL asc
), P.PAPER_NOMINAL) 
from #SECURITIES P
where PAPER_TYPE_CODE <> 'ENC'


-- ��������� ����� � �����������
Declare @Branch smallint, @Subpart varchar(3), @LAYER tinyint
Declare @i int

Declare #SUBPARTS insensitive cursor for

Select distinct SEC.BRANCH, SUB.SUBPART, SUB.LAYER
from #SECURITIES SEC
	cross join (
					Select '1.1' SUBPART, 1 LAYER
		union all	Select '1.2', 1
		union all	Select '1.3', 1
		union all	Select '1.4', 1
		union all	Select '2.1', 0
		union all	Select '2.2', 0
		union all	Select '2.3', 0
		union all	Select '3.0', 1
	) SUB

open #SUBPARTS
fetch #SUBPARTS into @Branch, @Subpart, @LAYER

while @@FETCH_STATUS = 0
begin
	Select @i = 0

	Update #SECURITIES set NUM_ROW = @i, @i = @i+1
	where BRANCH = @Branch
	and SUBPART = @Subpart
	and LAYER = @LAYER

	fetch #SUBPARTS into @Branch, @Subpart, @LAYER
end

close #SUBPARTS
Deallocate #SUBPARTS

--- �� ��������� {85944} � ��������� ������ � �������� ������ �������� �������� 810
UPDATE #SECURITIES 
    SET PAPER_CURRENCY_CODE = CASE WHEN PAPER_CURRENCY_CODE = '810' THEN '643' ELSE PAPER_CURRENCY_CODE END

-- ����� � ������� #SECURITIES ����� ��������� � ������� ������

exec Forms_cb711_2017 @Date, @NumBranch, 'PUT'

Delete FORMA711_RAS where DATE_CALC = @Date and (BRANCH = @NumBranch or @NumBranch = 0)

Insert into FORMA711_RAS
	Select @Date DATE_CALC,BRANCH, PART, SUBPART, ID_ACCOUNT, ID_CLIENT_OWNER, DEPO_ACC_TYPE, DEPO_OWNER_SECTOR
		, ID_PAPER, PAPER_COUNT, PAPER_NOMINAL, PAPER_CURRENCY_CODE, PAPER_TYPE_CODE
		, EMITENT_ID_CLIENT, EMITENT_NAME
		, REGISTRATOR_NAME, NOSTRO_STR_ACCOUNT
	from #SECURITIES 
	where LAYER = 0 and PART = 1 order by BRANCH, SUBPART

Insert into FORMA711_RAS(DATE_CALC, BRANCH, PART, SUBPART, ID_PAPER, PAPER_COUNT, ID_ACCOUNT, DEPO_ACC_TYPE
		, PAPER_NOMINAL, PAPER_CURRENCY_CODE, PAPER_TYPE_CODE, EMITENT_ID_CLIENT, EMITENT_NAME, REGISTRATOR_NAME, NOSTRO_STR_ACCOUNT)
	Select @Date DATE_CALC, BRANCH, PART, SUBPART
		, ID_PAPER
		, cast(COl202 as decimal(28,12)) PAPER_COUNT
		, TRADE_ID ID_ACCOUNT
		, '168' DEPO_ACC_TYPE
		, PAPER_NOMINAL, PAPER_CURRENCY_CODE, PAPER_TYPE_CODE
		, EMITENT_ID_CLIENT, EMITENT_NAME
		, REGISTRATOR_NAME, NOSTRO_STR_ACCOUNT
	from #SECURITIES 
	where LAYER = 0 and PART = 3 and COl202 <> 0
	order by BRANCH, SUBPART

Insert into FORMA711_RAS(DATE_CALC, BRANCH, PART, SUBPART, ID_PAPER, PAPER_COUNT, ID_ACCOUNT, DEPO_ACC_TYPE
		, PAPER_NOMINAL, PAPER_CURRENCY_CODE, PAPER_TYPE_CODE, EMITENT_ID_CLIENT, EMITENT_NAME, REGISTRATOR_NAME, NOSTRO_STR_ACCOUNT)
	Select @Date DATE_CALC, BRANCH, PART, SUBPART
		, ID_PAPER
		, cast(COl203 as decimal(28,12)) PAPER_COUNT
		, TRADE_ID ID_ACCOUNT
		, '169' DEPO_ACC_TYPE
		, PAPER_NOMINAL, PAPER_CURRENCY_CODE, PAPER_TYPE_CODE
		, EMITENT_ID_CLIENT, EMITENT_NAME
		, REGISTRATOR_NAME, NOSTRO_STR_ACCOUNT
	from #SECURITIES 
	where LAYER = 0 and PART = 3 and COl203 <> 0
	order by BRANCH, SUBPART

Insert into FORMA711_RAS(DATE_CALC, BRANCH, PART, SUBPART, ID_PAPER, PAPER_COUNT, ID_ACCOUNT, DEPO_ACC_TYPE
		, PAPER_NOMINAL, PAPER_CURRENCY_CODE, PAPER_TYPE_CODE, EMITENT_ID_CLIENT, EMITENT_NAME, REGISTRATOR_NAME, NOSTRO_STR_ACCOUNT)
	Select @Date DATE_CALC, BRANCH, PART, SUBPART
		, ID_PAPER
		, cast(COl204 as decimal(28,12)) PAPER_COUNT
		, TRADE_ID ID_ACCOUNT
		, '170' DEPO_ACC_TYPE
		, PAPER_NOMINAL, PAPER_CURRENCY_CODE, PAPER_TYPE_CODE
		, EMITENT_ID_CLIENT, EMITENT_NAME
		, REGISTRATOR_NAME, NOSTRO_STR_ACCOUNT
	from #SECURITIES 
	where LAYER = 0 and PART = 3 and COl204 <> 0
	order by BRANCH, SUBPART

Insert into FORMA711_RAS(DATE_CALC, BRANCH, PART, SUBPART, ID_PAPER, PAPER_COUNT, ID_ACCOUNT, DEPO_ACC_TYPE
		, PAPER_NOMINAL, PAPER_CURRENCY_CODE, PAPER_TYPE_CODE, EMITENT_ID_CLIENT, EMITENT_NAME, REGISTRATOR_NAME, NOSTRO_STR_ACCOUNT)
	Select @Date DATE_CALC, BRANCH, PART, SUBPART
		, ID_PAPER
		, cast(COl205 as decimal(28,12)) PAPER_COUNT
		, TRADE_ID ID_ACCOUNT
		, '171' DEPO_ACC_TYPE
		, PAPER_NOMINAL, PAPER_CURRENCY_CODE, PAPER_TYPE_CODE
		, EMITENT_ID_CLIENT, EMITENT_NAME
		, REGISTRATOR_NAME, NOSTRO_STR_ACCOUNT
	from #SECURITIES 
	where LAYER = 0 and PART = 3 and COl205 <> 0
	order by BRANCH, SUBPART

Insert into FORMA711_RAS(DATE_CALC, BRANCH, PART, SUBPART, ID_PAPER, PAPER_COUNT, ID_ACCOUNT, ID_CLIENT_OWNER, DEPO_ACC_TYPE
		, PAPER_NOMINAL, PAPER_CURRENCY_CODE, PAPER_TYPE_CODE, EMITENT_ID_CLIENT, EMITENT_NAME, REGISTRATOR_NAME, NOSTRO_STR_ACCOUNT)
	Select @Date DATE_CALC, BRANCH, PART, SUBPART
		, ID_PAPER
		, PAPER_COUNT
		, ID_ACCOUNT
		, ID_CLIENT_OWNER
		, cast(NUM_COLUMN as varchar(3)) DEPO_ACC_TYPE
		, PAPER_NOMINAL, PAPER_CURRENCY_CODE, PAPER_TYPE_CODE
		, EMITENT_ID_CLIENT, EMITENT_NAME
		, REGISTRATOR_NAME, NOSTRO_STR_ACCOUNT
	from #SECURITIES
	where LAYER = 0 and PART = 3 and NUM_COLUMN between 172 and 176
	order by BRANCH, SUBPART


Select	'������ ����� 711 �� '+convert(varchar(10), @Date, 104)+' ��������.' +char(10)
	+	'����������� ������� �� �������� 1 � 3'
	+	' ��������� � ������ "����� �711. ������������ ������" ' REZULT


Drop table #SECURITIES
Drop table #SETTING_DEPO_ACC_TYPES

GO
