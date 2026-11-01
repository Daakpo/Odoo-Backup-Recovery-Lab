# Manual backup and isolated restore

[Project overview](../README.md) · [Recovery screenshot gallery](gallery-03-manual-recovery.md)

## Recovery objective

Recover the Odoo business record and its associated data into a separate application instance, while preserving the original deployment. The recovery unit includes the PostgreSQL database, Odoo filestore and required configuration.

## Backup destination

The Windows host directory `E:\Enterprise-Lab-Backups\Odoo` mapped to the permanent VirtualBox share `OdooBackups`, mounted in Ubuntu at `/media/sf_OdooBackups`. A write test confirmed that Ubuntu-created content appeared on Windows. Access depended on the guest shared-folder group permissions.

The observed bundle directory was `odoo-backup-SzPMZ85w`.

| File | Observed size | Role |
|---|---:|---|
| database.dump | 4.1 MB | PostgreSQL custom-format logical backup |
| odoo-data.tar.gz | 2.9 MB | Archived Odoo data including filestore |
| odoo.conf | 215 B | Effective Odoo configuration |
| project.tar.gz | 696 B | Compose, environment and project directories |
| database-contents.txt | 587 KB | Restore catalog listing |
| SHA256SUMS | 320 B | Integrity manifest for four primary files |

The complete bundle occupied approximately **7.5 MB**. Its archives include private configuration and credentials, so the actual bundle is intentionally absent from this public package.

## Coordinated backup procedure

The lab stopped the original Odoo service to prevent application writes. PostgreSQL stayed online. A custom-format `pg_dump` captured `enterprise_lab`, and `docker cp` streamed the stopped Odoo container's `/var/lib/odoo` directory into a compressed archive. The effective Odoo configuration and project files completed the recovery bundle.

Validation covered the PostgreSQL restore catalog, compressed archive integrity, project archive readability and SHA-256 checksums. The first backup command changed working directory before its exit trap restarted Compose, causing a `no configuration file provided` error. Returning to the original project directory and starting Odoo corrected the restart. The source service then ran normally and all four checksum checks passed.

This procedure coordinates the database and filestore by pausing the application. It does not demonstrate a backup taken during live Odoo writes or a Veeam application-aware database integration.

![Original service restarted and four checksums passed](screenshots/062-20261101-004249.png)

*E062: Original service restarted and four checksums passed.*

## Separate recovery project

The restore directory was `/home/germain/enterprise-security-lab-restore`, restricted to its owner. The recovery Compose project used the explicit name `enterprise-security-lab-restore` so its database volume, application volume and network remained separate from the original stack.

Recovery controls:

- Separate named volumes and Compose project identity.
- Internal Docker network to limit outbound connectivity.
- Odoo scheduled workers disabled with `--max-cron-threads=0`.
- Backed-up Odoo configuration mounted read only.
- Original deployment preserved throughout validation.

The database restore created `enterprise_lab` from `template0` and imported the custom dump with `pg_restore --exit-on-error --no-owner`. A query of the restored `sale_order` table returned S00001, draft state and total 250.00.

The Odoo filestore came from the `odoo/filestore` subtree of `odoo-data.tar.gz`. A one-off root container extracted it into the recovery volume and restored Odoo ownership. Runtime cache and session content were not required for the filestore restore.

![Restored database query confirms S00001](screenshots/065-20261101-004927.png)

*E065: Restored database query confirms S00001.*

## Restore validation

| Check | Observed outcome |
|---|---|
| PostgreSQL restore | Completed and returned the quotation through SQL |
| Recovery service startup | PostgreSQL healthy, Odoo running |
| Original source stack | Preserved and running |
| Recovery HTTP check | HTTP 200 at the recovery container address |
| Recovery browser check | Quotation list contains S00001 and Northstart Demo Ltd |
| Text baseline comparison | Matching original and downloaded text hashes |

The planned loopback port 8070 did not respond in this internal-network configuration. Inspection identified the recovery container address `172.19.0.3`, and Ubuntu reached Odoo directly at port 8069. That address is an observed value, not a fixed configuration contract.

The attachment text checksum recorded in the lab was:

```text
5c553359fe23a9641d32500a0bb4d430ef322e70b83e597e450589405876e40a
```

Later attachment screenshots include the original loopback instance or omit enough browser context that they do not independently establish a fresh download from the isolated restore. They support the attachment baseline and byte comparison. The restored database and quotation UI provide direct evidence of application recovery, and the user confirmed that the restored instance exists and works.

![Restored Odoo quotation list at container IP](screenshots/070-20261101-005827.png)

*E070: Restored Odoo quotation list at container IP.*

## Local staging for Veeam

The bundle was copied from the shared folder into `/home/germain/odoo-veeam-source`. An initial copy failed because the current guest session lacked shared-folder access. Copying with elevated privileges and assigning ownership on the local destination corrected the permission issue. The local staging directory remained private. All four manifest checks passed, and its size remained 7.5 MB.

This copy preserves the earlier manual recovery point. It is not a fresh export of the current Odoo database.

## Recovery measurements

No formal recovery timer or target RTO/RPO was defined. Session timestamps cannot substitute for an end-to-end measured recovery duration. A future exercise should record the backup timestamp, recovery start, service-ready time and business-validation completion separately.

## Official reference

[PostgreSQL 16 pg_dump](https://www.postgresql.org/docs/16/app-pgdump.html) and [pg_restore](https://www.postgresql.org/docs/16/app-pgrestore.html)
