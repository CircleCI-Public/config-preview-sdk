# Using Orbs in CirlceCI Configuration
_The `orbs` stanza is available in configuration version 2.1 and later._

Orbs are packages of CircleCI configuration shared across projects. Orbs are made available for use in configuration through the `orbs` key in the top level of your config.yml. 

Importing a set of orbs might look like:

```yaml
orbs:
  rails: circleci/rails@1.13.3
  python: circleci/python@2.1
  heroku: circleci/heroku@volatile
```

The above would make three orbs available, one for each key in the map and named the same as the keys in the map. 

You can also write [inline orbs](inline-orbs), which can be especially useful during development of a new orb. Because the values of the above keys under `orbs` are all scalar values they are assumed to imports based on the orb URI format.

## Orb URI Format
Orb URIs have the format:

`[namespace]/[orb]@[version]`

Orb namespaces may have restrictions that prevent you from accesing orbs in those namespaces based on whether the build and the scope of the namespace are congruent.

## Semantic Versioning in Orbs

Orbs are published with the standard 3-number [semantic versioning system](https://semver.org/), `major.minor.patch`, and orb authors need to adhere to semantic versioning. Within `config.yml`, you can specify wildcard version ranges to resovle orbs. You can also use the special string `volatile` to pull in whatever the highest version number is.  

For instance, the versions below have the following meaning:

1. `circleci/python@volatile` - use the latest version of the Python orb in the registry at the time a build is triggered.
2. `circleci/python@2.*.*` - use the latest version of version 2.x.x of the Python orb .
3. `circleci/python@2.4.*` - use the latest version of version 2.4.x of the Python orb .
4. `circleci/python@3.1.4` - use exactly version 3.1.4 of the Python orb.

## Dev versioning in Orbs

### Defining dev versions
Orbs can be published with dev versions by a larger group of users in an organization than those who can publish semantic versions. Dev versions must be in the following format:

- Begin with the string "dev:"
- Have between 0 and 1023 of the following characters:
  - Numbers `0-9`
  - Lowercase letters `a-z`
  - Dashes `-`
  - Underscores `_`
  - Periods `.`

Examples:
- Valid:
  - "dev:"
  - "dev:1.2.3"
  - "dev:1.2.3-rc1"
- Invalid
  - "dev: 1" (No spaces allowed)
  - "dev:A" (No capital letters)
  - "1.2.3-rc1" (No leading "dev:")

### Using dev versions

For a project to reference a dev version, its organization must enable "allow uncertified orbs". Currently to do this, an organization admin must contact support to request activation. These are the admin of the org within Github or Bitbucket.

A dev version must be referenced entirely, like `circleci/codecov-clojure@dev:clojure-1.10-support`. In contrast to semantic versions, where `1.0` could be shorthand for `1.0.0`, there are no shorthand conveniences for dev versions. Dev versions are mutable: their contents can change, so it's best not to rely on a dev version long term in your projects.
