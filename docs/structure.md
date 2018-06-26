# Orb structure

Each Orb is packaged as a single file. Each Orb also has its 
own namespace to use when invoking its elements. Orbs are authored with similar 
YAML syntax to the base CircleCI build configuration.

## Anatomy of an Orb
Orbs are composed of one or more of the following elements, each of which represents a type of invocable element in CircleCI project configuration.:

* [commands](commands.md)
* [jobs](jobs.md)
* [executors](executors.md)

An example orb:
```
# .circleci/orbs/foo/orb.yml
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

Here, an orb is placed in `.circleci/orbs/foo/orb.yml`. **NOTE:** _orbs inside 
your .circleci folder is likely only something we will have for the Preview 
period. When we release the features of orbs you will most likely register your 
orbs on CircleCI and import them for use in your build config rather than need 
to put the code for the orbs in your project repository_. 

Our sample orb above has a single command name `echo` and a single job named `hello`.

### Naming

Orb, command, job, executor, and parameter names can only contain lowercase letters a-z, digits, and _ and -, and must start with a letter.

### Scoping considerations in Orb invocation

An orb `foo` effectively has a namespace called `foo` for use in your build configuration, and everything directly inside an orb is considered local to that orb.

The `/` character is used as the scope delimiter. For instance:
* `foo/bar` would look for `bar` in the `foo` orb.
* `bar` would look for `bar` in the local scope.
