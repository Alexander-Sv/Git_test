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
		-- подраздел 2.3
		, COL169					varchar(255)		null -- венквсельдержатель
		, COL170					varchar(19)			null -- ИНН
		, COL170B					tinyint				null -- yudin 06/08/14 возможно, для ПТК
		, COL171					varchar(20)			null -- ОГРН
		, COL172					varchar(3)			null -- ОКСМ
		, COL173					varchar(5)			null -- код типи ц.б.
		, COL174					varchar(10)			null -- серия векс.
		, COL175					varchar(20)			null -- номер векс.
		, COL176					varchar(20)			null -- номер бланка 
		, COL177					datetime			null -- дата составления
		, COL178					int					null -- код условия платежа
		, COL179					datetime			null -- дата 1
		, COL180					datetime			null -- дата 2
		, COL181					money				null -- вексельная сумма
		, COL182					varchar(3)			null -- код валюты
		, COL183					datetime			null -- дата поступления
		, COL184					varchar(255)		null -- основания
		, COL185					varchar(255)		null -- вексельдержатель
		, COL186					tinyint				null -- статус вексельдержателя
		, COL187					varchar(19)			null -- ИНН
		, COL187B					tinyint				null -- yudin 06/08/14 возможно, для ПТК
		, COL188					varchar(20)			null -- ОГРН
		, COL189					varchar(20)			null -- ОКСМ
		, COL190					varchar(60)			null -- примечание
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

if exists (select * from sysobjects where id = object_id('dbo.p711aForm_fbill_3_2017') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure dbo.p711aForm_fbill_3_2017
GO

Create Proc dbo.p711aForm_fbill_3_2017(
	@Date datetime
	, @NumBranch smallint
	, @SidVersion varchar(50)
)
As

SET NOCOUNT ON


Declare @FIELD_OKSM int			select @FIELD_OKSM = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Код страны регистрации/гражданства')
Declare @FIELD_OWNER_OGRN int	select @FIELD_OWNER_OGRN = (select ID_FIELD from DEPO_PARTICIPANT_ADDFL_DIC where NAME_FIELD = 'ОГРН')
Declare @FIELD_OWNER_OKSM int	select @FIELD_OWNER_OKSM = (select ID_FIELD from DEPO_PARTICIPANT_ADDFL_DIC where NAME_FIELD = 'Код страны регистрации/гражданства')
Declare @FIELD_OWNER_STATUS int;select @FIELD_OWNER_STATUS = (select ID_FIELD from DEPO_PARTICIPANT_ADDFL_DIC where NAME_FIELD = 'Статус')
-- расчет подраздела 2.3
-- Подраздел 2.3. Информация о векселях (кроме выпущенных самой кредитной организацией), 
-- принадлежащих сторонним лицам и находящихся в кредитной организации на различных основаниях
create table #tmp_bill(
    ID                 int          identity,

    -- счет депо
    ID_ACC             int          not null, -- счет депо

    -- л/с
    ID_ACCOUNT         int          not null, -- л/с
    RAZDEL             tinyint      not null, -- раздел (депо или внебаланс)

    -- договор
    NUM_CONTRACT      varchar(50)   null,
    DATE_CONTRACT     datetime      null,
    CONTRACT_MEANING  varchar(255)  not null, -- реквизиты договора

    -- ценная бумага
    ID_PAPER           int          not null,
    PAPER_SERIES       varchar(10)  not null,
    PAPER_NUMBER       varchar(20)  not null,
    PAPER_NOTE         varchar(255)  not null,
    DATE_EMISSION      datetime     not null,
    NOMINAL            money        not null,
    DATE_PAYING        datetime     not null,

    SID_TYPE_CB        varchar(5)   not null,
    PAYOFF_MEANING     varchar(255) null,     -- срок и условие платежа
    CURRENCY_CB        char(3)      not null,

    DATE_IN            datetime     null,     -- дата поступления

    -- векселедатель (эмитент)
    ID_EMITENT         int          not null,
    EMITENT_NAME       varchar(255)  not null,
    INN_ET             varchar(19)  not null,
	
	EMITENT_OGRN		varchar(20)		null
	, EMITENT_OKSM		varchar(3)		null
	,  IS_REZIDENT_ET	tinyint		null, --yudin 06/08/14

    -- векселедержатель на отчетную дату
    ID_CURRENT_OWNER   int          null,
    CURRENT_OWNER_NAME varchar(255)  null,
    INN_CURRENT_OWNER  varchar(19)  null
	, CURRENT_OWNER_OGRN	varchar(20)	null
	, CURRENT_OWNER_OKSM	varchar(3)	null
	, CURRENT_OWNER_STATUS  varchar(1)  null
    , BRANCH		   smallint		not null 
	, IS_REZIDENT_CURRENT_OWNER tinyint null -- yudin 06/08/14
    )
