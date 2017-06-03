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
		, COL74						decimal(28,12)		null   -- кол-во ц.б.
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

		, COL102					money				null  -- Объем вложениий в ц.б.
		, COL103                    varchar(5)          null  -- номер бал. счета 2-го порядка 

-- Поддержка ОКВЭД 2
		, ID_CLIENT int null
		, DATE_HISTORY datetime null
		, OKVED varchar(255) null
		, OKVED_OR_OKVED2 tinyint null

		)

		Go


if exists (select * from sysobjects where id = object_id('dbo.p711a2017_Part1') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure dbo.p711a2017_Part1
GO

Create Proc dbo.p711a2017_Part1(
      @Date      datetime
	, @PrintProt tinyint
    , @NumBranch smallint = 0
    )
as


Declare @CodesLoro varchar(255)	Select @CodesLoro = CODE_TYPE from #SETTING_DEPO_ACC_TYPES where NAME_TYPE = 'ЛОРО'

Declare @SUB_ACC smallint
select @SUB_ACC = dbo.fn_OGO_READ_SETTING_SCALAR('Депозитарий','Использование механизма субсчетов')
select @SUB_ACC = isnull(@SUB_ACC,0)


Declare @FIELD_OKSM int	select @FIELD_OKSM = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Код страны регистрации/гражданства')
Declare @FIELD_INDICATION int	select @FIELD_INDICATION = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Признак депозитария')
Declare @FIELD_LICENSE int	select @FIELD_LICENSE = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Лицензия профессионального участника РЦБ')
Declare @FIELD_ACC_NOSTRO_DEPO_ACC int	select @FIELD_ACC_NOSTRO_DEPO_ACC = (select ID_FIELD from DEPO_ACC_ADDFL_DIC where NAME_FIELD = 'Лиц. счет НОСТРО в вышестоящем депозитарии')
Declare @FIELD_TIN int	select @FIELD_TIN = (select ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Федеральный налоговый идент.номер (TIN)')

Insert into #SECURITIES(BRANCH, PART, SUBPART, ID_ACCOUNT, DEPO_TYPE_CODE, ID_PAPER, ID_CLIENT_OWNER, PAPER_COUNT
					, REGISTRATOR_NAME, REGISTRATOR_INDICATION, REGISTRATOR_INN, REGISTRATOR_IS_REZIDENT, REGISTRATOR_KPP
					, REGISTRATOR_OGRN, REGISTRATOR_OKSM, REGISTRATOR_LICENSE_NUM, NOSTRO_STR_ACCOUNT
	)
Select D.NUMBRANCH, 1 PART
	,	case 
			when @CodesLoro like '%,'+ltrim(rtrim(DT.CODE))+',%' then '1.1' 
			else case DEPO_ACC_OWNER.ID_CLIENT when 0 then '1.3' else '1.2' end
		end SUBPART
	, A.ID_ACCOUNT, DT.CODE DEPO_TYPE_CODE
	, PAPER.ID_PAPER
	, DEPO_ACC_OWNER.ID_CLIENT ID_CLIENT_OWNER
--	, case when @SUB_ACC = 1 and D.ID_CLIENT = 0 then S_SUB.SALDO else S.SALDO end PAPER_COUNT -- Обращение 79678. 25.07.2016
	, case when @SUB_ACC = 1 and (D.ID_CLIENT = 0 or isNull(S_SUB.SALDO,0) <> 0) then S_SUB.SALDO else S.SALDO end PAPER_COUNT

	, case when KEEPER.ID_CLIENT is null then null else  isnull(KEEPER.REDUCE_NAME, '')  end REGISTRATOR_NAME
	, case when KEEPER.ID_CLIENT is null then null else  
		case when KEEPER.BIC = '044525060' then 'Н' else left(KEEPER_INDICATION.SENSE_STRING, 1) end
	  end REGISTRATOR_INDICATION
	, case when KEEPER.ID_CLIENT is null then null else  
		case isnull(case KEEPER.IS_REZIDENT when 0 then KEEPER_TIN.FIELD else KEEPER.INN end, '')
			when '' then case KEEPER.IS_REZIDENT when 0 then '000' else '0000000000' end + case KEEPER.KIND_CLIENT when 1 then '' else '00' end
			else case KEEPER.IS_REZIDENT when 0 then KEEPER_TIN.FIELD else KEEPER.INN end
		end
	  end REGISTRATOR_INN
	, case when KEEPER.ID_CLIENT is null then null else  
		case	when KEEPER.KIND_CLIENT = 1 and KEEPER.IS_REZIDENT = 1 then 1
				when KEEPER.KIND_CLIENT = 1 and KEEPER.IS_REZIDENT = 0 then 2
				when KEEPER.KIND_CLIENT = 2 and KEEPER.IS_REZIDENT = 1 then 3
				when KEEPER.KIND_CLIENT = 2 and KEEPER.IS_REZIDENT = 0 then 4
		else 0  end 
	  end REGISTRATOR_IS_REZIDENT
	, case when KEEPER.ID_CLIENT is null then null else  case KEEPER.IS_REZIDENT when 1 then isnull(KEEPER.KPPU, '') else '' end  end REGISTRATOR_KPP
	, case when KEEPER.ID_CLIENT is null then null else  case KEEPER.IS_REZIDENT when 1 then isnull(KEEPER.OGRN, '') else '' end  end REGISTRATOR_OGRN
	, case when KEEPER.ID_CLIENT is null then null else  case isnull(left(KEEPER_KOD.FIELD, 3), '') when '' then '999' else KEEPER_KOD.FIELD end  end REGISTRATOR_OKSM
	, case when KEEPER.ID_CLIENT is null then null else  isnull(left(KEEPER_LICENSE_ARRAY.FIELD_STRING, 20), '')  end REGISTRATOR_LICENSE_NUM
	, case when KEEPER.ID_CLIENT is null then null else  KEEPING_PLACE_ACC.STR_ACCOUNT  end NOSTRO_STR_ACCOUNT

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

		left join DEPO_ACCOUNTS4 KEEPING_PLACE_ACC
			join DEPO_PART KEEPING_PLACE_PART
				join DEPO_ACC KEEPING_PLACE_DEPO
					join CLIENTS KEEPER
						left join CLIENTS_ADDFL_STRING KEEPER_KOD 
						on KEEPER_KOD.ID_OBJECT = KEEPER.ID_CLIENT
						and KEEPER_KOD.ID_FIELD = @FIELD_OKSM

						left join CLIENTS_ADDFL_STRING KEEPER_TIN
						on KEEPER_TIN.ID_OBJECT = KEEPER.ID_CLIENT
						and KEEPER_TIN.ID_FIELD = @FIELD_TIN

						left join CLIENTS_ADDFL_INT KEEPER_I
							join CLIENTS_ADDFL_SENSE KEEPER_INDICATION
							on KEEPER_INDICATION.ID_FIELD = KEEPER_I.ID_FIELD
							and KEEPER_INDICATION.SENSE_INT = KEEPER_I.FIELD
						on KEEPER_I.ID_FIELD = @FIELD_INDICATION 
						and KEEPER_I.ID_OBJECT = KEEPER.ID_CLIENT

						left join CLIENTS_ADDFL_ARRAY KEEPER_LICENSE_ARRAY
						on KEEPER_LICENSE_ARRAY.ID_OBJECT = KEEPER.ID_CLIENT
						and KEEPER_LICENSE_ARRAY.ID_FIELD = @FIELD_LICENSE
						and KEEPER_LICENSE_ARRAY.INDEX_COLUMN = 0 and KEEPER_LICENSE_ARRAY.INDEX_ROW = 0

					on KEEPER.ID_CLIENT = KEEPING_PLACE_DEPO.ID_CLIENT
					and KEEPER.ID_CLIENT <> 0
				on KEEPING_PLACE_DEPO.ID_ACC = KEEPING_PLACE_PART.ID_ACC
			on KEEPING_PLACE_PART.ID_PART = KEEPING_PLACE_ACC.ID_PART
		on KEEPING_PLACE_ACC.ID_ACCOUNT = SA.ID_ACCOUNT_A

	on SA.ID_ACCOUNT_P = A.ID_ACCOUNT


	join DEPO_PART P
		join DEPO_ACC D
			join DEPO_ACC_TYPE DT
			on DT.ID_ACC_TYPE = D.ID_ACC_TYPE
			and DT.ACTIV = 1

			join CLIENTS DEPO_ACC_OWNER
			on DEPO_ACC_OWNER.ID_CLIENT = D.ID_CLIENT

		on D.ID_ACC = P.ID_ACC
		and D.DATE_OPEN < @Date and D.DATE_CLOSE >= @Date
		and D.STATE <> 3 -- счет Депо не зарезервирован
		and (D.NUMBRANCH = @NumBranch or @NumBranch = 0)
	on P.ID_PART = A.ID_PART

	join DEPO_EMISSION PAPER
	on PAPER.ID_PAPER = A.ID_PAPER
where case when @SUB_ACC = 1 and D.ID_CLIENT = 0 then S_SUB.SALDO else S.SALDO end <> 0
order by 2, A.ID_ACCOUNT, PAPER.ID_PAPER


-- Проставляем тип счета депо (по установке)
Update S set S.DEPO_ACC_TYPE = SETTING.TYPE_ACC
from #SECURITIES S
	join #SETTING_DEPO_ACC_TYPES SETTING
	on SETTING.CODE_TYPE like '%,'+S.DEPO_TYPE_CODE+',%'
where S.SUBPART <> '1.1'

-- (85003) по инструкции 2332-у и 4212-у счета доверительного управляющего считаются счетами банка,
-- даже если они открыты на клиента
-- Наименования: Доверительное управление, Счета эмитентов, Залогодержатель, Эмиссионные счета
Update  #SECURITIES set SUBPART = '1.3' where DEPO_ACC_TYPE in ('TRUSTEE','ISSUER','ZALOGODERZHATEL','EMISSION')


-- код принадлежности к сектору экономики
Declare @Field_Property_form int			Select @Field_Property_form = ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Форма собственности'
--Declare @Field_OKVED int					Select @Field_OKVED = ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'ОКВЭД'
Declare @Field_State_strucrute_sign int		Select @Field_State_strucrute_sign = ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Признак гос.структуры'
Declare @Field_Registration_code int		Select @Field_Registration_code = ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Код страны регистрации/гражданства'
Declare @Field_RCB_license int				Select @Field_RCB_license = ID_FIELD from CLIENTS_ADDFL_DIC where NAME_FIELD = 'Лицензия профессионального участника РЦБ'

--------------------------------------------------------------------------------------------------------------------------------
--(Поддержка ОКВЭД 2)
--------------------------------------------------------------------------------------------------------------------------------

update #SECURITIES set ID_CLIENT= ID_CLIENT_OWNER,  DATE_HISTORY= @date

--заполнение ОКВЭДа из истории реквизита клиента
exec OGO_FILL_CLIENT_PROP_HISTORY '#SECURITIES', 'OKVED', 'ОКВЭД', 'ID_CLIENT', 4
exec OGO_FILL_CLIENT_PROP_ADDFL '#SECURITIES', 'OKVED', 'ОКВЭД', 4

--заполнение Версии ОКВЭДа из истории реквизита клиента
exec OGO_FILL_CLIENT_PROP_HISTORY '#SECURITIES', 'OKVED_OR_OKVED2', 'Версия ОКВЭД', 'ID_CLIENT', 1
exec OGO_FILL_CLIENT_PROP_ADDFL '#SECURITIES', 'OKVED_OR_OKVED2', 'Версия ОКВЭД', 1

--удаление пробелов
update #SECURITIES set OKVED= replace(OKVED, ' ', '') where OKVED <> ''

--добавление лидирующей запятой
update #SECURITIES set OKVED= ',' + OKVED + ',' where OKVED <> '' and len(OKVED) <= 253

--------------------------------------------------------------------------------------------------------------------------------

Update SEC set DEPO_OWNER_SECTOR = 
case C.IS_REZIDENT
	when 0 then 'S2'
	else
		case C.KIND_CLIENT
			when 2 then 'S14'
			else 
				case 
					when STATE_STRUCRUTE_SIGN.FIELD = 'Центральный банк' and REGISTRATION_CODE.FIELD = '643' then 'S121'
					else
						case C.IS_OFV
							when 1 then 'S131'
							else 
								case 
									when isnull(FIELD_RCB_LICENSE.FIELD_STRING, '') <> '' then 'S125'
									else
										case
											when ((OKVED_OR_OKVED2 <> 2 and OKVED LIKE '%,91%') or (OKVED_OR_OKVED2 = 2 and OKVED LIKE '%,94%')) then 'S112'
											when ((OKVED_OR_OKVED2 <> 2 and OKVED LIKE '%,66.01%') or (OKVED_OR_OKVED2 = 2 and OKVED LIKE '%,65.11%')) then 'S128'
											when ((OKVED_OR_OKVED2 <> 2 and OKVED LIKE '%,66.03%') or (OKVED_OR_OKVED2 = 2 and 
												(OKVED LIKE '%,65.12,%' or OKVED LIKE '%,65.12.1,%' or OKVED LIKE '%,65.12.2,%' or OKVED LIKE '%,65.12.3,%' or OKVED LIKE '%,65.12.4,%' or OKVED LIKE '%,65.12.5,%')
												)) then 'S128'
											when ((OKVED_OR_OKVED2 <> 2 and OKVED LIKE '%,66.02%') or (OKVED_OR_OKVED2 = 2 and (OKVED LIKE '%,65.3%' or OKVED LIKE '%,65.12.9,%'))) then 'S129'
											when ((OKVED_OR_OKVED2 <> 2 and OKVED LIKE '%,75.11.3,%') or (OKVED_OR_OKVED2 = 2 and OKVED LIKE '%,84.11.3,%')) then 'S133'
											else
												case
													when PROP_SNS.SENSE_STRING in ('Негос.ком.пред.и орг.', 'Негос.неком.орг.')
														then 'S11'
													when PROP_SNS.SENSE_STRING in (	  'Ком.пр.и орг.нах.в гос.кр.фед.с'
																					, 'Ком.пред.и орг.нах.в фед.соб.'
																					, 'Неком.орг.нах.в гос.кр.фед.соб.'
																					, 'Неком.орг.нах.в фед.соб.'
																					)
														then 'S111'
													when PROP_SNS.SENSE_STRING = 'Негос.фин.орг.' then 'S125'
													when PROP_SNS.SENSE_STRING in (	  'Фин.орг.нах.в гос.кр.фед.соб.'
																					, 'Фин.орг.нах.в фед.соб.'
																					)
														then 'S1251'
													when PROP_SNS.SENSE_STRING = 'Минфин России' then 'S13'
													when PROP_SNS.SENSE_STRING = 'Фин.орг.суб.РФ и мест.орг.вл.' then 'S132'
													when PROP_SNS.SENSE_STRING in (	  'В.бюд.фон.суб.РФ и мест.орг.вл.'
																					, 'Гос.в.бюдж.фонды'
																					)
														then 'S134'
													else
														case
															when KIND_CLIENT = 1 and SIGN_CLIENT = 2 then 'S122'
															else ''
														end
												end
										end
								end
						end
				end
		end
end,
SEC.DEPO_OWNER_OKSM = REGISTRATION_CODE.FIELD -- код оксм  КОЛОНКА 55
from #SECURITIES SEC
	join CLIENTS C
		left join CLIENTS_ADDFL_INT PROPERTY_FORM
			join CLIENTS_ADDFL_SENSE PROP_SNS
			on PROP_SNS.ID_FIELD = PROPERTY_FORM.ID_FIELD
			and PROP_SNS.SENSE_INT = PROPERTY_FORM.FIELD
		on PROPERTY_FORM.ID_OBJECT = C.ID_CLIENT
		and PROPERTY_FORM.ID_FIELD = @Field_Property_form

		left join CLIENTS_ADDFL_STRING STATE_STRUCRUTE_SIGN
		on STATE_STRUCRUTE_SIGN.ID_OBJECT = C.ID_CLIENT
		and STATE_STRUCRUTE_SIGN.ID_FIELD = @Field_State_strucrute_sign

		left join CLIENTS_ADDFL_STRING REGISTRATION_CODE
		on REGISTRATION_CODE.ID_OBJECT = C.ID_CLIENT
		and REGISTRATION_CODE.ID_FIELD = @Field_Registration_code

		left join CLIENTS_ADDFL_ARRAY FIELD_RCB_LICENSE
		on FIELD_RCB_LICENSE.ID_OBJECT = C.ID_CLIENT
		and FIELD_RCB_LICENSE.ID_FIELD = @Field_RCB_license
		and FIELD_RCB_LICENSE.INDEX_COLUMN = 0

	on C.ID_CLIENT = SEC.ID_CLIENT_OWNER

where SEC.SUBPART = '1.2' -- and LAYER = 1


-- данные счета депо и владельца счета
Update SEC
	  set OWNER_NAME = isnull(DEPO_ACC_OWNER.REDUCE_NAME, '') 
	, OWNER_INN =	case isnull(case DEPO_ACC_OWNER.IS_REZIDENT when 0 then DEPO_ACC_OWNER_TIN.FIELD else DEPO_ACC_OWNER.INN end, '')
						when '' then case DEPO_ACC_OWNER.IS_REZIDENT when 0 then '000' else '0000000000' end + case DEPO_ACC_OWNER.KIND_CLIENT when 1 then '' else '00' end
						else case DEPO_ACC_OWNER.IS_REZIDENT when 0 then DEPO_ACC_OWNER_TIN.FIELD else DEPO_ACC_OWNER.INN end
					end
	, OWNER_IS_REZIDENT = case	when DEPO_ACC_OWNER.KIND_CLIENT = 1 and DEPO_ACC_OWNER.IS_REZIDENT = 1 then 1
								when DEPO_ACC_OWNER.KIND_CLIENT = 1 and DEPO_ACC_OWNER.IS_REZIDENT = 0 then 2
								when DEPO_ACC_OWNER.KIND_CLIENT = 2 and DEPO_ACC_OWNER.IS_REZIDENT = 1 then 3
								when DEPO_ACC_OWNER.KIND_CLIENT = 2 and DEPO_ACC_OWNER.IS_REZIDENT = 0 then 4 
								else 0 end
	, OWNER_KPP = case DEPO_ACC_OWNER.IS_REZIDENT when 1 then isnull(DEPO_ACC_OWNER.KPPU, '') else '' end
	, OWNER_OGRN = case DEPO_ACC_OWNER.IS_REZIDENT when 1 then isnull(DEPO_ACC_OWNER.OGRN, '') else '' end
	, OWNER_OKSM = case isnull(left(OWNER_KOD.FIELD, 3), '') when '' then '999' else OWNER_KOD.FIELD end
	, OWNER_LICENSE_NUM = left(LICENSE_ARRAY.FIELD_STRING, 20)
	, OWNER_INDICATION = case when DEPO_ACC_OWNER.BIC = '044525060' then 'Н' else left(INDICATION.SENSE_STRING, 1) end	-- учитываем Внешэкономбанк
	, STR_ACCOUNT = A.STR_ACCOUNT

	, REGISTRATOR_NAME = case when isnull(SEC.REGISTRATOR_NAME, '' ) = '' then isnull(REGISTRATOR.REDUCE_NAME, '') else SEC.REGISTRATOR_NAME end 
	, REGISTRATOR_INDICATION = case when isnull(SEC.REGISTRATOR_INDICATION,'') = '' 
					then  case when REGISTRATOR.BIC = '044525060' then 'Н' else left(REGISTRATOR_INDICATION.SENSE_STRING, 1) end 
					else SEC.REGISTRATOR_INDICATION end	-- учитываем Внешэкономбанк
	, REGISTRATOR_INN = case when isnull(SEC.REGISTRATOR_INN, '') = ''
							then case isnull(case REGISTRATOR.IS_REZIDENT when 0 then REGISTRATOR_TIN.FIELD else REGISTRATOR.INN end, '')
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
	, REGISTRATOR_KPP =  case when isnull(SEC.REGISTRATOR_KPP, '') = '' 
						then case REGISTRATOR.IS_REZIDENT when 1 then isnull(REGISTRATOR.KPPU, '') else '' end 
						else SEC.REGISTRATOR_KPP end 
	, REGISTRATOR_OGRN = case when isnull(SEC.REGISTRATOR_OGRN,'') = '' 
							then case REGISTRATOR.IS_REZIDENT when 1 then isnull(REGISTRATOR.OGRN, '') else '' end 
							else SEC.REGISTRATOR_OGRN end
	, REGISTRATOR_OKSM = case when isnull(SEC.REGISTRATOR_OKSM,'') = '' 
							then case isnull(left(REGISTRATOR_KOD.FIELD, 3), '') when '' then '999' else REGISTRATOR_KOD.FIELD end 
							else SEC.REGISTRATOR_OKSM end 
	, REGISTRATOR_LICENSE_NUM = case when isnull(SEC.REGISTRATOR_LICENSE_NUM,'') = '' 
								then  isnull(left(REGISTRATOR_LICENSE_ARRAY.FIELD_STRING, 20), '') 
								else SEC.REGISTRATOR_LICENSE_NUM end
	, NOSTRO_STR_ACCOUNT = case when isnull(SEC.NOSTRO_STR_ACCOUNT, '') = '' then  ACC_REGISTRATOR.STR_ACCOUNT else SEC.NOSTRO_STR_ACCOUNT end

from #SECURITIES SEC
	join DEPO_ACCOUNTS4 A
		join DEPO_PART P
			join DEPO_ACC D
				join CLIENTS DEPO_ACC_OWNER
					left join CLIENTS_ADDFL_STRING OWNER_KOD 
					on OWNER_KOD.ID_OBJECT = DEPO_ACC_OWNER.ID_CLIENT
					and OWNER_KOD.ID_FIELD = @FIELD_OKSM

					left join CLIENTS_ADDFL_STRING DEPO_ACC_OWNER_TIN
					on DEPO_ACC_OWNER_TIN.ID_OBJECT = DEPO_ACC_OWNER.ID_CLIENT
					and DEPO_ACC_OWNER_TIN.ID_FIELD = @FIELD_TIN

					left join CLIENTS_ADDFL_INT I
						join CLIENTS_ADDFL_SENSE INDICATION
						on INDICATION.ID_FIELD = I.ID_FIELD
						and INDICATION.SENSE_INT = I.FIELD
					on I.ID_FIELD = @FIELD_INDICATION 
					and I.ID_OBJECT = DEPO_ACC_OWNER.ID_CLIENT

					left join CLIENTS_ADDFL_ARRAY LICENSE_ARRAY
					on LICENSE_ARRAY.ID_OBJECT = DEPO_ACC_OWNER.ID_CLIENT
					and LICENSE_ARRAY.ID_FIELD = @FIELD_LICENSE
					and LICENSE_ARRAY.INDEX_COLUMN = 0 and LICENSE_ARRAY.INDEX_ROW = 0
				on DEPO_ACC_OWNER.ID_CLIENT = D.ID_CLIENT

				left join DEPO_ACC_ADDFL ACC_NOSTRO
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
					on ACC_REGISTRATOR.STR_ACCOUNT = ACC_NOSTRO.FIELD_STRING
				on ACC_NOSTRO.ID_OBJECT = D.ID_ACC
				and ACC_NOSTRO.ID_FIELD = @FIELD_ACC_NOSTRO_DEPO_ACC

			on D.ID_ACC = P.ID_ACC
		on P.ID_PART = A.ID_PART

	on A.ID_ACCOUNT = SEC.ID_ACCOUNT

Insert into #SECURITIES(LAYER, BRANCH, PART, SUBPART, DEPO_ACC_TYPE, ID_PAPER, DEPO_OWNER_SECTOR, PAPER_COUNT
	, ID_ACCOUNT, DEPO_TYPE_CODE, ID_CLIENT_OWNER
	, OWNER_NAME, OWNER_INN, OWNER_IS_REZIDENT, OWNER_KPP, OWNER_OGRN, OWNER_OKSM, OWNER_LICENSE_NUM, OWNER_INDICATION, STR_ACCOUNT
	, REGISTRATOR_NAME, REGISTRATOR_INDICATION, REGISTRATOR_INN, REGISTRATOR_IS_REZIDENT, REGISTRATOR_KPP, REGISTRATOR_OGRN, REGISTRATOR_OKSM, REGISTRATOR_LICENSE_NUM, NOSTRO_STR_ACCOUNT
	,ENCUMBRANCES_PAPER_COUNT,PLEDGED_PAPER_COUNT,IN_KLIRING,WITH_CORP_ACTIONS,BAN_ON_OPERATIONS,UNDER_ARREST,DEPO_OWNER_OKSM	)
