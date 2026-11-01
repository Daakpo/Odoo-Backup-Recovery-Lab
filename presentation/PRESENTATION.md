# Odoo Backup and Recovery Lab

## Slide 1

Odoo Backup & Recovery

ODOO BACKUP & RECOVERY LAB

Restored Odoo and quotation S00001 in a separate Compose project.

Germain Daakpo Amouzou

github.com/Daakpo

Project repository: publication pending

01

### Talking points

Manual application recovery is verified. GitHub repository creation and upload have not completed. Use the verified GitHub profile link until publication. Scope: Docker deployment, manual recovery, Veeam Agent integration and engineering lessons.

## Slide 2

Scope and outcomes

Area

Status

What the evidence establishes

Odoo deployment

Verified

Odoo runs and PostgreSQL is healthy.

Manual backup

Verified

7.5 MB bundle. Four checksums pass.

Manual restore

Verified

Separate instance serves S00001.

Veeam SMB access

Verified

Dedicated account uploads a test file.

Veeam recovery

Open

Final success session and recovered hashes needed.

Bare metal / RTO

Open

Recovery media and measured timing unverified.

Lab uses sample customer records. Credentials redacted.

02

### Talking points

Evidence: E032, E062, E065, E070, E085, E117 and E118. I completed the Veeam follow-up steps after these captures. I still need to add the final successful backup-session and recovered-file screenshots. My manual Odoo recovery is documented separately.

## Slide 3

Lab architecture and recovery boundaries

Windows host with VirtualBox

Ubuntu 22.04 guest

Odoo 18

Loopback :8069

PostgreSQL 16

Internal service

odoo-data volume

postgres-data volume

Recovery bundle 7.5 MB

Dump + filestore + config

SHA256SUMS

Isolated restore project

Separate volumes and network

S00001 verified

Veeam Agent

File scope

E:\Enterprise-Lab-Backups

Odoo directory

VirtualBox shared folder

Veeam directory

SMB: VeeamBackups

Source and backup destinations

share the same physical host.

vboxsf

configured

03

### Talking points

Logical architecture based on the actual lab. The bundle exists on the Windows VirtualBox shared folder and as a verified local Ubuntu staging copy. The restore uses that manual bundle. The dashed Veeam connection represents configured SMB access, not proof of a successful backup. SMB observed path: //192.168.2.90/VeeamBackups. No independent-host or offsite copy is established.

## Slide 4

Ubuntu lab environment

4 GB guest RAM

Windows host with VirtualBox.

Ubuntu 22.04, amd64.

A 24 GB root filesystem constrains backup workspace.

E022  VM memory increased to 4 GB

A 24 GB guest root must hold the OS, containers and temporary backup workspace.

04

### Talking points

Evidence: docs/screenshots/022-20261031-211050.png
Memory screenshot after increasing the VM allocation. Guest storage figures come from the disk captures in gallery-01-platform.md.

## Slide 5

Container deployment

Database healthy

Odoo 18 and PostgreSQL 16 use separate named volumes.

Odoo publishes on Ubuntu loopback port 8069.

E032  Healthy PostgreSQL and running Odoo

The original stack publishes Odoo only on Ubuntu loopback. PostgreSQL has no host port.

05

### Talking points

Evidence: docs/screenshots/032-20261031-215827.png
Compose reference: compose.yaml. Separate volumes provide persistence, not independent backups. No database port is published.

## Slide 6

Business record baseline

Quotation S00001

Northstart Demo Ltd

IT Support Package

1 service at $250

Final tax: 0%

E043  Saved quotation S00001

Baseline: S00001, draft quotation, $250 total, with a PDF and recovery-test.txt attachment.

06

### Talking points

Evidence: docs/screenshots/043-20261031-224610.png
The spelling Northstart matches the stored customer. This record and its text/PDF attachments establish the recovery baseline.

## Slide 7

Manual recovery bundle

Four integrity checks pass

Custom database dump.

Odoo data and filestore.

