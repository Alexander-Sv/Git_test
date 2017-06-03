Create table #SECURITIES(
		  ID						int				identity
		, LAYER						tinyint			not null	default 0	-- 0 - изначальные данные, 1 - агрегированные, 2 - для схлопывания (группировки) по закладным физических лиц и по векселям

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

		, OWNER_NAME				varchar(160)		null   -- кол 2
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
		, PAPER_REG_NUM				varchar(50)			null   ---- saa 08.11.16 изменили значение поля на 50 (82694)
		, PAPER_CODE_ISIN			varchar(60)			null
		, PAPER_CURRENCY_CODE		varchar(3)			null
		, PAPER_NOMINAL				decimal(32,16)		null
		, PAPER_NOTE				varchar(255)		null

		-- Количество ценных бумаг, в отношении которых зафиксировано ,  обременение и (или) ограничение распоряжения, шт.         
		, ENCUMBRANCES_PAPER_COUNT  decimal(28,12)		null   -- пример - кол 21
		, PLEDGED_PAPER_COUNT		decimal(28,12)		null   -- пример - кол 22
		, IN_KLIRING				decimal(28,12)		null   -- пример - кол 23
		, WITH_CORP_ACTIONS			decimal(28,12)		null   -- пример - кол 24
		, BAN_ON_OPERATIONS			decimal(28,12)		null   -- пример - кол 25
		, UNDER_ARREST				decimal(28,12)		null   -- пример - кол 26 

		, DEPO_OWNER_OKSM			varchar(3)			null   -- пример - кол 55

		, REGISTRATOR_NAME			varchar(160)		null  --  пример - по старому 21
		, REGISTRATOR_INDICATION	varchar(1)			null
		, REGISTRATOR_INN			varchar(20)			null
		, REGISTRATOR_IS_REZIDENT	tinyint			null -- yudin 06/08/14
		, REGISTRATOR_KPP			varchar(20)			null
		, REGISTRATOR_OGRN			varchar(20)			null
		, REGISTRATOR_OKSM			varchar(3)			null
		, REGISTRATOR_LICENSE_NUM	varchar(20)			null
		, NOSTRO_STR_ACCOUNT		varchar(30)			null   --  раньше назывался счет НОСТРО

		, SID_TRADE_TYPE			varchar(20)			null
		, COL146					varchar(10)			null -- серия 
		, COL147					varchar(30)			null -- номер векселя
		, COL148					varchar(255)		null -- номер бланка 
		, COL149					datetime			null -- дата составления
		, COL150					int					null -- код условия
		, COL151					datetime			null -- дата 1
		, COL152					datetime			null -- дата 2
		, COL153					decimal(28,4)		null -- процентная ставка % годовых
		, COL154					money				null -- вексельная сумма
		, COL155					varchar(3)			null -- код валюты
		, COL156					money				null -- стоимость реализации
		, COL157					varchar(255)		null -- первый вексельдатель
		, COL158					varchar(19)			null -- ИНН
		, COL158B					tinyint				null -- yudin 06/08/14 возможно, для ПТК
		, COL159					varchar(20)			null -- ОГРН
		, COL160					varchar(3)			null -- ОКСМ
		, COL161					varchar(255)		null -- состояние векселя на отчетную дату
		, COL162					datetime			null -- дата факт. погашения
		, COL163					varchar(255)		null -- вексельдержатель
		, COL164					varchar(19)			null -- ИНН
		, COL164B					tinyint				null -- yudin 06/08/14 возможно, для ПТК
		, COL165					varchar(20)			null -- ОГРН
		, COL166					varchar(3)			null -- ОКСМ
		, COL167					varchar(255)		null -- примечание
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

    PAYOFF_MEANING       varchar(255) null       -- срок и условие платежа
    , BRANCH			 smallint	  not null 
    )


	Go

