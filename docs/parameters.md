# Using parameters in CircleCI configuration elements
Many config elements can be authored to be invocable in your `config.yml` file with specified parameters. Parameters are declared by name as the keys in a map that are all immediate children of the `parameters` key under a job, command, or executor. For instance, the following shows declaring a parameter `foo` in the definition of a command:

```yaml
command:
  parameters:
    foo:
      description: this parameter is used for a thing
      default: "I'm a default value"
      type: string

  steps:
  - echo '<< parameters.foo >>'
```

In the above example a value for the parameter `foo` can be passed when invoking the command. For instance, if the above job were in a command called `bar` passing the parameter `foo` would look something like:

```yaml
jobs:
  myjob:
    docker:
      - image: circleci/ruby:2.4-node
    steps:
      - bar:
          foo: "I'm the passed value"
```

## Parameter syntax
A parameter can have the following keys as immediate children:

| Key Name    | Description                                                                                   | Default value |
|-------------|-----------------------------------------------------------------------------------------------|---------------|
| description | Optional. Used to generate documentation for your orb.                                        | N/A           |
| type        | Required. Currently "string", "boolean", and "steps". are supported                           | N/A           |
| default     | The default value for the parameter. If not present, the parameter is implied to be required. | N/A           |

## Parameter types

### string

basic string parameters

```yaml
commands:
  copy-markdown:
    parameters:
      destination:
        description: destination directory
        type: string
        default: docs
    steps:
    - cp *.md << destination >>
```

Strings should be quoted if they would otherwise represent another type (such as boolean or number) or if they contain characters that have special meaning in yaml. Otherwise quotes are optional.

### boolean

boolean parameters are useful for conditionals

```yaml
commands:
  list-files:
    parameters:
      all:
        description: include all files
        type: boolean
        default: false
    steps:
    - ls <<# all >> -a <</ all >>
```

Boolean parameter evaluation is based on the [values specified in YAML 1.1][http://yaml.org/type/bool.html]:

* true: `y` `yes` `true` `on`
* false: `n` `no` `false` `off`
* also capitalized or uppercase versions of any of these

### steps

Used when you have a job or command that wants to mix predefined and user defined steps. When passed in to a command or job invocation, the steps passed as parameters are always defined as an array, even if only one step is provided.

```yaml
commands:
  run-tests:
    parameters:
      after-deps:
        description: "Steps that will be executed after dependencies are installed, but before tests are run"
        type: steps
        default: []
    steps:
    - run: make deps
    - << parameters.after-deps >>
    - run: make test
```

Steps passed as parameters are expanded and spliced into the array of existing steps.

```yaml
jobs:
  build:
    machine: true
    steps:
    - run-tests:
        after-deps:
          - run: echo "I installed the dependencies"
          - run: echo "And now I'm going to run the tests"
```

will become:

```yaml
steps:
  - run: make deps
  - run: echo "I installed the dependencies"
  - run: echo "And now I'm going to run the tests"
  - run: make test
```
