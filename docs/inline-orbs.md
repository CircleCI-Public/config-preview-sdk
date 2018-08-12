# Writing Inline Orbs
_The `orbs` stanza is available in configuration version 2.1 and later_

Inline orbs can be handy during development of an orb or as a convenience for namespacing jobs and commands in lengthy configurations, particularly if you later intend to share the orb.

To write inline orbs you would put the orb elements under that orb's key in the `orbs` declaration in config. For instance, if I wanted to import one orb then author inline for another it might look like:

```
orbs:
  ror: circleci/rails@volatile
  my-orb:
    executors:
      default:
        docker:
          - image: circleci/ruby:1.4.2
    commands:
      dospecialthings:
        steps:
          - run: echo "We will now do special things"
    jobs:
      myjob:
        executor: default
        steps:
          - dospecialthings

version: 2.1
workflows:
  main:
    jobs:
      - my-orb/myjob
```

In the above sample the contents of `my-orb` are resolved as an inline orb because the contents of `my-orb` are a map. Whereas the contents of `ror` are scalar value and thus assumed to be an orb URI.


