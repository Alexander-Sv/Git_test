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

		--- кол-во ценных бумаг на чсетах КО
		, COL74						decimal(28,12)		not null  default 0 -- кол-во ц.б.
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

		, COL102					money				null  -- Объем вложениий в ц.б.
		, COL103                    varchar(5)          null  -- номер бал. счета 2-го порядка 

		--- раздел 2
		-- подраздел 2.1
		, COL105					varchar(255)		null -- вексельдатель
		, COL106					varchar(19)			null -- ИНН
		, COL106B					tinyint				null -- yudin 06/08/14 возможно, для ПТК
		, COL107					varchar(20)			null -- ОГРН
		, COL108					varchar(20)			null -- ОКСМ
		, COL109					varchar(5)			null -- код типа ц.б.
		, COL110					varchar(10)			null -- серия векс
		, COL111					varchar(30)			null -- номер векс
		, COL112					varchar(255)		null -- номер бланка
		, COL113					datetime			null -- дата составления
		, COL114					int					null -- код условия
		, COL115					datetime			null -- дата 1
		, COL116					datetime			null -- дата 2
		, COL117					decimal(28,12)		null -- процентная ставка 
		, COL118					money				null -- вексельная сумма 
		, COL119					varchar(3)			null -- код валюты вексельной суммы 
		, COL120					money				null -- бал. стоимость векселя на дату прин на бал.
		, COL121					money				null -- бал. стоимость векселя на отчетн дату.
		, COL122					money				null -- накопленный дисконт
		, COL123					int					null -- категория качества
		, COL124					money				null -- сформированные резерв
		, COL125					datetime			null -- дата принятия на баланс
		, COL126					varchar(255)		null -- основание приобретения
		, COL127					varchar(160)		null -- контрагент
		, COL128					varchar(19)			null -- Инн
		, COL128B					tinyint				null --  yudin 06/08/14 возможно, для ПТК
		, COL129					varchar(20)			null -- огрн
		, COL130					varchar(20)			null -- оксм
		, COL131					varchar(5)			null -- бал. счет 2го пор.
		, COL132					varchar(160)		null -- местонахождения векселя
		, COL133					varchar(19)			null -- ИНН
		, COL133B					tinyint				null -- yudin 06/08/14 возможно, для ПТК
		, COL134					varchar(20)			null -- ОГРН
		, COL135					varchar(20)			null -- ОКСМ
		, COL136					varchar(255)		null -- основания нахожден. векс. в др. организ.
		, COL137					money				null -- стоимость реализации
		, COL138					datetime			null -- дата списания
		, COL139					varchar(255)		null -- основание выбытия
		, COL140					varchar(160)		null -- контрагент
		, COL141					varchar(19)			null -- Инн
		, COL141B					tinyint				null --  yudin 06/08/14 возможно, для ПТК
		, COL142					varchar(20)			null -- огрн
		, COL143					varchar(20)			null -- оксм
		, COL144					varchar(255)		null -- примечание

		-- подраздел 2.2
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

		-- подраздел 2.3
		, COl169					varchar(255)		null -- венквсельдержатель
		, COl170					varchar(19)			null -- ИНН
		, COl170B					tinyint				null -- yudin 06/08/14 возможно, для ПТК
		, COl171					varchar(20)			null -- ОГРН
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

		-- Раздел 3

		, COL192					varchar(255)		null -- наименование эмитента
		, COL193					varchar(19)			null -- ИНН
		, COL193B					tinyint				null -- yudin 06/08/14 возможно, для ПТК
		, COL194					varchar(10)			null -- КПП
		, COL195					varchar(20)			null -- ОГРН
		, COL196					varchar(20)			null -- ОКСМ
		, COL197					varchar(5)			null -- код типа ц.б.
		, COL198					varchar(20)			null -- гос рег номер выпоска ц.б.
		, COL199					varchar(20)			null -- еод ISIN
		, COL200					varchar(3)			null -- код валюты
		, COL201					money				null -- номинал стоимость одной цен бум

		, COL202					money				null -- переданных в Прям репо
		, COL203					money				null -- по сделкам займа
		, COL204					money				null -- получен по обр репо 
		, COL205					money				null -- получен по сдел займа
		, COL206					money				null -- переданных в довер упр
		, COL207					money				null -- права передан в довер упр
		, COL208					money				null -- в залог по обязат
		, COL209					money				null -- в залог по обязат 3х лиц
		, COL210					money				null -- принятых в залог
		, COL211					money				null -- учит на торг счетах
		, COL212					money				null -- ограничено в связи с копрорат действиями
		, COL213					money				null -- запрет на осуществен опер
		, COL214					money				null -- под арестом

		, COL215					varchar(60)			null -- примечание

-- Поддержка ОКВЭД 2
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
from fn_OGO_READ_SETTING_TABLE('Отчетность государственных органов','Настройка типов счетов для формы 711') T1
		join fn_OGO_READ_SETTING_TABLE('Отчетность государственных органов','Настройка типов счетов для формы 711') T2
			join fn_OGO_READ_SETTING_TABLE('Отчетность государственных органов','Настройка типов счетов для формы 711') T3
				join fn_OGO_READ_SETTING_TABLE('Отчетность государственных органов','Настройка типов счетов для формы 711') T4
				on T4.INDEX_ROW = T3.INDEX_ROW
				and T4.INDEX_COLUMN = 3
			on T3.INDEX_ROW = T2.INDEX_ROW
			and T3.INDEX_COLUMN = 2
		on T2.INDEX_ROW = T1.INDEX_ROW
		and T2.INDEX_COLUMN = 1
		and T1.INDEX_COLUMN = 0


