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
		, COL74						decimal(28,12)		null   -- ���-�� �.�.
		, COL75						decimal(28,12)		null
		, COL76						decimal(28,12)		null
		, COL77						decimal(28,12)		null
		, COL78						decimal(28,12)		null
		, COL79						decimal(28,12)		null
		, COL80						decimal(28,12)		null
		, COL81						decimal(28,12)		null
		, COL82						decimal(28,12)		null
		, COL83						decimal(28,12)		null
		, COL84						decimal(28,12)		null
		, COL85						decimal(28,12)		null

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
		)

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

	PAYOFF_TYPE          tinyint      null,      -- ��� ������� ������� �� ������� (saa 08.02.2017)
    PAYOFF_MEANING       varchar(255) null       -- ���� � ������� �������
    , BRANCH			 smallint	  not null 
    )

	Go


if exists (select * from sysobjects where id = object_id('dbo.p711aForm_fbill_1_2017') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure dbo.p711aForm_fbill_1_2017
go

create proc dbo.p711aForm_fbill_1_2017(
	  @Date datetime
	, @SidVersion varchar(50)
	)
as

set nocount on

-- ������ ���������� 2.1
---------------------------------------------------------------------------------------
-- ��������� 2.1. �������� ��������� ������������ �������
---------------------------------------------------------------------------------------
create table #tmp_fact(
    ID                int          identity,

    -- ���������� ����
    ID_BALANCE        int          not null,
    DATE_BALANCE_IN   datetime     not null,
    SUMMA_BALANCE     money        not null,
    SALDO_OSN         money        not null,
    SALDO_PRC         money        not null,
    SALDO_DISC        money        not null,
    BAL2_OSN          char(5)      not null,

    -- ������ ������
    ID_PAPER          int          not null,
    PAPER_SERIES      varchar(10)  not null,
    PAPER_NUMBER      varchar(30)  not null,
    PAPER_NOTE        varchar(255)  not null,
    DATE_EMISSION     datetime     not null,
    NOMINAL           money        not null,
    STR_NUM_BLANK     varchar(255) not null default '',

    SID_TYPE_CB       varchar(5)   not null,
    PAYOFF_MEANING    varchar(255) not null, -- ���� � ������� �������
    CURRENCY_CB       char(3)      not null,
	RISK_GROUP		  tinyint      null,     -- [123] -  ��������� �������� �������

    -- ����� � ������
    ID_CURRENCY       smallint     not null,
    SUMMA_BALANCE_RUR money        not null,
    SALDO_OSN_RUR     money        not null,
    SALDO_PRC_RUR     money        not null,
    SALDO_DISC_RUR    money        not null,
	SALDO_RESERVE	  money        null,    -- [124] - �������������� ������
	SUMMA_BAI_IN_RUR  money        null,    -- [120] - ���������� ��������� �� ������ ������� 

    -- ������������� (�������)
    ID_EMITENT        int          not null,
    EMITENT_NAME      varchar(255) not null,
    INN_ET            varchar(19)  not null
	, OGRN_ET		varchar(20)		not null
	, OKSM_ET		varchar(3)		not null
	,  IS_REZIDENT_ET tinyint	null,						--yudin

    -- ������������ (������)
    ID_TRADE_IN       int          not null,
    TRADE_IN_NUM      varchar(20)  not null,
    TRADE_IN_DATE     datetime     not null,
    TRADE_IN_MEANING  varchar(255) not null, -- ������� ������������

    -- ������������ (����������)
    CONTRAGENT_NAME   varchar(160) not null,
    INN_CONTR         varchar(19)  not null
	, OGRN_CONTR	varchar(20)		not null
	, OKSM_CONTR	varchar(3)		not null
	,  IS_REZIDENT_CONTR tinyint	null,					--yudin

	-- ������� ������
    ID_TRADE_OUT	INT			   NULL,
	TRADE_OUT_NUM      varchar(20) null,
	TRADE_OUT_DATE     datetime    null,
	TRADE_OUT_MEANING  varchar(255)null, -- ������� �������

	-- ������� (����������)
	  CONTRAGENT_NAME_OUT	   varchar(160)  null,
	  INN_CONTR_OUT			   varchar(19)   null
	, OGRN_CONTR_OUT		   varchar(20)	 null
	, OKSM_CONTR_OUT		   varchar(3)	 null
	, IS_REZIDENT_CONTR_OUT	   tinyint	null,	
	--- ����� �������
	SUMMA_OUT			money       null,
	DATE_BALANCE_OUT   datetime     null,  -- ���� �������� � �������

    -- ��������
    CLIENT_NAME       varchar(160) not null default '',
    INN_CLIENT        varchar(19)  not null default ''
	, OGRN_CLIENT 	varchar(20)			null
	, OKSM_CLIENT 	varchar(3)			null
	,  IS_REZIDENT_CLIENT tinyint null,						--yudin
    CLIENT_MEANING    varchar(255) not null default ''
    , BRANCH		  smallint     not null 
    )
