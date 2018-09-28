# Testing orbs
We are still working on some tooling around this, but here are a few 
forms of testing you might want to consider.

## Schema Validation
To test that an orb is valid yaml and passes a schema use `circleci orb validate` with our
CLI.

For example. Given an orb with source at `./src/orb.yml` running either:

- `circleci orb validate ./src/orb.yml` _or_
- `cat ./src/orb.yml | circleci orb validate -`

Will either let you know that the orb is valid, or return the first schema
violation it encounters.

We have an early version of an `orb-tools` orb that has a couple handy jobs. You 
can see the config of an orb that uses `orb-tools` to do rudimentary testing for 
validity [here](https://github.com/CircleCI-Public/hello-orb/blob/master/.circleci/config.yml)

## Expansion Testing
The next level of testing checks that an orb is expanding to generate the desired
final `config.yml` consumed by our system.

This is best done either by publishing the orb as a `dev`
version and then using it in your config and processing that config, or 
developing it as an inline orb and then processing that and comparing it the 
expanded state you expect.

#### For Example -
Assuming that a valid namespace and orb have already been created with the CLI.

Start with a simple orb in `src/orb.yml`
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

Validate it with `circleci orb validate src/orb.yml`
Publish a `dev` version with `circleci orb publish src/orb.yml namespace/orb@dev:0.0.1`

Then by including that orb in `.circleci/config.yml`
```yaml
version: 2.1

orbs:
  hello: namespace/orb@dev:0.0.1

workflows:
  hello-workflow:
    jobs:
      - hello/hello-build
```

After running `circleci config process .circleci/config.yml` the expected result would be
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

Tooling around expansion testing is something we're actively working to improve.

## Integration testing

This would involve running active builds with orbs. Today the only ways we have
to do that are to either develop the orb inline in a build that uses it and run 
that build, or publish the orb in one place (either from your CLI or in a 
separate build) and then have another project that uses that published orb.

For instance, you might have a repo with your orb that has a build which publishes 
it to `dev:${CIRCLE_BRANCH}` and then a separate project that pulls in your orb 
as `yournamespace/yourorb@dev:master` (assuming you pull in your master branch 
for testing) and runs whatever runtime tests you like, then if all of those go 
well you could either publish a production version of the orb manually from your 
CLI or automate that in the build.
