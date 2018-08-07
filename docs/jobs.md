# Authoring and using jobs
_Invoking jobs multiple times in a single workflow and parameters in jobs are available in configuration version 2.1 and later._

Jobs are sets of steps and the environments they should be executed within.

## Job naming and organization

Jobs are defined in your build configuration or in an orb. Job names are defined
in a map under the `jobs` key in configuration or in an external orb's configuration.

Like most elements, jobs can contain an optional but highly recommended `description`.

A user must invoke jobs in the workflows stanza of `config.yml`, passing any necessary parameters as subkeys to the job. See the [parameters documentation](parameters.md) for more detailed information.

Example of defining and invoking a parameterized job in a `config.yml`:

```yaml
version: 2

jobs:
  sayhello:
    description: A job that does very little other than demonstrate what a parameterized job looks like
    parameters:
      saywhat:
        description: "To whom shall we say hello?"
        default: "World"
        type: string
    machine: true
    steps:
      - echo "Hello << parameters.saywhat >>"

workflows:
  version: 2
  build:
    jobs:
      - sayhello
          saywhat: Everyone
```

### Jobs defined in an orb

If a job is declared inside an orb it can use commands in that orb or the global commands. We do not currently allow calling commands outside the scope of declaration of the job.

**hello-orb**
```yaml
# partial yaml from hello-orb
jobs:
  sayhello:
    parameters:
      saywhat:
        description: "To whom shall we say hello?"
        default: "World"
        type: string
    machine: true
    steps:
      - say:
          saywhat: "<< parameters.saywhat >>"
commands:
  saywhat:
    parameters:
      saywhat:
        type: string
    steps:
      - echo "<< parameters.saywhat >>"
```

**Config leveraging hello-orb**
```yaml
# config.yml
orbs:
  hello-orb: somenamespace/hello-orb@volatile
workflows:
  version: 2
  build:
    jobs:
      - hello-orb/sayhello:
          saywhat: Everyone
```

## Parameter scope

Parameters are in-scope only within the job or command that defined them. If you want a job or command to pass its parameters to a command it invokes, they must be passed explicitly.

```yaml
version: 2

jobs:
  sayhello:
    parameters:
      saywhat:
        description: "To whom shall we say hello?"
        default: "World"
        type: string
    machine: true
    steps:
      - say:
          # Since the command "say" doesn't define a default
          # value for the "saywhat" parameter, it must be
          # passed in manually
          saywhat: << parameters.saywhat >>

commands:
  say:
    parameters:
      saywhat:
        type: string
    steps:
      - echo "<< parameters.saywhat >>"

workflows:
  version: 2
  build:
    jobs:
      - sayhello
          saywhat: Everyone
```

For details on parameter naming rules, see the [naming section in the structure documentation](./structure.md#naming).

## Invoking the same job multiple times

A single configuration may invoke a job many times. At configuration processing time during build ingestion, CircleCI will auto-generate names if none are provided.  If you care about the name of the duplicate jobs, they can be explicitly named with the `name` key.

>NOTE: The user must explicitly name repeat jobs when a repeat job should be upstream of another job in a workflow (ie: if the job is used under the `requires` key of a job invocation in a workflow you will need to name it).

```yaml
workflows:
  version: 2
  build:
    jobs:
      - loadsay
      # This doesn't need an explicit name as it has no downstream dependencies
      - sayhello:
          saywhat: Everyone
          requires:
            - loadsay
      # This needs an explicit name for saygoodbye to require it as a job dependency
      - sayhello:
          name: SayHelloChad
          saywhat: Chad
      # Uses explicitly defined "sayhello"
      - saygoodbye:
          requires:
            - SayHelloChad
```

### Pre and post steps

Every job accepts two special arguments: `pre-steps` and `post-steps`.
Users can optionally invoke a job with one or both of these arguments. Steps under `pre-steps`
are executed before any of the other steps in the job. The steps under
`post-steps` are executed after all of the other steps.

For this reason, the parameter names `pre-steps` and `post-steps` are reserved
and may not be redefined by a job author. For example, the following job
definition is invalid:

```yaml
jobs:
  foo:
    parameters:
      pre-steps:    # invalid: pre-steps is a reserved parameter name
        type: steps
        default: []
```

See [Pre and Post Steps](pre-and-post-steps.md) for more.
