#!/bin/sh
echo "Validating module-04" >> /tmp/progress.log

# Source lab environment
if [ -f /etc/profile.d/lab.sh ]; then
    . /etc/profile.d/lab.sh
fi

# Find SSH key
KEY=$(ls /root/.ssh/*key 2>/dev/null | head -1)
if [ -z "$KEY" ]; then
    echo "FAIL: SSH key not found for accessing bootc VM"
    echo "HINT: Contact lab support - SSH key should exist at /root/.ssh/"
    exit 1
fi

# Check that the guest is back on version 1.0 (after rollback and reboot)
# This validates that the rollback workflow completed successfully
VERSION=$(ssh -i "$KEY" -o StrictHostKeyChecking=no core@bootc-vm 'cat /etc/lab-image-version 2>/dev/null' | tr -d '\r\n')
if [ "$VERSION" != "1.0" ]; then
    echo "FAIL: Bootc VM is not running version 1.0 after rollback (found: '$VERSION')"
    echo "HINT: Run 'sudo bootc rollback' then 'sudo systemctl reboot' on the Bootc VM to roll back to the previous image"
    exit 1
fi

echo "PASS: module-04 objectives verified" >> /tmp/progress.log
exit 0