---------------------------------------------------------------------------------------
-- векселя на хранении в депозитарии
---------------------------------------------------------------------------------------
declare @ID_FIELD_NUM_CONTR  int
select @ID_FIELD_NUM_CONTR  = ID_FIELD from DEPO_ACC_ADDFL_DIC where NAME_FIELD = 'Номер договора'

declare @ID_FIELD_DATE_CONTR int
select @ID_FIELD_DATE_CONTR = ID_FIELD from DEPO_ACC_ADDFL_DIC where NAME_FIELD = 'Дата договора'

-- для проверки наличия данныв в разделач счета 
declare @ID_FIELD_NUM_DOC INT, @ID_FIELD_DATE_DOC INT

select @ID_FIELD_NUM_DOC =  ID_FIELD from DEPO_PART_ADDFL_DIC where NAME_FIELD = 'Номер документа'
select @ID_FIELD_DATE_DOC = ID_FIELD from DEPO_PART_ADDFL_DIC where NAME_FIELD = 'Дата документа'



declare @ID_FIELD_INN int
select @ID_FIELD_INN = ID_FIELD from DEPO_PARTICIPANT_ADDFL_DIC where NAME_FIELD = 'ИНН'

Declare @FIELD_TIN int	select @FIELD_TIN = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Федеральный налоговый идент.номер (TIN)')

insert into #tmp_bill(
    -- счет депо
    ID_ACC,

    -- л/с
    ID_ACCOUNT,RAZDEL,

    -- договор
    NUM_CONTRACT,DATE_CONTRACT,CONTRACT_MEANING,

    -- ценная бумага
    ID_PAPER,PAPER_SERIES,PAPER_NUMBER,PAPER_NOTE,DATE_EMISSION,NOMINAL,
    DATE_PAYING,SID_TYPE_CB,CURRENCY_CB,

    -- векселедатель (эмитент)
    ID_EMITENT, EMITENT_NAME, INN_ET, BRANCH
	, EMITENT_OGRN, EMITENT_OKSM, IS_REZIDENT_ET
    )