---------------------------------------------------------------------------------------
declare @ID_FIELD_KOD int	select @ID_FIELD_KOD = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = '��� ������ �����������/�����������')
Declare @FIELD_TIN int		select @FIELD_TIN = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = '����������� ��������� �����.����� (TIN)')
declare @ID_FIELD_OSN int	select @ID_FIELD_OSN = (select ID_FIELD from BILL_TRADES_ADDFL_DIC where NAME_FIELD = '��������� ���������� ������')

insert into #tmp_fact(
    -- ���������� ����
    ID_BALANCE,DATE_BALANCE_IN,SUMMA_BALANCE,SALDO_OSN,SALDO_PRC,SALDO_DISC,BAL2_OSN,

    -- ������ ������
    ID_PAPER,PAPER_SERIES,PAPER_NUMBER,PAPER_NOTE,DATE_EMISSION,NOMINAL,
    SID_TYPE_CB,PAYOFF_MEANING,CURRENCY_CB,

    -- ����� � ������
    ID_CURRENCY,SUMMA_BALANCE_RUR,SALDO_OSN_RUR,SALDO_PRC_RUR,SALDO_DISC_RUR,

    -- ������������� (�������)
    ID_EMITENT,EMITENT_NAME,INN_ET
	, OGRN_ET, OKSM_ET, IS_REZIDENT_ET, --yudin
                               
    -- ������������ (������)
    ID_TRADE_IN,TRADE_IN_NUM,TRADE_IN_DATE,TRADE_IN_MEANING,

    -- ������������ (����������)
    CONTRAGENT_NAME,INN_CONTR
	, OGRN_CONTR, OKSM_CONTR , IS_REZIDENT_CONTR --yudin
    , BRANCH 

    )

