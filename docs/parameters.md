# Using Parameters in CircleCI Configuration Elements
_The `parameters` declaration is available in configuration version 2.1 and later._

Many config elements can be authored to be invocable in your `config.yml` file with specified parameters. Parameters are declared by name as the keys in a map that are all immediate children of the `parameters` key under a job, command, or executor. 

For instance, the following shows declaring a parameter `foo` in the definition of a command `bar`:

```yaml
commands:
  bar:
    parameters:
      foo:
        description: this parameter is used for a thing
        default: "I'm a default value"
        type: string

    steps:
      - echo '<< parameters.foo >>'
```

In the above example a value for the parameter `foo` can be passed when invoking the command. For instance, passing the parameter `foo` would look something like:

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
| type        | Required. Currently "string", "boolean", "enum", and "steps" are supported                           | N/A           |
| default     | The default value for the parameter. If not present, the parameter is implied to be required. | N/A           |

## Parameter Types

This section describes the 

### String

Basic string parameters

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

Strings should be quoted if they would otherwise represent another type (such as boolean or number) or if they contain characters that have special meaning in yaml. In all other instances, quotes are optional.

### Boolean

Boolean parameters are useful for conditionals:

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

Capitalized and uppercase versions of the above values are also valid.

### Steps

Used when you have a job or command that needs to mix predefined and user-defined steps. When passed in to a command or job invocation, the steps passed as parameters are always defined as an array, even if only one step is provided.

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
    - steps: << parameters.after-deps >>
    - run: make test
```

Steps passed as parameters are given as the value of a `steps` declaration under the job's `steps` declaration and are expanded and spliced into the array of existing steps. For example,

```yaml
jobs:
  build:
    machine: true
    steps:
    - run-tests:
        after-deps:
          - run: echo "The dependencies are installed"
          - run: echo "And now I'm going to run the tests"
```

will become:

```yaml
steps:
  - run: make deps
  - run: echo "The dependencies are installed"
  - run: echo "And now I'm going to run the tests"
  - run: make test
```

### Enum

Use the `enum` parameter to declare the target operating system for a binary.

```yaml
commands:
  list-files:
    parameters:
      os: 
        default: "linux"
        description: The target Operating System for the heroku binary. Must be one of "linux", "darwin", "win32".
        type: enum
        enum: ["linux", "darwin", "win32"]
```        

The following `enum` type decalration is invalid because the default is not declared in the enum list.

```yaml
commands:
  list-files:
    parameters:      
      os:
        type: enum
        default: "windows" #invalid declaration of default that does not appear in the comma-separated enum list
        enum: ["darwin", "linux"]
```        

