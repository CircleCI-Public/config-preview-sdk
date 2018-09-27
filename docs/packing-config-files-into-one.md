# Packing config files

`circleci config pack` converts a filesystem tree into a single yaml file
based on directory structure and file contents. It prints the merged contents
to standard out. It can be used for orb authoring or writing build config
alike.

A brief example

```bash
$ tree
.
├── config.yml
└── foo
    ├── bar
    │   └── @baz.yml
    ├── foo.yml
    └── subtree
        └── types.yml

3 directories, 4 files

$ circleci config pack foo
bar:
  baz: qux
foo: bar
subtree:
  types:
    ginkgo:
      seasonality: deciduous
    oak:
      seasonality: deciduous
    pine:
      seasonality: evergreen

```

Some notes about the above example

- A path and filename become a tree of keys and values, where the file
  contents are the innermost value.

  Thus:

    ```shell
    $ cat foo/foo.yml
    {foo: bar}
    ```

  Is mapped to:

    ```yaml
    foo: bar
    ```

- A file beginning with `@` will have its contents merged into its parent
  level. This can be useful at the top level of an orb, when one might want a
  generic `orb.yml` to contain metadata, but not to map into an `orb` key-value
  pair.

  Thus:

    ```shell
    $ cat foo/bar/@baz.yml
    {baz: qux}
    ```

  Is mapped to:

    ```yaml
    bar:
      baz: qux
    ```

- The top level `foo` is not part of the collapsed result. These two commands produce identical yaml:
  - `cd foo && circleci config collapse .`
  - `circleci config collapse foo`

## Example with a config.yml
See [The example_config_pack folder](./example_config_pack) to see how
`circleci config pack` could be used with git commit hooks to generate a
single config.yml from multiple yaml sources.