Select 1 LAYER, BRANCH, PART, SUBPART, DEPO_ACC_TYPE, ID_PAPER, DEPO_OWNER_SECTOR, PAPER_COUNT
	, ID_ACCOUNT, DEPO_TYPE_CODE, ID_CLIENT_OWNER
	, OWNER_NAME, OWNER_INN, OWNER_IS_REZIDENT, OWNER_KPP, OWNER_OGRN, OWNER_OKSM, OWNER_LICENSE_NUM, OWNER_INDICATION, STR_ACCOUNT
	, REGISTRATOR_NAME, REGISTRATOR_INDICATION, REGISTRATOR_INN, REGISTRATOR_IS_REZIDENT, REGISTRATOR_KPP, REGISTRATOR_OGRN, REGISTRATOR_OKSM, REGISTRATOR_LICENSE_NUM, NOSTRO_STR_ACCOUNT
	, ENCUMBRANCES_PAPER_COUNT,PLEDGED_PAPER_COUNT,IN_KLIRING,WITH_CORP_ACTIONS,BAN_ON_OPERATIONS,UNDER_ARREST,DEPO_OWNER_OKSM	
from #SECURITIES
where SUBPART = '1.1'


Insert into #SECURITIES(LAYER, BRANCH, PART, SUBPART, DEPO_ACC_TYPE, ID_PAPER, DEPO_OWNER_SECTOR, PAPER_COUNT
		, REGISTRATOR_NAME, REGISTRATOR_INDICATION, REGISTRATOR_INN, REGISTRATOR_IS_REZIDENT, REGISTRATOR_KPP, 
		REGISTRATOR_OGRN, REGISTRATOR_OKSM, REGISTRATOR_LICENSE_NUM, NOSTRO_STR_ACCOUNT
		,ENCUMBRANCES_PAPER_COUNT,PLEDGED_PAPER_COUNT,IN_KLIRING,WITH_CORP_ACTIONS,BAN_ON_OPERATIONS,UNDER_ARREST,DEPO_OWNER_OKSM	
		)