Configuration and project archive.

E062  Original service restarted and four checksums passed

Verification: sha256sum -c SHA256SUMS

All four primary recovery-bundle files pass.

07

### Talking points

Evidence: docs/screenshots/062-20261101-004249.png
Odoo paused during export. PostgreSQL remained online. The original Compose service restarted after correcting the working-directory issue. The 7.5 MB bundle includes private configuration and is not published.

## Slide 8

Database restoration

S00001 restored

A separate Compose project uses new data volumes.

The restored database query returns draft state and total 250.00.

E065  Restored database query confirms S00001

The restored SQL record returns S00001, draft state and total 250.00.

08

### Talking points

Evidence: docs/screenshots/065-20261101-004927.png
Recovery project: enterprise-security-lab-restore. Created enterprise_lab from template0 and imported with pg_restore --exit-on-error --no-owner.

## Slide 9

Restored application

Recovered quotation S00001

Recovery Odoo instance reachable from Ubuntu.

The original application remains separate.

E070  Restored Odoo quotation list at container IP

Separate project, volumes and network preserve the original application during recovery.

09

### Talking points

Evidence: docs/screenshots/070-20261101-005827.png
The observed recovery address is 172.19.0.3, subject to change. The intended host loopback mapping on 8070 did not respond in the internal-network configuration. Later attachment views have mixed provenance and are described separately in docs/RECOVERY.md.

## Slide 10

Windows SMB destination

Ubuntu upload succeeds

A dedicated Windows account writes to VeeamBackups.

Share and NTFS permissions control access.

E085  SMB upload test succeeds

GM-PC\veeambackup authenticates through a private password prompt. No password appears in E085.

10

### Talking points

Evidence: docs/screenshots/085-20261101-013449.png
UNC: //192.168.2.90/VeeamBackups. Account: GM-PC\veeambackup. Share Change and NTFS Modify. A scoped TCP 445 rule allows the lab network path. Destination is on the same host, with no offsite-copy claim.

## Slide 11

Veeam Agent and DKMS rebuild

Kernel modules rebuilt

Cleanup crossed mounted kernel paths.

Reinstalled kernel packages and headers.

A DKMS rebuild restored both modules.

E102  Veeam modules rebuilt successfully

Both veeamblksnap.ko and bdevfilter.ko rebuilt against kernel 6.8.0-85-generic.

modinfo confirms version 13.1.2.11.

11

### Talking points

Evidence: docs/screenshots/102-20261101-023147.png
These results follow a cleanup incident affecting firmware/module paths. Details in docs/TROUBLESHOOTING.md. No reboot verification is claimed.
Context: unsafe recursive cleanup traversed same-filesystem bind mounts and affected kernel-module paths. Reinstallation of kernel packages and current headers, followed by DKMS rebuild, restored both Veeam modules. This was a troubleshooting repair, not a Veeam compatibility claim.

## Slide 12

Recovery media storage failure

ISO creation runs out of space

Recovery-media creation stops with a space error.

Bootable recovery media remains unverified.

E094  Recovery ISO creation fails for lack of space

Cause: a ~4.8 GB workspace exhausted free space on the 24 GB root filesystem.

Remedy: provision workspace capacity before retrying, then store finished recovery media externally.

12

### Talking points

Evidence: docs/screenshots/094-20261101-021207.png
The initial downloaded ISO was i386 although the guest is amd64. The later download-and-patch attempt failed. This slide documents troubleshooting, not a completed bare-metal recovery capability.

## Slide 13

Full-machine backup attempt

Progress remains at 8%

1.9 GB processed.

373.3 MB transferred.

The stopped session ends in Failed.

E113  Backup remains at 8 percent

Root cause: snapshot storage growth exhausted root headroom. Root usage reached 99%.

Forced stop restored ~2.7 GB free. Provision snapshot capacity before retrying.

13

### Talking points

