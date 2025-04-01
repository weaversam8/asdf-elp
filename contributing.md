# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

asdf plugin test elp https://github.com/weaversam8/asdf-elp.git "elp -h"
```

Tests are automatically run in GitHub Actions on push and PR.