Select 1 LAYER, BRANCH, PART, SUBPART, DEPO_ACC_TYPE, ID_PAPER, DEPO_OWNER_SECTOR, sum(PAPER_COUNT) PAPER_COUNT
		, REGISTRATOR_NAME, REGISTRATOR_INDICATION, REGISTRATOR_INN, REGISTRATOR_IS_REZIDENT, REGISTRATOR_KPP, 
		REGISTRATOR_OGRN, REGISTRATOR_OKSM, REGISTRATOR_LICENSE_NUM, NOSTRO_STR_ACCOUNT,
		SUM(ISNULL(ENCUMBRANCES_PAPER_COUNT,0)) as ENCUMBRANCES_PAPER_COUNT,SUM(ISNULL(PLEDGED_PAPER_COUNT,0)) as PLEDGED_PAPER_COUNT
		,SUM(ISNULL(IN_KLIRING,0)) as IN_KLIRING,SUM(ISNULL(WITH_CORP_ACTIONS,0)) as WITH_CORP_ACTIONS,SUM(ISNULL(BAN_ON_OPERATIONS,0)) as BAN_ON_OPERATIONS
		,SUM(ISNULL(UNDER_ARREST,0)) as UNDER_ARREST,DEPO_OWNER_OKSM
from #SECURITIES
where SUBPART = '1.2'
group by BRANCH, PART, SUBPART, DEPO_ACC_TYPE, ID_PAPER, DEPO_OWNER_SECTOR
		, REGISTRATOR_NAME, REGISTRATOR_INDICATION, REGISTRATOR_INN, REGISTRATOR_IS_REZIDENT, REGISTRATOR_KPP,
		 REGISTRATOR_OGRN, REGISTRATOR_OKSM, REGISTRATOR_LICENSE_NUM, NOSTRO_STR_ACCOUNT,DEPO_OWNER_OKSM




