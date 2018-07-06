# Conditional steps

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

> `condition` is a single value that evaluates to `true` or `false` at the time the config is processed, so you cannot use environment variables as conditions, as those are not injected until your steps are running in the shell of your execution environment. You can use parameters as your conditions.

### Example

```
# inside orb.yml for orb `myorb`
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
workflows:
  workflow:
    jobs:
      - myorb/myjob:
          preinstall-foo: false
      - myorb/myjob:
          preinstall-foo: true
```


## More Complex Conditionals

You might want to compare equality, check a string against a regexp, or do
simple boolean logic inside a conditional. Above, the condition is always a
single parameter, such as "<< parameters.foo >>", but you may also provide a map
of a single key, from the set `["equals", "matches", "or", "and", and "not"]`,
and a single value: a list of arguments.

### equals

`equals` operates on any number of arguments, and checks that they are all
equal.

```
- when:
    condition:
      equals: ["<< parameters.foo >>", "bar"]
```

### matches
`matches` is a function of two arguments--a pattern and a string to match. The
pattern must match the entire string.

```
- when:
    condition:
      matches: ['\w+[\w\d]+', "<< parameters.foo >>"]
```

### boolean operators: or, and, not

`or` is a function of any number of arguments. If any are truthy,
conditional steps will run.

```
- when:
    condition:
      or: ["<< parameters.foo >>", "<< parameters.bar >>"]
```

`and` is a function of any number of arguments. If all are truthy,
the conditional steps will run.
```
- when:
    condition:
      and: ["<< parameters.foo >>", "<< parameters.bar >>"]
```

`not` is a function of a single argument. If the argument is truthy, the
conditional steps will run.

```
- when:
    condition:
      not: "<< parameters.foo >>"
```

### Combining Conditionals

You can also combine conditionals. The arguments to any of the conditional functions
above can be other conditionals. For example:

```
- when:
    condition:
      and:
        - matches: ['\w+', "<< parameters.foo >>"]
        - matches: ['\d+', "<< parameters.bar >>"]
        - not: ["<< parameters.bang" >>]
    steps:
      - do stuff here
```
