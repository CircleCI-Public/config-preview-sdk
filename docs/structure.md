# Orb structure

Each Orb is packaged as a single file. Each Orb also has its own namespace to use when invoking its elements. Orbs are authored with similar YAML syntax to the base CircleCI build configuration.

## Anatomy of an Orb
Orbs are composed of one or more of the following elements, each of which represents a type of invocable element in CircleCI project configuration:

* [commands](commands.md)
* [jobs](jobs.md)
* [executors](executors.md)

An example orb:
```yaml
# foo Orb
commands:
  echo:
    steps:
      - run: echo "hello world"
jobs:
  hello:
    machine: true
    steps:
      - echo
```

Our sample orb above has a single command name `echo` and a single job named `hello`.

### Naming

Orb, command, job, executor, and parameter names can only contain lowercase letters a-z, digits, and _ and -, and must start with a letter.

### Scoping considerations in Orb invocation

An orb `foo` effectively has a namespace called `foo` for use in your build configuration, and everything directly inside an orb is considered local to that orb.

The `/` character is used as the scope delimiter. For instance:
* `foo/bar` would look for `bar` in the `foo` orb.
* `bar` would look for `bar` in the local configuration scope.