Insert into #SECURITIES(LAYER, BRANCH, PART, SUBPART, ID_PAPER, COL74, COL82, COL83, COL84, COL85

	, OWNER_NAME
	, OWNER_INN
	, OWNER_IS_REZIDENT
	, OWNER_KPP
	, OWNER_OGRN
	, OWNER_OKSM
	, OWNER_LICENSE_NUM
	, OWNER_INDICATION
	, STR_ACCOUNT

	, REGISTRATOR_NAME
	, REGISTRATOR_INDICATION
	, REGISTRATOR_INN
	, REGISTRATOR_IS_REZIDENT
	, REGISTRATOR_KPP
	, REGISTRATOR_OGRN
	, REGISTRATOR_OKSM
	, REGISTRATOR_LICENSE_NUM
	, NOSTRO_STR_ACCOUNT

)
Select 1 LAYER, BRANCH, PART, SUBPART, ID_PAPER
	, sum(case when DEPO_ACC_TYPE not in ('TRUSTEE', 'ISSUER', 'ZALOGODERZHATEL', 'EMISSION') then PAPER_COUNT else 0.0 end) COL74
	, sum(case DEPO_ACC_TYPE when 'TRUSTEE' then PAPER_COUNT else 0.0 end) COL82
	, sum(case DEPO_ACC_TYPE when 'ISSUER' then PAPER_COUNT else 0.0 end) COL83
	, sum(case DEPO_ACC_TYPE when 'ZALOGODERZHATEL' then PAPER_COUNT else 0.0 end) COL84
	, sum(case DEPO_ACC_TYPE when 'EMISSION' then PAPER_COUNT else 0.0 end) COL85

	, OWNER_NAME
	, OWNER_INN
	, OWNER_IS_REZIDENT
	, OWNER_KPP
	, OWNER_OGRN
	, OWNER_OKSM
	, OWNER_LICENSE_NUM
	, OWNER_INDICATION
	, STR_ACCOUNT

	, REGISTRATOR_NAME
	, REGISTRATOR_INDICATION
	, REGISTRATOR_INN
	, REGISTRATOR_IS_REZIDENT
	, REGISTRATOR_KPP
	, REGISTRATOR_OGRN
	, REGISTRATOR_OKSM
	, REGISTRATOR_LICENSE_NUM
	, NOSTRO_STR_ACCOUNT

