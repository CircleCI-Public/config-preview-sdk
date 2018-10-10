# CD Techniques

_This is a draft for comment as we continue to develop techniques and features in orb publishing_

## The `circleci/orb-tools` orb

In order to aid you in your CD efforts we have put together an orb-tools orb you can
reference while building your own orb.

The `orb-tools` orb is a shortcut, but not a pre-requisite to orb publishing. 

[comment]: # (TODO [for docs team]: the link below should point to the registry docs once that is live)

Find the full source [here](https://github.com/CircleCI-Public/circleci-orbs/blob/master/src/orb-tools/orb.yml).

> Note: All publishing activity can be conducted directly from the [CircleCI CLI](https://github.com/CircleCI-Public/circleci-cli).

The `orb-tools` orb provides a number of jobs and commands that may be useful to you.

### orb-tools commands:
- `orb-tools/pack` **(experimental)** uses the CLI to pack an orb file structure into a single orb yml.
- `orb-tools/validate` uses the CLI to validate a given orb yml. **[Example usage](#example-usage)**.
- `orb-tools/increment` uses the CLI to increment the version of an orb in the registry. If the orb does not have a version yet it starts at 0.0.0.
- `orb-tools/publish` uses the CLI to publish an orb to the registry.

### orb-tools jobs:
- `orb-tools/pack` **(experimental)** Pack the contents of an orb for publishing.
  - parameters
     - _source-dir_: Path to the root of the orb source directory to be packed. (ie: my-orb/src/)
     - _destination-orb-path_: Path including filename of where the packed orb will be written.
     - _validate_: Boolean for whether or not to do validation on the orb. Default is false.
     - _checkout_: Boolean for whether or not to checkout as a first step. Default is true.
     - _attach-workspace_: Boolean for whether or not to attach to an existing workspace. Default is false.
     - _workspace-root_: Workspace root path that is either an absolute path or a path relative to the working directory. Defaults to '.' (the working directory)
     - _workspace-path_: Path of the workspace to persist to relative to workspace-root. Typically this is the same as the destination-orb-path. If the default value of blank is provided then this job will not persist to a workspace.
     - _artifact-path_: Path to directory that should be saved as a job artifact. If the default value of blank is provided then this job will not save any artifacts.
- `orb-tools/increment` Uses the CLI to increment the version of an orb in the registry. If the orb does not have a version yet it starts at 0.0.0
  - parameters
     - _orb-path_: Path to an orb file.
     - _orb-ref_: A versionless orb-ref in the form <namespace>/<orb-name>
     - _segment_: The semver segment to increment 'major' or 'minor' or 'patch'
     - _publish-token-variable_: The env var containing your token. Pass this as a literal string such as `$ORB_PUBLISHING_TOKEN`. Do not paste the actual token into your configuration. If omitted it's assumed the CLI has already been setup with a valid token.
     - _validate_: Boolean for whether or not to do validation on the orb. Default is false.
     - _checkout_: Boolean for whether or not to checkout as a first step. Default is true.
     - _attach-workspace_: Boolean for whether or not to attach to an existing workspace. Default is false.
     - _workspace-root_: Workspace root path that is either an absolute path or a path relative to the working directory. Defaults to '.' (the working directory)
 - `orb-tools/publish`
   - parameters
     - _orb-path_: Path of the orb file to publish.
     - _orb-ref_: A full orb-ref in the form of <namespace>/<orbname>@<semver>
     - _publish-token-variable_: The env var containing your publish token. Pass this as a literal string such as `$ORB_PUBLISHING_TOKEN`. DO NOT paste the actual token into your configuration. If omitted it's assumed the CLI has already been setup with a valid token.
     - _validate_: Boolean for whether or not to do validation on the orb. Default is false.
     - _checkout_: Boolean for whether or not to checkout as a first step. Default is true.
     - _attach-workspace_: Boolean for whether or not to attach to an existing workspace. Default is false.
     - _workspace-root_: Workspace root path that is either an absolute path or a path relative to the working directory. Defaults to '.' (the working directory)

### Example usage

Below is an example of how to use the orb-tools orb to validate and publish an orb.

```yaml
version: 2.1

orbs:
  orb-tools: circleci/orb-tools@volatile

workflows:
  btd:
    jobs:
      - orb-tools/publish:
          orb-path: src/orb.yml
          orb-ref: circleci/hello-build@dev:${CIRCLE_BRANCH}
          publish-token-variable: "$CIRCLECI_DEV_API_TOKEN"
          validate: true
```

In this example, the `btd` workflow runs the `orb-tools/validate` job first. If the orb is indeed valid, the next step will execute, and `orb-tools/publish-orb` will execute.