select
    -- счет депо
    D.ID_ACC,

    -- л/с
    L.ID_ACCOUNT,4 RAZDEL,

    -- договор
	-- Если есть номер документа и дата документа в разделе договора, то берем их. Иначе брем из договора.
    CASE WHEN (NUM_DOC.FIELD_STRING IS NOT NULL and  DATE_DOC.FIELD_DATE is not NULL) THEN NUM_DOC.FIELD_STRING ELSE  NUM_CONTR.FIELD_STRING END as NUM_CONTRACT, 
	CASE WHEN (NUM_DOC.FIELD_STRING IS NOT NULL and  DATE_DOC.FIELD_DATE is not NULL) THEN DATE_DOC.FIELD_DATE ELSE   DATE_CONTR.FIELD_DATE END as DATE_CONTRACT,
    case 
		when NUM_DOC.FIELD_STRING IS NOT NULL and  DATE_DOC.FIELD_DATE is not NULL
			then  'N '+NUM_DOC.FIELD_STRING+' от '+convert(varchar(10),DATE_DOC.FIELD_DATE,104) 
        when NUM_CONTR.FIELD_STRING is not null and  DATE_CONTR.FIELD_DATE is not null
			then 'N '+NUM_CONTR.FIELD_STRING+' от '+convert(varchar(10),DATE_CONTR.FIELD_DATE,104) 
        else ''
    end CONTRACT_MEANING,

    -- ценная бумага
    EM.ID_PAPER,isnull(EM.PAPER_SERIES,''),isnull(EM.PAPER_NUMBER,''),isnull(EM.PAPER_NOTE,''),EM.DATE_EMISSION,EM.NOMINAL,
    EM.DATE_PAYING,isnull(PT.SID_TYPE_CB,'OTHER'),VL.CURRENCY_CB,

    -- векселедатель (эмитент)
    ET.ID_EMITENT,ET.EMITENT_NAME,
    case 
        when ltrim(isnull(case CL_ET.IS_REZIDENT when 0 then CL_ET_TIN.FIELD else CL_ET.INN end,'')) = '' 
			then replicate('0',case when CL_ET.KIND_CLIENT = 1 then 10 else 12 end) 
        else left(case CL_ET.IS_REZIDENT when 0 then CL_ET_TIN.FIELD else CL_ET.INN end,19) 
    end
    , D.NUMBRANCH
	, isnull(CL_ET.OGRN, '') EMITENT_OGRN
	, case isnull(left(EMITENT_OKSM.FIELD, 3), '') when '' then '999' else EMITENT_OKSM.FIELD end EMITENT_OKSM
	, case	when CL_ET.KIND_CLIENT = 1 and CL_ET.IS_REZIDENT = 1 then 1
			when CL_ET.KIND_CLIENT = 1 and CL_ET.IS_REZIDENT = 0 then 2
			when CL_ET.KIND_CLIENT = 2 and CL_ET.IS_REZIDENT = 1 then 3
			when CL_ET.KIND_CLIENT = 2 and CL_ET.IS_REZIDENT = 0 then 4 
			else 0 end IS_REZIDENT_ET --yudin 06/08/14

--select 'insert into #tmp_bill' , NUM_CONTR.FIELD_STRING as NUM_CONTR , DATE_CONTR.FIELD_DATE as DATE_CONTR  , NUM_DOC.FIELD_STRING as NUM_DOC , DATE_DOC.FIELD_DATE as DATE_DOC

from
    -- счет депо
    DEPO_ACC D 
		JOIN DEPO_PART P on P.ID_ACC = D.ID_ACC 
 
    -- договор
    left join DEPO_ACC_ADDFL NUM_CONTR
     on NUM_CONTR.ID_FIELD = @ID_FIELD_NUM_CONTR
    and NUM_CONTR.ID_OBJECT = D.ID_ACC

    left join DEPO_ACC_ADDFL DATE_CONTR
     on DATE_CONTR.ID_FIELD = @ID_FIELD_DATE_CONTR
    and DATE_CONTR.ID_OBJECT = D.ID_ACC
	
	-- по части договора
	LEFT JOIN DEPO_PART_ADDFL NUM_DOC
		ON NUM_DOC.ID_FIELD = @ID_FIELD_NUM_DOC
		AND NUM_DOC.ID_OBJECT = P.ID_PART

	LEFT JOIN DEPO_PART_ADDFL DATE_DOC
		ON DATE_DOC.ID_FIELD = @ID_FIELD_DATE_DOC
		AND DATE_DOC.ID_OBJECT = P.ID_PART

    -- л/с
    --,DEPO_ACC_TYPE DT,DEPO_PART P,DEPO_ACCOUNTS4 L,OD_SALTRN4 S,
	 ,DEPO_ACC_TYPE DT,DEPO_ACCOUNTS4 L,OD_SALTRN4 S,

    -- ценная бумага
    DEPO_EMISSION EM,DEPO_PAPER_TYPES PT,COM_CURRENCY VL,

    -- векселедатель (эмитент)
    DEPO_EMITENT ET
	, CLIENTS CL_ET
		left join CLIENTS_ADDFL_STRING EMITENT_OKSM
		on EMITENT_OKSM.ID_OBJECT = CL_ET.ID_CLIENT
		and EMITENT_OKSM.ID_FIELD = @FIELD_OKSM

		left join CLIENTS_ADDFL_STRING CL_ET_TIN
		on CL_ET_TIN.ID_OBJECT = CL_ET.ID_CLIENT
		and CL_ET_TIN.ID_FIELD = @FIELD_TIN