from #SECURITIES
where SUBPART = '1.3'
group by BRANCH, PART, SUBPART, ID_PAPER
	, OWNER_NAME
	, OWNER_INN
	, OWNER_IS_REZIDENT
	, OWNER_KPP
	, OWNER_OGRN
	, OWNER_OKSM
	, OWNER_LICENSE_NUM
	, OWNER_INDICATION
	, STR_ACCOUNT

	, REGISTRATOR_NAME
	, REGISTRATOR_INDICATION
	, REGISTRATOR_INN
	, REGISTRATOR_IS_REZIDENT
	, REGISTRATOR_KPP
	, REGISTRATOR_OGRN
	, REGISTRATOR_OKSM
	, REGISTRATOR_LICENSE_NUM
	, NOSTRO_STR_ACCOUNT




-- Приобретены по сделкам обратного РЕПО и получены по сделкам займа
--Update SEC set 
--	  COL76 = case TYP.SID_TRADE_TYPE when 'UBS_REPO' then S.REST else 0.0 end
--	, COL77 = case TYP.SID_TRADE_TYPE when 'UBS_LOAN' then S.REST else 0.0 end
--	, SEC.SID_TRADE_TYPE = TYP.SID_TRADE_TYPE
--from #SECURITIES SEC
--	join DLG_REST_FR REST
--		join DLG_REST_SALDO_FR S
--		on S.ID_REST = REST.ID_REST
--		and S.TYPE_REST = 0				-- для налогового учета метод FIFO (другой пока не используется)
--		AND S.DATE_FR < @Date and S.DATE_NEXT >= @Date

