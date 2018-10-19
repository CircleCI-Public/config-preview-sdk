# Testing orbs
CircleCI is still working on some tooling around testing; however, a few different types of testing you can persform are described below.

In order to run these tests automatically in a build, you will need to install the full circleci cli tool. [TODO: instructions].

You can use shell unit testing frameworks such as [BATS](https://github.com/sstephenson/bats).

## Schema Validation
To test whether an orb is valid YAML and passes a schema, use `circleci orb validate` with the CircleCI CLI.

For example: Given an orb with source at `./src/orb.yml` running either:

- `circleci orb validate ./src/orb.yml` _or_
- `cat ./src/orb.yml | circleci orb validate -`

will either let you know that the orb is valid, or return the first schema violation it encounters.

CircleCI has an early version of an `orb-tools` orb that contains a few handy jobs. You can see the config of an orb that uses `orb-tools` to do rudimentary testing for validity [here](https://github.com/CircleCI-Public/hello-orb/blob/master/.circleci/config.yml). [TODO: this link currently doesn't go to an example of using it to directly validate. Figure out what that example is and if it is worth putting here.]

## Expansion Testing
The next level of testing checks that an orb is expanding to generate the desired final `config.yml` consumed by our system.

This testing is best completed by either publishing the orb as a `dev` version and then using it in your config and processing that config, or by using config packing to make it an inline orb and then processing that. Then you compare it to the expanded state you expect.

[yq](https://github.com/kislyuk/yq) is a useful tool to make assertions about things in yaml, so that you can look at specific elements rather than having fragile tests that depend on every aspect of an expanded job, or ignoring structure when looking for smaller elements.

#### For Example -
Assuming that a valid namespace and orb have already been created with the CLI, perform the following steps:

[TODO: this wouldn't work inside a build. replace this with a similarly detailed example of how to do it with config packing, which can be. Possibly in a different doc file.]

1. start with a simple orb in `src/orb.yml`

```yaml
version: 2.1

executors:
  default:
  	parameters:
    	tag:
      	type: string
        default: "curl-browsers"
      docker:
        - image:  circleci/buildpack-deps:<< parameters.tag >>

jobs:
  hello-build:
  	executor: default
    steps:
    	- run: echo "Hello, build!"
```

2. Validate it with `circleci orb validate src/orb.yml`.

3. Publish a `dev` version with `circleci orb publish src/orb.yml namespace/orb@dev:0.0.1`.

4. Include that orb in `.circleci/config.yml`:

```yaml
version: 2.1

orbs:
  hello: namespace/orb@dev:0.0.1

workflows:
  hello-workflow:
    jobs:
      - hello/hello-build
```

5. After running `circleci config process .circleci/config.yml` the expected result would be:

```yaml
version: 2
jobs:
  hello/hello-build:
    docker:
      - image: circleci/buildpack-deps:curl-browsers
    steps:
      - run:
          command: echo "Hello, build!"
workflows:
  hello-workflow:
    jobs:
      - hello/hello-build
  version: 2

# Original config.yml file:
# version: 2.1
#
# orbs:
#   hello: namespace\/orb@dev:0.0.1
#
# workflows:
#   hello-workflow:
#     jobs:
#       - hello\/hello-build
```

Tooling around expansion testing is something CircleCI is actively working to improve.

## Runtime testing

Runtime testing involves running active builds with orbs. This is somewhat tricky to do, as the jobs in a build can only depend on orbs that are either part of the config or were published when the build started.

One approach is to run jobs within your build's jobs:

* Use the circlecli tool to run local builds within circle builds. This is usually the best because it prints the build output to standard out, which makes it easy to make assertions about. [TODO: detailed example of this, link to it.]

The other main approach is to make the orb entities available to your job's config, which can be done in at least a couple ways. When doing it this way, you can make checks using post-steps for jobs that you run and test, or subsequent steps for commands that you run and test. These can check things like filesystem state, but until we add additional tooling cannot make assertions about the output of the jobs and commands.

1. Use your orb as your config. If you define your testing and publishing jobs in your orb, they will have access to all everything defined in the orb. The downside is that you may need to add extraneous jobs and commands to your orb, and your orb will depend on any orbs that you need for testing and publishing.
2. When you run a build, publish a dev version of the orb, then do an automated push to a branch which uses a config that uses that dev version. This new build can run the tests. The downside here is that the build that does the real testing is not directly tied to its commit.

## Integration testing

Sometimes you will want to test how your orbs interact with external services. Again there are several possible approaches depending on circumstances:

1. Make your orb support a dry-run functionality of whatever it is interacting with, and use that mode in your tests
2. Do real interactions, using a properly set up test account
3. Spin up a local service in another container of your job
