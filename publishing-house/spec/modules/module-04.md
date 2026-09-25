# Module Outline: Roll Back a Failed Update

## Brief Overview

Image-based updates come with a built-in safety net: if a new image causes
problems, the host can boot back into its previous image. In this module
participants respond to a problematic update by rolling the bootc host back to its
previous image using `bootc rollback`. This is the final stage of the operational
update lifecycle and demonstrates how image mode makes recovery predictable. The
module ends with a validate button that confirms the host has returned to the
previous deployment.

## Audience and Time

- **Personas:** RHEL system administrators and platform operators (intermediate).
- **Prerequisites:** Completion of Modules 2 and 3 (an updated image built,
  pushed, and applied to the host); comfort with the RHEL command line and
  `sudo`.
- **Estimated duration:** ~5 minutes.

## Learning Objectives

- Troubleshoot a failed update by rolling a bootc host back to its previous
  image.
- Verify that the host has returned to the prior deployment after rollback.

## Lab Structure

| Section | Title | Duration |
|---------|-------|----------|
| 1 | Identify the failed update | 2 min |
| 2 | Roll back to the previous image | 2 min |
| 3 | Verify the rollback | 1 min |

## Detailed Steps

1. Observe symptoms of a problematic update on the host and inspect the current
   and previous deployments with `bootc status`.
2. Identify the previous (known-good) image that the host can return to.
3. Roll the host back to its previous image with `bootc rollback`.
4. Reboot if required so the host boots into the previous deployment.
5. Confirm with `bootc status` that the prior deployment is now the booted image.
6. Use the validate button to verify the host has rolled back to the previous
   image (`bootc status` reports the prior deployment as booted).

## Key Takeaways

- Image mode provides a reliable rollback path: the previous image remains
  available to boot into.
- `bootc rollback` returns the host to its prior deployment, making recovery from
  a bad update predictable.
- `bootc status` confirms which deployment is booted, before and after rollback.

## Infrastructure Notes

Depends on Modules 2 and 3 having built, pushed, and applied an updated image so
a previous deployment exists to roll back to. The validation script verifies that
`bootc status` reports the prior deployment as the booted image.