if exists (select * from sysobjects where id = object_id('dbo.p711aForm_fbill_2_2017') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure dbo.p711aForm_fbill_2_2017
GO

Create Proc dbo.p711aForm_fbill_2_2017(
	@Date		datetime,
	@SidVersion varchar(50)
	)
As

SET NOCOUNT ON

-- расчет подраздела 2.2
---------------------------------------------------------------------------------------
-- Подраздел 2.2. Выпущенные кредитной организацией векселя
---------------------------------------------------------------------------------------
create table #tmp_own(
    ID                 int          identity,

    -- балансовый учет
    ID_BALANCE         int          not null,

    -- ценная бумага
    ID_PAPER           int          not null,
    PAPER_SERIES       varchar(10)  not null,
    PAPER_NUMBER       varchar(30)  not null,
    PAPER_NOTE         varchar(255)  not null,
    DATE_EMISSION      datetime     not null,
    NOMINAL            money        not null,
	BALANCE_SUMMA	   money        null,
    STR_NUM_BLANK      varchar(255) not null default '',
    STATE_PAPER        varchar(255) not null default '', -- состояние

    PAYOFF_MEANING     varchar(255) not null, -- срок и условие платежа
    CURRENCY_CB        char(3)      not null,

    -- первый векселедержатель
    ID_FIRST_OWNER     int          not null,
    FIRST_OWNER_NAME   varchar(255)  not null,
    INN_FIRST_OWNER    varchar(19)  not null,
	FIRST_OWNER_OGRN	varchar(20)		not null
	, FIRST_OWNER_OKSM	varchar(3)		not null
	,	IS_REZIDENT_FIRST_OWNER tinyint null, --yudin 06/08/14

    -- векселедержатель на отчетную дату (при наличии векселя в кредитной организации)
    IS_EXIST           tinyint      null,     -- 1 -- есть в кредитной организации,0 - нет
    ID_CURRENT_OWNER   int          null,
    CURRENT_OWNER_NAME varchar(255)  null,
	CURRENT_OWNER_OGRN	varchar(20)			null
	, CURRENT_OWNER_OKSM	varchar(3)		null,
    INN_CURRENT_OWNER  varchar(19)  null
    , DATE_BALANCE_OUT datetime null			-- если состояние векселя = 9 - то дата фактического погашения
    , BRANCH		   smallint     not null
	, DATE_FACT_PAYOFF	datetime		null
	,   IS_REZIDENT_CURRENT_OWNER tinyint null --yudin 06/08/14
    )


declare @ID_FIELD_INN int	select @ID_FIELD_INN = ID_FIELD from DEPO_PARTICIPANT_ADDFL_DIC where NAME_FIELD = 'ИНН'
declare @FIELD_DEPO_PARTICIPANT_OGRN int	select @FIELD_DEPO_PARTICIPANT_OGRN = ID_FIELD from DEPO_PARTICIPANT_ADDFL_DIC where NAME_FIELD = 'ОГРН'
declare @FIELD_DEPO_PARTICIPANT_OKSM int	select @FIELD_DEPO_PARTICIPANT_OKSM = ID_FIELD from DEPO_PARTICIPANT_ADDFL_DIC where NAME_FIELD = 'Код страны регистрации/гражданства'


insert into #tmp_own(
    -- балансовый учет
    ID_BALANCE,

    -- ценная бумага
    ID_PAPER,PAPER_SERIES,PAPER_NUMBER,PAPER_NOTE,DATE_EMISSION,NOMINAL,BALANCE_SUMMA,
    PAYOFF_MEANING,CURRENCY_CB,

    -- первый векселедержатель
    ID_FIRST_OWNER,FIRST_OWNER_NAME,INN_FIRST_OWNER
	, FIRST_OWNER_OGRN, FIRST_OWNER_OKSM
    , BRANCH 
	, IS_REZIDENT_FIRST_OWNER --yudin 06/08/14
    )

select
    -- балансовый учет
    T.ID_BALANCE,

    -- ценная бумага
    T.ID_PAPER,isnull(EM.PAPER_SERIES,''),
	isnull(EM.PAPER_NUMBER,''),
	isnull(EM.PAPER_NOTE,''),
	EM.DATE_EMISSION,EM.NOMINAL,
	BAL.SUMMA_BALANCE as BALANCE_SUMMA, -- стоимость реализации
    T.PAYOFF_MEANING,VL.CURRENCY_CB,

    -- первый векселедержатель
    BILL.ID_PAPER_OWNER                     as ID_FIRST_OWNER,
    BILL.PAPER_OWNER                        as FIRST_OWNER_NAME,
    case 
        when ltrim(isnull(OWNER_FIRST_INN.FIELD_STRING,'')) = '' 
        then replicate('0',case OWNER_FIRST.KIND_PARTICIPANT when 1 then 10 else 12 end) 
        else left(OWNER_FIRST_INN.FIELD_STRING,19) 
    end as INN_FIRST_OWNER
	, isnull(left(OWNER_FIRST_OGRN.FIELD_STRING, 20), '') FIRST_OWNER_OGRN
	, isnull(left(OWNER_FIRST_OKSM.FIELD_STRING, 3), '') FIRST_OWNER_OKSM
    , BRANCH
	, case	when OWNER_FIRST.KIND_PARTICIPANT = 1 and left(isnull(OWNER_FIRST_OKSM.FIELD_STRING, '643'), 3) =  '643'	then 1 
			when OWNER_FIRST.KIND_PARTICIPANT = 1 and left(isnull(OWNER_FIRST_OKSM.FIELD_STRING, '643'), 3) <> '643'	then 2
			when OWNER_FIRST.KIND_PARTICIPANT = 2 and left(isnull(OWNER_FIRST_OKSM.FIELD_STRING, '643'), 3) =  '643'	then 3
			when OWNER_FIRST.KIND_PARTICIPANT = 2 and left(isnull(OWNER_FIRST_OKSM.FIELD_STRING, '643'), 3) <> '643'	then 4 
			else 0 end IS_REZIDENT_FIRST_OWNER -- yudin 06/08/14