select    
    -- ���������� ����
    T.ID_BALANCE,T.DATE_BALANCE_IN,T.SUMMA_BALANCE,T.SALDO_OSN,T.SALDO_PRC,T.SALDO_DISC,A_OSN.BAL2,

    -- ������ ������
    T.ID_PAPER,isnull(EM.PAPER_SERIES,''),isnull(EM.PAPER_NUMBER,''),isnull(EM.PAPER_NOTE,''),EM.DATE_EMISSION,EM.NOMINAL,
    isnull(PT.SID_TYPE_CB,'OTHER') SID_TYPE_CB,isnull(T.PAYOFF_MEANING,''),VL.CURRENCY_CB,

    -- ����� � ������
    EM.ID_CURRENCY,
    round(SUMMA_BALANCE * R.RATE,2) SUMMA_BALANCE_RUR,
    round(SALDO_OSN  * R.RATE,2) SALDO_OSN_RUR,
    round(SALDO_PRC  * R.RATE,2) SALDO_PRC_RUR,
    round(SALDO_DISC * R.RATE,2) SALDO_DISC_RUR,

    -- ������������� (�������)
    T.ID_EMITENT,ET.EMITENT_NAME,
    case 
        when CL_ET.IS_REZIDENT = 0 and @Date > '20100101' 
        then isnull(left(ltrim(CL_ET_KOD.FIELD),3),'999') 
        else
            case 
                when ltrim(isnull(case CL_ET.IS_REZIDENT when 0 then CL_ET_TIN.FIELD else CL_ET.INN end, '')) = '' 
					then replicate('0',case when CL_ET.KIND_CLIENT = 1 then 10 else 12 end)
                else left(case CL_ET.IS_REZIDENT when 0 then CL_ET_TIN.FIELD else CL_ET.INN end,19) 
            end
    end INN_ET
	, case CL_ET.IS_REZIDENT when 1 then isnull(CL_ET.OGRN, '') else '' end OGRN_ET
	, case isnull(left(CL_ET_KOD.FIELD, 3), '') when '' then '999' else CL_ET_KOD.FIELD end OKSM_ET
	, case	when CL_ET.KIND_CLIENT = 1 and CL_ET.IS_REZIDENT = 1 then 1
			when CL_ET.KIND_CLIENT = 1 and CL_ET.IS_REZIDENT = 0 then 2
			when CL_ET.KIND_CLIENT = 2 and CL_ET.IS_REZIDENT = 1 then 3
			when CL_ET.KIND_CLIENT = 2 and CL_ET.IS_REZIDENT = 0 then 4
			else 0 end IS_REZIDENT_ET --yudin 06/08/14
			
    -- ������������ (������)
    , T.ID_TRADE_IN,TR.TRADE_NUM,TR.DATE_TRN,
    isnull(TR_OSN.FIELD_STRING,'')+' N '+TR.TRADE_NUM+' �� '+convert(varchar(10),TR.DATE_TRN,104) TRADE_IN_MEANING,

    -- ������������ (����������)
    CL_CONTR.REDUCE_NAME,
    case 
        when ltrim(isnull(case CL_CONTR.IS_REZIDENT when 0 then CL_CONTR_TIN.FIELD else CL_CONTR.INN end, '')) = '' 
			then replicate('0',case when CL_CONTR.KIND_CLIENT = 1 then 10 else 12 end) 
        else left(case CL_CONTR.IS_REZIDENT when 0 then CL_CONTR_TIN.FIELD else CL_CONTR.INN end,19)
    end INN_CONTR
	, case CL_CONTR.IS_REZIDENT when 1 then isnull(CL_CONTR.OGRN, '') else '' end OGRN_CONTR
	, case isnull(left(CL_CONTR_KOD.FIELD, 3), '') when '' then '999' else CL_CONTR_KOD.FIELD end OKSM_CONTR
	, case	when CL_CONTR.KIND_CLIENT = 1 and CL_CONTR.IS_REZIDENT = 1 then 1
			when CL_CONTR.KIND_CLIENT = 1 and CL_CONTR.IS_REZIDENT = 0 then 2
			when CL_CONTR.KIND_CLIENT = 2 and CL_CONTR.IS_REZIDENT = 1 then 3
			when CL_CONTR.KIND_CLIENT = 2 and CL_CONTR.IS_REZIDENT = 0 then 4 
			else 0 end IS_REZIDENT_CONTR -- yudin 06/08/14
    , DIV.NUMBRANCH

from #GET_ACC_PAPER_SALDO T,
	OD_ACCOUNTS0 A_OSN,
    DEPO_EMISSION EM,
	DEPO_PAPER_TYPES PT,
	COM_CURRENCY VL,
	COM_RATES_CB R,
    DEPO_EMITENT ET,

    CLIENTS CL_ET
		left join CLIENTS_ADDFL_STRING CL_ET_KOD on CL_ET_KOD.ID_OBJECT = CL_ET.ID_CLIENT and CL_ET_KOD.ID_FIELD = @ID_FIELD_KOD

		left join CLIENTS_ADDFL_STRING CL_ET_TIN on CL_ET_TIN.ID_OBJECT = CL_ET.ID_CLIENT and CL_ET_TIN.ID_FIELD = @FIELD_TIN
    , BILL_TRADES_BASE TR
		left join BILL_TRADES_ADDFL TR_OSN on TR_OSN.ID_OBJECT = TR.ID_TRADE and TR_OSN.ID_FIELD = @ID_FIELD_OSN
		join UBS_DIVISION DIV on DIV.NUM_DIVISION = TR.NUM_DIVISION

	, BILL_TRADES_OWN TR_OWN,BILL_CONTRACT TR_CONTR
	, CLIENTS CL_CONTR
		left join CLIENTS_ADDFL_STRING CL_CONTR_KOD on CL_CONTR_KOD.ID_OBJECT = CL_CONTR.ID_CLIENT and CL_CONTR_KOD.ID_FIELD = @ID_FIELD_KOD

		left join CLIENTS_ADDFL_STRING CL_CONTR_TIN on CL_CONTR_TIN.ID_OBJECT = CL_CONTR.ID_CLIENT and CL_CONTR_TIN.ID_FIELD = @FIELD_TIN