exec p711a2017_Part1 @Date, @PrintProt, @NumBranch				-- Раздел 1

-- Раздел 2

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
---------------------------------------------------------------------------------------
exec OGO_GET_ACC_BILL @Date, @NumBranch -- балансовый учет векселей
---------------------------------------------------------------------------------------

	exec p711aForm_fbill_1_2017 @Date, @SidVersion				-- расчет подраздела 2.1 - учтенные векселя
	exec p711aForm_fbill_2_2017 @Date, @SidVersion				-- расчет подраздела 2.2 - собственные векселя
	exec p711aForm_fbill_3_2017 @Date,@NumBranch, @SidVersion	-- расчет подраздела 2.3 - векселя на хранении

DROP TABLE #GET_ACC_PAPER_SALDO

exec p711a2017_Part3 @Date, @NumBranch						-- Раздел 3


-- данные ценной бумаги, эмитента и регистратора
Declare @FIELD_OKSM int	select @FIELD_OKSM = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Код страны регистрации/гражданства')
Declare @FIELD_INDICATION int	select @FIELD_INDICATION = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Признак депозитария')
Declare @FIELD_LICENSE int	select @FIELD_LICENSE = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Лицензия профессионального участника РЦБ')
Declare @FIELD_ACC_NOSTRO_PAPER int	select @FIELD_ACC_NOSTRO_PAPER = (select ID_FIELD from DEPO_EMISSION_ADDFL_DIC where NAME_FIELD = 'Лиц. счет НОСТРО в вышестоящем депозитарии')
Declare @FIELD_TIN int	select @FIELD_TIN = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Федеральный налоговый идент.номер (TIN)')

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
	
	--- заполнение занных вышестоящего депозитария из  бумаги. Если не нашли в Счете то берем из бумаги, иначе ничего не делаем.
	/*
	, REGISTRATOR_NAME = case when isnull(SEC.REGISTRATOR_NAME, '' ) = '' then  isnull(REGISTRATOR.REDUCE_NAME, '') else SEC.REGISTRATOR_NAME end
	, REGISTRATOR_INDICATION = case when  isnull(SEC.REGISTRATOR_INDICATION,'') = '' then 
								 case when REGISTRATOR.BIC = '044525060' then 'Н' else left(REGISTRATOR_INDICATION.SENSE_STRING, 1) end 
								 else SEC.REGISTRATOR_INDICATION end	-- учитываем Внешэкономбанк
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
								 case when REGISTRATOR.BIC = '044525060' then 'Н' else left(REGISTRATOR_INDICATION.SENSE_STRING, 1) end 
								 else SEC.REGISTRATOR_INDICATION end	-- учитываем Внешэкономбанк
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

-- для паев инвестиционных фондов - резидентов
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
	and UK.ID_FIELD = (Select ID_FIELD from DEPO_EMISSION_ADDFL_DIC where NAME_FIELD = 'Управляющая компания')
where SEC.PAPER_TYPE_CODE = 'SHS8'

-------------------------------------------- -------------------------------------------- 
--- {85726} Если не нашли вышестоящего депозитария (к. 86-91), то пустые строки
UPDATE #SECURITIES
    SET REGISTRATOR_INN = '',
    REGISTRATOR_KPP = '',
    REGISTRATOR_OGRN = '',
    REGISTRATOR_OKSM = ''
WHERE REGISTRATOR_NAME = ''
-------------------------------------------- Схлопывание-------------------------------------------

-- Схлопываем закладные физических лиц
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
	, 'физические лица' EMITENT_NAME
	, '000000000000' EMITENT_INN, 3 EMITENT_IS_REZIDENT
from #SECURITIES SEC where SEC.LAYER = 2

-- Схлопываем векселя
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

-- Учитываем Амортизацию номинала ценных бумаг
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
		and AMORT_DATE.ID_FIELD = (Select ID_FIELD from DEPO_EMISSION_ADDFL_DIC where NAME_FIELD = 'Амортизация номинала')
		AND AMORT_DATE.FIELD_DATE < @Date
	where P_IN.ID_PAPER = P.ID_PAPER
	order by P_IN.ID_PAPER, AMORT_DATE.FIELD_DATE desc, AMORT_VALUE.FIELD_DECIMAL asc
), P.PAPER_NOMINAL) 
from #SECURITIES P
where PAPER_TYPE_CODE <> 'ENC'


-- нумерация строк в подразделах
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

--- по обращению {85944} у некоторых банков в карточке валюты заведено значение 810
UPDATE #SECURITIES 
    SET PAPER_CURRENCY_CODE = CASE WHEN PAPER_CURRENCY_CODE = '810' THEN '643' ELSE PAPER_CURRENCY_CODE END

-- Здесь в таблице #SECURITIES готов Рекордсет с данными Отчета

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


Select	'Расчет формы 711 на '+convert(varchar(10), @Date, 104)+' выполнен.' +char(10)
	+	'Расшифровка расчета по разделам 1 и 3'
	+	' сохранена в список "Форма №711. Рассчитанные данные" ' REZULT


Drop table #SECURITIES
Drop table #SETTING_DEPO_ACC_TYPES

GO