where
    -- счет депо 
      D.ID_ACC_TYPE = DT.ID_ACC_TYPE
  and DT.ACTIV = 1

  --and P.ID_ACC = D.ID_ACC
  and L.ID_PART = P.ID_PART

  and D.STATE <> 3  -- не зарезервирован
  and D.DATE_OPEN <= @Date
  and D.DATE_CLOSE > @Date

  and S.ID_ACCOUNT = L.ID_ACCOUNT
  and S.DATE_TRN   < @Date
  and S.DATE_NEXT >= @Date
  and S.SALDO <> 0 -- штуки

    -- ценная бумага
  and EM.ID_EMITENT <> 0 -- кроме собственных векселей
  and EM.ID_PAPER = L.ID_PAPER
  and EM.ID_CLASS = 3 -- векселя

    -- исключаем учтенные и собственные векселя
  and not exists(select * from #GET_ACC_PAPER_SALDO T where T.ID_PAPER = L.ID_PAPER)

    -- тип ценной бумаги
  and PT.ID_PAPER_TYPE = EM.ID_PAPER_TYPE

    -- валюта номинала
  and VL.ID_CURRENCY = EM.ID_CURRENCY

    -- векселедатель (эмитент)
  and ET.ID_EMITENT = EM.ID_EMITENT
  and CL_ET.ID_CLIENT = ET.ID_CLIENT
  and (D.NUMBRANCH = @NumBranch or @NumBranch = 0)

order by D.NUMBRANCH, ET.EMITENT_NAME,isnull(PT.SID_TYPE_CB,'OTHER'),isnull(EM.PAPER_SERIES,''),isnull(EM.PAPER_NUMBER,'')
---------------------------------------------------------------------------------------
-- векселя на хранении на внебалансе
-- нет в депозитарии
---------------------------------------------------------------------------------------
declare @ID_FIELD int
select @ID_FIELD = ID_FIELD from DEPO_EMISSION_ADDFL_DIC where NAME_FIELD = 'Договор хранения'
---------------------------------------------------------------------------------------

insert into #tmp_bill(
    -- счет депо
    ID_ACC,

    -- л/с
    ID_ACCOUNT,RAZDEL,

    -- договор
    NUM_CONTRACT,DATE_CONTRACT,CONTRACT_MEANING,
    DATE_IN,

    -- ценная бумага
    ID_PAPER,PAPER_SERIES,PAPER_NUMBER,PAPER_NOTE,DATE_EMISSION,NOMINAL,
    DATE_PAYING,SID_TYPE_CB,CURRENCY_CB,

    -- векселедатель (эмитент)
    ID_EMITENT,EMITENT_NAME,INN_ET,BRANCH, IS_REZIDENT_CURRENT_OWNER
    )

