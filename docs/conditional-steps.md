# Conditional Steps

Conditional steps allow the definition of steps that only run if a condition is
met. For example, an orb could define a command that runs a set of steps if the
orb's user invokes it with `myorb/foo: { dostuff: true }`, but not
`myorb/foo: { dostuff: false }`.

Note that the condition is checked before a workflow is actually run. This
means, for example, that a user can't use a condition to check an environment
variable.

Conditional steps can be located anywhere a regular step could. For example, an
orb author could define conditional steps in the `steps` key of a Job or a
Command.

A conditional step consists of a step with the key `when` or `unless`. The
subkey `steps` defines the steps to run if the condition under subkey
`condition` is met. Currently the `condition` is a single value that evaluates
to `true` or `false`.

### Conditional steps in an orb

```
# inside orb.yml for orb `myorb`

jobs:
  myjob:
    parameters:
      preinstall-foo:
        type: boolean
        default: false
      foo-download-url:
        type: string
        default: ""
    executor: some-executor
    steps:
      - checkout
      - when:
        condition: << parameters.preinstall-foo >>
        steps:
          - install-foo:
            download-url: << parameters.foo-download-url >>
      - unless:
        condition: << parameters.preinstall-foo >>
        steps:
          - compile-foo
      - verify-foo-version
      - build
      - test
```

```
# inside user's build.yml
workflows:
  workflow:
    jobs:
      - myorb/myjob:
          preinstall-foo: true
          foo-download-url: https://example.com/foo.sh
```

