if exists (select * from sysobjects where id = object_id('dbo.p711Form_2017') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure dbo.p711Form_2017
GO

Create Proc dbo.p711Form_2017(
      @Date      datetime
    , @SidVersion varchar(50)
	, @NumBranch smallint = 0
	, @Unload tinyint = 0 -- 1-выгрузка в ПТК ПСД, 2-выгрузка в КЛИКО, 0-иначе
    )
As


Declare @AmountColumns tinyint 
Select @AmountColumns = 177

declare @strSQL varchar(8000)
declare @strListCreate varchar(8000),@strListSelect varchar(8000)
declare @j_begin int,@j_end int

Select @strListCreate = '',@strListSelect = ''


exec p711Form_2014_query_column    1, @AmountColumns,@strListCreate output,@strListSelect output


begin 
			create table #tTemp_rep(
				  LAYER		tinyint		not null	default 0
				, BRANCH   smallint null,
				GRP      varchar(15) null,
				SYMBOL   varchar(15) null,
				NUM_STAT smallint null,
				-- раздел 1 подраздел 1.1
			 COL1   varchar(255) null,  -- номер строки 
			 COL2   varchar(255) null,
			 COL3   varchar(255) null,
			 COL3B  varchar(20)  null,
			 COL4   varchar(255) null,
			 COL5   varchar(255) null,
			 COL6   varchar(255) null,
			 COL7   varchar(255) null,
			 COL8   varchar(255) null,
			 COL9   varchar(255) null,
			 COL10  varchar(255) null,
			 COL11  varchar(255) null,
			 COL11B varchar(20)  null,
			 COL12  varchar(255) null,
			 COL13  varchar(255) null,
			 COL14  varchar(255) null,
			 COL15  varchar(255) null,
			 COL16  varchar(255) null,
			 COL17  varchar(255) null,
			 COL18  varchar(255) null,
			 COL19  money null,
			 COL20  money null,
			 COL21  money null,
			 COL22  money null,
			 COL23  money null,
			 COL24  money null,
			 COL25  money null,
			 COL26  money null,
			 COL27  varchar(255) null,
			 COL28  varchar(255) null,
			 COL29  varchar(255) null,
			 COL29B varchar(20)  null,
			 COL30  varchar(255) null,
			 COL31  varchar(255) null,
			 COL32  varchar(255) null,
			 COL33  varchar(255) null,
			 COL34  varchar(255) null,

			 -- подраздел 1.2
			 COL35  varchar(255) null, -- номер строки
			 COL36  varchar(255) null,
			 COL37  varchar(255) null,
			 COL37B varchar(20)  null,
			 COL38  varchar(255) null,
			 COL39  varchar(255) null,
			 COL40  varchar(255) null, -- ОКСМ
			 COL41  varchar(255) null,
			 COL42  varchar(255) null,
			 COL43  varchar(255) null,
			 COL44  varchar(255) null,
			 COL45  money null,
			 COL46  varchar(255) null,
			 COL47  money null,
			 COL48  money null, -- обременения
			 COL49  money null,
			 COL50  money null,
			 COL51  money null,
			 COL52  money null,
			 COL53  money null,
			 COL54  varchar(255) null,
			 COL55  varchar(255) null,
			 COL56  varchar(255) null,
			 COL57  varchar(255) null,
			 COL58  varchar(255) null, --инн
			 COL58B varchar(20)  null,
			 COL59  varchar(255) null,
			 COL60  varchar(255) null,
			 COL61  varchar(255) null,
			 COL62  varchar(255) null,

			-- подраздел 1.3
			 COL63 varchar(255) null,  -- номер строки
			 COL64 varchar(255) null,
			 COL65 varchar(255) null, -- инн
			 COL65B varchar(20) null,
			 COL66 varchar(255) null,
			 COL67 varchar(255) null,
			 COL68 varchar(255) null,
			 COL69 varchar(255) null,
			 COL70 varchar(255) null,
			 COL71 varchar(255) null,
			 COL72 varchar(255) null,
			 COL73 money null, -- номинал
			 COL74 money null, -- еол-во
			 COL75 money null,
			 COL76 money null,
			 COL77 money null,
			 COL78 money null,
			 COL79 money null,
			 COL80 money null,
			 COL81 money null,
			 COL82 money null,
			 COL83 money null,
			 COL84 money null,
			 COL85 money null,
			 COL86 varchar(255) null,
			 COL87 varchar(255) null,
			 COL88 varchar(255) null,
			 COL88B varchar(20) null,
			 COL89 varchar(255) null,
			 COL90 varchar(255) null,
			 COL91 varchar(255) null,
			 COL92 varchar(255) null,

			 -- подраздел 1.4
			 COL93  varchar(255) null, -- номер строки
			 COL94  varchar(255) null,
			 COL95  varchar(255) null,
			 COL95B varchar(20)  null,
			 COL96  varchar(255) null,
			 COL97  varchar(255) null,
			 COL98  varchar(255) null,
			 COL99  varchar(255) null,
			 COL100 varchar(255) null,
			 COL101 varchar(255) null,
			 COL102 money null,
			 COL103 varchar(255) null,

			 -- раздел 2
			 -- подраздел 2.1 
			 COL104 varchar(255) null,  -- номер строки 
			 COL105 varchar(255) null,
			 COL106 varchar(255) null,
			 COL106B varchar(20) null,
			 COL107 varchar(255) null,
			 COL108 varchar(255) null,
			 COL109 varchar(255) null,
			 COL110 varchar(255) null,
			 COL111 varchar(255) null,
			 COL112 varchar(255) null,
			 COL113 varchar(255) null, -- дата составления
			 COL114 varchar(255) null,
			 COL115 varchar(255) null,
			 COL116 varchar(255) null,
			 COL117 money null,
			 COL118 money null,
			 COL119 varchar(255) null,
			 COL120 money null,
			 COL121 money null,
			 COL122 money null,
			 COL123 varchar(255) null,
			 COL124 money null,
			 COL125 varchar(255) null,
			 COL126 varchar(255) null,
			 COL127 varchar(255) null,
			 COL128 varchar(255) null,  -- инн
			 COL128B varchar(20) null,
			 COL129 varchar(255) null,
			 COL130 varchar(255) null,
			 COL131 varchar(255) null,
			 COL132 varchar(255) null,
			 COL133 varchar(255) null,
			 COL133B varchar(20) null,
			 COL134 varchar(255) null,
			 COL135 varchar(255) null,
			 COL136 varchar(255) null,
			 COL137 money null,
			 COL138 varchar(255) null,
			 COL139 varchar(255) null,
			 COL140 varchar(255) null,
			 COL141 varchar(255) null, -- инн
			 COL141B varchar(20) null,
			 COL142 varchar(255) null,
			 COL143 varchar(255) null,
			 COL144 varchar(255) null,

			 -- подраздел 2.2
			 COL145 varchar(255) null, --- номер строки
			 COL146 varchar(255) null,
			 COL147 varchar(255) null,
			 COL148 varchar(255) null,
			 COL149 varchar(255) null,
			 COL150 varchar(255) null,
			 COL151 varchar(255) null,
			 COL152 varchar(255) null,
			 COL153 money null,
			 COL154 money null,
			 COL155 varchar(255) null,
			 COL156 money null,
			 COL157 varchar(255) null,
			 COL158 varchar(255) null,
			 COL158B varchar(20) null,
			 COL159 varchar(255) null,
			 COL160 varchar(255) null, -- оксм
			 COL161 varchar(255) null,
			 COL162 varchar(255) null,
			 COL163 varchar(255) null,
			 COL164 varchar(255) null,
			 COL164B varchar(20) null,
			 COL165 varchar(255) null,
			 COL166 varchar(255) null,
			 COL167 varchar(255) null,

			 -- подраздел 2.3
			 COL168 varchar(255) null,  -- номер строки
			 COL169 varchar(255) null,
			 COL170 varchar(255) null,
			 COL170B varchar(20) null,
			 COL171 varchar(255) null,
			 COL172 varchar(255) null,
			 COL173 varchar(255) null,
			 COL174 varchar(255) null,
			 COL175 varchar(255) null,
			 COL176 varchar(255) null,
			 COL177 varchar(255) null,
			 COL178 varchar(255) null,
			 COL179 varchar(255) null,
			 COL180 varchar(255) null,
			 COL181 money null,        -- вексельная сумма
			 COL182 varchar(255) null,
			 COL183 varchar(255) null,
			 COL184 varchar(255) null,
			 COL185 varchar(255) null,
			 COL186 varchar(255) null,
			 COL187 varchar(255) null,
			 COL187B varchar(20) null,
			 COL188 varchar(255) null,
			 COL189 varchar(255) null,
			 COL190 varchar(255) null,

			 --- раздел 3
			 COL191 varchar(255) null, -- номер строки
			 COL192 varchar(255) null,
			 COL193 varchar(255) null,
			 COL193B varchar(20) null,
			 COL194 varchar(255) null,
			 COL195 varchar(255) null,
			 COL196 varchar(255) null,
			 COL197 varchar(255) null,
			 COL198 varchar(255) null,
			 COL199 varchar(255) null,
			 COL200 varchar(255) null,
			 COL201 money null,
			 COL202 money null,
			 COL203 money null,
			 COL204 money null,
			 COL205 money null,
			 COL206 money null,
			 COL207 money null,
			 COL208 money null,
			 COL209 money null,
			 COL210 money null,
			 COL211 money null,
			 COL212 money null,
			 COL213 money null,
			 COL214 money null,
			 COL215 varchar(255) null )