select
    -- счет депо
    0,

    -- л/с
    S.ID_ACCOUNT,2 RAZDEL,

    -- договор
    null NUM_CONTRACT,null DATE_CONTRACT,
    case 
        when isnull(A.DATEDOG,'22220101') = '22220101'
        then isnull(ltrim(A.DATENUMDOG),'')
        else '№ '+isnull(ltrim(A.DATENUMDOG),'')+' от '+convert(varchar(10),A.DATEDOG,104)
    end CONTRACT_MEANING,
    AR_DATE_IN.FIELD_DATE DATE_IN,

    -- ценная бумага
    EM.ID_PAPER,isnull(EM.PAPER_SERIES,''),isnull(EM.PAPER_NUMBER,''),isnull(EM.PAPER_NOTE,''),EM.DATE_EMISSION,EM.NOMINAL,
    EM.DATE_PAYING,isnull(PT.SID_TYPE_CB,'OTHER'),VL.CURRENCY_CB,

    -- векселедатель (эмитент)
    ET.ID_EMITENT,ET.EMITENT_NAME,CL_ET.INN
    , A.NUMBRANCH
	, case	when CL_ET.KIND_CLIENT = 1 and CL_ET.IS_REZIDENT = 1 then 1
			when CL_ET.KIND_CLIENT = 1 and CL_ET.IS_REZIDENT = 0 then 2
			when CL_ET.KIND_CLIENT = 2 and CL_ET.IS_REZIDENT = 1 then 3
			when CL_ET.KIND_CLIENT = 2 and CL_ET.IS_REZIDENT = 0 then 4 
			else 0 end IS_REZIDENT_CURRENT_OWNER
from
    -- ценная бумага
    DEPO_EMISSION EM,DEPO_PAPER_TYPES PT,COM_CURRENCY VL,

    -- договор хранения
    DEPO_EMISSION_ADDFL_ARRAY AR_DATE_IN, DEPO_EMISSION_ADDFL_ARRAY AR_DATE_OUT, DEPO_EMISSION_ADDFL_ARRAY AR_ACC,

    -- л/с
    OD_ACCOUNTS2 A,OD_SALTRN2 S,

    -- векселедатель (эмитент)
    DEPO_EMITENT ET,CLIENTS CL_ET

