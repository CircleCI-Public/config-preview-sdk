# Authoring and using commands in CircleCI configuration
_The `commands` stanza is available in configuration version 2.1 and later_

Commands are reusable sets of steps that can be invoked with specific parameters inside a job. For instance, `checkout` and `run` are considered built-in commands. You may also author your own commands or use those authored by others.

## Using commands
Commands can be invoked as steps in a job. For instance, to invoke the command `sayhello`, passing it a parameter `to` you would write:

```yaml
jobs:
  myjob:
    docker:
      - image: "circleci/node:9.6.1"
    steps:
      - sayhello:
          to: "Lev"
```

## Authoring commands
A command definition is YAML that defines metadata, parameters, and a sequence of steps to be executed when invoking the command.

### Command syntax
A command can have the following immediate children keys as a map:

- **description:** (optional) A string that describes the purpose of the command, used for generating documentation.
- **parameters:** (optional) A map of parameter keys, each of which adheres to the [parameter](parameters.md) spec.
- **steps:** (required) A sequence of steps run inside the calling job of the command.

### Defining your commands

Commands are declared under the `commands` key of a `config.yml` or `orb.yml` file. For instance, to make a command called `sayhello` it might look like:

```yaml
commands:
  sayhello:
    description: "A very simple command for demonstration purposes"
    parameters:
      to:
        type: string
        default: "Hello World"
    steps:
      - run: echo << parameters.to >>
```

When invoking a command, the steps of that command are inserted where it's invoked. Commands can only be invoked as part of the sequence under `steps` in a job.

### Invoking other commands in your command
Commands can use other commands in the scope of execution. For instance, if a command is declared inside your Orb it can use other commands in that orb. It can also use commands defined in other orbs that you have imported (e.g. `some-orb/some-command`).

## Built-in commands

CircleCI has several built-in commands available to all circleci.com customers and available by default in CircleCI server installations. Examples of built-in commands are:

  * `checkout`
  * `setup_remote_docker`
  * `save_to_workspace`

> NOTE: Built-in commands are implicitly in the empty scope and are thus syntactically equivalent to primitives such as `run`). This _may_ change in future versions of configuration but is true to maintain compatibility with version `2` configuration.

## Examples

The following is a an example of part of an "s3tools" orb defining a command called "s3sync":

```yaml
# s3tools orb
commands:
  s3sync:
    description: "A simple encapsulation of doing an s3 sync"
    parameters:
      from:
        type: string
      to:
        type: string
      overwrite:
        default: false
        type: boolean
    steps:
      - run:
          name: Deploy to S3
          command: aws s3 sync << parameters.from >> << parameters.to >><<# parameters.overwrite >> --delete<</ parameters.overwrite >>"
```

The above could be invoked in `config.yml` as:

```yaml
version: 2

orbs:
  s3tools: circleci/s3@1

workflows:
  version: 2
  build-test-deploy:
    jobs:
      - deploy2s3:
        steps:
          - s3tools/s3sync:
              from: .
              to: "s3://mybucket_uri"
              overwrite: true
```

If the same command were declared locally inside `config.yml` it would look something like:

```yaml
commands:
  s3sync:
    parameters:
      from:
        type: string
      to:
        type: string
      overwrite:
        default: false
        type: boolean
    steps:
      - run:
          name: Deploy to S3
          command: "aws s3 sync << parameters.from >> << parameters.to >><<# parameters.overwrite >> --delete<</ parameters.overwrite >>"
executors:
  aws:
    docker:
      - image: cibuilds/aws:1.15
jobs:
  deploy2s3:
    executor: aws
    steps:
      - s3sync:
          from: .
          to: "s3://mybucket_uri"
          overwrite: true
```

