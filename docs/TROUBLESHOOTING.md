# Troubleshooting and lessons learned

[Project overview](../README.md) · [Evidence index](EVIDENCE.md)

## Incident record

| Issue | Evidence | Resolution or current state |
|---|---|---|
| Ubuntu root full and desktop unavailable | Disk and directory investigation | Targeted cleanup restored space and the desktop |
| Too little guest memory | Memory inspection | VM allocation increased to 4 GB |
| Backup exit trap could not find Compose file | Backup output ends with configuration-file error | Returned to source project and restarted Odoo |
| Recovery loopback port unavailable | Curl refused on 8070 | Reached the recovery container directly from Ubuntu |
| Recovery media workspace exhausted root space | ISO write fails, temporary workspace about 4.8 GB | ISO remained incomplete |
| Temporary cleanup crossed bind mounts | Busy mount errors and missing modules | Unmounted affected paths and repaired packages / DKMS |
| Veeam full-machine backup stalled | 8% progress, snapshot low-space log, root 99% | Forced stop, session Failed, space partly recovered |
| Shared-folder copy denied | cp permission error | Elevated copy, then ownership changed on local destination |

## Bind-mount cleanup incident

During failed recovery-media preparation, Veeam left temporary bind mounts pointing into the guest's firmware and current-kernel module directories. An unsafe cleanup command used recursive deletion with `--one-file-system`. Because bind mounts can reference the same filesystem, that option did not prevent traversal into the mounted host directories.

I ran the cleanup command without fully checking the temporary bind mounts. That was a mistake: `--one-file-system` did not protect directories mounted from the same filesystem. I kept the screenshots to show what went wrong and why I changed my cleanup approach.

I unmounted the affected temporary bind paths, reinstalled the firmware and kernel-module packages, checked package integrity, and rebuilt the Veeam modules after restoring the current kernel headers. Final `modinfo` output confirmed the Veeam modules existed again. These checks do not constitute a documented reboot or complete host integrity attestation.

Operational lesson: inspect mount topology and use application-managed cleanup before deleting a temporary directory. Directory names and a filesystem-boundary flag do not establish that recursive deletion is safe.

## Snapshot storage pressure

The guest had a 24 GB root filesystem, Docker images and application data. The full-machine job also needed snapshot storage on root. The visible `Target` bottleneck and stalled percentage did not by themselves explain the incident. The low-space snapshot log and matching root capacity readings provided additional evidence.

The smaller recovery-bundle workflow reduces scope and avoids a snapshot for static exported files. A future full-machine test needs adequate guest capacity, working recovery media and explicit restore validation.

## Evidence discipline

- A repository marked accessible proves connectivity and access, not recoverability.
- A job in Running state does not prove successful completion.
- A System session marked Success is not necessarily an Odoo backup session.
- Hash checks detect a mismatch against the recorded manifest, not whether a database is logically correct.
- A working restored application proves more than an archive listing alone.
- Source and recovery browser addresses should remain visible during future validation captures.

## Next improvements

Capture final Veeam success and recovered-file checks, measure recovery timing, provide independent backup storage, complete an amd64 recovery-media exercise, and test the procedure after a planned restart. Pin image digests for a future repeatable environment and add a separately reviewed persistent Odoo management configuration.
