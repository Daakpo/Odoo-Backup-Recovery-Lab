# Odoo Backup & Recovery Lab — Technical report

**Author:** Germain Daakpo Amouzou  
**Scope:** Completed manual application backup and isolated restore; Veeam integration with remaining verification work.

## Executive overview

This lab deploys Odoo 18 and PostgreSQL 16 on Ubuntu 22.04 using Docker Compose. A coordinated database, filestore and configuration backup produced an approximately 7.5 MB recovery bundle. Four SHA-256 manifest checks passed. A separate recovery project returned quotation S00001 through SQL and the Odoo interface.

The Veeam work establishes Linux agent installation, kernel-module troubleshooting and SMB destination access. The recorded full-machine attempt failed; a later successful backup and recovered-file proof are not included. No bare-metal recovery or measured RTO/RPO is claimed.

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

[View the PDF](Presentation.pdf) · [Download the PowerPoint from the release](https://github.com/Daakpo/Odoo-Backup-Recovery-Lab/releases/tag/Backup_Lab)

The release describes the initial milestone. The current repository runbooks and evidence index define the available implementation and verification scope.