where
    -- ценная бумага
      EM.ID_EMITENT <> 0 -- кроме собственных векселей
  and EM.ID_CLASS = 3 -- векселя

    -- исключаем учтенные и собственные векселя
  and not exists(select * from #GET_ACC_PAPER_SALDO T where T.ID_PAPER = EM.ID_PAPER)

    -- тип ценной бумаги
  and PT.ID_PAPER_TYPE = EM.ID_PAPER_TYPE

    -- валюта номинала
  and VL.ID_CURRENCY = EM.ID_CURRENCY

    -- договор
  and AR_DATE_IN.ID_FIELD     = @ID_FIELD
  and AR_DATE_IN.ID_OBJECT    = EM.ID_PAPER
  and AR_DATE_IN.INDEX_COLUMN = 0 --Дата принятия

  and AR_DATE_OUT.ID_FIELD     = @ID_FIELD
  and AR_DATE_OUT.ID_OBJECT    = EM.ID_PAPER
  and AR_DATE_OUT.INDEX_COLUMN = 1 --Дата снятия
  and AR_DATE_OUT.INDEX_ROW    = AR_DATE_IN.INDEX_ROW

  and AR_ACC.ID_FIELD          = @ID_FIELD
  and AR_ACC.ID_OBJECT         = EM.ID_PAPER
  and AR_ACC.INDEX_COLUMN      = 2 --Номер счета
  and AR_ACC.INDEX_ROW         = AR_DATE_IN.INDEX_ROW

  and AR_DATE_IN.FIELD_DATE  <  @Date
  and AR_DATE_OUT.FIELD_DATE >= @Date

    -- л/с
  and AR_ACC.FIELD_STRING = A.STRACCOUNT
  and A.BAL2 = '90803'

    -- сальдо л/с
  and S.ID_ACCOUNT = A.ID_ACCOUNT
  and S.DATE_TRN < @Date
  and S.DATE_NEXT >= @Date
  and S.SALDO <> 0

    -- векселедатель (эмитент)
  and ET.ID_EMITENT = EM.ID_EMITENT
  and CL_ET.ID_CLIENT = ET.ID_CLIENT
  and (A.NUMBRANCH = @NumBranch or @NumBranch = 0)

order by A.NUMBRANCH, ET.EMITENT_NAME,isnull(PT.SID_TYPE_CB,'OTHER'),isnull(EM.PAPER_SERIES,''),isnull(EM.PAPER_NUMBER,'')


--select '#tmp_bill_2' ,* from #tmp_bill where CONTRACT_MEANING = 'N 0100002.13001 от 01.01.2010'

-- векселедержатель на отчетную дату
update T set 
    ID_CURRENT_OWNER   = EN.ID_OWNER_NEXT,
    CURRENT_OWNER_NAME = isnull(EN.OWNER_NEXT,''),
    INN_CURRENT_OWNER  = 
        case 
            when ltrim(isnull(OWNER_CURRENT_INN.FIELD_STRING,'')) = '' 
            then replicate('0',10) 
            else left(OWNER_CURRENT_INN.FIELD_STRING,19) 
        end
	, IS_REZIDENT_CURRENT_OWNER = case	when OWNER_CURRENT.KIND_PARTICIPANT = 1 and isnull(OWNER_CURRENT_OKSM.FIELD_STRING, '643') = '643' then 1 --yudin 07/08/14
										when OWNER_CURRENT.KIND_PARTICIPANT = 1 and isnull(OWNER_CURRENT_OKSM.FIELD_STRING, '643') <> '643' then 2
										when OWNER_CURRENT.KIND_PARTICIPANT = 2 and isnull(OWNER_CURRENT_OKSM.FIELD_STRING, '643') = '643' then 3
										when OWNER_CURRENT.KIND_PARTICIPANT = 2 and isnull(OWNER_CURRENT_OKSM.FIELD_STRING, '643') <> '643' then 4 
										else 0 end
	, CURRENT_OWNER_OGRN = isnull(OWNER_CURRENT_OGRN.FIELD_STRING, '')
	, CURRENT_OWNER_OKSM = isnull(OWNER_CURRENT_OKSM.FIELD_STRING, '')
	,CURRENT_OWNER_STATUS = ISNULL(OWNER_CURRENT_STATUS.FIELD_STRING,'')
from #tmp_bill T,

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
		on OWNER_CURRENT_OGRN.ID_OBJECT = OWNER_CURRENT.ID_PARTICIPANT
		and OWNER_CURRENT_OGRN.ID_FIELD = @FIELD_OWNER_OGRN
		
		left join DEPO_PARTICIPANT_ADDFL OWNER_CURRENT_OKSM
		on OWNER_CURRENT_OKSM.ID_OBJECT = OWNER_CURRENT.ID_PARTICIPANT
		and OWNER_CURRENT_OKSM.ID_FIELD = @FIELD_OWNER_OKSM
		-- Статус вексельдателя (код) (1-собственник, 2- довер. управляющий, 3-иное)
		left join DEPO_PARTICIPANT_ADDFL OWNER_CURRENT_STATUS
		on OWNER_CURRENT_OKSM.ID_OBJECT = OWNER_CURRENT.ID_PARTICIPANT
		and OWNER_CURRENT_OKSM.ID_FIELD = @FIELD_OWNER_STATUS

where EN.ID_PAPER = T.ID_PAPER

  and EN.ID_PAPER       = EN_LAST.ID_PAPER
  and EN.ID_ENDORSEMENT = EN_LAST.LAST_ID_ENDORSEMENT

  and OWNER_CURRENT.ID_PARTICIPANT = EN.ID_OWNER_NEXT
-------------------------------------------
-- отчитывающийся банк - первый векселедержателей
-- нет индоссаментов
update T set 
    ID_CURRENT_OWNER   = BILL.ID_PAPER_OWNER,
    CURRENT_OWNER_NAME = BILL.PAPER_OWNER,
    INN_CURRENT_OWNER  = isnull(OWNER_FIRST_INN.FIELD_STRING,'')
	, IS_REZIDENT_CURRENT_OWNER = case	when OWNER_FIRST.KIND_PARTICIPANT = 1 and isnull(T.CURRENT_OWNER_OKSM, '643') = '643' then 1 --yudin 07/08/14
										when OWNER_FIRST.KIND_PARTICIPANT = 1 and isnull(T.CURRENT_OWNER_OKSM, '643') <> '643' then 2
										when OWNER_FIRST.KIND_PARTICIPANT = 2 and isnull(T.CURRENT_OWNER_OKSM, '643') = '643' then 3
										when OWNER_FIRST.KIND_PARTICIPANT = 2 and isnull(T.CURRENT_OWNER_OKSM, '643') <> '643' then 4 
										else 0 end
from #tmp_bill T,

    -- первый векселедержатель    
    DEPO_BILL BILL,
    DEPO_PARTICIPANT OWNER_FIRST 
    left join DEPO_PARTICIPANT_ADDFL OWNER_FIRST_INN
     on OWNER_FIRST_INN.ID_FIELD = @ID_FIELD_INN
    and OWNER_FIRST_INN.ID_OBJECT = OWNER_FIRST.ID_PARTICIPANT

where T.ID_CURRENT_OWNER is null 

    -- первый векселедержатель
  and BILL.ID_PAPER = T.ID_PAPER
  and OWNER_FIRST.ID_PARTICIPANT = BILL.ID_PAPER_OWNER
---------------------------------------------------------------------------------------
-- дата поступления (1-й кредитовый оборот по счету - счета пассивные)
update T set DATE_IN = S.MIN_DATE_TRN
from #tmp_bill T,
    (select ID_ACCOUNT,min(DATE_TRN) MIN_DATE_TRN from OD_SALTRN4 where OBOROT_CR <> 0 group by ID_ACCOUNT) S
where T.RAZDEL = 4 -- только для депо
  and S.ID_ACCOUNT = T.ID_ACCOUNT
---------------------------------------------------------------------------------------
-- срок и условие платежа
create table #PAPER_PAYOFF(
    ID_PAPER             INT          NOT NULL,
    DATE_EMISSION        DATETIME     NOT NULL,
    DATE_PAYING          DATETIME     NOT NULL,

    PAYOFF_TYPE          TINYINT      NOT NULL,
    PAYOFF_INTERVAL_TYPE TINYINT      NOT NULL,
    PAYOFF_INTERVAL      SMALLINT     NOT NULL,
    PAYOFF_DATE_GE       DATETIME     NOT NULL,
    PAYOFF_DATE_LE       DATETIME     NOT NULL,
    PAYOFF_PRODUCE_DATE  DATETIME     NOT NULL,

    PAYOFF_MEANING       VARCHAR(255) NULL       -- срок и условие платежа
    )