--		join DLG_TRADE T
--			join DLG_TRADE_TYPE TYP
--			on TYP.TRADE_TYPE = T.TRADE_TYPE
--			and TYP.SID_TRADE_TYPE in ('UBS_REPO' ,'UBS_LOAN')
--		on T.TRADE_ID = REST.TRADE_ID
--		and REST.ID_CONTRACT = 0		-- собственные бумаги
--		and REST.HOLDING_ID = 100		-- обратное РЕПО
--	on REST.NUMPAPER = SEC.ID_PAPER
--where SEC.SUBPART = '1.3'

--- зфакоментировано 14.12.2016 (83462)  SAA
/*  
-- (80969), KVF, 01.09.2016 - учтено, что в DLG_REST_FR остатки храняться по лотам, 
-- и нужно их суммировать с группировкой по бумагам.
Update SEC set 
	  COL76 = case REST.SID_TRADE_TYPE when 'UBS_REPO' then REST.REST else 0.0 end
	, COL77 = case REST.SID_TRADE_TYPE when 'UBS_LOAN' then REST.REST else 0.0 end
	, SEC.SID_TRADE_TYPE = REST.SID_TRADE_TYPE
from #SECURITIES SEC
	 join (
		select 
			  FR.NUMPAPER
			, TYP.SID_TRADE_TYPE
			, Sum( S.REST ) REST
		from DLG_REST_FR FR
			join DLG_REST_SALDO_FR S on S.ID_REST = FR.ID_REST
				and S.TYPE_REST = 0				-- для налогового учета метод FIFO (другой пока не используется)
				and S.DATE_FR < @Date 
				and S.DATE_NEXT >= @Date
			join DLG_TRADE T on T.TRADE_ID = FR.TRADE_ID
			join DLG_TRADE_TYPE TYP	on TYP.TRADE_TYPE = T.TRADE_TYPE
				and TYP.SID_TRADE_TYPE in ( 'UBS_REPO' ,'UBS_LOAN' )
		where   FR.ID_CONTRACT = 0		-- собственные бумаги
			and FR.HOLDING_ID = 100		-- обратное РЕПО
		group by FR.NUMPAPER
			, TYP.SID_TRADE_TYPE
		) REST on REST.NUMPAPER = SEC.ID_PAPER
where SEC.SUBPART = '1.3'
*/
--- для ситуации, если у КО есть бумаги определенного выпуска (ID_paper) и он получил еще таких бумаг по РЕПО и залогу кол 63,64
update SEC
	set SEC.COL76 = SEC.COL76 +  case REST.SID_TRADE_TYPE when 'UBS_REPO' then (REST.REST) else 0.0 end,
	SEC.COL77 = SEC.COL77 + case REST.SID_TRADE_TYPE when 'UBS_LOAN' then (REST.REST) else 0.0 end,
	SEC.SID_TRADE_TYPE = REST.SID_TRADE_TYPE