where T.ID_EMITENT <> 0 -- �������� �������

    -- ���� ����������� �����
  and A_OSN.ID_ACCOUNT = T.ID_ACC_OSN     

    -- ������ ������
  and EM.ID_PAPER      = T.ID_PAPER
  and EM.ID_CLASS      = 3 -- �������       

    -- ��� ������ ������
  and PT.ID_PAPER_TYPE = EM.ID_PAPER_TYPE 

    -- ������ ��������
  and VL.ID_CURRENCY   = EM.ID_CURRENCY

    -- ���� ������ �������� �� �������� ����
  and R.ID_CURRENCY    = EM.ID_CURRENCY
  and R.DATE_RATE      < @DATE
  and R.DATE_NEXT     >= @DATE

    -- �������
  and ET.ID_EMITENT    = EM.ID_EMITENT    
  and CL_ET.ID_CLIENT  = ET.ID_CLIENT

    -- ������������ (������)
  and TR.ID_TRADE = T.ID_TRADE_IN       

    -- ������������ (����������)
  and TR_OWN.ID_TRADE = TR.ID_TRADE
  and TR_OWN.PARTITION_NUMBER = 1
  and TR_CONTR.ID_CONTRACT = TR_OWN.ID_CONTRACT
  and CL_CONTR.ID_CLIENT = TR_CONTR.ID_CLIENT

order by DIV.NUMBRANCH, ET.EMITENT_NAME,isnull(PT.SID_TYPE_CB,'OTHER'),isnull(EM.PAPER_SERIES,''),isnull(EM.PAPER_NUMBER,'')

--------------------------------------------------------------------------------------- 
-- ����� ������
declare @ID_FIELD_BLANK int
select @ID_FIELD_BLANK = ID_FIELD from DEPO_EMISSION_ADDFL_DIC where NAME_FIELD = '����� ������'

update T set STR_NUM_BLANK = S.FIELD
from #tmp_fact T,DEPO_EMISSION_ADDFL_STRING S
where S.ID_FIELD = @ID_FIELD_BLANK
  and S.ID_OBJECT = T.ID_PAPER
--------------------------------------------------------------------------------------- 
-- ��������
    -- �����������, ���.����, � �������� �� �������� ���� ��������� ������ �������
    -- ���������
declare @ID_FIELD_NUM_CONTR int,@ID_FIELD_DATE_CONTR int
select @ID_FIELD_NUM_CONTR  = ID_FIELD from DEPO_ACC_ADDFL_DIC where NAME_FIELD = '����� ��������'
select @ID_FIELD_DATE_CONTR = ID_FIELD from DEPO_ACC_ADDFL_DIC where NAME_FIELD = '���� ��������'

--- ���� ������� ��������� � �����, �� ������ ����� �� ��������� "����� ����������" - "�������� ���������"
DECLARE @BANK_INN varchar(19) , @BANK_OGRN varchar(20) , @BANK_OKSM varchar(3)

select @BANK_INN  = [dbo].[fn_OGO_READ_SETTING_SCALAR]( '�������� ���������', '��� �����' ),
	   @BANK_OGRN = [dbo].[fn_OGO_READ_SETTING_SCALAR]( '�������� ���������', '���� �����' ),
	   @BANK_OKSM = '643'

