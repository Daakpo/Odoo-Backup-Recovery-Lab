# Screenshot evidence index

I organized my 118 screenshots into the stage galleries below. I redacted visible database-manager passwords and a session cookie before publishing them. The filenames retain the original capture timestamps. Some screenshots show failed attempts that I kept to document my troubleshooting.

- [Platform preparation and Docker](gallery-01-platform.md) — 32 screenshots
- [Odoo business records and attachments](gallery-02-odoo.md) — 19 screenshots
- [Manual backup and isolated recovery](gallery-03-manual-recovery.md) — 25 screenshots
- [Windows SMB destination](gallery-04-smb.md) — 9 screenshots
- [Veeam installation and recovery media troubleshooting](gallery-05-veeam-install.md) — 18 screenshots
- [Veeam job attempt and verified recovery source](gallery-06-veeam-job.md) — 15 screenshots

## Key checkpoints

| Evidence | Checkpoint | Interpretation |
|---|---|---|
| [E032](screenshots/032-20261031-215827.png) | Healthy PostgreSQL and running Odoo | Odoo runs and PostgreSQL is healthy. |
| [E043](screenshots/043-20261031-224610.png) | Saved quotation S00001 | S00001 establishes the business record baseline. |
| [E062](screenshots/062-20261101-004249.png) | Original service restarted and four checksums passed | All four manual bundle hashes pass. |
| [E065](screenshots/065-20261101-004927.png) | Restored database query confirms S00001 | SQL query confirms S00001 in the restored database. |
| [E070](screenshots/070-20261101-005827.png) | Restored Odoo quotation list at container IP | Restored Odoo UI at the recovery container address. |
| [E085](screenshots/085-20261101-013449.png) | SMB upload test succeeds | Dedicated account can write to the SMB share. |
| [E102](screenshots/102-20261101-023147.png) | Veeam modules rebuilt successfully | Veeam kernel modules are present after repair. |
| [E116](screenshots/116-20261101-031636.png) | All System job and accessible SMB repository | Existing job is All System and SMB repository is accessible. |
| [E117](screenshots/117-20261101-032032.png) | Local recovery bundle four checksums pass | Local staging copy preserves all four bundle hashes. |
| [E118](screenshots/118-20261101-032145.png) | Stopped full-machine session shows Failed | Stopped full-machine backup is Failed, not a restore point. |

I completed the Veeam follow-up steps after the last screenshot in this index. I still need to add the successful backup-session and recovered-file screenshots to document the final result.