from #SECURITIES SEC
	 join (
		select 
			  FR.NUMPAPER
			, TYP.SID_TRADE_TYPE
			, Sum( S.REST ) REST
		from DLG_REST_FR FR
			join DLG_REST_SALDO_FR S on S.ID_REST = FR.ID_REST
				and S.TYPE_REST = 0				-- для налогового учета метод FIFO (другой пока не используется)
				and S.DATE_FR < @Date 
				and S.DATE_NEXT >= @Date
			join DLG_TRADE T on T.TRADE_ID = FR.TRADE_ID
			join DLG_TRADE_TYPE TYP	on TYP.TRADE_TYPE = T.TRADE_TYPE
				and TYP.SID_TRADE_TYPE in ( 'UBS_REPO' ,'UBS_LOAN' )
		where   FR.ID_CONTRACT = 0		-- собственные бумаги
			and FR.HOLDING_ID = 100		-- обратное РЕПО
		group by FR.NUMPAPER
			, TYP.SID_TRADE_TYPE
		) REST on REST.NUMPAPER = SEC.ID_PAPER
where SEC.SUBPART = '1.3' and REST.REST <> 0 and ISNULL(COL74, 0) <> 0 

/*
Insert into #SECURITIES(LAYER, BRANCH, PART, SUBPART, ID_PAPER, COL74, COL82, COL83, COL84, COL85,

	COL76, COL77, SID_TRADE_TYPE

	, OWNER_NAME
	, OWNER_INN
	, OWNER_IS_REZIDENT
	, OWNER_KPP
	, OWNER_OGRN
	, OWNER_OKSM
	, OWNER_LICENSE_NUM
	, OWNER_INDICATION
	, STR_ACCOUNT

	, REGISTRATOR_NAME
	, REGISTRATOR_INDICATION
	, REGISTRATOR_INN
	, REGISTRATOR_IS_REZIDENT
	, REGISTRATOR_KPP
	, REGISTRATOR_OGRN
	, REGISTRATOR_OKSM
	, REGISTRATOR_LICENSE_NUM
	, NOSTRO_STR_ACCOUNT)
select  1 LAYER, BRANCH, PART, SUBPART, ID_PAPER, COL74, COL82, COL83, COL84, COL85,

	 case REST.SID_TRADE_TYPE when 'UBS_REPO' then SUM(REST.REST) else 0.0 end AS COL76,
	 case REST.SID_TRADE_TYPE when 'UBS_LOAN' then SUM(REST.REST) else 0.0 end AS COL77,
	 REST.SID_TRADE_TYPE as SID_TRADE_TYPE

	, OWNER_NAME
	, OWNER_INN
	, OWNER_IS_REZIDENT
	, OWNER_KPP
	, OWNER_OGRN
	, OWNER_OKSM
	, OWNER_LICENSE_NUM
	, OWNER_INDICATION
	, STR_ACCOUNT

	, REGISTRATOR_NAME
	, REGISTRATOR_INDICATION
	, REGISTRATOR_INN
	, REGISTRATOR_IS_REZIDENT
	, REGISTRATOR_KPP
	, REGISTRATOR_OGRN
	, REGISTRATOR_OKSM
	, REGISTRATOR_LICENSE_NUM
	, NOSTRO_STR_ACCOUNT

from #SECURITIES SEC
	 join (
		select 
			  FR.NUMPAPER
			, TYP.SID_TRADE_TYPE
			, Sum( S.REST ) REST
		from DLG_REST_FR FR
			join DLG_REST_SALDO_FR S on S.ID_REST = FR.ID_REST
				and S.TYPE_REST = 0				-- для налогового учета метод FIFO (другой пока не используется)
				and S.DATE_FR < @Date 
				and S.DATE_NEXT >= @Date
			join DLG_TRADE T on T.TRADE_ID = FR.TRADE_ID
			join DLG_TRADE_TYPE TYP	on TYP.TRADE_TYPE = T.TRADE_TYPE
				and TYP.SID_TRADE_TYPE in ( 'UBS_REPO' ,'UBS_LOAN' )
		where   FR.ID_CONTRACT = 0		-- собственные бумаги
			and FR.HOLDING_ID = 100		-- обратное РЕПО
		group by FR.NUMPAPER
			, TYP.SID_TRADE_TYPE
		) REST on REST.NUMPAPER = SEC.ID_PAPER
where SEC.SUBPART = '1.3' and REST.REST <> 0 and ISNULL(COL74, 0) <> 0 
	and 1 =  case when (@@SPID = 231 and CAST(getdate() as date) = '20170313') then 2 else 1 end
group by BRANCH, PART, SUBPART, ID_PAPER,
	COL74, COL82, COL83, COL84, COL85,
	REST.SID_TRADE_TYPE
	, OWNER_NAME
	, OWNER_INN
	, OWNER_IS_REZIDENT
	, OWNER_KPP
	, OWNER_OGRN
	, OWNER_OKSM
	, OWNER_LICENSE_NUM
	, OWNER_INDICATION
	, STR_ACCOUNT

	, REGISTRATOR_NAME
	, REGISTRATOR_INDICATION
	, REGISTRATOR_INN
	, REGISTRATOR_IS_REZIDENT
	, REGISTRATOR_KPP
	, REGISTRATOR_OGRN
	, REGISTRATOR_OKSM
	, REGISTRATOR_LICENSE_NUM
	, NOSTRO_STR_ACCOUNT

	if @@SPID = 231 and CAST(getdate() as date) = '20170313'
select * from #SECURITIES where SUBPART = '1.3' and ID_PAPER = 1393
*/
Update #SECURITIES set COL76 = isnull(COL76, 0.0), COL77 = isnull(COL77, 0.0) where LAYER = 1 and SUBPART = '1.3'

