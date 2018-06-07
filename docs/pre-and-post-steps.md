# Pre and Post Steps

All jobs accept two special arguments of type `steps`: `pre-steps` and 
`post-steps`. If an orb user invokes a job with one or both of these arguments,
the job will run the steps in `pre-steps` first, before any other steps run, and
run the steps in `post-steps` last, after any other steps run.

## Motivation

Pre- and post- steps allows an orb user to run commands before or after a job 
runs, in the same environment, without needing to modify the orb directly.

While an orb author *may* declare and use a `steps` parameter for this purpose, 
in cases where they do not, a user should still be able to execute steps in the 
job's environment without modifying the orb. For example, an orb user might 
wish to upload assets after the job is complete, or run some custom setup steps 
before job execution.

## Example of using pre- and post-steps

An orb `foo` might define a job:

```
# orb.yml for orb `foo`
jobs:
  bar:
    executor: some-executor
    steps:
      - checkout
      - build
      - test
```

Then an orb user could use the job as follows:
```
# config.yml
version: 2
workflows:
  version: 2
  build:
    jobs:
      - foo/bar:
          pre-steps:
            - install-custom-dependency
          post-steps:
            - upload-artifact
```

The resulting configuration would look like this:

```
version: 2
jobs:
  bar:
    executor: some-executor
    steps:
      - install-custom-dependency
      - checkout
      - build
      - test
      - upload-artifact
workflows:
  version: 2
  build:
    jobs:
      - foo/bar

```

