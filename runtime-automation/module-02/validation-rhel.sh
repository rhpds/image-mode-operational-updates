#!/bin/sh
echo "Validating module-02" >> /tmp/progress.log

# Source lab environment (GUID/DOMAIN may not be set in non-login shell)
if [ -f /etc/profile.d/lab.sh ]; then
    . /etc/profile.d/lab.sh
fi

# Verify the updated image was pushed to the registry
# The participant should have built and pushed registry-${GUID}.${DOMAIN}/base
IMAGE_REF="registry-${GUID}.${DOMAIN}/base"

# Use skopeo to check if the image exists in the registry (any response means it's there)
if ! skopeo inspect --no-tags docker://${IMAGE_REF} > /dev/null 2>&1; then
    echo "FAIL: Updated image not found in registry at ${IMAGE_REF}"
    echo "HINT: Build and push the image with 'podman build --file ~/examples/Containerfile --tag ${IMAGE_REF} ~/examples' then 'podman push ${IMAGE_REF}'"
    exit 1
fi

echo "PASS: module-02 objectives verified" >> /tmp/progress.log
exit 0
