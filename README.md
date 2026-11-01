# Odoo Backup & Recovery Lab

A hands-on infrastructure lab demonstrating coordinated PostgreSQL + Odoo filestore backups, isolated recovery, and Veeam Agent integration on Linux. 

**Author:** Germain Daakpo Amouzou  
**Environment:** Ubuntu 22.04, Docker, PostgreSQL 16, Odoo 18, Veeam Agent for Linux

[📄 Read the Full Technical Report](docs/REPORT.md) | [📊 View the Presentation](docs/Presentation.pdf)

---

## 📌 Scope & Outcomes

*This project prioritizes verified evidence and honest scope over a perfect success story.*

| Area | Status | What the evidence establishes |
| :--- | :--- | :--- |
| **Odoo Deployment** | ✅ Verified | Odoo 18 and PostgreSQL 16 run healthy in Docker. |
| **Manual Backup** | ✅ Verified | 7.5 MB bundle created; four SHA-256 checksums pass. |
| **Manual Restore** | ✅ Verified | Separate Compose project restores DB and filestore; UI shows S00001. |
| **Veeam SMB Access** | ✅ Verified | Dedicated Windows account successfully writes to SMB share. |
| **Veeam Recovery** | ⚠️ Open | Final success session and recovered hashes pending. |
| **Bare Metal / RTO** | ❌ Open | Recovery media failed (out of space); RTO/RPO not measured. |

---

## 🏗 Architecture & Recovery Boundaries

![Architecture Diagram](evidence/01_deployment/architecture_diagram.png)

*Note: The diagram highlights a critical failure domain: the source data and backup destinations currently share the same physical Windows host.*

---

## 🛠 Skills Demonstrated

*   **Containers:** Docker Engine, Compose, named volumes, internal networks.
*   **Databases:** PostgreSQL logical backup (`pg_dump`), `pg_restore`, SQL verification.
*   **Linux Operations:** Disk diagnosis, mount topology inspection, DKMS kernel module repair.
*   **Backup Integration:** Veeam Agent for Linux, Windows SMB share permissions.
*   **Verification:** SHA-256 manifest checks, isolated restore testing.

---

## 📂 Repository Structure

*   **`/docs`**: Full technical report and presentation slides.
*   **`/compose`**: Sanitized Docker Compose files and `.env.example`.
*   **`/scripts`**: Verification and restore automation scripts.
*   **`/evidence`**: All 118 screenshots, organized by workflow stage.

---
