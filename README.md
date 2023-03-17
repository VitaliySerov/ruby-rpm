[![CircleCI](https://circleci.com/gh/feedforce/ruby-rpm.svg?style=shield)](https://circleci.com/gh/feedforce/ruby-rpm)

# What is this spec?

Forked from hansode's ruby-2.1.x-rpm project at https://github.com/hansode/ruby-2.1.x-rpm and updated for 2.2.2.

# build SRPM and RPM

It's Simple.

1. Create your feature branch named `ruby-{major}.{minor}.{patch}` (e.g ruby-2.2.4)
2. Edit `ruby-{major}.{minor}.spec`
    - Change value of `Version`
    - Add Changelog
3. Push to the branch.
4. Create a Pull request.
5. When the Pull request is merged, CircleCI will release ruby rpms to https://github.com/feedforce/ruby-rpm/releases .

## Automation

We create a Pull Request automatically using CircleCI.

# About Docker Image

This project uses Docker to build RPMs.

The Docker images are hosted at [GitHub Container Registry (ghcr.io)](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry).

- For CentOS 7: `ghcr.io/feedforce/ruby-rpm:centos7`

## How to build and push Docker image

Build and push Docker image to ghcr.io from GitHub Actions.

### Manually

Currently, only manual execution using the workflow_dispatch event is supported.

1. Open https://github.com/feedforce/ruby-rpm/actions/workflows/push-docker-image.yml
1. Run workflow with master branch
1. Wait until workflow succeededs
1. Open https://github.com/feedforce/ruby-rpm/pkgs/container/ruby-rpm
1. Check that a new image has been pushed
