# Build config lifecycle
Configuration in CircleCI is sent to the platform as a valid YAML string that should both adhere to the schema and be semantically sound. Checks on the shape of your config will be conducted prior to processing your build. Once your build configuration hits our system, it will follow the path detailed below.

## Lifecycle of configuration in a build

Once a project is created with configuration, each build is run from that source of configuration in the following ways:

1. When a build is initiated via webhook from your project's main git repository or via the API, the first check is of authorization. The credentials associated with the build request must be able to execute against the project. If credentials do not pass the authorization screen, you will not receive any confirmation that the project is even valid. This is similar behavior to the way GitHub serves a 404 error code in response to a request for a repository that you don't have access to, rather than acknowledge that the repository exists at all.

2. If the build request passes authorization, the build increments the build number on the project and project configuration is retrieved from source based on the SHA1 of the commit (unless config is being passed in via the API). If your configuration cannot be retrieved, the build will be failed and you will see a failed Build.

3. Configuration for the build is validated to ensure it parses as YAML and adheres to the CircleCI configuration schema (TODO: publish and link to the schema). If the configuration cannot be processed the build will fail, and you will see the resulting errors in the build.

4. If configuration can be processed, all dynamic elements are resolved including orbs and inline commands and parameters. 
If there are errors during orb and parameter resolution, the build will be failed, and you will see errors related to config compilation on the build. 

5. If the build configuration can be fully resolved, the build proceeds to workflow coordination. If your build configuration has only a single job, a minimal workflow will be "wrapped" around your job automatically immediately prior to being passed to coordination.

6. Workflow coordination orchestrates the state of your build, sending execution jobs to their respective executor fleets, tracking the state of approval jobs, and resolving context security rules at job run time. Any problems at this layer can result in a failed workflow with error messages.

7. Execution jobs can queue depending on the nature of your plan. Once taken off the queue:
 - The configuration of the job is passed to the build agent and is run in the executor specified in your job configuration.
 - Environment variables in configuration are injected at this stage into the runtime of your job.
     - The system is designed to minimize the surface area of systems where your secrets are decrypted.
 - Non-zero exit codes in shell commands executed in the steps of your job will cause the job to fail (and thus the upstream workflow to fail).
 - Failed jobs will show whatever was in the console output.
     - If you have test metadata specific errors will be surfaced directly.

8. After all the jobs that can be run in all the workflows of the build are at a terminal state the build is complete.
Builds will show both the original configuration received and the expanded configuration that was created during configuration processing. The build, along with its configuration, will stay in your build list until the expiry of the data retention rules in your plan.
