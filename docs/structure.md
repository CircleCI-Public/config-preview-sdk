# Orb Structure

Each Orb is packaged and shared as a folder of files that follows a convenient convention for structuring configuration code. Each Orb also has its own namespace to use when invoking its elements. Orbs are authored with similar YAML syntax to the base CircleCI build configuration.

## Anatomy of an Orb
Orbs are composed of one or more of the following elements, each of which represents a type of invocable element in CircleCI project configuration.:

* [commands](commands.md)
* [jobs](jobs.md)
* [executors](executors.md)

The structure of an Orb is organized by the above types, then by the name of each specific invocable element.

Orbs also have metadata that can be used to generate documentation or set global parameters, in orb.yml at the root of the orb. TODO: we may in the future allow you to define the entire contents of your orb in the `orb.yml` file.

Below is a sample structure of a bare-bones Orb. Here, a directory `foo` is placed in `.circleci/orbs/`. **NOTE:** _orbs inside your .circleci folder is likely only something we will have for the Preview period. When we release the features of orbs you will most likely register your orbs on CircleCI and import them for use in your build config rather than need to put the code for the orbs in your project repository_. 

```
.circleci/orbs/foo/
├── commands
│   └── echo.yml
├── jobs
│   └── hello.yml
├── orb.yml
```

Our sample orb above has a single command name `echo` and a single job named `hello`. The `orb.yml` file has metadata about `foo` used mostly for auto-generating documentation such as a description, authorship info, etc.

### Naming

Orb, command, job, executor, and parameter names can only contain lowercase letters a-z, digits, and _ and -, and must start with a letter.

### Scoping Considerations in Orb Invocation

An orb `foo` effectively has a namespace called `foo` for use in your build configuration, and everything directly inside an orb is considered local to that orb.

The `/` character is used as the scope delimiter. For instance:
* `foo/bar` would look for `bar` in the `foo` orb.
* `bar` would look for `bar` in the local scope.
