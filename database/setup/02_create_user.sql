-- Name: Blaise Byishimo Ngoga
-- Student ID: 29359
-- Group: I
-- Project: Retail Sales and Profitability Monitoring System
-- PDB: i_29359_blaise_retail_db
-- Run as SYSDBA from SQL*Plus/SQLcl after 01_create_pdb.sql.
-- Oracle creates the PDB ADMIN USER as part of CREATE PLUGGABLE DATABASE; this script
-- explicitly applies and verifies the required local DBA and session privileges.

WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
SET ECHO ON
SET VERIFY OFF

ALTER SESSION SET CONTAINER = i_29359_blaise_retail_db;

GRANT DBA TO blaise_admin;
GRANT CREATE SESSION TO blaise_admin;

SELECT username, account_status, default_tablespace, temporary_tablespace
FROM dba_users
WHERE username = 'BLAISE_ADMIN';

SELECT granted_role, admin_option
FROM dba_role_privs
WHERE grantee = 'BLAISE_ADMIN'
ORDER BY granted_role;

PROMPT To confirm the connection as BLAISE_ADMIN, connect to the PDB in SQL Developer and run:
PROMPT SELECT SYS_CONTEXT('USERENV','CON_NAME') AS pdb_name, USER AS username FROM dual;
