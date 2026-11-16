-- Name: Blaise Byishimo Ngoga
-- Student ID: 29359
-- Group: I
-- Project: Retail Sales and Profitability Monitoring System
-- PDB: i_29359_blaise_retail_db
-- Run as SYSDBA after 01_create_pdb.sql and 02_create_user.sql.
-- Datafiles are placed in the directory containing the CDB root datafiles.

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET ECHO ON
SET VERIFY OFF

ALTER SESSION SET CONTAINER = CDB$ROOT;

COLUMN db_file_dir NEW_VALUE db_file_dir NOPRINT
SELECT SUBSTR(name, 1, GREATEST(INSTR(name, '/', -1), INSTR(name, '\', -1))) AS db_file_dir
FROM v$datafile
WHERE con_id = 1
  AND ROWNUM = 1;

ALTER SESSION SET CONTAINER = i_29359_blaise_retail_db;

CREATE TABLESPACE retail_data
  DATAFILE '&db_file_dir.i_29359_blaise_retail_db_retail_data01.dbf'
  SIZE 100M
  AUTOEXTEND ON NEXT 10M MAXSIZE 1G;

CREATE TABLESPACE retail_idx
  DATAFILE '&db_file_dir.i_29359_blaise_retail_db_retail_idx01.dbf'
  SIZE 50M
  AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

CREATE TEMPORARY TABLESPACE retail_temp
  TEMPFILE '&db_file_dir.i_29359_blaise_retail_db_retail_temp01.dbf'
  SIZE 50M
  AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

ALTER USER blaise_admin
  DEFAULT TABLESPACE retail_data
  TEMPORARY TABLESPACE retail_temp
  QUOTA UNLIMITED ON retail_data
  QUOTA UNLIMITED ON retail_idx;

-- Use a dedicated PDB port rather than routing through the CDB global port.
EXEC DBMS_XDB_CONFIG.SETGLOBALPORTENABLED(FALSE);
EXEC DBMS_XDB_CONFIG.SETHTTPSPORT(5559);

SELECT tablespace_name, contents, status
FROM dba_tablespaces
WHERE tablespace_name IN ('RETAIL_DATA', 'RETAIL_IDX', 'RETAIL_TEMP')
ORDER BY tablespace_name;

SELECT DBMS_XDB_CONFIG.GETHTTPSPORT() AS https_port FROM dual;
