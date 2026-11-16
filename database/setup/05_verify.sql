-- Name: Blaise Byishimo Ngoga
-- Student ID: 29359
-- Group: I
-- Project: Retail Sales and Profitability Monitoring System
-- Run as SYSDBA in the CDB root, from the repository root directory.
-- Output is spooled to screenshots\phase3_verification.txt.

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET ECHO ON
SET VERIFY OFF
SET PAGESIZE 100
SET LINESIZE 220
SET TAB OFF

ALTER SESSION SET CONTAINER = CDB$ROOT;
SPOOL screenshots\phase3_verification.txt

PROMPT === PDB exists and is open ===
SELECT name, open_mode, restricted
FROM v$pdbs
WHERE name = 'I_29359_BLAISE_RETAIL_DB';

PROMPT === Admin user defaults and DBA role ===
SELECT c.name AS pdb_name,
       u.username,
       u.account_status,
       u.default_tablespace,
       u.temporary_tablespace
FROM cdb_users u
JOIN v$containers c ON c.con_id = u.con_id
WHERE c.name = 'I_29359_BLAISE_RETAIL_DB'
  AND u.username = 'BLAISE_ADMIN';

SELECT c.name AS pdb_name, r.granted_role, r.admin_option
FROM cdb_role_privs r
JOIN v$containers c ON c.con_id = r.con_id
WHERE c.name = 'I_29359_BLAISE_RETAIL_DB'
  AND r.grantee = 'BLAISE_ADMIN'
ORDER BY r.granted_role;

PROMPT === Data and temporary tablespace files ===
SELECT tablespace_name,
       file_name,
       ROUND(bytes / 1048576) AS current_mb,
       autoextensible,
       ROUND(increment_by * p.block_size / 1048576) AS next_mb,
       ROUND(maxbytes / 1048576) AS max_mb
FROM (
  SELECT con_id, tablespace_name, file_name, bytes, autoextensible, increment_by, maxbytes
  FROM cdb_data_files
  UNION ALL
  SELECT con_id, tablespace_name, file_name, bytes, autoextensible, increment_by, maxbytes
  FROM cdb_temp_files
) f
CROSS JOIN (
  SELECT TO_NUMBER(value) AS block_size
  FROM v$parameter
  WHERE name = 'db_block_size'
) p
WHERE f.con_id = (
  SELECT con_id FROM v$pdbs WHERE name = 'I_29359_BLAISE_RETAIL_DB'
)
  AND f.tablespace_name IN ('RETAIL_DATA', 'RETAIL_IDX', 'RETAIL_TEMP')
ORDER BY tablespace_name, file_name;

PROMPT === Archive log mode (CDB setting) ===
SELECT name, log_mode FROM v$database;

PROMPT === Enterprise Manager Express HTTPS port ===
ALTER SESSION SET CONTAINER = i_29359_blaise_retail_db;
SELECT DBMS_XDB_CONFIG.GETHTTPSPORT() AS https_port FROM dual;
ALTER SESSION SET CONTAINER = CDB$ROOT;

PROMPT === Admin login confirmation ===
PROMPT Open a separate SQL Developer connection as BLAISE_ADMIN to the PDB and run:
PROMPT SELECT SYS_CONTEXT('USERENV','CON_NAME') AS pdb_name, USER AS username FROM dual;

SPOOL OFF
