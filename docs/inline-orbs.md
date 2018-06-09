# Writing Inline Orbs
Inline orbs can be handy during development of an orb or as a convenience for namespacing jobs and commands in lengthy configurations, particularly if you later intend to share the orb.

To write inline orbs you would put the orb elements under that orb's key in the `orbs` declaration in config. For instance, if I wanted to import one orb then author inline for another it might look like:

```
orbs:
  ror: circleci/rails@latest
  my-orb:
    executors:
      default:
        docker:
          - image: circleci/ruby:1.4.2
    commands:
      dospecialthings:
        steps:
          - run: echo: "We will now do special things
    jobs:
      myjob:
        executor: default
        steps:
          - dospcialthings

workflows:
  main:
    - my-orb/myjob
```

In the above sample the contents of `my-orb` are resolved as an inline orb because the contents of `my-orb` are a map. Whereas the contents of `ror` are scalar value and thus assumed to be an orb URI.

## Publishing inline orbs to the registry

To publish an inline orb to the registry you can use the CLI to extract it and push it to the registry:

`circleci orb publish --from-inline path/to/orb.yml --namespace mycompany --name myspecialorb --version 1.1.1`

Note that you can also directly publish through our GraphQL API, though the CLI encapsulates that funcionality and is the recommended method.