-- вложения в которые признаны безнадежными долгами (данные по векселям)
Update SEC set COL79 = 1.0
from #SECURITIES SEC
	join BILL_BALANCE B
		join BILL_LOG_BASE_OPER O
			join BILL_LOG_GROUP_OPER OGL
				join BILL_GROUP_OPER OG
				on OG.ID_GROUP_OPER = OGL.ID_GROUP_OPER
				and OG.SID_OPERATION = 'UBS_BILL_ACCEPT_BILLS_UNCOLLECTIBLE'
			on OGL.ID_LOG_GROUP_OPER = O.ID_LOG_GROUP_OPER
		on O.ID_BALANCE = B.ID_BALANCE
	on B.ID_PAPER = SEC.ID_PAPER
where SEC.LAYER = 1 and SEC.SUBPART = '1.3'

Update #SECURITIES set COL79 = isnull(COL79, 0.0) where LAYER = 1 and SUBPART = '1.3'


Update #SECURITIES set COL75 = case when COL74 - (COL76 + COL77 + COL79) > 0 then COL74 - (COL76 + COL77 + COL79) else 0.0 end 
	where LAYER = 1 and SUBPART = '1.3' and ISNULL(SID_TRADE_TYPE,'') not in ( 'UBS_REPO' ,'UBS_LOAN' )

	-- подраздел 1.4 в разрезе портфелей
		insert into #SECURITIES(LAYER, BRANCH, PART, SUBPART, ID_PAPER,STR_ACCOUNT, COL102, COL103)
		Select distinct 
			  SEC.LAYER
			, SEC.BRANCH
			, SEC.PART
			, '1.4' as SUBPART
			, SEC.ID_PAPER 
			, SEC.STR_ACCOUNT
			, FINRES.REPORT_SUMMA * RCB.RATE / 1000  as COL102
			, LEFT(PAPER_ACC.STRACCOUNT,5)  as COL103
		from #SECURITIES SEC	
		join fn_PaperFinResOnDateByPortfolio(@Date) FINRES
			on FINRES.ID_PAPER = SEC.ID_PAPER
			and FINRES.REPORT_SUMMA <> $0
		join vw_DLG_ACC_PAPER PAPER_ACC
			on PAPER_ACC.ID_PAPER = SEC.ID_PAPER
			and PAPER_ACC.NAME_FIELD = CASE FINRES.HOLDING_ID 
										WHEN 1 THEN 'Счета учета ценных бумаг - ТСС'
										WHEN 2 THEN 'Счета учета ценных бумаг - до погашения'
										WHEN 5 THEN 'Счета учета ценных бумаг - для продажи'
										WHEN 6 THEN 'Счета учета ценных бумаг - не погашенные'
								   END
			and PAPER_ACC.NAME_TYPE_ACC = 'вложения в ценные бумаги'
		join DEPO_EMISSION PAPER
			join COM_CURRENCY VL
				left join COM_RATES_CB RCB
					on RCB.ID_CURRENCY = VL.ID_CURRENCY
						AND RCB.DATE_RATE < @Date and RCB.DATE_NEXT >= @Date
			on VL.ID_CURRENCY = PAPER.ID_CURRENCY
		on PAPER.ID_PAPER = SEC.ID_PAPER
		where   SEC.SUBPART = '1.3' 
		and SEC.LAYER = 1
		and IsNull( SEC.COL76, $0 ) + IsNull( SEC.COL77, $0 ) = $0	
		order by SEC.ID_PAPER


/*
-- Подраздел 1.4
Insert into #SECURITIES(LAYER, BRANCH, PART, SUBPART, ID_PAPER,STR_ACCOUNT)
Select distinct 
	  LAYER
	, BRANCH
	, PART
	, '1.4' SUBPART
	, ID_PAPER 
	, STR_ACCOUNT
from #SECURITIES 
where   SUBPART = '1.3' 
	and LAYER = 1
	and IsNull( COL76, $0 ) + IsNull( COL77, $0 ) = $0		-- (80969), KVF, 01.09.2016 - РЕПО и займ в 1.4 не учитываем

-- балансовая стоимость вложений в бумаги
-- с учетом рыночной ТСС
Update SEC set COL102 = FINRES.REPORT_SUMMA * RCB.RATE / 1000 
from #SECURITIES SEC
		join fn_PaperFinResOnDate(@Date) FINRES
		on FINRES.ID_PAPER = SEC.ID_PAPER

		join DEPO_EMISSION PAPER
			join COM_CURRENCY VL
				join COM_RATES_CB RCB
				on RCB.ID_CURRENCY = VL.ID_CURRENCY
				AND RCB.DATE_RATE < @Date and RCB.DATE_NEXT >= @Date
			on VL.ID_CURRENCY = PAPER.ID_CURRENCY
		on PAPER.ID_PAPER = SEC.ID_PAPER
where SEC.LAYER = 1 and SEC.SUBPART = '1.4'

Delete #SECURITIES where SUBPART = '1.4' and COL102 is null

-- балансовый счет второго порядка раздела А
Update SEC set COL103 = O.BAL2
	from #SECURITIES SEC
		left join vw_DLG_ACC_PAPER PAPER on SEC.ID_PAPER = PAPER.ID_PAPER and PAPER.NAME_TYPE_ACC = 'вложения в ценные бумаги'
			join OD_ACCOUNTS0 O on O.STRACCOUNT = PAPER.STRACCOUNT
			join OD_SALTRN0 TRN on TRN.ID_ACCOUNT = O.ID_ACCOUNT
				and TRN.DATE_TRN < @Date
				and TRN.DATE_NEXT >= @Date
				and TRN.SALDO <> 0
	where SEC.LAYER = 1 and SEC.SUBPART = '1.4'
	*/
GO

drop table #SECURITIES
Go
