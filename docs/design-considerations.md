# Design Considerations

Here are some things to think about while designing orbs.
### Always use `description`
Good metadata = good docs = good developer experience. Explain usage, assumptions, and any tricks in the `description` key under jobs, commands, executors, and parameters.

### Match commands to executors
If you're providing commands, try to provide one or more executors in which they will run.

### Name things concisely
Remember that use of your commands and jobs is always contextual to your orb, so you can use general names like "run-tests" in most cases.

### Required vs. Optional parameters
Try to provide sound default values of parameters whenever possible.

### Job-only orbs are inflexible
While sometimes appropriate, it can be frustrating for users to not be able to use the commands in their own jobs. Pre and post steps when invoking jobs are a work-around for users on this front.

### Parameter `steps` are powerful
Wrapping steps provided by the user allows you to encapsulate and sugar things like caching strategies and other more complex tasks, providing a lot of value to users. Read more about this [here](https://github.com/CircleCI-Public/config-preview-sdk/blob/docs/docs/parameters.md#steps).
