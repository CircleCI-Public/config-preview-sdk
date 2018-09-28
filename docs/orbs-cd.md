# CD Techniques

_Placeholder for more information regarding CD_

## The `circleci/orb-tools` orb:

_Note_: The following documentation is based on updates that need to be made to
the `orb-tools` orb. (Remove this once that has been completed)

In order to aid you in your CD efforts we have put together an orb-tools orb you can
reference while building your own orb.

Find the full source [here](https://github.com/CircleCI-Public/circleci-orbs/blob/master/src/orb-tools/orb.yml)

The `orb-tools` orb provides a number of jobs and commands that may be useful to you.

### orb-tools commands:
- `orb-tools/validate` uses the CLI to validate a given orb yml
- `orb-tools/pack` **(experimental & optional)** uses the CLI to pack an orb file structure into a single orb yml.
- `orb-tools/store-as-artifact` stores an orb as a circleci artifact
- `orb-tools/persist-to-workspace` persists an orb yml between jobs in a workflow
- `orb-tools/publish` publishes an orb to the registry

### orb-tools jobs:
- `orb-tools/validate-orb` uses the CLI to validate a given orb yml
  - parameters:
    - _path_: The path to the orb code to validate that is relative to the root of the repo.
- `orb-tools/pack-and-validate-orb` **(experimental & optional)**
  - parameters:
    - _path_: The root of where the code for the orb lives relative to the root of the repo.
    - _workspace-path_: When provided, save the contents of the orb into the workspace at the given path. The value should include a trailing slash.  Empty string (also the default value) is a no-op.
    - _artifact-path_: When provided, save the contents of the orb as an artifact in the directory specified. The value should include a trailing slash.  Empty string (also the default value) is a no-op."
    - _destination-file-name_: The name of the file where the packed string will be stored.  In most cases you can leave the default value of `orb.yml`.
- `orb-tools/publish-orb`
  - parameters:
    - _namespace_: "The namespace where this should be published."
    - _orb_: "The orb name where this should be published."
    - _version_: "The version to use when publishing the orb. Prefix with `dev:` to publish a dev label"
    - _workspace-path_: "The directory relative to the workspace root where the orb file will be found. Should end in a trailing /"
    - _token-variable_: "The env var containing your token. Pass this as a literal string such as `$ORB_DEV_PUBLISHING_TOKEN`. Do not paste the actual token into your configuration."
    - _file-name_: "The name of the file where the packed string is stored. In most cases you can leave the default value."
    - _do-validation_: "Boolean for whether to do validation. Default is true."


### Example usage

Below is an example of how to use the orb-tools orb to validate and publish an
orb

```yaml
version: 2.1

orbs:
  orb-utils: circleci/orb-tools@volatile
workflows:
  btd:
    jobs:
      - orb-utils/validate-orb:
          path: ./src/                  # path to root orb dir 
      - orb-utils/publish-orb:
          namespace: circleci
          orb: hello-build
          version: dev:${CIRCLE_BRANCH} # remove `dev:` and use a semver to release a production version
          token-variable: "$CIRCLECI_API_TOKEN"
          requires: [validate-orb]
```
