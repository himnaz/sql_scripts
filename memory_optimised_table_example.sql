ALTER DATABASE TestDB ADD FILEGROUP TestDB_mod CONTAINS MEMORY_OPTIMIZED_DATA 
Go 
ALTER DATABASE TestDB ADD FILE (name='TestDB_mod1', filename='c:\data\TestDB_mod1') TO FILEGROUP TestDB_mod 
Go

USE [test]
GO

/****** Object:  Table [dbo].[QMS_Cache]    Script Date: 24/01/2020 14:36:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QMS_Cache]
(
	[QMS_CID] [int] IDENTITY(1,1) NOT NULL,
	[VRN_PH_LN_HSH] [int] NOT NULL,
	[VRN_PH_DOB_HSH] [int] NOT NULL,
	[VRN_PH_CPC_HSH] [int] NOT NULL,
	[VRN_PH_OPC_HSH] [int] NOT NULL,
	[QUO_ID] [int] NOT NULL,
	[QUO_NUM] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VEH_OVN_PC] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[COR_PC] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VRN] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PHD_DOB] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DRV_DOB] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DRV_NAM] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UK_RES_MON] [smallint] NULL,
	[LIC_OWN_MON] [smallint] NULL,
	[CNV_CNT] [tinyint] NULL,
	[CLM_CNT] [tinyint] NULL,
	[VEH_OWN_MON] [smallint] NULL,
	[ANN_MLG] [smallint] NULL,
	[VEH_OVN_LOC] [varchar](23) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NCD_PRD] [tinyint] NULL,
	[VEH_USE] [char](17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DRV_OCC] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DRV_LIC_TYP] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INS_PRV_DEC] [tinyint] NULL,
	[LD_DT] [datetime2](7) NOT NULL,

INDEX [IX_VRN_PH_CPC_HSH] NONCLUSTERED HASH 
(
	[VRN_PH_CPC_HSH]
)WITH ( BUCKET_COUNT = 16777216),
INDEX [IX_VRN_PH_DOB_HSH] NONCLUSTERED HASH 
(
	[VRN_PH_DOB_HSH]
)WITH ( BUCKET_COUNT = 16777216),
INDEX [IX_VRN_PH_LN_HSH] NONCLUSTERED HASH 
(
	[VRN_PH_LN_HSH]
)WITH ( BUCKET_COUNT = 16777216),
INDEX [IX_VRN_PH_OPC_HSH] NONCLUSTERED HASH 
(
	[VRN_PH_OPC_HSH]
)WITH ( BUCKET_COUNT = 16777216),
 PRIMARY KEY NONCLUSTERED 
(
	[QMS_CID] ASC
)
)WITH ( MEMORY_OPTIMIZED = ON , DURABILITY = SCHEMA_AND_DATA )
GO




CREATE TABLE [dbo].[QMS_Cache1]
(
	[QMS_CID] [int] IDENTITY(1,1) NOT NULL,
	[VRN_PH_LN_HSH] [int] NOT NULL,
	[VRN_PH_DOB_HSH] [int] NOT NULL,
	[VRN_PH_CPC_HSH] [int] NOT NULL,
	[VRN_PH_OPC_HSH] [int] NOT NULL,
	[QUO_ID] [int] NOT NULL,
	[QUO_NUM] [char](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VEH_OVN_PC] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[COR_PC] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[VRN] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PHD_DOB] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DRV_DOB] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DRV_NAM] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UK_RES_MON] [smallint] NULL,
	[LIC_OWN_MON] [smallint] NULL,
	[CNV_CNT] [tinyint] NULL,
	[CLM_CNT] [tinyint] NULL,
	[VEH_OWN_MON] [smallint] NULL,
	[ANN_MLG] [smallint] NULL,
	[VEH_OVN_LOC] [varchar](23) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NCD_PRD] [tinyint] NULL,
	[VEH_USE] [char](17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DRV_OCC] [char](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DRV_LIC_TYP] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INS_PRV_DEC] [tinyint] NULL,
	[LD_DT] [datetime2](7) NOT NULL,


 PRIMARY KEY NONCLUSTERED 
(
	[QMS_CID] ASC
)
)WITH ( MEMORY_OPTIMIZED = OFF , DURABILITY = SCHEMA_AND_DATA )
GO
