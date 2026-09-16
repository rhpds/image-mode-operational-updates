# Module Outline: Configure Automatic Updates

## Brief Overview

Once an updated image is published to a registry, a bootc host can be configured
to pull and apply updates on its own. In this module participants enable and
observe the `bootc-fetch-apply-updates` systemd timer, which periodically fetches
the latest image and applies it to the host. This is the second stage of the
operational update lifecycle: automated delivery of the image built in Module 2.
The module ends with a validate button that confirms the timer is enabled and
active.

## Audience and Time

- **Personas:** RHEL system administrators and platform operators (intermediate).
- **Prerequisites:** Basic understanding of systemd services and timers;
  completion of Module 2 (an updated image published to the registry).
- **Estimated duration:** ~6 minutes.

## Learning Objectives

- Configure automatic updates on a bootc host using the
  `bootc-fetch-apply-updates` systemd timer.
- Observe the timer fetching and applying the updated image.

## Lab Structure

| Section | Title | Duration |
|---------|-------|----------|
| 1 | Understand the bootc-fetch-apply-updates timer | 2 min |
| 2 | Enable and start the timer | 2 min |
| 3 | Observe the update being fetched and applied | 2 min |

## Detailed Steps

1. Review how the `bootc-fetch-apply-updates` systemd timer periodically fetches
   the latest image from the registry and applies it to the host.
2. Inspect the current timer state with `systemctl status
   bootc-fetch-apply-updates.timer`.
3. Enable and start the timer so updates are applied automatically
   (`systemctl enable --now bootc-fetch-apply-updates.timer`).
4. Confirm the timer is enabled and active.
5. Trigger or wait for the associated service to run and observe it fetching and
   applying the updated image published in Module 2.
6. Verify the host has staged/applied the new image with `bootc status`.
7. Use the validate button to verify the
   `bootc-fetch-apply-updates.timer` is enabled and active.

## Key Takeaways

- Bootc hosts can pull and apply updates automatically via the
  `bootc-fetch-apply-updates` systemd timer.
- Enabling the timer turns image delivery into a hands-off, scheduled operation.
- `bootc status` reflects the image the host has fetched and applied.

## Infrastructure Notes

Depends on Module 2 having pushed an updated image to the registry. The
validation script verifies that the `bootc-fetch-apply-updates.timer` is enabled
and active.
