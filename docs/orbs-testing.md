# Testing orbs
Testing orbs can be done at a few different levels. Choosing how much testing you want to do will depend on the complexity and scope of the audience for your orb.

In all cases, we recommend you make use of the CircleCI CLI to validate your orb locally and/or automate testing in a build. For installation instructions for the CLI [see the CLI documentation](https://circleci.com/docs/2.0/local-cli/)

For advanced testing, you may also want to use a shell unit testing framework such as [BATS](https://github.com/sstephenson/bats).

You can think of orb testing at 4 levels, in increasing levels of complexity and scope.

1. **Schema Validation** - this can be done with a single CLI command and checks if the orb is well-formed YAML and conforms to the orb schema.
2. **Expansion Testing** - this can be done by scripting the CircleCI CLI and tests whether the elements of the orb generate the configuration you intended when processing configuration containing those elements.
3. **Runtime Testing** - this requires setting up separate tests and running them inside a CircleCI build.
4. **Integration Testing** - this is likely only needed for fairly advanced orbs or orbs designed specifically as public, stable interfaces to 3rd-party services. Doing orb integration tests requires a custom build and your own external testing environments for whatever systems you are integration with.

Below are further details and suggested techniques for each level of orb testing.

## Schema Validation
To test whether an orb is valid YAML and is well-formed according to the schema, use `circleci orb validate` with the CircleCI CLI.

For example: Given an orb with source at `./src/orb.yml` you can run `circleci orb validate ./src/orb.yml` to get feedback on whether the orb is valid and will pass through config processing. If there is an error you will receive the first schema validation error encountered. Alternatively, you can pass STDIN rather than a file path. For instance, equivalent to the previous example you can run `cat ./src/orb.yml | circleci orb validate -`. Note that schema errors are often best read "inside out", where your coding error may be best described in one of the inner-most errors in a stack of errors.

Validation testing can also be run inside a build using the CircleCI CLI. You can directly use the `circleci/circleci-cli` orb to get the CLI into your builds, or use the `circleci/orb-tools` orb that contains a few handy commands jobs, including doing schema validation by default in its jobs. An example of an orb that uses `orb-tools` to do basic publishing is the ["hello-build" orb](https://github.com/CircleCI-Public/hello-orb/blob/master/.circleci/config.yml).

## Expansion Testing
The next level of testing checks that an orb is expanding to generate the desired final `config.yml` consumed by our system.

This testing is best completed by either publishing the orb as a `dev` version and then using it in your config and processing that config, or by using config packing to make it an inline orb and then processing that. Then you can use `circleci config process` and compare it to the expanded state you expect. You can also use.

Another form of expansion testing can be done on the orb, itself, when your orb references other orbs. You can use `circleci orb process` to resolve the orbs dependent orbs and see how it would be expanded when you publish it to the registry.

Keep in mind that when testing expansion it's best to test the underlying structure of the data rather than the literal string that's expanded. A useful tool to make assertions about things in yaml is [yq](https://github.com/kislyuk/yq). It allows you to inspect specific structural elements rather than having fragile tests that depend on string comparisons or every aspect of an expanded job.

The following steps illustrate doing basic expansion testing from the CLI:

1. Assume a simple orb in `src/orb.yml`

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
#   hello: namespace/orb@dev:0.0.1
#
# workflows:
#   hello-workflow:
#     jobs:
#       - hello/hello-build
```
The above result can now be used in a custom script that tests for its structure relative to what's expected. This form of testing is useful for ensuring you don't break any contracts your orb interface has established with users of the orb and allows testing different parameter inputs and how they impact what's generated during config processing.

## Runtime Testing
Runtime testing involves running active builds with orbs. Because the jobs in a build can only depend on orbs that are either part of the config or were published when the build started, this technique requires some special planning.

One approach is to run jobs within your build's jobs by using the `circleci` CLI to run local builds using `circleci local execute` on a `machine` executor within your builds. This allows you to print the build output to STDOUT, so you can make assertions about it. This approach can be limiting because local builds don't support workflows and have other caveats, but it also is powerful if you need to test the actual running output of a build using your orb elements. For an example of using this technique see [https://github.com/CircleCI-Public/artifactory-orb](https://github.com/CircleCI-Public/artifactory-orb).

The other main approach to runtime testing is to make the orb entities available to your job's config directly.

One option is to make checks using [post-steps](pre-and-post-steps.md) for jobs that you run and test, or subsequent steps for commands that you run and test. These can check things like filesystem state, but cannot make assertions about the output of the jobs and commands (NOTE: we are working to improve this limitation and welcome feedback on your ideal mechanism for testing orbs).

Another approach is to use your orb source as your `config.yml`. If you define your testing and publishing jobs in your orb, they will have access to  everything defined in the orb. The downside is that you may need to add extraneous jobs and commands to your orb, and your orb will depend on any orbs that you need for testing and publishing.

Yet another approach is when you run a build, publish a dev version of the orb, then do an automated push to a branch which uses a config that uses that dev version. This new build can run the tests. The downside here is that the build that does the real testing is not directly tied to its commit, and you end up with multiple jobs every time you want to change your orb.

## Integration Testing
Sometimes you will want to test how your orbs interact with external services. There are several possible approaches depending on circumstances:

1. Make your orb support a dry-run functionality of whatever it is interacting with, and use that mode in your tests
2. Do real interactions, using a properly set up test account and a separate repository that runs those tests using a published dev version of your orb.
3. Spin up a local service in another container of your job

