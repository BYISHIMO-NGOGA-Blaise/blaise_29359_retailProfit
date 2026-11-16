-- Name: Blaise Byishimo Ngoga
-- Student ID: 29359
-- Group: I
-- Project: Retail Sales and Profitability Monitoring System
-- PDB: i_29359_blaise_retail_db (shortened project name: retail)
-- Run in SQL*Plus/SQLcl as SYSDBA, connected to the local CDB root.
-- Create a separate destination directory before running; the Oracle service must be able to write to it.

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET ECHO OFF
SET VERIFY OFF

ALTER SESSION SET CONTAINER = CDB$ROOT;
SHOW CON_NAME
SELECT name, cdb, log_mode FROM v$database;

-- This identifies the seed-file directory for FILE_NAME_CONVERT.
COLUMN seed_dir NEW_VALUE seed_dir NOPRINT
SELECT SUBSTR(name, 1, GREATEST(INSTR(name, '/', -1), INSTR(name, '\', -1))) AS seed_dir
FROM v$datafile
WHERE con_id = 2
  AND ROWNUM = 1;

ACCEPT pdb_data_dir CHAR PROMPT 'Existing writable PDB data directory (end with slash or backslash): '
ACCEPT admin_password CHAR PROMPT 'Lab-only admin password (course convention: first name): ' HIDE

CREATE PLUGGABLE DATABASE i_29359_blaise_retail_db
  ADMIN USER blaise_admin IDENTIFIED BY "&admin_password"
  ROLES = (DBA)
  FILE_NAME_CONVERT = ('&seed_dir', '&pdb_data_dir');

UNDEFINE admin_password
UNDEFINE pdb_data_dir
UNDEFINE seed_dir

ALTER PLUGGABLE DATABASE i_29359_blaise_retail_db OPEN;
ALTER PLUGGABLE DATABASE i_29359_blaise_retail_db SAVE STATE;

SELECT name, open_mode, restricted
FROM v$pdbs
WHERE name = 'I_29359_BLAISE_RETAIL_DB';
