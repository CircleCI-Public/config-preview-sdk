# Using orbs in CircleCI configuration
_The `orbs` stanza is available in configuration version 2.1 and later._

Orbs are packages of CircleCI configuration shared across projects. Orbs are made available for use in a configuration through the `orbs` key in the top level of your config.yml.

This document mostly covers the use of existing orbs in your configuration. See the docs on [authoring and publishing orbs](orbs-authoring.md) to learn more about making your own.

Importing a set of orbs might look like:

```yaml
orbs:
  slack: circleci/slack@0.1.0
  heroku: circleci/heroku@volatile
```

The above would make two orbs available, one for each key in the map and named the same as the keys in the map.

Because the values of the above keys under `orbs` are all scalar values they are assumed to be imports based on the orb ref format of `${NAMESPACE}/${ORB_NAME}@${VERSION}`

You may also write [inline orbs](inline-orbs.md), which may be especially useful during development of a new orb.

## Certified orbs vs. 3rd party orbs
Certified orbs are those that CircleCI has built or has reviewed and approved as part of the features of the CircleCI platform. Any project may use certified orbs in configuration version 2.1 and higher.

3rd party orbs are those published by our customers and other members of our community. For you to publish orbs or for your projects to use 3rd party orbs, your organization must opt-in under SECURITY within the Organization Settings page under the section "Orb Security Settings" where an organization administrator must agree to the terms for using 3rd-party software. NOTE: This setting can only be toggled by organization administrators.

## Orb ref format
Orb refs have the format:

`[namespace]/[orb]@[version]`

## Semantic versioning in orbs
Orbs are published with the standard 3-number [semantic versioning system](https://semver.org/), `major.minor.patch`, and orb authors need to adhere to semantic versioning. Within `config.yml`, you may specify wildcard version ranges to resolve orbs. You may also use the special string `volatile` to pull in whatever the highest version number is at time your build runs. For instance, when `mynamespace/some-orb@8.2.0` exists, and `mynamespace/some-orb@8.1.24` and `mynamespace/some-orb@8.0.56` are published after `8.2.0`, volatile will still refer to `mynamespace/some-orb@8.2.0` as the highest semver.

Examples of orb version declarations and their meaning:

1. `circleci/python@volatile` - use the latest version of the Python orb in the registry at the time a build is triggered.
2. `circleci/python@2` - use the latest version of version 2.x.y of the Python orb .
3. `circleci/python@2.4` - use the latest version of version 2.4.x of the Python orb .
4. `circleci/python@3.1.4` - use exactly version 3.1.4 of the Python orb.

### Using dev versions
While all production orbs must be published securely by organization admins, dev orbs allow your team broader latitude. See the [Orb authoring and publishing doc](orbs-authoring.md) for more information on how you can create your own dev orbs.

A dev version must be referenced entirely, like `mynamespace/myorb@dev:mybranch`. Whereas production orbs allow wildcard semver references, there are no  wildcards in dev versions.

IMPORTANT NOTE: **Dev versions are mutable and expire.** Their contents can be changed by other members of your organization, and they are subject to deletion after 90 days, so we strongly recommend you do not rely on a dev versions in any production software and use them only while developing your orb.