from #GET_ACC_PAPER_SALDO T
		LEFT JOIN BILL_BALANCE BAL on BAL.ID_BALANCE = T.ID_BALANCE  and BAL.ID_PAPER = T.ID_PAPER,
    DEPO_EMISSION EM,
	COM_CURRENCY VL,
	-- первый векселедержатель    
    DEPO_BILL BILL,
    DEPO_PARTICIPANT OWNER_FIRST 
		left join DEPO_PARTICIPANT_ADDFL OWNER_FIRST_INN
		on OWNER_FIRST_INN.ID_FIELD = @ID_FIELD_INN
		and OWNER_FIRST_INN.ID_OBJECT = OWNER_FIRST.ID_PARTICIPANT

		left join DEPO_PARTICIPANT_ADDFL OWNER_FIRST_OGRN
		on OWNER_FIRST_OGRN.ID_FIELD = @FIELD_DEPO_PARTICIPANT_OGRN
		and OWNER_FIRST_OGRN.ID_OBJECT = OWNER_FIRST.ID_PARTICIPANT

		left join DEPO_PARTICIPANT_ADDFL OWNER_FIRST_OKSM
		on OWNER_FIRST_OKSM.ID_FIELD = @FIELD_DEPO_PARTICIPANT_OKSM
		and OWNER_FIRST_OKSM.ID_OBJECT = OWNER_FIRST.ID_PARTICIPANT

where T.ID_EMITENT = 0  -- собственные векселя

    -- ценная бумага
  and EM.ID_PAPER      = T.ID_PAPER
  and EM.ID_CLASS      = 3 -- векселя           

    -- валюта номинала
  and VL.ID_CURRENCY   = EM.ID_CURRENCY

    -- первый векселедержатель
  and BILL.ID_PAPER = EM.ID_PAPER
  and OWNER_FIRST.ID_PARTICIPANT = BILL.ID_PAPER_OWNER

order by isnull(EM.PAPER_SERIES,''),isnull(EM.PAPER_NUMBER,'')

-- удалим векселя находившиеся на балансе в течение отчетного месяца и снятые до отчетной даты, 
-- так как для расчета других подразделов они уже не нужны (лишние) 
Delete F from #GET_ACC_PAPER_SALDO F join BILL_BALANCE B on B.ID_BALANCE = F.ID_BALANCE where B.DATE_BALANCE_OUT < @Date

---------------------------------------------------------------------------------------
-- проверка наличия собственного векселя в кредитной организации
update T set IS_EXIST = 1 -- есть в кредитной организации
from #tmp_own T
where exists(select *
from DEPO_ACCOUNTS4 DA, OD_SALTRN4 S
where DA.ID_PAPER = T.ID_PAPER
  and S.ID_ACCOUNT = DA.ID_ACCOUNT
  and S.DATE_TRN < @Date
  and S.DATE_NEXT >= @Date
  and S.SALDO <> 0)

update #tmp_own set IS_EXIST = isnull(IS_EXIST,0)
---------------------------------------------------------------------------------------
-- векселедержатель на отчетную дату - при наличии в кредитной организации

-- если не было передачи
update T set 
    ID_CURRENT_OWNER   = ID_FIRST_OWNER,
    CURRENT_OWNER_NAME = FIRST_OWNER_NAME,
    INN_CURRENT_OWNER  = INN_FIRST_OWNER
	, CURRENT_OWNER_OGRN = FIRST_OWNER_OGRN
	, CURRENT_OWNER_OKSM = FIRST_OWNER_OKSM
	, IS_REZIDENT_CURRENT_OWNER = IS_REZIDENT_FIRST_OWNER
