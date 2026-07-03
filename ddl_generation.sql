SELECT ORDINAL_POSITION
      , '[' + COLUMN_NAME + ']' as Column_Name, '[' + DATA_TYPE + ']' as Data_type
	  ,  CHARACTER_MAXIMUM_LENGTH as length
      , case when IS_NULLABLE = 'NO' then 'NOT NULL' when IS_NULLABLE = 'YES' then 'NULL' end as nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'PolicyQuoteVersion'





SELECT ',' + str(ORDINAL_POSITION) + ',' + '[' + COLUMN_NAME + ']'
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'PolicyQuoteVersion'
and table_schema = 'D4P'



select ',max(len(' + column_name + ')) ' + column_name + '-' + REPLACE(str(character_maximum_length),' ','')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Loss_History'
and table_schema = 'D4P'
and data_type = 'varchar'


select ',max(len(' + column_name + ')) ' + column_name
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Customer'
and table_schema = 'D4P'
and data_type = 'varchar'

select
max(len(Product_Class)) Product_Class
,max(len(REC_SRC)) REC_SRC
,max(len(REC_ID)) REC_ID
,max(len(PolicyQuoteVersionID)) PolicyQuoteVersionID
,max(len(PrePostInceptionClaimsID)) PrePostInceptionClaimsID
,max(len(CLAIM_PRE_POST)) CLAIM_PRE_POST
,max(len(ClaimCauseCode)) ClaimCauseCode
,max(len(ClaimCauseDescription)) ClaimCauseDescription
,max(len(ClaimClosureReason)) ClaimClosureReason
,max(len(ClaimType)) ClaimType
,max(len(FaultIndicator)) FaultIndicator
,max(len(NCDImpact)) NCDImpact
,max(len(ClaimLocation)) ClaimLocation
,max(len(ClaimReference)) ClaimReference
,max(len(ClaimRiskPostcode)) ClaimRiskPostcode
,max(len(ClaimStatus)) ClaimStatus
,max(len(EligibleForNCD)) EligibleForNCD
,max(len(InsuredName)) InsuredName
,max(len(InsuredPostcode)) InsuredPostcode
,max(len(RollNumber)) RollNumber
,max(len(SectionCode)) SectionCode
,max(len(SectionName)) SectionName
,max(len(IncidentDriverFirstName)) IncidentDriverFirstName
,max(len(IncidentDriverLastName)) IncidentDriverLastName
,max(len(IncidentDriverMiddleName)) IncidentDriverMiddleName
from d4p.Loss_History with (nolock)