# Odoo Backup & Recovery Lab — Technical report

**Author:** Germain Daakpo Amouzou  
**Scope:** Completed manual application backup and isolated restore; Veeam integration with remaining verification work.

## Executive overview

I deployed Odoo 18 and PostgreSQL 16 on Ubuntu 22.04 using Docker Compose. I backed up the database, filestore and configuration into an approximately 7.5 MB bundle, then verified all four SHA-256 manifest entries. After restoring into a separate project, I confirmed quotation S00001 through SQL and the Odoo interface.

I installed Veeam Agent for Linux, repaired its kernel modules and verified access to the Windows SMB destination. My full-machine attempt failed under storage pressure. I still need to add final backup and recovered-file evidence for the follow-up workflow. I have not completed bare-metal recovery or measured RTO/RPO.

## Engineering report

| Section | Coverage |
|---|---|
| [Deployment](DEPLOYMENT.md) | VM preparation, Docker, service layout and business baseline |
| [Architecture](ARCHITECTURE.md) | Data flow, logical isolation and shared-host failure domain |
| [Manual recovery](RECOVERY.md) | Backup components, checksum validation, restore and evidence limits |
| [Veeam integration](VEEAM.md) | Agent, dedicated SMB destination and remaining verification |
| [Troubleshooting](TROUBLESHOOTING.md) | Storage pressure, permissions, DKMS and failed attempts |
| [Evidence index](EVIDENCE.md) | 118 redacted publication screenshots in six workflow galleries |

## Main lessons

Database recovery and filestore recovery must be coordinated. A readable backup archive alone does not establish application recovery. Separate Compose projects avoid overwriting the original volumes, while SQL and browser checks demonstrate business data usability. Keeping backups on the same physical host leaves a shared failure domain.

## Presentation

[View the PDF](Presentation.pdf) · [Download the PowerPoint](Odoo_Backup_Recovery_Lab.pptx)

The release describes the initial milestone. The current repository runbooks and evidence index define the available implementation and verification scope.