from #tmp_own T
--where T.IS_EXIST = 1 -- есть в кредитной организации

update T set 
    ID_CURRENT_OWNER   = EN.ID_OWNER_NEXT,
    CURRENT_OWNER_NAME = isnull(EN.OWNER_NEXT,''),
    INN_CURRENT_OWNER  = 
        case 
            when ltrim(isnull(OWNER_CURRENT_INN.FIELD_STRING,'')) = '' 
				then replicate('0',case OWNER_CURRENT.KIND_PARTICIPANT when 1 then 10 else 12 end) 
            else left(OWNER_CURRENT_INN.FIELD_STRING,19) 
        end
	, CURRENT_OWNER_OGRN = left(isnull(OWNER_CURRENT_OGRN.FIELD_STRING, ''), 20)
	, CURRENT_OWNER_OKSM = left(isnull(OWNER_CURRENT_OKSM.FIELD_STRING, ''), 3)
	, IS_REZIDENT_CURRENT_OWNER = case	when OWNER_CURRENT.KIND_PARTICIPANT = 1 and left(isnull(OWNER_CURRENT_OKSM.FIELD_STRING, '643'), 3) =  '643'	then 1
										when OWNER_CURRENT.KIND_PARTICIPANT = 1 and left(isnull(OWNER_CURRENT_OKSM.FIELD_STRING, '643'), 3) <> '643'	then 2
										when OWNER_CURRENT.KIND_PARTICIPANT = 2 and left(isnull(OWNER_CURRENT_OKSM.FIELD_STRING, '643'), 3) =  '643'	then 3
										when OWNER_CURRENT.KIND_PARTICIPANT = 2 and left(isnull(OWNER_CURRENT_OKSM.FIELD_STRING, '643'), 3) <> '643'	then 4 
										else 0 end -- yudin 06/08/14

from #tmp_own T,
    DEPO_ENDORSEMENT EN,

    -- последняя передаточная надпись на отчетную дату
    (select ID_PAPER,max(ID_ENDORSEMENT) LAST_ID_ENDORSEMENT
    from DEPO_ENDORSEMENT
    where DATE_TRN < @Date
    group by ID_PAPER) EN_LAST,

    DEPO_PARTICIPANT OWNER_CURRENT
		left join DEPO_PARTICIPANT_ADDFL OWNER_CURRENT_INN
		on OWNER_CURRENT_INN.ID_FIELD = @ID_FIELD_INN
		and OWNER_CURRENT_INN.ID_OBJECT = OWNER_CURRENT.ID_PARTICIPANT

		left join DEPO_PARTICIPANT_ADDFL OWNER_CURRENT_OGRN
		on OWNER_CURRENT_OGRN.ID_FIELD = @FIELD_DEPO_PARTICIPANT_OGRN
		and OWNER_CURRENT_OGRN.ID_OBJECT = OWNER_CURRENT.ID_PARTICIPANT

		left join DEPO_PARTICIPANT_ADDFL OWNER_CURRENT_OKSM
		on OWNER_CURRENT_OKSM.ID_FIELD = @FIELD_DEPO_PARTICIPANT_OKSM
		and OWNER_CURRENT_OKSM.ID_OBJECT = OWNER_CURRENT.ID_PARTICIPANT

where --T.IS_EXIST = 1 -- есть в кредитной организации
  --and 
  EN.ID_PAPER = T.ID_PAPER

  and EN.ID_PAPER       = EN_LAST.ID_PAPER
  and EN.ID_ENDORSEMENT = EN_LAST.LAST_ID_ENDORSEMENT

  and OWNER_CURRENT.ID_PARTICIPANT = EN.ID_OWNER_NEXT


-- номер бланка
declare @ID_FIELD_BLANK int
select @ID_FIELD_BLANK = ID_FIELD from DEPO_EMISSION_ADDFL_DIC where NAME_FIELD = 'Номер бланка'

update T set STR_NUM_BLANK = S.FIELD
from #tmp_own T,DEPO_EMISSION_ADDFL_STRING S
where S.ID_FIELD = @ID_FIELD_BLANK
  and S.ID_OBJECT = T.ID_PAPER 


-- состояние на отчетную дату
update T set STATE_PAPER = S.State
from #tmp_own T, dbo.fn_p711aForm_paper_state_ver(@SidVersion) S,
	dbo.fn_OGO_BILL_PAPER_STATE(@Date) PS
