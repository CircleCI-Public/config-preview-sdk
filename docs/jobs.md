# Authoring and using jobs
Jobs are sets of steps run in a given executor.

## Job naming and organization

Jobs are defined in your build configuration or in an orb. In an orb, a job's file name becomes its name. In your build configuration, job names are defined by the map under the `jobs` key in build config.

Like most elements, jobs can contain an optional but highly recommended `description`.

A user must invoke jobs in the workflows stanza of `config.yml`, passing any necessary parameters as subkeys to the job. See the [parameters documentation](parameters.md) for more detailed information.

Example of defining and invoking a parameterized job in a config.yml:

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

```yaml
# build.yml
workflows:
  version: 2
  build:
    jobs:
      - hello-orb/sayhello:
          saywhat: Everyone
```

```yaml
# .circleci/orbs/hello-orb/jobs/sayhello.yml
parameters:
  saywhat:
    description: "To whom shall we say hello?"
    default: "World"
    type: string
machine: true
steps:
  - say:
      saywhat: "<< parameters.saywhat >>"
```

```yaml
# .circleci/orbs/hello-orb/commands/say.yml
parameters:
  saywhat:
    type: string
steps:
  - echo "<< parameters.saywhat >>"
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

A single build configuration may invoke a job many times.  At configuration processing time during build ingestion, CircleCI will auto-generate names if they aren't provided.  If one cares about the name of the duplicate jobs, one can explicitly name them with the `name` key. **NOTE:** One must explicitly name repeat jobs when a repeat job should be upstream (ie: is used under the `requires` key of a job invocation in a workflow) of another job in the workflow.:

```yaml
workflows:
  version: 2
  build:
    jobs:
      - sayhello:
          name: SayHelloEveryone
          saywhat: Everyone
      - sayhello:
          name: SayHelloChad
          saywhat: Chad
```



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
      - saygoodbye:
          requires:
            - SayHelloChad
```
