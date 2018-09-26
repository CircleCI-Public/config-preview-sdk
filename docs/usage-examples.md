# Providing usage examples of orbs
_The `examples` stanza is available in configuration version 2.1 and later_

As an author of an orb, you may want to document examples of using it in a CircleCI config file, not only to provide a starting point for new users, but also to demonstrate more complicated use cases.

## Simple examples
Given the following orb:

```yaml
version: 2.1
description: A foo orb

commands:
  hello:
    description: Greet the user politely
    parameters:
      username:
        type: string
        description: A name of the user to greet
    steps:
      - run: "echo Hello << parameters.username >>"
```

...you can supply an additional `examples` stanza like this:

```yaml
examples:
  simple_greeting:
    description: Greeting a user named Anna
    usage:
      version: 2.1
      orbs:
        foo: bar/foo@1.2.3
      jobs:
        build:
          machine: true
          steps:
            - foo/hello:
                username: "Anna"
```

Please note that `examples` can contain multiple keys at the same level as `simple_greeting`, allowing for multiple examples.

## Expected usage results

The above usage example can be optionally supplemented with a `result` key, demonstrating what the configuration will look like after expanding the orb with its parameters:

```yaml
examples:
  simple_greeting:
    description: Greeting a user named Anna
    usage:
      version: 2.1
      orbs:
        foo: bar/foo@1.2.3
      jobs:
        build:
          machine: true
          steps:
            - foo/hello:
                username: "Anna"
    result:
      version: 2.1
      jobs:
        build:
          machine: true
          steps:
          - run:
              command: echo Hello Anna
      workflows:
        version: 2
        workflow:
          jobs:
          - build
```

**Note:** in the future we may add automated checks whether the output of compiling `usage` matches what is specified in `result`.

## Example usage syntax
The top level `examples` key is optional. Example usage maps nested below it can have the following keys:

- **description:** (optional) A string that explains the example's purpose, making it easier for users to understand it.
- **usage:** (required) A full, valid config map that includes an example of using the orb.
- **result:** (optional) A full, valid config map demonstrating the result of expanding the orb with supplied parameters.
