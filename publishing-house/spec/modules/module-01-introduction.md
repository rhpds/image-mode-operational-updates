# Module Outline: Introduction to Image Mode Updates

## Brief Overview

RHEL image mode delivers the operating system as a bootc container image, which
changes how a host is updated: instead of patching packages in place, you build a
new image, push it to a registry, and let the host pull and apply it — with a
clean rollback path if something goes wrong. This introductory module sets the
context for the lab, explaining the operational update lifecycle end to end. It
orients participants to the running bootc host and the build-and-publish
infrastructure they will use in the hands-on modules that follow. No changes are
made to the system in this module.

## Audience and Time

- **Personas:** RHEL system administrators and platform operators (intermediate).
- **Prerequisites:** Comfort with the RHEL command line and `sudo`; basic
  understanding of systemd services and timers; basic familiarity with container
  images and registries. No prior image mode / bootc experience required.
- **Estimated duration:** ~3 minutes.

## Learning Objectives

- Describe how the image mode (bootc) update workflow differs from traditional
  in-place package updates.
- Identify the three stages of the operational update lifecycle covered by this
  lab: build and push an updated image, configure automatic updates, and roll
  back a failed update.
- Recognize the lab environment: a running bootc host with build tooling
  (Containerfile and Podman) and registry access.

## Lab Structure

| Section | Title | Duration |
|---------|-------|----------|
| 1 | How image mode changes the update workflow | 1 min |
| 2 | The operational update lifecycle at a glance | 1 min |
| 3 | Your lab environment | 1 min |

## Detailed Steps

1. Read the overview of RHEL image mode: the OS is delivered as a bootc container
   image rather than as individually managed packages.
2. Understand how updating a host means building a new image, pushing it to a
   registry, and letting the host pull and apply it.
3. Review the three hands-on stages ahead: building and pushing an updated image,
   configuring automatic updates via the `bootc-fetch-apply-updates` systemd
   timer, and rolling back after a problematic update.
4. Tour the lab environment: a single running RHEL image mode host, provisioned
   from a base bootc image, with a Containerfile and Podman present and registry
   access available.
5. Inspect the host's current image with `bootc status` to confirm which
   deployment is booted before making any changes.

## Key Takeaways

- Image mode delivers RHEL as a bootc container image; updates are image-based,
  not package-based.
- The update lifecycle is: build a new image, push it to a registry, pull and
  apply it on the host, and roll back if needed.
- The lab host already includes the tooling (Containerfile, Podman) and registry
  access needed for the hands-on modules.

## Infrastructure Notes

This module is introductory and has no validation button or verification script.
The host should be booted and reporting its current image via `bootc status`
before the learner begins.
