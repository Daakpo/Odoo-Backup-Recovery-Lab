# Architecture and recovery boundaries

[Project overview](../README.md#architecture) · [Manual recovery](RECOVERY.md) · [Veeam integration](VEEAM.md)

The README contains editable Mermaid diagrams for the deployment topology and verified recovery workflow.

| Boundary | Design | Implication |
|---|---|---|
| Original application | Odoo 18 and PostgreSQL 16 in Docker; database has no host port | Application and database data live in separate named volumes |
| Manual backup | Stop Odoo writes; export database, filestore and configuration | Coordinated application recovery point |
| Backup destination | VirtualBox shared folder on Windows | Same physical host as source VM |
| Manual restore | Separate Compose project, internal network and independent volumes | Logical isolation, without physical disaster isolation |
| Validation | Four manifest checks, restored SQL record and quotation UI | Manual recovery evidence; no measured recovery objective |
| Veeam destination | Dedicated SMB account and share | Access verified; completed backup and recovered-file evidence still pending |

The observed recovery container address is temporary. The original loopback address and recovery container address must not be confused when collecting proof. Both backup destinations remain on the source Windows host; an independent offsite copy is a future improvement.

## Next validation milestones

1. Capture a completed Veeam backup session and restore point.
2. Recover files to a separate directory and compare their hashes.
3. Record backup time, recovery start and business-validation completion for RTO/RPO analysis.
4. Test recovery from storage independent of the Windows host.
