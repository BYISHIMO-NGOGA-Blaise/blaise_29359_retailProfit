-- Name: Blaise Byishimo Ngoga
-- Student ID: 29359
-- Group: I
-- Project: Retail Sales and Profitability Monitoring System
-- Run connected as SYSDBA to the local CDB root.

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET ECHO ON

ALTER SESSION SET CONTAINER = CDB$ROOT;
SELECT name, log_mode FROM v$database;

-- ARCHIVELOG is a CDB-level redo-log mode, not a setting owned by one PDB.
-- A PDB cannot independently change how its CDB writes and archives redo logs.
-- Changing the mode requires SYSDBA access and restarting the whole CDB in MOUNT mode.
-- Never run these local-only steps against a shared lab server.

-- If the query above reports NOARCHIVELOG, and this is your own local CDB only,
-- run these commands manually as SYSDBA after confirming archive storage is configured:
-- SHUTDOWN IMMEDIATE
-- STARTUP MOUNT
-- ALTER DATABASE ARCHIVELOG
-- ALTER DATABASE OPEN
-- Then rerun this script to verify LOG_MODE = ARCHIVELOG.
