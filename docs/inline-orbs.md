# Writing inline orbs
_The `orbs` stanza is available in configuration version 2.1 and later_

Inline orbs can be handy during development of an orb, or as a convenience for namespacing jobs and commands in lengthy configurations, particularly if you later intend to share the orb.

To write inline orbs, you need to place the orb elements under that orb's key in the `orbs` declaration in config. For example, if you wanted to import one orb, and then author inline for another orb, the orb might look like the example shown below.

```yaml
orbs:
  codecov: circleci/codecov-clojure@0.0.4
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
          - codecov/upload:
              path: ~/tmp/results.xml

version: 2.1
workflows:
  main:
    jobs:
      - my-orb/myjob
```

In the above example, the contents of `my-orb` are resolved as an inline orb because the contents of `my-orb` are a map; whereas the contents of `codecov` are a scalar value and thus assumed to be an orb URI.
