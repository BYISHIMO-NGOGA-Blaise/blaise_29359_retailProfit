# Phase III database setup

## Project identifiers

- Student: Blaise Byishimo Ngoga (29359)
- Group: I
- PDB: `i_29359_blaise_retail_db` (24 characters; project name shortened to `retail`)
- Admin user: `blaise_admin`
- Tablespaces: `retail_data`, `retail_idx`, and `retail_temp`
- Enterprise Manager Express HTTPS port: `5559`
- Expected EM Express URL: `https://localhost:5559/em`

## Preconditions

1. Use your own local Oracle Database 21c CDB and connect as SYSDBA to `CDB$ROOT`.
2. Do not run PDB creation, restart, or archive-log commands on a shared lab server.
3. Before running `01_create_pdb.sql`, create a separate writable PDB datafile destination directory (not the seed directory). Enter its full path with a trailing slash or backslash when prompted. The script obtains the PDB seed source directory from the database.
4. The PDB admin password is prompted with input hidden. For this course lab only, enter the required first-name password; never store it in the repository.
5. Run scripts from the repository root so the verification spool path resolves correctly.

## Run order

Run each script in SQL*Plus or SQLcl as SYSDBA:

1. `@database/setup/01_create_pdb.sql`
2. `@database/setup/02_create_user.sql`
3. `@database/setup/03_tablespaces.sql`
4. `@database/setup/04_archive_log.sql`
5. `@database/setup/05_verify.sql`

`01_create_pdb.sql` creates the PDB admin account because Oracle's `CREATE PLUGGABLE DATABASE` statement creates it as part of PDB creation. `02_create_user.sql` explicitly grants and verifies the required local DBA/session privileges.

`03_tablespaces.sql` uses the CDB root datafile directory for the three PDB files. It configures the admin default/temporary tablespaces, quotas, and a dedicated PDB HTTPS port. Oracle Database 21c deprecates EM Express; if it is unavailable in this installation, use SQL Developer's DBA panel as allowed by the course instructions.

`04_archive_log.sql` reports the current CDB archive mode. The local-only restart commands are comments so they cannot accidentally restart a database when the verification script is run; execute them manually only after confirming the CDB is your own local installation and archive storage is configured.

## Evidence status

The scripts have not yet been run against the local Oracle instance from this workspace. Do not treat generated or sample output as evidence. Run `05_verify.sql`, save its spool output, connect separately as `blaise_admin` to confirm the PDB/user, and capture the screenshots listed in [`screenshots/README.md`](../../screenshots/README.md).
