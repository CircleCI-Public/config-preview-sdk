# Explaining the design approach to CircleCI configuration

## What problems are we trying to solve with the new build processing system?
1. **Better [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) support** 
The configuration in CircleCI 2.0 is designed to be highly deterministic. As a result, the syntax proved in many cases to be much more verbose and prone to too much boiler plate and repeated code blocks. We aim to provide better ways avoid repetitive build configuration.

2. **Code reuse across projects** 
We hear from a lot of customers that they want better ways to share configuration across projects. This repo introduces Orbs, reusable packages of parameterizable CircleCI configuration elements that can be added to the Orb registry for use across projects.

3. **Easier path to common configuration**
We often hear that people want more off-the-shelf options to get their first useful builds flowing, especially for common platforms like Rails, Node, and they want better encapsulation of common tasks like deploying to Heroku or pushing to an S3 bucket.

## Core characteristics of CircleCI build configuration
1. **Deterministic:** Every build should behave the same way given the same inputs.

> This prevents things from changing on you that you can't control, and it prevents CircleCI from having to make and then carry assumptions about how you want to run your builds.


2. **Config as Data:** We use YAML because it provides a way to author a data structure with a reasonable balance between syntactic weight and expressiveness.

> Having configuration be data rather than a programming language allows easy and reliable tooling for doing config syntax and schema validation, various static analysis and data tranformations that occur during the processing of your builds, and automated documentation with first-class metadata.


3. **Declarative of Build Behaviors:** The semantics of CircleCI config revolve around the core domain model of build execution inside our platform.

> The core structure is driven by workflows that invoke and coordinate jobs that express a set of steps to run and the execution environment in which to run them. Our configuration code is intrinsically meta to your build process. We want to let you focus on what your code is going to do inside the runtime and get out of your way as much possible. Using a declarative syntax allows to give you an expressive set of primitives without making you learn much, if anything, about how our internal systems work or learn some new programming language.

## Configuration lifecycle
1. **Retrieval:** Build configuration you write is retrieved from your git repository when CircleCI receives webhooks from your version control provider (eg: GitHub) or can be passed in as part of an API call triggering a build. 
2. **Processing:** Build configuration goes through a processing step prior to hitting the workflows and job execution layers of CircleCI. All invoked commands, jobs, and other structural elements, along with any parameters passed in this invocations, are resolved during this configuration processing step. 

> One major implication is that configuration processing does not have access to your runtime environment or your environment variables and other sensitive information.

3. **Coordination:** Workflows enforce the rules of when to run specific jobs and keep track of the state of those jobs.
4. **Execution:** The steps of your jobs as executed in the executor you specified, which is provisioned just for running your job and discarded after your job completes. This is the stage at which your environment variables and other build data is injected.


## Design choices made in Orbs
1. **Stick with YAML:** We considered providing a DSL in a programming language like JavaScript or Python to build the data structures of configuration dynamically.
We chose to first build a YAML-based packaging mechanism because:
    * Our customers and employees already know it, so it adds the least friction and cognitive load to adopt.
    * It is a widely adopted data format that allow us to provide a deterministic and declarative DSL. No other data format was deemed sufficiently better to switch.
    * Our configuration can be more easily self-documenting and statically processed by using a data format instead of a programming language.
1. **Transparency:** If you can execute an orb you can see the source of that orb.
Orbs are less like your core software, and more like a piece of configuration you would otherwise copy and paste. Orbs are part of your build process, so you should be able to see what they do if you can execute them.
1. **First-class Metadata:** We allow a `description` key as part of the structure of orbs, so it's easier to generate documentation or read through the code without having extra-structural comments.
1. **Semantic Versioning and Locking:** We want to allow orb authors to dynamically add features and fixes to orbs. At the same time, we want to prevent things from changing out from under orb users: fixing the orbs that users leverage so that users' configurations remain static unless the user specifies otherwise. 
We choose to enforce a strict format for [semver](https://semver.org/) on all published revisions. When importing we allow an orb user to lock a specific revision or to assume the risk of breakage and to use the latest version (`volatile`).
1. **Register-time Dependency Resolution:** If an orb (`my-orb`) imports other orbs, we will resolve and lock those dependencies at the time that `my-orb` is added to the registry.
For instance, let's say that you publish version 1.2.0 of `my-orb`, and it contains:

```
orbs:
  foo-orb: somenamespace/some-orb:volatile` 
```


At the time you register 1.2.0 of `my-orb` the latest version of `foo-orb` will be flatteneded into `my-orb` version 1.2.0. If a new version of `foo-orb` is published it won't get incorporated into `my-orb` until you publish a new version. **NOTE:** _We recommend selecting the fully qualified version of the orbs that you import to ensure deterministic behavior._

1. **One registry per CircleCI installation:** Orbs are specific to running CircleCI builds, so we decided to avoid the complexities and security surface area of having arbitrary registries.
All orbs used in a CirlceCI build must be in the registry of the installation on which your build runs. 
1. **All orbs live in a namespace:** All orbs live in exactly one namespace.
There is no "empty" namespace, nor are there reserved special defaults like "_" for CircleCI or "official" orbs. We are likely to introduce a Certified Orbs program or similar in the future, but that will offer first-class metadata on the orb, explicitly defining inclusion rather than relying on implied in a special namespace.
1. **Revisions are immutable:** To prevent mysterious changes cropping up in the builds of those who use orbs, we do not allow changes to an orb revision once it has gone live.