update T set 
    CLIENT_NAME = 
        case
            when A.BAL2 = '98000' and CL.ID_CLIENT = 0 then '��������� �����'
            when A.BAL2 = '98020'                      then '��� ������� � ��������� �����'
            else isnull(CL.REDUCE_NAME,'')
        end,
    INN_CLIENT = 
		case when ((CL.ID_CLIENT = 0 and A.BAL2 = '98000') OR A.BAL2 = '98020') then @BANK_INN
			else	case 
					when CL.IS_REZIDENT = 0 and @Date > '20100101' 
					then isnull(left(ltrim(CL_KOD.FIELD),3),'999') 
					else 
						case 
							when ltrim(isnull(case CL.IS_REZIDENT when 0 then CL_TIN.FIELD else CL.INN end, '')) = '' 
							then replicate('0',case when CL.KIND_CLIENT = 1 then 10 else 12 end) 
							else left(case CL.IS_REZIDENT when 0 then CL_TIN.FIELD else CL.INN end,19) 
						end
				end
			end
	, OGRN_CLIENT = case when ((CL.ID_CLIENT = 0 and A.BAL2 = '98000') OR A.BAL2 = '98020') then @BANK_OGRN
						else case CL.IS_REZIDENT when 1 then isnull(CL.OGRN, '') else '' end
						end
	, OKSM_CLIENT = case when ((CL.ID_CLIENT = 0 and A.BAL2 = '98000') OR A.BAL2 = '98020') then @BANK_OKSM
						 else  case isnull(left(CL_KOD.FIELD, 3), '') when '' then '999' else CL_KOD.FIELD end
						 end
	, IS_REZIDENT_CLIENT = case	when CL.KIND_CLIENT = 1 and CL.IS_REZIDENT = 1 then 1
								when CL.KIND_CLIENT = 1 and CL.IS_REZIDENT = 0 then 2
								when CL.KIND_CLIENT = 2 and CL.IS_REZIDENT = 1 then 3
								when CL.KIND_CLIENT = 2 and CL.IS_REZIDENT = 0 then 4
								else case when CL.ID_CLIENT = 0 then 1 else 0 end
							end
    , CLIENT_MEANING = 
        '������������ ������� '+
        ltrim(isnull(DS.FIELD_STRING,''))+
        case when DD.FIELD_DATE is null then '' else ' �� '+convert(varchar(10),DD.FIELD_DATE,104) end
from #tmp_fact T,DEPO_ACCOUNTS4 DA,OD_ACCOUNTS4 A,OD_SALTRN4 S,
    CLIENTS CL
        left join CLIENTS_ADDFL_STRING CL_KOD on CL_KOD.ID_OBJECT = CL.ID_CLIENT and CL_KOD.ID_FIELD = @ID_FIELD_KOD

		left join CLIENTS_ADDFL_STRING CL_TIN on CL_TIN.ID_OBJECT = CL.ID_CLIENT and CL_TIN.ID_FIELD = @FIELD_TIN
	, DEPO_PART DP 
        left join DEPO_ACC_ADDFL DS on DS.ID_OBJECT = DP.ID_ACC and DS.ID_FIELD = @ID_FIELD_NUM_CONTR
        left join DEPO_ACC_ADDFL DD on DD.ID_OBJECT = DP.ID_ACC and DD.ID_FIELD = @ID_FIELD_DATE_CONTR,
    DEPO_PART_TYPE DT
where DA.ID_PAPER  = T.ID_PAPER
  and A.ID_ACCOUNT = DA.ID_ACCOUNT
  
  and S.ID_ACCOUNT = A.ID_ACCOUNT
  and S.DATE_TRN < @Date
  and S.DATE_NEXT >= @Date
  and S.SALDO < 0
  
  and DA.ID_PART = DP.ID_PART
  
  and DT.ID_PART_TYPE = DP.ID_PART_TYPE
  and DT.ACTIV = 0
  
  and CL.ID_CLIENT = A.ID_CLIENT

