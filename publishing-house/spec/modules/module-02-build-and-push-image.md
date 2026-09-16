# Module Outline: Build and Push an Updated Image

## Brief Overview

In image mode, updating a host begins with producing a new OS image. In this
module participants build an updated bootc image from the provided Containerfile
using Podman, then push the resulting image to a container registry so the host
can later pull and apply it. This is the first stage of the operational update
lifecycle and establishes the image that subsequent modules will deliver and roll
back. The module ends with a validate button that confirms the image was built
and successfully pushed.

## Audience and Time

- **Personas:** RHEL system administrators and platform operators (intermediate).
- **Prerequisites:** Basic familiarity with container images and registries and
  with Podman; completion of Module 1 for context.
- **Estimated duration:** ~6 minutes.

## Learning Objectives

- Build an updated bootc image from a Containerfile using Podman.
- Push the updated bootc image to a container registry.

## Lab Structure

| Section | Title | Duration |
|---------|-------|----------|
| 1 | Review the Containerfile and current image | 2 min |
| 2 | Build the updated bootc image with Podman | 2 min |
| 3 | Push the image to the registry | 2 min |

## Detailed Steps

1. From the host terminal, review the provided Containerfile that defines the
   updated bootc image.
2. Confirm the host's current image with `bootc status`.
3. Build the updated bootc image with Podman (`podman build`), tagging it for the
   target registry.
4. Verify the built image is present locally (`podman images`).
5. Push the updated image to the container registry (`podman push`).
6. Confirm the push succeeded and the image is available in the registry.
7. Use the validate button to verify the updated image was built and successfully
   pushed.

## Key Takeaways

- Updating an image mode host starts by building a new bootc image, not by
  patching packages in place.
- Podman builds and pushes bootc images just like any other container image.
- The registry is the delivery mechanism: an image must be pushed there before a
  host can pull and apply it.

## Infrastructure Notes

Podman and registry credentials must be present and ready on the host. The
validation script verifies that the updated image was built and successfully
pushed to the registry.
