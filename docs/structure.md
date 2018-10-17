# Orb structure

Orbs are authored with similar YAML syntax to the base CircleCI build configuration. Each orb also has its own namespace to use when invoking its elements. Orbs are typically packaged as a single file, can also be locally defined inside configs or other orbs. There is support for [packing multiple files together](packing-config-files-into-one.md) for large orbs.

## Anatomy of an orb
Orbs are composed of one or more of the following elements, each of which represents a type of invocable element in CircleCI project configuration:

* `description` (a string)
* [commands](commands.md)
* [jobs](jobs.md)
* [executors](executors.md)
* [orbs](inline-orbs.md)

Additionally, [usage examples](usage-examples.md) may also be provided for documentation purposes.

An example orb:
```yaml
# foo orb
description: A hello-world orb example
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

Note that the example Orb shown above has a single command name `echo` and a single job named `hello`.

### Naming

Orb, command, job, executor, and parameter names can only contain lowercase letters a-z, digits, and _ and -, and must start with a letter.

### Scoping considerations in orb invocation

An orb `foo` effectively has a namespace called `foo` for use in your build configuration, and everything directly inside an orb is considered local to that orb.

The `/` character is used as the scope delimiter. For instance:
* `foo/bar` would look for `bar` in the `foo` orb.
* `bar` would look for `bar` in the local configuration scope.