---- ����� 102 ���������� ��������� ������� (� ������ ������������ �������� (��������) �� ���� �������� �� ������ (�������� ���������), ���.
UPDATE T
	set T.SUMMA_BAI_IN_RUR = BAL.SUMMA_BALANCE * ISNULL(CB.RATE , $0) 
FROM #tmp_fact T
		join BILL_BALANCE BAL  -- ���������� ��������� ������� �� ���� �������
			on T.ID_PAPER = BAL.ID_PAPER 
			  and T.ID_BALANCE = BAL.ID_BALANCE 
			  and BAL.DATE_BALANCE_OUT > @Date -- ���� �� ������ � �������� ������� ��� �����
		left join COM_RATES_CB CB  -- ���� �� ���� �������
			on CB.ID_CURRENCY = T.ID_CURRENCY 
			  and CB.DATE_RATE      < BAL.DATE_BALANCE_IN
			  and CB.DATE_NEXT     >= BAL.DATE_BALANCE_IN

---- ����� 123, 124 ���. �������� � �������������� ������
UPDATE T
	SET T.RISK_GROUP = RES.RISK_GROUP,
	T.SALDO_RESERVE = ISNULL((RUR.SALDO * CB.RATE), $0)
FROM #tmp_fact T
	join COM_CURRENCY CUR on CUR.CURRENCY_CB = T.CURRENCY_CB
	inner join BILL_BALANCE BAL on BAL.ID_BALANCE = T.ID_BALANCE -- ��� ����� ID ����� �������
		left join (select MAX(DATE_OPERATION) as DATE_OPERATION , ID_ACCOUNT_BAL  -- ���� ��������� �������� �� �������
					from  BILL_RESERVE_LOG where DATE_OPERATION <= @Date  
					GROUP BY ID_ACCOUNT_BAL ) RES_DATE 
				on RES_DATE.ID_ACCOUNT_BAL = BAL.ID_ACCOUNT
		left JOIN BILL_RESERVE_LOG RES  -- ��������� �������� � ID ����� �������
			on RES.ID_ACCOUNT_BAL = BAL.ID_ACCOUNT and RES.DATE_OPERATION = RES_DATE.DATE_OPERATION
		left JOIN OD_SALTRN0 RUR  -- ������� �� ����� �������
			ON RUR.ID_ACCOUNT = RES.ID_ACCOUNT_RESERVE and @Date between RUR.DATE_TRN AND RUR.DATE_NEXT
		left join COM_RATES_CB CB  -- ���� �� ���� �������
			on CB.ID_CURRENCY = CUR.ID_CURRENCY 
			  and CB.DATE_RATE      < @DATE
			  and CB.DATE_NEXT     >= @DATE

---- ���� ���� ������� ������� � �������� �������, �� ��������� ���� 137-143
	update T SET 
		T.SUMMA_OUT = ISNULL(BAL.SUMMA_BALANCE, 0),
		T.DATE_BALANCE_OUT = BAL.DATE_BALANCE_OUT,
		--- ��������� �������
		T.TRADE_OUT_MEANING = case when BAL.ID_TRADE_OUT IS NOT NULL THEN 
				 isnull(TR_OSN.FIELD_STRING,'')+' N '+TR.TRADE_NUM+' �� '+convert(varchar(10),TR.DATE_TRN,104)
				 ELSE '' END 
		-- ����������
		,T.CONTRAGENT_NAME_OUT = CL_CONTR.REDUCE_NAME
		-- ��� �����������
		,T.INN_CONTR_OUT	=case 
        when ltrim(isnull(case CL_CONTR.IS_REZIDENT when 0 then CL_CONTR_TIN.FIELD else CL_CONTR.INN end, '')) = '' 
			then replicate('0',case when CL_CONTR.KIND_CLIENT = 1 then 10 else 12 end) 
        else left(case CL_CONTR.IS_REZIDENT when 0 then CL_CONTR_TIN.FIELD else CL_CONTR.INN end,19)
    end 	
		-- ���� �����������	
		,T.OGRN_CONTR_OUT = case CL_CONTR.IS_REZIDENT when 1 then isnull(CL_CONTR.OGRN, '') else '' end
		-- ���� 
		,T.OKSM_CONTR_OUT = case isnull(left(CL_CONTR_KOD.FIELD, 3), '') when '' then '999' else CL_CONTR_KOD.FIELD	end	
		-- ��� ������ COL141B ��� �����
		,T.IS_REZIDENT_CONTR_OUT = case	when CL_CONTR.KIND_CLIENT = 1 and CL_CONTR.IS_REZIDENT = 1 then 1
			when CL_CONTR.KIND_CLIENT = 1 and CL_CONTR.IS_REZIDENT = 0 then 2
			when CL_CONTR.KIND_CLIENT = 2 and CL_CONTR.IS_REZIDENT = 1 then 3
			when CL_CONTR.KIND_CLIENT = 2 and CL_CONTR.IS_REZIDENT = 0 then 4 
			else 0 end
	from #tmp_fact T
		 join BILL_BALANCE BAL on BAL.ID_BALANCE = T.ID_BALANCE and BAL.ID_PAPER = T.ID_PAPER
				and BAL.DATE_BALANCE_OUT between DATEADD(month, -1, @date) AND DATEADD(day, -1, @date)
			--- ������ �������
		 join BILL_TRADES_BASE TR on TR.ID_TRADE = BAL.ID_TRADE_OUT 

			left join BILL_TRADES_ADDFL TR_OSN on TR_OSN.ID_OBJECT = TR.ID_TRADE and TR_OSN.ID_FIELD = @ID_FIELD_OSN
		, CLIENTS CL_CONTR
			left join CLIENTS_ADDFL_STRING CL_CONTR_KOD on CL_CONTR_KOD.ID_OBJECT = CL_CONTR.ID_CLIENT and CL_CONTR_KOD.ID_FIELD = @ID_FIELD_KOD
			left join CLIENTS_ADDFL_STRING CL_CONTR_TIN on CL_CONTR_TIN.ID_OBJECT = CL_CONTR.ID_CLIENT and CL_CONTR_TIN.ID_FIELD = @FIELD_TIN
		, BILL_TRADES_OWN TR_OWN
		, BILL_CONTRACT TR_CONTR

	where 
	--- ���������� �� ������ �������
	TR_OWN.ID_TRADE = TR.ID_TRADE
	and TR_OWN.PARTITION_NUMBER = 2
	and TR_CONTR.ID_CONTRACT = TR_OWN.ID_CONTRACT
	and CL_CONTR.ID_CLIENT = TR_CONTR.ID_CLIENT

Update #tmp_fact set CURRENCY_CB = '643' where CURRENCY_CB = '810'

Insert into #SECURITIES(BRANCH, PART, SUBPART, ID_PAPER, 
		  COL105, COL106, COL106B, COL107, COL108, COL109,
		  COL110, COL111, COL112, COL113, COL114, COL115, COL116, COL117, COL118 , COL119,COL120,
		  COL121, COL122, COL123,COL124, COL125, COL126, COL127, COL128, COL128B, COL129,
		  COL130, COL131, COL132, COL133, COL133B, COL134, COL135, COL136, COL137, COL138,
		  COL139, COL140,COL141, COL141B, COL142,COL143, COL144)
	Select T.BRANCH, 2 PART, '2.1' SUBPART, T.ID_PAPER
		, T.EMITENT_NAME as COL105,
		  T.INN_ET as COL106,
		  T.IS_REZIDENT_ET as COL106B,
		  T.OGRN_ET as COL107,
		  T.OKSM_ET as COL108,
		  T.SID_TYPE_CB as COL109,
		  T.PAPER_SERIES as COL110,
		  T.PAPER_NUMBER as COL111,
		  T.STR_NUM_BLANK as COL112,
		  T.DATE_EMISSION as COL113,
		  COL114 = CASE WHEN DP.PAYOFF_TYPE = 1 THEN 1  --- ������������ ����
						WHEN DP.PAYOFF_TYPE = 2 THEN 1  --- �� �������-�� ������� �� ������������
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN 2 -- �� ������������
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN 3 -- �� ������������, �� �� ����� ������������ ����
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN 4 --  �� ������������, �� �� ����� ������������ ���� � �� ������� ������������ ����
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN 99 --  ����
						WHEN DP.PAYOFF_TYPE = 4 THEN 99 END, -- �� �������-�� ������� �� ������������

		 COL115 =  CASE WHEN DP.PAYOFF_TYPE = 1 THEN DP.DATE_PAYOFF   --- ������������ ����
						WHEN DP.PAYOFF_TYPE = 2 THEN DP.DATE_PAYOFF   --- �� �������-�� ������� �� ������������
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN '22220101' -- �� ������������
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN DP.PAYOFF_DATE_GE -- �� ������������, �� �� ����� ������������ ����
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN DP.PAYOFF_DATE_GE --  �� ������������, �� �� ����� ������������ ���� � �� ������� ������������ ����
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN '22220101' --  ����
						WHEN DP.PAYOFF_TYPE = 4 THEN '22220101' END, -- �� �������-�� ������� �� ������������

		COL116 =   CASE WHEN DP.PAYOFF_TYPE = 1 THEN '22220101'   --- ������������ ����
						WHEN DP.PAYOFF_TYPE = 2 THEN '22220101'   --- �� �������-�� ������� �� ������������
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN '22220101' -- �� ������������
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN '22220101' -- �� ������������, �� �� ����� ������������ ����
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN DP.PAYOFF_DATE_LE --  �� ������������, �� �� ����� ������������ ���� � �� ������� ������������ ����
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN '22220101' --  ����
						WHEN DP.PAYOFF_TYPE = 4 THEN '22220101' END, -- �� �������-�� ������� �� ������������
			
		  B.PAPER_PERCENT as COL117,
		  T.NOMINAL as COL118, 
		  T.CURRENCY_CB as COL119, 
		  ISNULL(T.SUMMA_BAI_IN_RUR ,$0) as COL120, -- ���. ��������� �� ������ �������
		  ISNULL(T.SUMMA_BALANCE_RUR,$0) as COL121, -- ���. ��������� �� �������� ����
		  T.SALDO_PRC_RUR + T.SALDO_DISC_RUR as COL122,
		  T.RISK_GROUP as COL123,
		  T.SALDO_RESERVE as COL124,
		  T.DATE_BALANCE_IN as COL125,
		  T.TRADE_IN_MEANING as COL126,
		  T.CONTRAGENT_NAME as COL127,
		  T.INN_CONTR as COL128,
		  T.IS_REZIDENT_CONTR as COL128B,
		  T.OGRN_CONTR as COL129,
		  T.OKSM_CONTR as COL130,
		  T.BAL2_OSN as COL131,
		  T.CLIENT_NAME as COL132,
		  T.INN_CLIENT as COL133,
		  T.IS_REZIDENT_CLIENT as COL133B,
		  T.OGRN_CLIENT as COL134,
		  T.OKSM_CLIENT as COL135,
		  T.CLIENT_MEANING as COL136,
		  T.SUMMA_OUT as COL137,
		  T.DATE_BALANCE_OUT as COL138,
		  T.TRADE_OUT_MEANING as COL139,
		  T.CONTRAGENT_NAME_OUT as COL140,
		  T.INN_CONTR_OUT as COL141,
		  T.IS_REZIDENT_CONTR_OUT as COL141B,
		  T.OGRN_CONTR_OUT as COL142,
		  T.OKSM_CONTR_OUT as COL143, 
		  T.PAPER_NOTE as COL144
	from #tmp_fact T
		join dbo.fn_OGO_PAPER_DATE_PAYM() DP on DP.ID_PAPER = T.ID_PAPER
			left join DEPO_BILL B on T.ID_PAPER = B.ID_PAPER
			

drop table #tmp_fact


GO
drop table #GET_ACC_PAPER_SALDO
drop table #SECURITIES
Go