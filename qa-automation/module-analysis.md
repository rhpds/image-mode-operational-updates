# Module Analysis for E2E Testing

This document extracts executable commands, expected outcomes, validation points, and dependencies from all 4 lab modules.

---

## Module 01: Introduction to Image Mode Updates

### Host Context
- **Terminal**: Bootc VM (`bootc-vm` via SSH)
- **User**: lab-user (sudo available)

### Executable Commands (in order)
1. `sudo bootc status`
2. `cat /etc/lab-image-version`

### Expected Outcomes
- `bootc status` shows:
  - Booted image reference present
  - No staged image (first boot)
  - No rollback image (first boot)
- `/etc/lab-image-version` contains: `1.0`

### Validation Points
- Confirm `bootc status` returns successfully
- Verify booted image field is populated
- Verify NO staged deployment exists
- Verify NO rollback deployment exists
- Verify version marker file contains exactly `1.0`

### Critical State Changes
- None (read-only inspection)

### Module Dependencies
- None (entry point)

---

## Module 02: Build and Push an Updated Image

### Host Context
- **Terminal**: Build host terminal (`rhel`)
- **User**: lab-user (podman available)
- **Registry**: `registry-{guid}.{domain}`

### Executable Commands (in order)
1. `cat ~/examples/Containerfile`
2. `podman build --file ~/examples/Containerfile --tag registry-{guid}.{domain}/base ~/examples`
3. `podman images | grep base`
4. `podman push registry-{guid}.{domain}/base`

### Expected Outcomes
- Containerfile exists at `~/examples/Containerfile`
- Containerfile shows:
  - Installs `tmux`
  - Updates `/etc/lab-image-version` to `2.0`
  - Ends with `bootc container lint`
- `podman build` completes successfully
- Built image appears in local podman images list
- `podman push` completes successfully
- Image is available in registry at `registry-{guid}.{domain}/base`

### Validation Points
- Verify Containerfile exists and is readable
- Verify `podman build` exits with status 0
- Verify image tagged as `registry-{guid}.{domain}/base` appears in `podman images`
- Verify `podman push` exits with status 0
- (Optional) Verify registry contains the image via registry API or pull test

### Critical State Changes
- New bootc container image built locally
- Image pushed to registry with tag `registry-{guid}.{domain}/base`

### Module Dependencies
- None (independent build step)

---

## Module 03: Configure Automatic Updates

### Host Context
- **Terminal**: Bootc VM (`bootc-vm` via SSH)
- **User**: lab-user (sudo available)

### Executable Commands (in order)

#### Initial inspection
1. `systemctl status bootc-fetch-apply-updates.timer --no-pager`

#### Optional: Configure schedule
2. `sudo mkdir -p /etc/systemd/system/bootc-fetch-apply-updates.timer.d`
3. Create `/etc/systemd/system/bootc-fetch-apply-updates.timer.d/schedule.conf`:
   ```
   [Timer]
   OnCalendar=
   OnCalendar=*-*-* 02:00:00
   RandomizedDelaySec=30m
   ```
4. `sudo systemctl daemon-reload`

#### Enable and trigger update
5. `sudo systemctl enable --now bootc-fetch-apply-updates.timer`
6. `systemctl is-enabled bootc-fetch-apply-updates.timer`
7. `systemctl is-active bootc-fetch-apply-updates.timer`
8. `sudo systemctl start bootc-fetch-apply-updates.service`

#### **CRITICAL: System reboots automatically after service stages the update**

#### Post-reboot verification (reconnect to VM)
9. `sudo bootc status`
10. `cat /etc/lab-image-version`
11. `command -v tmux`

### Expected Outcomes

#### Before enable
- Timer status shows: inactive (dead), disabled

#### After enable
- Timer is-enabled returns: `enabled`
- Timer is-active returns: `active`

#### After service start
- Service fetches image from registry
- Service stages new image (version 2.0)
- **System automatically reboots**

#### After reboot
- `bootc status` shows:
  - Booted image: version 2.0
  - Rollback image: version 1.0 (previous deployment now available)
- `/etc/lab-image-version` contains: `2.0`
- `command -v tmux` returns: `/usr/bin/tmux` (or similar path)

### Validation Points
- Verify timer is disabled initially
- Verify timer becomes enabled after `enable --now`
- Verify timer becomes active after `enable --now`
- Verify service completes without error
- **Verify system reboots** (connection drops, then reconnects)
- After reboot, verify booted image is version 2.0
- After reboot, verify rollback image is version 1.0
- Verify version marker file shows `2.0`
- Verify `tmux` binary exists and is executable

### Critical State Changes
- Timer enabled persistently (survives reboots)
- New image fetched from registry
- New image staged for next boot
- **System reboots** (automatic, triggered by service)
- Bootc deployment switched to version 2.0
- Previous version (1.0) becomes rollback target

### Module Dependencies
- **Requires Module 02 complete**: Image version 2.0 must exist in registry at `registry-{guid}.{domain}/base`

---

## Module 04: Roll Back a Failed Update

### Host Context
- **Terminal**: Bootc VM (`bootc-vm` via SSH)
- **User**: lab-user (sudo available)