Evidence: docs/screenshots/113-20261101-030344.png
The full-machine job remained All System. A Target bottleneck alone did not prove cause. Snapshot low-free-space logs and df output support the storage diagnosis. Forced stop recovered root free space to about 2.7 GB.

## Slide 14

7.5 MB static recovery bundle

Four staged hashes pass

Verified with:

sha256sum -c SHA256SUMS

Intended Veeam mode:

file level, snapshot disabled.

E117  Local recovery bundle four checksums pass

Static copy of the manual recovery point, not a new export of live data.

14

### Talking points

Evidence: docs/screenshots/117-20261101-032032.png
Source: /home/germain/odoo-veeam-source. It preserves the earlier manual backup point, not a fresh Odoo export. Official reference: https://helpcenter.veeam.com/docs/agentforlinux/userguide/file_backup_snapshotless.html

## Slide 15

Lessons learned

Application checks

SQL and Odoo UI validate usability.

Hashes validate integrity.

Workspace capacity

Budget temporary workspace and snapshot growth.

Mount topology

Inspect bind mounts before recursive cleanup.

Failure domains

Keep another copy outside the Windows host.

15

### Talking points

See docs/RECOVERY.md and docs/TROUBLESHOOTING.md. I ran a cleanup command without fully checking the bind mounts. It affected firmware and module paths, which I repaired afterward. I kept the incident in my notes because it changed how I check temporary mount points before cleanup.

## Slide 16

Findings and risks

Finding

Risk

Engineering response

24 GB guest root

ISO and snapshot space exhaustion

Provision workspace and snapshot capacity.

Backups on the host

Host loss affects source and copies

Add independent storage and an offsite copy.

Recovery ISO incomplete

Machine recovery remains untested

Create compatible amd64 media and boot-test it.

Veeam closeout open

Restore-point usability unverified

Capture Success and recovered-bundle hashes.

No measured RTO/RPO

Recovery objectives remain unknown

Time a repeatable end-to-end recovery test.

16

### Talking points

Findings summarize the captured lab limitations. Risks describe possible consequences rather than additional observed failures. No numerical RTO/RPO or production recovery guarantee is inferred.

## Slide 17

What I would do next

01  Close Veeam evidence

Successful file backup and recovery to a separate folder.

Exit check: all four recovered-file hashes pass.

02  Expand recovery capacity

Allocate workspace and create amd64 recovery media.

Exit check: media boots and the next test has headroom.

03  Separate backup storage

Add a copy outside the Windows host failure domain.

Exit check: restore from that independent copy.

04  Measure repeatability

Time recovery and record the exact backup timestamp.

Exit check: measured RTO/RPO with a repeatable runbook.

17

### Talking points

Proposed next work, not completed results. A successful backup is insufficient without recovery validation. External output media alone does not provide the guest temporary workspace needed by ISO generation.

## Slide 18

Skills demonstrated

Linux operations

Disk diagnosis, mount inspection and DKMS repair

Container infrastructure

Compose services, health checks and separate volumes

Data recovery

PostgreSQL logical restore and Odoo filestore recovery

Backup integration

Veeam Agent setup and Windows SMB access controls

Engineering judgment

Integrity checks and lessons from the recovery tests

18

### Talking points

Supported by the deployment and recovery guides, SMB screenshots, module rebuild capture and incident record. These are hands-on lab skills, not a production deployment or certification claim.

## Slide 19

Project materials and contact

Manual application recovery verified

Odoo 18, PostgreSQL 16, Ubuntu and Veeam Agent

GitHub portfolio: github.com/Daakpo

Repository: Odoo-Backup-Recovery-Lab

Publication pending GitHub sign-in.

Report: docs/Odoo_Backup_Recovery_Lab_Report.docx

README, technical guides and all 118 screenshots accompany this deck.

LinkedIn: linkedin.com/in/gdamouzou

19

### Talking points

Author: Germain Daakpo Amouzou. The final package contains the report, presentation, public-safe reference configuration and complete stage galleries. GitHub publication has not completed. Do not present the planned repository as a live link.
