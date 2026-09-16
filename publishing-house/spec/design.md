# Managing Updates for RHEL Image Mode Hosts

## Overview

RHEL image mode delivers the operating system as a bootc container image, so
updating a host means building a new image, pushing it to a registry, and letting
the host pull and apply it — with a clean rollback path if something goes wrong.
This lab teaches that operational update lifecycle end to end.

Participants start with a running bootc host and the infrastructure to build and
publish images. They will build an updated bootc image and push it to a registry,
configure the host to fetch and apply updates automatically via the
`bootc-fetch-apply-updates` systemd timer, and roll the host back to its previous
image after a problematic update.

## Target Audience

- **Role:** RHEL system administrators and platform operators
- **Experience level:** Intermediate
- **What they already know:** RHEL command line, systemd units and timers, and
  basic container/Podman concepts
- **What they don't know:** How image mode (bootc) changes the update workflow —
  building and publishing OS images, automatic update delivery, and image-based
  rollback

## Prerequisites

- Comfort with the RHEL command line and `sudo`
- Basic understanding of systemd services and timers
- Basic familiarity with container images and registries
- No prior image mode / bootc experience required

<!-- Prerequisites are assumed knowledge, verified by trust — the lab does not run an automated skills check. -->

## Learning Objectives

1. Build an updated bootc image and push it to a container registry
2. Configure automatic updates on a bootc host using the `bootc-fetch-apply-updates` systemd timer
3. Troubleshoot a failed update by rolling a bootc host back to its previous image

## Content Type

Lab (hands-on)

## Products & Technologies

- Red Hat Enterprise Linux (image mode / bootc)
- Podman (container build and push)

Upstream project: bootc

## Module Map

| Module | Title | Duration |
|--------|-------|----------|
| 1 | Introduction to Image Mode Updates | ~3 min |
| 2 | Build and Push an Updated Image | ~6 min |
| 3 | Configure Automatic Updates | ~6 min |
| 4 | Roll Back a Failed Update | ~5 min |
| — | **Total hands-on** | **~17 min** |
| — | Intro / presentation | ~3 min |
| — | **Total lab** | **~20 min** |

## Difficulty Level

Intermediate

## Environment

**Learner view:** A single RHEL package mode host that runs nested
virtualization. Inside it runs the RHEL image mode (bootc) host as a guest VM —
this is the host the learner updates and rolls back. A local container registry
also runs on the package mode host and is the target for pushed images, so the
update loop is fully self-contained. The build tooling (a Containerfile and
Podman) is present, and the learner works from the terminal.

**Automation needed:** Yes

Setup automation must provision the RHEL package mode host, enable nested
virtualization, stand up the local container registry, create and boot the bootc
guest VM from a base bootc image, place the Containerfile and supporting build
files, ensure Podman and registry credentials are ready, and confirm the bootc
guest is booted and reporting its current image via `bootc status`.

## Infrastructure Requirements

- **Platform:** RHEL VMs
- **Cloud provider:** CNV (nested virtualization required — infra review to confirm a nested-virt-capable base CI, or a bare-metal/Troshka flavor if that matches prior image mode labs)
- **Topology:** Per-student
- **Sizing:** 1 RHEL package mode host per student — 8 vCPU, 32 GB RAM, 150 GB disk. Runs nested virtualization: the bootc host runs as a guest VM, and the local container registry runs on the same host. Sized for the nested guest, registry, and multiple bootc image versions.
- **Automation approach:** Ansible
- **AI/MaaS:** None
- **External services:** `registry.redhat.io` (base bootc image), `cdn.redhat.com` (RHEL package repos for build-time RPM layering). The update registry is local to the host, so no external push egress is required.
- **AAP version:** N/A (AAP not used)
- **Non-GA products:** None (RHEL image mode is GA)

## Assessment Strategy (Optional)

This is a Zero-Touch guided lab, so each hands-on module ships with a validate
button backed by a verification script:

- **Module 2:** Verify the updated image was built and successfully pushed to the registry.
- **Module 3:** Verify the `bootc-fetch-apply-updates.timer` is enabled and active.
- **Module 4:** Verify the host has rolled back to the previous image (`bootc status` reports the prior deployment as booted).

Module 1 is introductory and has no validation.
