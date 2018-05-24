# Authoring and Using Commands in CircleCI Configuration
Commands are reusable sets of steps that can be invoked with specific parameters inside a job. For instance, `checkout` and `run` are considered built-in commands. You may also author your own commands or use those authored by others.

## Using Commands
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

## Authoring Commands
A command definition is YAML that defines metadata, parameters, and a sequence of steps to be executed when invoking the command.

### Command Syntax
A command can have the following immediate children keys as a map:

- **description:** (optional) A string that describes the purpose of the command, used for generating documenation.
- **parameters:** (optional) A map of parameter keys, each of which adheres to the [parameter](parameters.md) spec.
- **steps:** (required) A sequence of steps run inside the calling job of the command.

### Adding your commands directly in config.yml

Commands are declared under the `commands` key of your `config.yml` file. For instance, to make a command called `sayhello` it might look like:

```yaml
commands:
  sayhello:
    description: "A very simple command for demonstration purposes"
    parameters:
      to:
        type: string
    steps:
      - run: echo << parameters.to >>
```

When invoking a command, the steps of that command are inserted where it's invoked. Commands can only be invoked as part of the sequence under `steps` in a job.

### Adding your commands as separate files
As a convenience, commands can also be broken out into individual files in a folder called `commands`. Each file in that folder will become a command with the name of that file. For instance, in the above example you could take the `sayhello` command and put it in a file called `sayhello.yml` with the following contents:

```
description: "A very simple command for demonstration purposes"
parameters:
  to:
    required: true
steps:
  - run: echo << parameters.to >>
```

When you run a CircleCI build the system will expand all file-based commands in your `.circleci` folder the verbose YAML form seen above before processing. Thus, the two are logically equivalent at execution time.

### Invoking other commands in your command
Commands can use other commands in the scope of execution. For instance, if a command is declared locally inside your `.circleci` folder it can invoke other commands also declared locally. If a command is declared inside an Orb it can use other commands in that orb. We do not yet allow calling commands outside the scope of declaration.

## Built-in Commands

CircleCI has several built-in commands available to all circleci.com customers and available by default in CircleCI server installations. Examples of built-in commands are:

  * `checkout`
  * `setup_remote_docker`
  * `save_to_workspace`

_NOTE: Built-in commands are implicitly in the empty scope and are thus syntactically equivalent to primitives such as `run`). This _may_ change in future versions of configuration but is true to maintain compatibility with version `2` configuration._

## Examples
The following is a command that might appear in an orb called "s3tools" as `s3sync.yml` and, thus, invocable as `s3sync` in a job:

```yaml
description: "A simple encapsultion of doing an s3 sync"
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
workflow:
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

If the same command were declared locally inside config.yml it would end up looking like:

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
jobs:
  deploy2s3:
    steps:
      - s3sync:
          from: .
          to: "s3://mybucket_uri"
          overwrite: true
```

