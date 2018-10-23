# Design Considerations

Here are some things to think about while designing orbs.

### Orbs are always world-readable
All published orbs can be read and used by anyone, not just members of your organization. In general, it is strongly recommended that you do not put secrets or other sensitive variables into your configuration. Instead, use contexts or project environment variables and use the names of those environment variables in your orbs.

### Always use `description`
Good metadata = good docs = good developer experience. Explain usage, assumptions, and any tricks in the `description` key under jobs, commands, executors, and parameters.

### Match commands to executors
If you are providing commands, try to provide one or more executors in which they will run.

### Name things concisely
Remember that use of your commands and jobs is always contextual to your orb, so you can use general names like "run-tests" in most cases.

### Required vs. optional parameters
Try to provide sound default values of parameters whenever possible.

### Job-only orbs are inflexible
While sometimes appropriate, it can be frustrating for users to not be able to use the commands in their own jobs. Pre and post steps when invoking jobs are a work-around for users on this front.

### Parameter `steps` are powerful for orb users
Wrapping steps provided by the user allows you to encapsulate and sugar things like caching strategies and other more complex tasks, providing a lot of value to users. Read more about this [here](parameters.md#steps).