end
--select @strSQL = 'alter table #tTemp_rep add '+@strListCreate
--select (@strSQL)


exec Forms_cb711_2017 @Date, @NumBranch, 'GET'



Update #tTemp_rep set LAYER = 1 where left(SYMBOL,1) = '1'

	begin
		
	if @NumBranch = 0
		begin 		
						Update #tTemp_rep set LAYER = 0 where left(SYMBOL,1) = '1'


						-- Схлопываем физические лица из разных филиалов по разделу 1
						Insert into #tTemp_rep(LAYER, GRP, SYMBOL,
						COL1,COL2,COL3,COL3B,COL4,COL5,COL6,COL7,COL8,COL9,COL10,COL11,COL11B,COL12,COL13,COL14,COL15,COL16,COL17,COL18,COL19,
						COL20,
						COL21,
						COL22,
						COL23,
						COL24,
						COL25,
						COL26,
						COL27,COL28,COL29,COL29B,COL30,COL31,COL32,COL33,COL34	,COL35
						,COL36,COL37,COL37B,COL38,COL39,COL40,COL41,COL42,COL43,COL44,COL45,COL46,COL47,COL48,COL49,COL50,COL51,COL52
						,COL53,COL54,COL55,COL56,COL57,COL58,COL58B,COL59,COL60,COL61,COL62,COL63,COL64,COL65,COL65B,COL66,COL67,COL68
						,COL69,COL70,COL71,COL72,COL73,COL74,COL75,COL76,COL77,COL78,COL79,COL80,COL81,COL82,COL83,COL84,COL85,COL86
						,COL87,COL88,COL88B,COL89,COL90,COL91,COL92,COL93,COL94,COL95,COL95B,COL96,COL97,COL98,COL99,COL100,COL101,COL102
						,COL103,COL104,COL105,COL106,COL106B,COL107,COL108,COL109,COL110,COL111,COL112,COL113,COL114,COL115,COL116,COL117
						,COL118,COL119,COL120,COL121,COL122,COL123,COL124,COL125,COL126,COL127,COL128,COL128B,COL129,COL130,COL131,COL132
						,COL133,COL133B,COL134,COL135,COL136,COL137,COL138,COL139,COL140,COL141,COL141B,COL142,COL143,COL144,COL145,COL146
						,COL147,COL148,COL149,COL150,COL151,COL152,COL153,COL154,COL155,COL156,COL157,COL158,COL158B,COL159,COL160,COL161
						,COL162,COL163,COL164,COL164B,COL165,COL166,COL167,COL168,COL169,COL170,COL170B,COL171,COL172,COL173,COL174,COL175
						,COL176,COL177,COL178,COL179,COL180,COL181,COL182,COL183,COL184,COL185,COL186,COL187,COL187B,COL188,COL189,COL190
						,COL191,COL192,COL193,COL193B,COL194,COL195,COL196,COL197,COL198,COL199,COL200,COL201,COL202,COL203,COL204,COL205
						,COL206,COL207,COL208,COL209,COL210,COL211,COL212,COL213,COL214,COL215 
						)
						Select LAYER = 1 , GRP = T.GRP, SYMBOL = T.SYMBOL,
					    COL1   = T.COL1  ,COL2   = T.COL2  ,COL3   = T.COL3  ,COL3B  = T.COL3B ,COL4   = T.COL4  ,COL5   = T.COL5  ,COL6   = T.COL6  ,COL7   = T.COL7  ,
                        COL8   = T.COL8  ,COL9   = T.COL9  ,COL10  = T.COL10 ,COL11  = T.COL11 ,COL11B = T.COL11B,COL12  = T.COL12 ,COL13  = T.COL13 ,COL14  = T.COL14 ,
                        COL15  = T.COL15 ,COL16  = T.COL16 ,COL17  = T.COL17 ,COL18  = T.COL18 ,COL19 = T.COL19,
						COL20 = SUM(T.COL20),
						COL21 = SUM(T.COL21) ,
						COL22 = SUM(T.COL22) ,
						COL23 = SUM(T.COL23) ,
						COL24 = SUM(T.COL24) ,
						COL25 = SUM(T.COL25) ,
						COL26 = SUM(T.COL26) ,
						COL27  = T.COL27 ,COL28  = T.COL28 ,COL29  = T.COL29 ,COL29B = T.COL29B,COL30  =T.COL30 ,COL31  = T.COL31 ,COL32  = T.COL32 ,COL33  = T.COL33 ,
						COL34  = T.COL34 ,COL35  = T.COL35 ,COL36  = T.COL36 ,COL37  = T.COL37 ,COL37B =T.COL37B,COL38  = T.COL38 ,COL39  = T.COL39 ,COL40  = T.COL40 ,
						COL41  = T.COL41 ,COL42  = T.COL42 ,COL43  = T.COL43 ,COL44  = T.COL44, COL45 = T.COL45 ,COL46 = T.COL46,
						COL47 = SUM(T.COL47) ,
						COL48 = SUM(T.COL48) ,
						COL49 = SUM(T.COL49) ,
						COL50 = SUM(T.COL50) ,
						COL51 = SUM(T.COL51) ,
						COL52 = SUM(T.COL52) ,
						COL53 = SUM(T.COL53) ,
						COL54  = T.COL54 ,COL55  = T.COL55 ,COL56  = T.COL56 ,COL57  = T.COL57 ,COL58  = T.COL58 ,COL58B = T.COL58B,COL59  = T.COL59 ,COL60  = T.COL60 ,
						COL61  = T.COL61 ,COL62  = T.COL62 ,COL63  = T.COL63 ,COL64  = T.COL64 ,COL65  = T.COL65 ,COL65B = T.COL65B,COL66  = T.COL66 ,COL67  = T.COL67 ,
						COL68  = T.COL68 ,COL69  = T.COL69 ,COL70  = T.COL70 ,COL71  = T.COL71 ,COL72  = T.COL72 ,COL73 = T.COL73,
						COL74 = SUM(T.COL74),
						COL75 = SUM(T.COL75),
						COL76 = SUM(T.COL76),
						COL77 = SUM(T.COL77),
						COL78 = SUM(T.COL78),
						COL79 = SUM(T.COL79),
						COL80 = SUM(T.COL80),
						COL81 = SUM(T.COL81),
						COL82 = SUM(T.COL82),
						COL83 = SUM(T.COL83),
						COL84 = SUM(T.COL84),
						COL85 = SUM(T.COL85),
						COL86  = T.COL86 ,COL87  = T.COL87 ,COL88  = T.COL88 ,COL88B = T.COL88B,COL89  = T.COL89 ,COL90  = T.COL90 ,COL91  = T.COL91 ,
						COL92  = T.COL92 ,COL93  = T.COL93 ,COL94  = T.COL94 ,COL95  = T.COL95 ,COL95B = T.COL95B,COL96  = T.COL96 ,COL97  = T.COL97 ,
						COL98  = T.COL98 ,COL99  = T.COL99 ,COL100 = T.COL100,COL101 = T.COL101,
						COL102 = SUM(T.COL102),
						COL103  = T.COL103 ,COL104  = T.COL104 ,COL105  = T.COL105 ,COL106  = T.COL106 ,COL106B = T.COL106B,COL107  = T.COL107 ,
						COL108  = T.COL108 ,COL109  = T.COL109 ,COL110  = T.COL110 ,COL111  = T.COL111 ,COL112  = T.COL112 ,COL113  = T.COL113 ,
						COL114  = T.COL114 ,COL115  = T.COL115 ,COL116  = T.COL116 ,
						COL117 = SUM(T.COL117),
						COL118 = SUM(T.COL118),
						COL119 = T.COL119,
						COL120 = SUM(T.COL120),
						COL121 = SUM(T.COL121),
						COL122 = SUM(T.COL122),
						COL123 = T.COL123,
						COL124 = SUM(T.COL124),
						COL125  = T.COL125 ,COL126  = T.COL126 ,COL127  = T.COL127 ,COL128  = T.COL128 ,COL128B = T.COL128B,COL129  = T.COL129 ,
						COL130  = T.COL130 ,COL131  = T.COL131 ,COL132  = T.COL132 ,COL133  = T.COL133 ,COL133B = T.COL133B,COL134  = T.COL134 ,
						COL135  = T.COL135 ,COL136  = T.COL136 ,									
						COL137 = SUM(T.COL137),
						COL138  = T.COL138 ,COL139  = T.COL139 ,COL140  = T.COL140 ,COL141  = T.COL141 ,COL141B = T.COL141B,COL142  = T.COL142 ,
						COL143  = T.COL143 ,COL144  = T.COL144 ,COL145  = T.COL145 ,COL146  = T.COL146 ,COL147  = T.COL147 ,COL148  = T.COL148 ,
						COL149  = T.COL149 ,COL150  = T.COL150 ,COL151  = T.COL151 ,COL152  = T.COL152 ,
						COL153 = SUM(T.COL153),
						COL154 = SUM(T.COL154),
						COL155 = T.COL155,
						COL156 = SUM(T.COL156),
						COL157  = T.COL157 ,COL158  = T.COL158 ,COL158B = T.COL158B,COL159  = T.COL159 ,COL160  = T.COL160 ,COL161  = T.COL161 ,
						COL162  = T.COL162 ,COL163  = T.COL163 ,COL164  = T.COL164 ,COL164B = T.COL164B,COL165  = T.COL165 ,COL166  = T.COL166 ,
						COL167  = T.COL167 ,COL168  = T.COL168 ,COL169  = T.COL169 ,COL170  = T.COL170 ,COL170B = T.COL170B,COL171  = T.COL171 ,
						COL172  = T.COL172 ,COL173  = T.COL173 ,COL174  = T.COL174 ,COL175  = T.COL175 ,COL176  = T.COL176 ,COL177  = T.COL177 ,
						COL178  = T.COL178 ,COL179  = T.COL179 ,COL180  = T.COL180 ,
						COL181 = SUM(T.COL181),
						COL182  = T.COL182 ,COL183  = T.COL183 ,COL184  = T.COL184 ,COL185  = T.COL185 ,COL186  = T.COL186 ,COL187  = T.COL187 ,
						COL187B = T.COL187B,COL188  = T.COL188 ,COL189  = T.COL189 ,COL190  = T.COL190 ,COL191  = T.COL191 ,COL192  = T.COL192 ,
						COL193  = T.COL193 ,COL193B = T.COL193B,COL194  = T.COL194 ,COL195  = T.COL195 ,COL196  = T.COL196 ,COL197  = T.COL197 ,
						COL198  = T.COL198 ,COL199  = T.COL199 ,COL200  = T.COL200 ,
						COL201 = SUM(T.COL201),
						COL202 = SUM(T.COL202),
						COL203 = SUM(T.COL203),
						COL204 = SUM(T.COL204),
						COL205 = SUM(T.COL205),
						COL206 = SUM(T.COL206),
						COL207 = SUM(T.COL207),
						COL208 = SUM(T.COL208),
						COL209 = SUM(T.COL209),
						COL210 = SUM(T.COL210),
						COL211 = SUM(T.COL211),
						COL212 = SUM(T.COL212),
						COL213 = SUM(T.COL213),
						COL214 = SUM(T.COL214),
						COL215 = T.COL215
						from #tTemp_rep T
						where GRP < 5 -- Раздел 1
						and 'физические лица' in ( isnull(COL10, ''), isnull(COL36, ''), isnull(COL64, ''), isnull(COL94, '') )
						group by GRP, SYMBOL,
						   COL1  ,COL2   ,COL3   ,COL3B  ,COL4   ,COL5   ,COL6   ,COL7   ,COL8   ,COL9   ,COL10  ,COL11  ,COL11B ,COL12  ,COL13  ,COL14  
						,COL15  ,COL16  ,COL17  ,COL18, COL19, COL27  ,COL28  ,COL29  ,COL29B 
						,COL30  ,COL31  ,COL32  ,COL33  ,COL34	
						,COL35 ,COL36  ,COL37  ,COL37B ,COL38  ,COL39  ,COL40  ,COL41  ,COL42  ,COL43  ,COL44 , COL45 ,COL46  ,COL54  ,COL55  ,COL56  ,COL57  ,COL58  ,COL58B ,COL59  ,COL60  ,COL61  ,COL62 
						,COL63,COL64 ,COL65 ,COL65B,COL66 ,COL67 ,COL68 ,COL69 ,COL70 ,COL71 ,COL72, COL73 ,COL86 ,COL87 ,COL88 ,COL88B,COL89 ,COL90 ,COL91 ,COL92 
						,COL93,COL94 ,COL95 ,COL95B,COL96 ,COL97 ,COL98 ,COL99 ,COL100,COL101,COL103
						,COL104,COL105 ,COL106 ,COL106B,COL107 ,COL108 ,COL109 ,COL110 ,COL111 ,COL112 ,COL113 ,COL114 ,COL115 ,COL116 
						,COL119 ,COL123 ,COL125 ,COL126 ,COL127 ,COL128 ,COL128B,COL129 ,COL130 ,COL131 
						,COL132 ,COL133 ,COL133B,COL134 ,COL135 ,COL136 ,COL138 ,COL139 ,COL140 ,COL141 ,COL141B,COL142 ,COL143 ,COL144 
						,COL145,COL146 ,COL147 ,COL148 ,COL149 ,COL150 ,COL151 ,COL152 ,COL155 ,COL157 ,COL158 ,COL158B
						,COL159 ,COL160 ,COL161 ,COL162 ,COL163 ,COL164 ,COL164B,COL165 ,COL166 ,COL167 
						,COL168 ,COL169 ,COL170 ,COL170B,COL171 ,COL172 ,COL173 ,COL174 ,COL175 ,COL176 ,COL177 ,COL178 ,COL179 ,COL180  
						,COL182 ,COL183 ,COL184 ,COL185 ,COL186 ,COL187 ,COL187B,COL188 ,COL189 ,COL190 
						,COL191,COL192 ,COL193 ,COL193B,COL194 ,COL195 ,COL196 ,COL197 ,COL198 ,COL199 ,COL200 ,COL215 
		


						-- Схлопываем из разных филиалов всех остальных, кроме физических лиц
						Insert into #tTemp_rep(LAYER, GRP, SYMBOL,
						COL1,COL2,COL3,COL3B,COL4,COL5,COL6,COL7,COL8,COL9,COL10,COL11,COL11B,COL12,COL13,COL14,COL15,COL16,COL17,COL18
						,COL19,COL20,COL21,COL22,COL23,COL24,COL25,COL26,COL27,COL28,COL29,COL29B,COL30,COL31,COL32,COL33,COL34	,COL35
						,COL36,COL37,COL37B,COL38,COL39,COL40,COL41,COL42,COL43,COL44,COL45,COL46,COL47,COL48,COL49,COL50,COL51,COL52
						,COL53,COL54,COL55,COL56,COL57,COL58,COL58B,COL59,COL60,COL61,COL62,COL63,COL64,COL65,COL65B,COL66,COL67,COL68
						,COL69,COL70,COL71,COL72,COL73,COL74,COL75,COL76,COL77,COL78,COL79,COL80,COL81,COL82,COL83,COL84,COL85,COL86
						,COL87,COL88,COL88B,COL89,COL90,COL91,COL92,COL93,COL94,COL95,COL95B,COL96,COL97,COL98,COL99,COL100,COL101,COL102
						,COL103,COL104,COL105,COL106,COL106B,COL107,COL108,COL109,COL110,COL111,COL112,COL113,COL114,COL115,COL116,COL117
						,COL118,COL119,COL120,COL121,COL122,COL123,COL124,COL125,COL126,COL127,COL128,COL128B,COL129,COL130,COL131,COL132
						,COL133,COL133B,COL134,COL135,COL136,COL137,COL138,COL139,COL140,COL141,COL141B,COL142,COL143,COL144,COL145,COL146
						,COL147,COL148,COL149,COL150,COL151,COL152,COL153,COL154,COL155,COL156,COL157,COL158,COL158B,COL159,COL160,COL161
						,COL162,COL163,COL164,COL164B,COL165,COL166,COL167,COL168,COL169,COL170,COL170B,COL171,COL172,COL173,COL174,COL175
						,COL176,COL177,COL178,COL179,COL180,COL181,COL182,COL183,COL184,COL185,COL186,COL187,COL187B,COL188,COL189,COL190
						,COL191,COL192,COL193,COL193B,COL194,COL195,COL196,COL197,COL198,COL199,COL200,COL201,COL202,COL203,COL204,COL205
						,COL206,COL207,COL208,COL209,COL210,COL211,COL212,COL213,COL214,COL215 
						)
						Select LAYER = 1 , GRP = T.GRP, SYMBOL = T.SYMBOL,
					        COL1   = T.COL1  ,COL2   = T.COL2  ,COL3   = T.COL3  ,COL3B  = T.COL3B ,COL4   = T.COL4  ,COL5   = T.COL5  ,COL6   = T.COL6  ,COL7   = T.COL7  ,
                            COL8   = T.COL8  ,COL9   = T.COL9  ,COL10  = T.COL10 ,COL11  = T.COL11 ,COL11B = T.COL11B,COL12  = T.COL12 ,COL13  = T.COL13 ,COL14  = T.COL14 ,
                            COL15  = T.COL15 ,COL16  = T.COL16 ,COL17  = T.COL17 ,COL18  = T.COL18 ,COL19 = T.COL19,
						COL20 = SUM(T.COL20) ,
						COL21 = SUM(T.COL21) ,
						COL22 = SUM(T.COL22) ,
						COL23 = SUM(T.COL23) ,
						COL24 = SUM(T.COL24) ,
						COL25 = SUM(T.COL25) ,
						COL26 = SUM(T.COL26) ,
						COL27  = T.COL27 ,COL28  = T.COL28 ,COL29  = T.COL29 ,COL29B = T.COL29B,COL30  =T.COL30 ,COL31  = T.COL31 ,COL32  = T.COL32 ,COL33  = T.COL33 ,
						COL34  = T.COL34 ,COL35  = T.COL35 ,COL36  = T.COL36 ,COL37  = T.COL37 ,COL37B =T.COL37B,COL38  = T.COL38 ,COL39  = T.COL39 ,COL40  = T.COL40 ,
						COL41  = T.COL41 ,COL42  = T.COL42 ,COL43  = T.COL43 ,COL44  = T.COL44, COL45 = T.COL45 ,COL46 = T.COL46,
						COL47 = SUM(T.COL47) ,
						COL48 = SUM(T.COL48) ,
						COL49 = SUM(T.COL49) ,
						COL50 = SUM(T.COL50) ,
						COL51 = SUM(T.COL51) ,
						COL52 = SUM(T.COL52) ,
						COL53 = SUM(T.COL53) ,
						COL54  = T.COL54 ,COL55  = T.COL55 ,COL56  = T.COL56 ,COL57  = T.COL57 ,COL58  = T.COL58 ,COL58B = T.COL58B,COL59  = T.COL59 ,COL60  = T.COL60 ,
						COL61  = T.COL61 ,COL62  = T.COL62 ,COL63  = T.COL63 ,COL64  = T.COL64 ,COL65  = T.COL65 ,COL65B = T.COL65B,COL66  = T.COL66 ,COL67  = T.COL67 ,
						COL68  = T.COL68 ,COL69  = T.COL69 ,COL70  = T.COL70 ,COL71  = T.COL71 ,COL72  = T.COL72 ,COL73 = T.COL73,
						COL74 = SUM(T.COL74),
						COL75 = SUM(T.COL75),
						COL76 = SUM(T.COL76),
						COL77 = SUM(T.COL77),
						COL78 = SUM(T.COL78),
						COL79 = SUM(T.COL79),
						COL80 = SUM(T.COL80),
						COL81 = SUM(T.COL81),
						COL82 = SUM(T.COL82),
						COL83 = SUM(T.COL83),
						COL84 = SUM(T.COL84),
						COL85 = SUM(T.COL85),
						COL86  = T.COL86 ,COL87  = T.COL87 ,COL88  = T.COL88 ,COL88B = T.COL88B,COL89  = T.COL89 ,COL90  = T.COL90 ,COL91  = T.COL91 ,
						COL92  = T.COL92 ,COL93  = T.COL93 ,COL94  = T.COL94 ,COL95  = T.COL95 ,COL95B = T.COL95B,COL96  = T.COL96 ,COL97  = T.COL97 ,
						COL98  = T.COL98 ,COL99  = T.COL99 ,COL100 = T.COL100,COL101 = T.COL101,
						COL102 = SUM(T.COL102),
						COL103  = T.COL103 ,COL104  = T.COL104 ,COL105  = T.COL105 ,COL106  = T.COL106 ,COL106B = T.COL106B,COL107  = T.COL107 ,
						COL108  = T.COL108 ,COL109  = T.COL109 ,COL110  = T.COL110 ,COL111  = T.COL111 ,COL112  = T.COL112 ,COL113  = T.COL113 ,
						COL114  = T.COL114 ,COL115  = T.COL115 ,COL116  = T.COL116 ,
						COL117 = SUM(T.COL117),
						COL118 = SUM(T.COL118),
						COL119 = T.COL119,
						COL120 = SUM(T.COL120),
						COL121 = SUM(T.COL121),
						COL122 = SUM(T.COL122),
						COL123 = T.COL123,
						COL124 = SUM(T.COL124),
						COL125  = T.COL125 ,COL126  = T.COL126 ,COL127  = T.COL127 ,COL128  = T.COL128 ,COL128B = T.COL128B,COL129  = T.COL129 ,
						COL130  = T.COL130 ,COL131  = T.COL131 ,COL132  = T.COL132 ,COL133  = T.COL133 ,COL133B = T.COL133B,COL134  = T.COL134 ,
						COL135  = T.COL135 ,COL136  = T.COL136 ,									
						COL137 = SUM(T.COL137),
						COL138  = T.COL138 ,COL139  = T.COL139 ,COL140  = T.COL140 ,COL141  = T.COL141 ,COL141B = T.COL141B,COL142  = T.COL142 ,
						COL143  = T.COL143 ,COL144  = T.COL144 ,COL145  = T.COL145 ,COL146  = T.COL146 ,COL147  = T.COL147 ,COL148  = T.COL148 ,
						COL149  = T.COL149 ,COL150  = T.COL150 ,COL151  = T.COL151 ,COL152  = T.COL152 ,
						COL153 = SUM(T.COL153),
						COL154 = SUM(T.COL154),
						COL155 = T.COL155,
						COL156 = SUM(T.COL156),
						COL157  = T.COL157 ,COL158  = T.COL158 ,COL158B = T.COL158B,COL159  = T.COL159 ,COL160  = T.COL160 ,COL161  = T.COL161 ,
						COL162  = T.COL162 ,COL163  = T.COL163 ,COL164  = T.COL164 ,COL164B = T.COL164B,COL165  = T.COL165 ,COL166  = T.COL166 ,
						COL167  = T.COL167 ,COL168  = T.COL168 ,COL169  = T.COL169 ,COL170  = T.COL170 ,COL170B = T.COL170B,COL171  = T.COL171 ,
						COL172  = T.COL172 ,COL173  = T.COL173 ,COL174  = T.COL174 ,COL175  = T.COL175 ,COL176  = T.COL176 ,COL177  = T.COL177 ,
						COL178  = T.COL178 ,COL179  = T.COL179 ,COL180  = T.COL180 ,
						COL181 = SUM(T.COL181),
						COL182  = T.COL182 ,COL183  = T.COL183 ,COL184  = T.COL184 ,COL185  = T.COL185 ,COL186  = T.COL186 ,COL187  = T.COL187 ,
						COL187B = T.COL187B,COL188  = T.COL188 ,COL189  = T.COL189 ,COL190  = T.COL190 ,COL191  = T.COL191 ,COL192  = T.COL192 ,
						COL193  = T.COL193 ,COL193B = T.COL193B,COL194  = T.COL194 ,COL195  = T.COL195 ,COL196  = T.COL196 ,COL197  = T.COL197 ,
						COL198  = T.COL198 ,COL199  = T.COL199 ,COL200  = T.COL200 ,
						COL201 = SUM(T.COL201),
						COL202 = SUM(T.COL202),
						COL203 = SUM(T.COL203),
						COL204 = SUM(T.COL204),
						COL205 = SUM(T.COL205),
						COL206 = SUM(T.COL206),
						COL207 = SUM(T.COL207),
						COL208 = SUM(T.COL208),
						COL209 = SUM(T.COL209),
						COL210 = SUM(T.COL210),
						COL211 = SUM(T.COL211),
						COL212 = SUM(T.COL212),
						COL213 = SUM(T.COL213),
						COL214 = SUM(T.COL214),
						COL215 = T.COL215
						from #tTemp_rep T
						where GRP < 5 -- Раздел 1
						and not ('физические лица' in ( isnull(COL10, ''), isnull(COL36, ''), isnull(COL64, ''), isnull(COL94, '') ))
						group by GRP, SYMBOL,
						   COL1  ,COL2   ,COL3   ,COL3B  ,COL4   ,COL5   ,COL6   ,COL7   ,COL8   ,COL9   ,COL10  ,COL11  ,COL11B ,COL12  ,COL13  ,COL14  
						,COL15  ,COL16  ,COL17  ,COL18, COL19, COL27  ,COL28  ,COL29  ,COL29B 
						,COL30  ,COL31  ,COL32  ,COL33  ,COL34	
						,COL35 ,COL36  ,COL37  ,COL37B ,COL38  ,COL39  ,COL40  ,COL41  ,COL42  ,COL43  ,COL44 , COL45 ,COL46  ,COL54  ,COL55  ,COL56  ,COL57  ,COL58  ,COL58B ,COL59  ,COL60  ,COL61  ,COL62 
						,COL63,COL64 ,COL65 ,COL65B,COL66 ,COL67 ,COL68 ,COL69 ,COL70 ,COL71 ,COL72, COL73 ,COL86 ,COL87 ,COL88 ,COL88B,COL89 ,COL90 ,COL91 ,COL92 
						,COL93,COL94 ,COL95 ,COL95B,COL96 ,COL97 ,COL98 ,COL99 ,COL100,COL101,COL103
						,COL104,COL105 ,COL106 ,COL106B,COL107 ,COL108 ,COL109 ,COL110 ,COL111 ,COL112 ,COL113 ,COL114 ,COL115 ,COL116 
						,COL119 ,COL123 ,COL125 ,COL126 ,COL127 ,COL128 ,COL128B,COL129 ,COL130 ,COL131 
						,COL132 ,COL133 ,COL133B,COL134 ,COL135 ,COL136 ,COL138 ,COL139 ,COL140 ,COL141 ,COL141B,COL142 ,COL143 ,COL144 
						,COL145,COL146 ,COL147 ,COL148 ,COL149 ,COL150 ,COL151 ,COL152 ,COL155 ,COL157 ,COL158 ,COL158B
						,COL159 ,COL160 ,COL161 ,COL162 ,COL163 ,COL164 ,COL164B,COL165 ,COL166 ,COL167 
						,COL168 ,COL169 ,COL170 ,COL170B,COL171 ,COL172 ,COL173 ,COL174 ,COL175 ,COL176 ,COL177 ,COL178 ,COL179 ,COL180  
						,COL182 ,COL183 ,COL184 ,COL185 ,COL186 ,COL187 ,COL187B,COL188 ,COL189 ,COL190 
						,COL191,COL192 ,COL193 ,COL193B,COL194 ,COL195 ,COL196 ,COL197 ,COL198 ,COL199 ,COL200 ,COL215 


						-- нумерация строк в подразделах
						Declare @Subpart varchar(3), @LAYER tinyint
						Declare @i int

						Declare #SUBPARTS insensitive cursor for
										Select '1.1' SUBPART, 1 LAYER
							union all	Select '1.2' SUBPART, 1 LAYER
							union all	Select '1.3' SUBPART, 1 LAYER
							union all	Select '1.4' SUBPART, 1 LAYER

						open #SUBPARTS
						fetch #SUBPARTS into @Subpart, @LAYER

						while @@FETCH_STATUS = 0
						begin
							Select @i = 0

							Update #tTemp_rep 
								set NUM_STAT = @i, @i = @i+1
							where SYMBOL = @Subpart
							and LAYER = @LAYER

							fetch #SUBPARTS into @Subpart, @LAYER
						end

						close #SUBPARTS
						Deallocate #SUBPARTS

	end

		Update T
			set T.COL21 = COL22 + COL23 + COL24 + COL25 + COL26
		from #tTemp_rep T

		Update T
			set T.COL48 = COL49 + COL50 + COL51 + COL52 + COL53
		from #tTemp_rep T

		Update #tTemp_rep set  COL1  = NUM_STAT where SYMBOL = '1.1'
		Update #tTemp_rep set  COL35 = NUM_STAT where SYMBOL = '1.2'
		Update #tTemp_rep set  COL63 = NUM_STAT where SYMBOL = '1.3'
		Update #tTemp_rep set  COL93 = NUM_STAT where SYMBOL = '1.4'
		Update #tTemp_rep set  COL104= NUM_STAT where SYMBOL = '2.1'
		Update #tTemp_rep set  COL145 = NUM_STAT where SYMBOL = '2.2'
		Update #tTemp_rep set  COL168 = NUM_STAT where SYMBOL = '2.3'
		Update #tTemp_rep set  COL191 = NUM_STAT where SYMBOL = '3.0'


		exec p711_Add_Necessary_row @Date

        --Если в графе 46 не переданы значения OWNER, DEPOPROG, TRUSTEE, FAUTHOLDER, HOLDER , SUBOWNER , SUBTRUSTEE, 
		--для других значений графы 46 графа 54 заполняется - 000 (3 нулями)
		Update T
			set T.COL54 = '000'
		from #tTemp_rep T
		where ISNULL(T.COL46,'') not in ('OWNER', 'DEPOPROG', 'TRUSTEE', 'FAUTHOLDER', 'HOLDER' , 'SUBOWNER' , 'SUBTRUSTEE')

		If @Unload = 1	-- для выгрузки в ПТК ПСД подменяем строковой идентификатор Кода типа ценной бумаги на соответствующий Двузначный код
			begin
				Declare @ShortCodeOther varchar(2)	Select @ShortCodeOther = CODE_TYPE_CB from DEPO_PAPER_TYPES_CB where SID_TYPE_CB = 'OTHER'
				
				Update T set  T.COL15 =  isnull(SHORT_CODE_15 .CODE_TYPE_CB, @ShortCodeOther)
							, T.COL41 =  isnull(SHORT_CODE_41 .CODE_TYPE_CB, @ShortCodeOther)
							, T.COL69 =  isnull(SHORT_CODE_69 .CODE_TYPE_CB, @ShortCodeOther)
							, T.COL99 =  isnull(SHORT_CODE_99 .CODE_TYPE_CB, @ShortCodeOther)
							, T.COL109 = isnull(SHORT_CODE_109 .CODE_TYPE_CB, @ShortCodeOther)
							, T.COL173 = isnull(SHORT_CODE_173.CODE_TYPE_CB, @ShortCodeOther)
							, T.COL197 = isnull(SHORT_CODE_197.CODE_TYPE_CB, @ShortCodeOther)
				from #tTemp_rep T
					left join DEPO_PAPER_TYPES_CB SHORT_CODE_15
					on SHORT_CODE_15.SID_TYPE_CB = T.COL15

					left join DEPO_PAPER_TYPES_CB SHORT_CODE_41
					on SHORT_CODE_41.SID_TYPE_CB = T.COL41

					left join DEPO_PAPER_TYPES_CB SHORT_CODE_69
					on SHORT_CODE_69.SID_TYPE_CB = T.COL69

					left join DEPO_PAPER_TYPES_CB SHORT_CODE_99
					on SHORT_CODE_99.SID_TYPE_CB = T.COL99

					left join DEPO_PAPER_TYPES_CB SHORT_CODE_109
					on SHORT_CODE_109.SID_TYPE_CB = T.COL109

					left join DEPO_PAPER_TYPES_CB SHORT_CODE_173
					on SHORT_CODE_173.SID_TYPE_CB = T.COL173

					left join DEPO_PAPER_TYPES_CB SHORT_CODE_197
					on SHORT_CODE_197.SID_TYPE_CB = T.COL197
				where T.LAYER = 1 or T.GRP >= 5


				-- для выгрузки в ПТК ПСД подменяем строковый тип счета на соответствующий код типа счета
				Update T set T.COL46 = ACC_CODES.CODE_ACC
				from #tTemp_rep T
					join (	Select T1.VALUE TYPE_ACC, min(T2.VALUE) CODE_ACC
							from fn_OGO_READ_SETTING_TABLE('Отчетность государственных органов','Настройка типов счетов для формы 711') T1
								join fn_OGO_READ_SETTING_TABLE('Отчетность государственных органов','Настройка типов счетов для формы 711') T2
								on T2.INDEX_ROW = T1.INDEX_ROW
								and T1.INDEX_COLUMN = 3
								and T2.INDEX_COLUMN = 4
							group by T1.VALUE ) ACC_CODES
					on ACC_CODES.TYPE_ACC = T.COL46

						--- Если не проставить NULL, то выгрузка в ПТК заполняет 0(нуль), а это не правильно
						update #tTemp_rep
						set COL42 = NULL
					where LEFT(ISNULL(COL37B,''), 1) in ('2','4')

			end
    
    -- Для собственных векселей нули не заполняем
		Update T Set COL86 = NULL
		From #tTemp_rep T
		Where (COL87 = 'Э' or COL87 Is NULL)
		And COL86 = ''

		Update T Set COL88 = NULL
		From #tTemp_rep T
		Where (COL87 = 'Э' or COL87 Is NULL)
		And COL88 = ''

		Update T Set COL89 = NULL
		From #tTemp_rep T
		Where (COL87 = 'Э' or COL87 Is NULL)
		And COL89 = ''

		Update T Set COL90 = NULL
		From #tTemp_rep T
		Where (COL87 = 'Э' or COL87 Is NULL)
		And COL90 = ''

		Update T Set COL91 = NULL
		From #tTemp_rep T
		Where (COL87 = 'Э' or COL87 Is NULL)
		And COL91 = ''

		Update T Set COL92 = NULL
		From #tTemp_rep T
		Where (COL87 = 'Э' or COL87 Is NULL)
		And COL92 = ''

		--для физ лиц 0 значения не заполняются
		Update T Set COL65 = NULL
		From #tTemp_rep T
		Where Convert(decimal(1,0),COL65B) in (3,4)
		And COL65 = ''

		Update T Set COL66 = NULL
		From #tTemp_rep T
		Where Convert(decimal(1,0),COL65B) in (3,4)
		And COL66 = ''

		Update T Set COL67 = NULL
		From #tTemp_rep T
		Where Convert(decimal(1,0),COL65B) in (3,4)
		And COL67 = ''

		Update T Set COL70 = NULL
		From #tTemp_rep T
		Where Convert(decimal(1,0),COL65B) in (3,4)
		And COL70 = ''

		Update T Set COL71 = NULL
		From #tTemp_rep T
		Where Convert(decimal(1,0),COL65B) in (3,4)
		And COL71 = ''

		--- если даты >= 2222 год, то не показываем их
		update #tTemp_rep
			set 
				COL115 = case when COL115 = '01.01.2222' then '' else COL115 end,
				COL116 = case when COL116 = '01.01.2222' then '' else COL116 end,
				COL151 = case when COL151 = '01.01.2222' then '' else COL151 end,
				COL152 = case when COL152 = '01.01.2222' then '' else COL152 end,
				COL179 = case when COL179 = '01.01.2222' then '' else COL179 end,
				COL180 = case when COL180 = '01.01.2222' then '' else COL180 end

		If @Unload = 1	-- для выгрузки в ПТК ПСД если эмитент нерез, то гос. рег. номер не проставляем
			begin
				update #tTemp_rep
					set COL16 = CASE WHEN Convert(decimal,COL11B,0) in (2,4) and SYMBOL = '1.1' THEN NULL ELSE COL16 END
					,COL42 = CASE WHEN Convert(decimal,COL37B,0) in (2,4) and SYMBOL = '1.2' THEN NULL ELSE COL42 END
					,COL70 = CASE WHEN Convert(decimal,COL65B,0) in (2,4) and SYMBOL = '1.3' THEN NULL ELSE COL70 END
					,COL100 = CASE WHEN Convert(decimal,COL95B,0) in (2,4) and SYMBOL = '1.4' THEN NULL ELSE COL100 END
			end

		Select LAYER, BRANCH, GRP, SYMBOL, NUM_STAT
			, COL1, COL2, COL3
			, Convert(decimal(1,0),COL3B) COL3B
			, COL4, COL5, COL6, COL7, COL8, COL9, COL10, COL11
			, Convert(decimal(1,0),COL11B) COL11B
			, COL12, COL13, COL14, COL15, COL16, COL17, COL18
			, CONVERT(VARCHAR(20),Round(COL19,4),2) as COL19
			, CONVERT(VARCHAR(20),Round(COL20,4),2) as COL20
			, CONVERT(VARCHAR(20),Round(COL21,4),2) as COL21
			, CONVERT(VARCHAR(20),Round(COL22,4),2) as COL22
			, CONVERT(VARCHAR(20),Round(COL23,4),2) as COL23
			, CONVERT(VARCHAR(20),Round(COL24,4),2) as COL24
			, CONVERT(VARCHAR(20),Round(COL25,4),2) as COL25
			, CONVERT(VARCHAR(20),Round(COL26,4),2) as COL26
			,COL27,COL28,COL29 
			,Convert(decimal(1,0),COL29B) COL29B
			,COL30,COL31 ,COL32 ,COL33 ,COL34 ,COL35 ,COL36 
			,CASE WHEN Convert(decimal(1,0),COL37B) in (1,3) then COL37 else null end as COL37
			,CASE WHEN Convert(decimal(1,0),COL37B) in (2,4) then COL37 else null end as COL31TIN
			,Convert(decimal(1,0),COL37B) as COL37B
			,COL38 ,COL39 ,COL40 ,COL41 ,COL42 ,COL43 ,COL44 
			,CONVERT(VARCHAR(20),Round(COL45,4),2) as COL45
			,COL46 
			,CONVERT(VARCHAR(20),Round(COL47,4),2) as COL47 
			,CONVERT(VARCHAR(20),Round(COL48,4),2) as COL48 
			,CONVERT(VARCHAR(20),Round(COL49,4),2) as COL49 
			,CONVERT(VARCHAR(20),Round(COL50,4),2) as COL50 
			,CONVERT(VARCHAR(20),Round(COL51,4),2) as COL51 
			,CONVERT(VARCHAR(20),Round(COL52,4),2) as COL52 
			,CONVERT(VARCHAR(20),Round(COL53,4),2) as COL53 
			,COL54 ,COL55,COL56 ,COL57 ,COL58 
			,Convert(decimal(1,0),COL58B) as COL58B
			,COL59 ,COL60 ,COL61 ,COL62 ,COL63 ,COL64 ,COL65 
			,case when Convert(decimal(1,0),COL65B) <> 0 then Convert(decimal(1,0),COL65B) else NULL end  COL65B
			,case when Convert(decimal(1,0),COL65B) in (1,3) Then COL66 else NULL end COL66
			,case when Convert(decimal(1,0),COL65B) in (1,3) Then COL67 else NULL end COL67
			,COL68 ,COL69 ,COL70 ,COL71 ,COL72 
			,CONVERT(VARCHAR(20),Round(COL73,4),2) as COL73
			,CONVERT(VARCHAR(20),Round(COL74,4),2) as COL74
			,CONVERT(VARCHAR(20),Round(COL75,4),2) as COL75
			,CONVERT(VARCHAR(20),Round(COL76,4),2) as COL76
			,CONVERT(VARCHAR(20),Round(COL77,4),2) as COL77
			,CONVERT(VARCHAR(20),Round(COL78,4),2) as COL78
			,CONVERT(VARCHAR(20),Round(COL79,4),2) as COL79
			,CONVERT(VARCHAR(20),Round(COL80,4),2) as COL80
			,CONVERT(VARCHAR(20),Round(COL81,4),2) as COL81
			,CONVERT(VARCHAR(20),Round(COL82,4),2) as COL82
			,CONVERT(VARCHAR(20),Round(COL83,4),2) as COL83
			,CONVERT(VARCHAR(20),Round(COL84,4),2) as COL84
			,CONVERT(VARCHAR(20),Round(COL85,4),2) as COL85
			,COL86 ,COL87 ,COL88 
			,Convert(decimal(1,0),COL88B) as COL88B
			,COL89 ,COL90 ,COL91 ,COL92 ,COL93 ,COL94 ,COL95 
			,Convert(decimal(1,0),COL95B) as COL95B 
            ,case when Convert(decimal(1,0),COL95B) in (1,3) then COL96 else NULL end COL96
            ,case when Convert(decimal(1,0),COL95B) in (1,3) then COL97 else NULL end COL97
			,COL98 ,COL99 ,COL100,COL101
			,CONVERT(VARCHAR(20),Round(COL102,4),2) as COL102
			,COL103 ,COL104,COL105,COL106
			,Convert(decimal(1,0),COL106B) COL106B
			,COL107,COL108,COL109,COL110,COL111,COL112,COL113,COL114,COL115,COL116
			,CONVERT(VARCHAR(20),Round(COL117,4)) as COL117
			,CONVERT(VARCHAR(20),Round(COL118,4)) as COL118
			,COL119
			,CONVERT(VARCHAR(20),Round(COL120,4)) as COL120
			,CONVERT(VARCHAR(20),Round(COL121,4)) as COL121
			,CONVERT(VARCHAR(20),Round(COL122,4)) as COL122
			,COL123
			,CONVERT(VARCHAR(20),Round(COL124,4)) as COL124
			,COL125,COL126,COL127,COL128
			,Convert(decimal(1,0),COL128B) COL128B
			,COL129,COL130,COL131,COL132,COL133
			,Convert(decimal(1,0),COL133B) COL133B
			,COL134,COL135,COL136
			,CONVERT(VARCHAR(20),Round(COL137,4)) as COL137
			,COL138 
			,COL139 
			,COL140 
			,COL141 
			,Convert(decimal(1,0),COL141B) COL141B
			,COL142 ,COL143 ,COL144 ,COL145 ,COL146 ,COL147 ,COL148 ,COL149 ,COL150 ,COL151 ,COL152
			,CONVERT(VARCHAR(20),Round(COL153,4)) as COL153 
			,CONVERT(VARCHAR(20),Round(COL154,4)) as COL154 
			,COL155 
			,CONVERT(VARCHAR(20),Round(COL156,4)) as COL156
			,COL157 
			,COL158 
			,Convert(decimal(1,0),COL158B) COL158B
			,COL159 ,COL160 ,COL161
			,CASE WHEN COL161 <> 1 THEN COL162 else null end COL162
			,CASE WHEN COL161 <> 1 THEN COL163 else null end COL163
			,CASE WHEN COL161 <> 1 THEN COL164 else null end COL164 
			,CASE WHEN COL161 <> 1 THEN Convert(decimal(1,0),COL164B) else null end as COL164B
			,CASE WHEN COL161 <> 1 THEN COL165 else null end COL165
			,CASE WHEN COL161 <> 1 THEN COL166 else null end COL166
			,CASE WHEN COL161 <> 1 THEN COL167 else null end COL167
			,COL168 ,COL169 ,COL170 
			,Convert(decimal(1,0),COL170B) as COL170B
			,COL171 ,COL172 ,COL173 ,COL174 ,COL175 ,COL176 ,COL177 ,COL178 ,COL179 ,COL180 
			,CONVERT(VARCHAR(20),Round(COL181,4)) as COL181 
			,COL182 ,COL183 ,COL184 ,COL185 ,COL186 ,COL187 
			,Convert(decimal(1,0),COL187B) as COL187B
			,COL188 ,COL189 ,COL190 ,COL191 ,COL192 ,COL193 
			,Convert(decimal(1,0),COL193B) as COL193B
			,COL194 ,COL195 ,COL196 ,COL197 ,COL198 ,COL199 ,COL200 
			,CONVERT(VARCHAR(20),Round(COL201,4)) as COL201 
			,CONVERT(VARCHAR(20),Round(COL202,4)) as COL202 
			,CONVERT(VARCHAR(20),Round(COL203,4)) as COL203 
			,CONVERT(VARCHAR(20),Round(COL204,4)) as COL204 
			,CONVERT(VARCHAR(20),Round(COL205,4)) as COL205 
			,CONVERT(VARCHAR(20),Round(COL206,4)) as COL206 
			,CONVERT(VARCHAR(20),Round(COL207,4)) as COL207 
			,CONVERT(VARCHAR(20),Round(COL208,4)) as COL208 
			,CONVERT(VARCHAR(20),Round(COL209,4)) as COL209 
			,CONVERT(VARCHAR(20),Round(COL210,4)) as COL210 
			,CONVERT(VARCHAR(20),Round(COL211,4)) as COL211 
			,CONVERT(VARCHAR(20),Round(COL212,4)) as COL212 
			,CONVERT(VARCHAR(20),Round(COL213,4)) as COL213 
			,CONVERT(VARCHAR(20),Round(COL214,4)) as COL214 
			,COL215 
		
		from #tTemp_rep 
		where LAYER = 1 or GRP >= 5
		order by GRP, NUM_STAT
		
	end

	

 --Drop table #tTemp_rep


GO
