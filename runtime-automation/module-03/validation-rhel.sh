#!/bin/sh
echo "Validating module-03" >> /tmp/progress.log

# Source lab environment
if [ -f /etc/profile.d/lab.sh ]; then
    . /etc/profile.d/lab.sh
fi

# Find SSH key (may not have GUID set)
KEY=$(ls /root/.ssh/*key 2>/dev/null | head -1)
if [ -z "$KEY" ]; then
    echo "FAIL: SSH key not found for accessing bootc VM"
    echo "HINT: Contact lab support - SSH key should exist at /root/.ssh/"
    exit 1
fi

# Check that the bootc-fetch-apply-updates timer is enabled on the guest
if ! ssh -i "$KEY" -o StrictHostKeyChecking=no core@bootc-vm 'systemctl is-enabled bootc-fetch-apply-updates.timer' > /dev/null 2>&1; then
    echo "FAIL: bootc-fetch-apply-updates.timer is not enabled on the bootc VM"
    echo "HINT: Run 'sudo systemctl enable --now bootc-fetch-apply-updates.timer' on the Bootc VM"
    exit 1
fi

# Check that the guest is running version 2.0 (after the update and reboot)
# This validates that the automatic update workflow completed successfully
VERSION=$(ssh -i "$KEY" -o StrictHostKeyChecking=no core@bootc-vm 'cat /etc/lab-image-version 2>/dev/null' | tr -d '\r\n')
if [ "$VERSION" != "2.0" ]; then
    echo "FAIL: Bootc VM is not running version 2.0 (found: '$VERSION')"
    echo "HINT: The update should have been applied after running 'sudo systemctl start bootc-fetch-apply-updates.service' and the automatic reboot. Check 'sudo bootc status' on the Bootc VM."
    exit 1
fi

echo "PASS: module-03 objectives verified" >> /tmp/progress.log
exit 0