### Executable Commands (in order)

#### Pre-rollback inspection
1. `sudo bootc status`

#### Execute rollback
2. `sudo bootc rollback`

#### Verify staged rollback
3. `sudo bootc status`

#### Reboot to apply rollback
4. `sudo systemctl reboot`

#### **CRITICAL: System reboots to activate rollback**

#### Post-reboot verification (reconnect to VM)
5. `sudo bootc status`
6. `cat /etc/lab-image-version`
7. `command -v tmux || echo "tmux is gone — back to version 1.0"`

### Expected Outcomes

#### Before rollback
- `bootc status` shows:
  - Booted image: version 2.0
  - Rollback image: version 1.0

#### After `bootc rollback`
- `bootc status` shows:
  - Booted image: version 2.0 (still current)
  - Staged image: version 1.0 (previous image staged for next boot)

#### After reboot
- `bootc status` shows:
  - Booted image: version 1.0 (now active)
  - Rollback image: version 2.0 (roles swapped)
- `/etc/lab-image-version` contains: `1.0`
- `command -v tmux` returns non-zero (tmux no longer present)

### Validation Points
- Before rollback: verify booted=2.0, rollback=1.0
- After `bootc rollback`: verify staged deployment is 1.0
- Verify `bootc rollback` exits successfully (status 0)
- **Verify system reboots** (connection drops, then reconnects)
- After reboot: verify booted=1.0, rollback=2.0
- Verify version marker file shows `1.0`
- Verify tmux is NOT available (command -v tmux fails)

### Critical State Changes
- Previous deployment (1.0) staged for next boot
- **System reboots** (manual, via systemctl reboot)
- Bootc deployment switched back to version 1.0
- Version 2.0 becomes rollback target (roles swapped)
- Package `tmux` no longer available (was only in 2.0)

### Module Dependencies
- **Requires Module 03 complete**: System must be running version 2.0 with 1.0 available as rollback

---

## Cross-Module Dependencies Summary

```
Module 01 (Inspect)
    ↓
Module 02 (Build) ──→ Registry contains version 2.0
    ↓
Module 03 (Update) ──→ System running version 2.0, rollback=1.0
    ↓
Module 04 (Rollback) ──→ System running version 1.0, rollback=2.0
```

---

## Critical Test Scenarios

### 1. **Reboot Handling**
- Module 03: System reboots automatically after fetch-apply-updates service
- Module 04: System reboots manually via systemctl reboot
- **Test requirement**: E2E tests must handle SSH reconnection after reboot

### 2. **Image Registry Dependency**
- Module 03 depends on Module 02 pushing image to registry
- **Test requirement**: Verify registry contains image before attempting update

### 3. **State Transitions**
- Module 01 → 02: No state change (read-only → build)
- Module 02 → 03: Registry state change (new image available)
- Module 03 → 04: VM state change (running 2.0, rollback 1.0 exists)
- **Test requirement**: Validate expected state before each module

### 4. **Idempotency Concerns**
- Module 03: Timer enable is idempotent
- Module 04: Rollback requires rollback target to exist
- **Test requirement**: Tests should verify prerequisites before executing commands

---

## File Paths Referenced

### Build Host
- `~/examples/Containerfile` — bootc image definition for version 2.0

### Bootc VM
- `/etc/lab-image-version` — version marker (1.0 or 2.0)
- `/usr/bin/tmux` — utility added in version 2.0
- `/etc/systemd/system/bootc-fetch-apply-updates.timer.d/schedule.conf` — optional timer schedule override

---

## Ansible Task Recommendations

### Module 01 Tasks
1. SSH to bootc-vm
2. Run `sudo bootc status`, parse output
3. Assert: booted image exists, no staged, no rollback
4. Read `/etc/lab-image-version`, assert equals `1.0`

### Module 02 Tasks
1. SSH to build host (rhel)
2. Verify `~/examples/Containerfile` exists
3. Run `podman build` with registry tag
4. Assert: build exit code 0
5. Run `podman images | grep base`, assert image exists
6. Run `podman push`
7. Assert: push exit code 0

### Module 03 Tasks
1. SSH to bootc-vm
2. Check timer status, assert inactive
3. Enable timer with `systemctl enable --now`
4. Verify timer is enabled and active
5. Start fetch-apply-updates service
6. **Wait for system reboot** (poll SSH until connection drops, then wait for recovery)
7. Reconnect via SSH
8. Run `bootc status`, assert booted=2.0, rollback=1.0
9. Read `/etc/lab-image-version`, assert equals `2.0`
10. Verify tmux exists with `command -v tmux`

### Module 04 Tasks
1. SSH to bootc-vm
2. Run `sudo bootc status`, assert booted=2.0, rollback=1.0
3. Run `sudo bootc rollback`
4. Assert: rollback exit code 0
5. Run `sudo systemctl reboot`
6. **Wait for system reboot** (poll SSH until connection drops, then wait for recovery)
7. Reconnect via SSH
8. Run `bootc status`, assert booted=1.0, rollback=2.0
9. Read `/etc/lab-image-version`, assert equals `1.0`
10. Verify tmux does NOT exist (command -v tmux fails)
