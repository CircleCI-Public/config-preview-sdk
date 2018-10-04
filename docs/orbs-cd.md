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
- `orb-tools/validate` uses the CLI to validate a given orb yml. **[Example usage](#example-usage)**.
- `orb-tools/pack` **(experimental & optional)** uses the CLI to pack an orb file structure into a single orb yml.
- `orb-tools/persist-orb-to-workspace` persists an orb between jobs in a workflow.
- `orb-tools/increment` uses the CLI to increment the version of an orb in the registry. If the orb does not have a version yet it starts at 0.0.0.
- `orb-tools/publish` uses the CLI to publish an orb to the registry.

### orb-tools jobs:
- `orb-tools/validate-orb` uses the CLI to validate a given orb yml.
  - parameters
    - _orb-path_: The path to the orb code to validate that is relative to the root of the repo.
    - _workspace-path_: When provided, save the contents of the orb into the workspace at the given path. The value should include a trailing slash.  Empty string (also the default value) is a no-op.
- `orb-tools/pack-and-validate-orb` **(experimental & optional)** Pack the contents of an orb for publishing and validate the orb is well-formed.
  - parameters
    - _path_: The root of where the code for the orb lives relative to the root of the repo.
    - _workspace-path_: When provided, save the contents of the orb into the workspace at the given path. The value should include a trailing slash.  Empty string (also the default value) is a no-op.
    - _artifact-path_: When provided, save the contents of the orb as an artifact in the directory specified. The value should include a trailing slash.  Empty string (also the default value) is a no-op."
    - _destination-file-name_: The name of the file where the packed string will be stored.  In most cases you can leave the default value of `orb.yml`.
- `orb-tools/increment-orb` Uses the CLI to increment the version of an orb in the registry. If the orb does not have a version yet it starts at 0.0.0
  - parameters
    - _orb-path_: Path to an orb.
    - _namespace_: Namespace the orb lives under.
    - _orb-name_: Name of the orb to increment.
    - _segment_: The semver segment to increment 'major' or 'minor' or 'patch'.
    - _workspace-path_: The directory relative to the workspace root where the orb file will be found. Should end in a trailing `/`.
    - _release-token-variable_: The env var containing your release token. Pass this as a literal string such as `$ORB_PUBLISHING_TOKEN`. Do not paste the actual token into your configuration. If omitted it's assumed the CLI has already been setup with a valid token.
- `orb-tools/publish-dev-orb`
  - parameters
    - _namespace_: The namespace where this should be published.
    - _orb-name_: The orb name where this should be published.
    - _version_: The semver to use when publishing the orb (eg: if you pass `1.2.3`).
    - _release-token-variable_: The env var containing your release token. Pass this as a literal string such as `$ORB_PUBLISHING_TOKEN`. Do not paste the actual token into your configuration. If omitted it's assumed the CLI has already been setup with a valid token.
    - _workspace-path_: The directory relative to the workspace root where the orb file will be found. Should end in a trailing `/`.
    - _file-name_: The name of the file where the packed string is stored. In most cases you can leave the default value.
    - _do-validation_: Boolean for whether to do validation. Default is `true`.
- `orb-tools/publish-release-orb`
  - parameters
    - _namespace_: The namespace where this should be published.
    - _orb-name_: The orb name where this should be published.
    - _label_: The label to use when publishing the dev orb (eg: if you pass `foo` you will publish to `dev:foo`).
    - _dev-token-variable_: The env var containing your dev token. Pass this as a literal string such as `$ORB_DEV_PUBLISHING_TOKEN`. Do not paste the actual token into your configuration. If omitted it's assumed the CLI has already been setup with a valid token.
    - _workspace-path_: The directory relative to the workspace root where the orb file will be found. Should end in a trailing `/`.
    - _file-name_: The name of the file where the packed string is stored. In most cases you can leave the default value.
    - _do-validation_: Boolean for whether to do validation. Default is true.

### Example usage

Below is an example of how to use the orb-tools orb to validate and publish an orb.

```yaml
version: 2.1

orbs:
  orb-tools: circleci/orb-tools@volatile
workflows:
  btd:
    jobs:
      - orb-tools/validate-orb:
          orb-path: ./src/orb.yml
          workspace-path: ./workspace/
      - orb-tools/publish-dev-orb:
          namespace: circleci
          orb-name: hello-build
          label: ${CIRCLE_BRANCH}
          dev-token-variable: "$CIRCLECI_DEV_API_TOKEN"
          workspace-path: ./workspace/
          requires: [validate-orb]
```
In this example, the `btd` workflow runs the `orb-tools/validate-orb` job first. If the orb is indeed valid, the next step will execute, and `orb-tools/publish-dev-orb` will execute.

Note that, because the compiled code is run through CircleCI's workflow conductor, `orb-tools/publish-dev-orb` _requires_ `validate-orb`, instead of `orb-tools/validate-orb`.
