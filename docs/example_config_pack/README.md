# Example of "circleci config pack" to manage config.yml
This is a small, functional example that generates a `config.yml` from
multiple yaml sources. The entry point is
[regenerate_config.sh](./regenerate_config.sh), which can be used in a git
commit hook to ensure `config.yml` accurately reflects the template files.