-- #tmp_bill -> #PAPER_PAYOFF
insert into #PAPER_PAYOFF(
    ID_PAPER,DATE_EMISSION,DATE_PAYING,
    PAYOFF_TYPE,PAYOFF_INTERVAL_TYPE,PAYOFF_INTERVAL,
    PAYOFF_DATE_GE,PAYOFF_DATE_LE,PAYOFF_PRODUCE_DATE
    )
select distinct
    T.ID_PAPER,T.DATE_EMISSION,T.DATE_PAYING,
    BILL.PAYOFF_TYPE,isnull(BILL.PAYOFF_INTERVAL_TYPE,0),BILL.PAYOFF_INTERVAL,
    isnull(BILL.PAYOFF_DATE_GE,'22220101'),isnull(BILL.PAYOFF_DATE_LE,'22220101'),
    isnull(BILL.PAYOFF_PRODUCE_DATE,'22220101')     
from #tmp_bill T,DEPO_BILL BILL
where T.ID_PAPER = BILL.ID_PAPER

exec OGO_FILL_PAYOFF_MEANING -- срок и условие платежа

-- #PAPER_PAYOFF -> #tmp_bill
update T set PAYOFF_MEANING = L.PAYOFF_MEANING
from #tmp_bill T,#PAPER_PAYOFF L
where T.ID_PAPER = L.ID_PAPER

