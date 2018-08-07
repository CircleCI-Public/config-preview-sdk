# Conditional steps
_Conditional steps are available in configuration version 2.1 and later_

Conditional steps allow the definition of steps that only run if a condition is
met. For example, an orb could define a command that runs a set of steps *if* the
orb's user invokes it with `myorb/foo: { dostuff: true }`, but not
`myorb/foo: { dostuff: false }`.

These conditions are checked before a workflow is actually run. That
means, for example, that a user can't use a condition to check an environment
variable.

Conditional steps can be located anywhere a regular step could. For example, an
orb author could define conditional steps in the `steps` key of a Job or a
Command.

A conditional step consists of a step with the key `when` or `unless`. Under this conditional key are the subkeys `steps` and `condition`. If `condition` is met (using when/unless logic), the subkey `steps` are run. 

> `condition` is a single value that evaluates to `true` or `false` at the time the config is processed, so you cannot use environment variables as conditions, as those are not injected until your steps are running in the shell of your execution environment. You can use parameters as your conditions. The empty string will resolve as falsey in `when` conditions.

### Example

```
# Contents of the orb `myorb` in namespace `mynamespace`
jobs:
  myjob:
    parameters:
      preinstall-foo:
        type: boolean
        default: false
    machine: true
    steps:
      - run: echo "preinstall is << parameters.preinstall-foo >>"
      - when:
          condition: << parameters.preinstall-foo >>
          steps:
            - run: echo "preinstall"
      - unless:
          condition: << parameters.preinstall-foo >>
          steps:
            - run: echo "don't preinstall"
```

```
# inside config.yml
version: 2

orbs:
  myorb: mynamespace/myorb@1.0.1

workflows:
  workflow:
    jobs:
      - myorb/myjob:
          preinstall-foo: false
      - myorb/myjob:
          preinstall-foo: true
```