where T.ID_BALANCE = PS.Id_Balance
  and S.Meaning = PS.State


Update T set T.DATE_BALANCE_OUT = B.DATE_BALANCE_OUT
		, T.DATE_FACT_PAYOFF = B.DATE_BALANCE_OUT
from #tmp_own T join BILL_BALANCE B on B.ID_BALANCE = T.ID_BALANCE 
where T.STATE_PAPER = '9'


Update #tmp_own set CURRENCY_CB = '643' where CURRENCY_CB = '810'


Insert into #SECURITIES(BRANCH, PART, SUBPART, ID_PAPER,
	COL146, COL147, COL148, COL149,
	COL150, COL151, COL152, COL153, COL154, COL155, COL156, COL157, COL158, COL158B, COL159,
	COL160, COL161, COL162, COL163, COL164, COL164B, COL165, COL166, COL167)

	Select BRANCH, 2 PART, '2.2' SUBPART, T.ID_PAPER,
	 T.PAPER_SERIES as COL146,
	 T.PAPER_NUMBER as COL147,
	 T.STR_NUM_BLANK as COL148,
	 T.DATE_EMISSION as COL149,
	 COL150 = CASE WHEN DP.PAYOFF_TYPE = 1 THEN 1  --- определенный день
						WHEN DP.PAYOFF_TYPE = 2 THEN 1  --- во столько-то времени от предъявления
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN 2 -- по предъявлении
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN 3 -- по предъявлении, но не ранее определенной даты
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN 4 --  по предъявлении, но не ранее определенной даты и не позднее определенной даты
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN 99 --  иное
						WHEN DP.PAYOFF_TYPE = 4 THEN 99 END, -- во столько-то времени от предъявления

	 COL151 = CASE WHEN DP.PAYOFF_TYPE = 1 THEN DP.DATE_PAYOFF   --- определенный день
						WHEN DP.PAYOFF_TYPE = 2 THEN DP.DATE_PAYOFF   --- во столько-то времени от предъявления
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN '22220101' -- по предъявлении
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN DP.PAYOFF_DATE_GE -- по предъявлении, но не ранее определенной даты
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN DP.PAYOFF_DATE_GE --  по предъявлении, но не ранее определенной даты и не позднее определенной даты
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN '22220101' --  иное
						WHEN DP.PAYOFF_TYPE = 4 THEN '22220101' END, -- во столько-то времени от предъявления

	 COL152 =  CASE WHEN DP.PAYOFF_TYPE = 1 THEN '22220101'   --- определенный день
						WHEN DP.PAYOFF_TYPE = 2 THEN '22220101'   --- во столько-то времени от предъявления
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN '22220101' -- по предъявлении
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN '22220101' -- по предъявлении, но не ранее определенной даты
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN DP.PAYOFF_DATE_LE --  по предъявлении, но не ранее определенной даты и не позднее определенной даты
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN '22220101' --  иное
						WHEN DP.PAYOFF_TYPE = 4 THEN '22220101' END, -- во столько-то времени от предъявления
												
	 B.PAPER_PERCENT as COL153,
	 T.NOMINAL as COL154,
	 T.CURRENCY_CB as COL155,
	 T.BALANCE_SUMMA as COL156,
	 T.FIRST_OWNER_NAME as COL157,
	 T.INN_FIRST_OWNER as COL158,
	 T.IS_REZIDENT_FIRST_OWNER as COL158B,
	 T.FIRST_OWNER_OGRN as COL159,
	 T.FIRST_OWNER_OKSM as COL160,
	 T.STATE_PAPER as COL161,
	 T.DATE_FACT_PAYOFF as COL162,
	 T.CURRENT_OWNER_NAME as COL163,
	 T.INN_CURRENT_OWNER as COL164,
	 T.IS_REZIDENT_CURRENT_OWNER as COL164B,
	 T.CURRENT_OWNER_OGRN as COL165,
	 T.CURRENT_OWNER_OKSM as COL166,
	 T.PAPER_NOTE as COL167
	from #tmp_own T
		join dbo.fn_OGO_PAPER_DATE_PAYM() DP on DP.ID_PAPER = T.ID_PAPER
			left join DEPO_BILL B on T.ID_PAPER = B.ID_PAPER

drop table #tmp_own 



GO
drop table #GET_ACC_PAPER_SALDO
drop table #SECURITIES
Go