drop table #PAPER_PAYOFF


Update #tmp_bill set CURRENCY_CB = '643' where CURRENCY_CB = '810'


		Insert into #SECURITIES(BRANCH, PART, SUBPART, ID_PAPER, 
			COL169,
			COL170, COL170B, COL171,COL172, COL173, COL174, COL175, COL176, COL177, COL178, COL179,
			COL180, COL181, COL182, COL183, COL184, COL185,COL186, COL187, COL187B, COL188, COL189, 
			COL190) 
			Select BRANCH, 2 PART, '2.3' SUBPART, T.ID_PAPER,
				 EMITENT_NAME as COL169,
				 INN_ET as COL170,
			     IS_REZIDENT_ET as COL170B,
			     EMITENT_OGRN as COL171,
			     EMITENT_OKSM as COL172,
			     SID_TYPE_CB as COL173,
			     PAPER_SERIES as COL174,
			     PAPER_NUMBER as COL175,
			     '' as COL176,
			     T.DATE_EMISSION as COL177,
				 COL178 = CASE WHEN DP.PAYOFF_TYPE = 1 THEN 1  --- определенный день
						WHEN DP.PAYOFF_TYPE = 2 THEN 1  --- во столько-то времени от предъявления
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN 2 -- по предъявлении
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN 3 -- по предъявлении, но не ранее определенной даты
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN 4 --  по предъявлении, но не ранее определенной даты и не позднее определенной даты
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN 99 --  иное
						WHEN DP.PAYOFF_TYPE = 4 THEN 99 END, -- во столько-то времени от предъявления

				 COL179 = CASE WHEN DP.PAYOFF_TYPE = 1 THEN DP.DATE_PAYOFF   --- определенный день
						WHEN DP.PAYOFF_TYPE = 2 THEN DP.DATE_PAYOFF   --- во столько-то времени от предъявления
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN '22220101' -- по предъявлении
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN DP.PAYOFF_DATE_GE -- по предъявлении, но не ранее определенной даты
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN DP.PAYOFF_DATE_GE --  по предъявлении, но не ранее определенной даты и не позднее определенной даты
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN '22220101' --  иное
						WHEN DP.PAYOFF_TYPE = 4 THEN '22220101' END, -- во столько-то времени от предъявления

				 COL180 = CASE WHEN DP.PAYOFF_TYPE = 1 THEN '22220101'   --- определенный день
						WHEN DP.PAYOFF_TYPE = 2 THEN '22220101'   --- во столько-то времени от предъявления
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN '22220101' -- по предъявлении
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE = '22220101' THEN '22220101' -- по предъявлении, но не ранее определенной даты
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE <> '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN DP.PAYOFF_DATE_LE --  по предъявлении, но не ранее определенной даты и не позднее определенной даты
						WHEN DP.PAYOFF_TYPE = 3 AND DP.PAYOFF_DATE_LE = '22220101' AND DP.PAYOFF_DATE_GE <> '22220101' THEN '22220101' --  иное
						WHEN DP.PAYOFF_TYPE = 4 THEN '22220101' END, -- во столько-то времени от предъявления
						
				 NOMINAL  as COL181,
				 CURRENCY_CB  as COL182,
				 DATE_IN  as COL183,
				 CONTRACT_MEANING  as COL184,
				 CURRENT_OWNER_NAME  as COL185,
				 CURRENT_OWNER_STATUS as COL186,
				 INN_CURRENT_OWNER  as COL187,
				 IS_REZIDENT_CURRENT_OWNER  as COL187B,
				 CURRENT_OWNER_OGRN  as COL188,
				 CURRENT_OWNER_OKSM  as COL189,
				 left(PAPER_NOTE, 60) as COL190
			from #tmp_bill T
				join dbo.fn_OGO_PAPER_DATE_PAYM() DP on DP.ID_PAPER = T.ID_PAPER


drop table #tmp_bill


GO
drop table #GET_ACC_PAPER_SALDO
drop table #SECURITIES
Go