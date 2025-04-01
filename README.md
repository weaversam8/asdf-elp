<div align="center">

# asdf-elp [![Build](https://github.com/weaversam8/asdf-elp/actions/workflows/build.yml/badge.svg)](https://github.com/weaversam8/asdf-elp/actions/workflows/build.yml) [![Lint](https://github.com/weaversam8/asdf-elp/actions/workflows/lint.yml/badge.svg)](https://github.com/weaversam8/asdf-elp/actions/workflows/lint.yml)

[elp](https://whatsapp.github.io/erlang-language-platform/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add elp
# or
asdf plugin add elp https://github.com/weaversam8/asdf-elp.git
```

elp:

```shell
# Show all installable versions
asdf list-all elp

# Install specific version
asdf install elp latest

# Set a version globally (on your ~/.tool-versions file)
asdf global elp latest

# Now elp commands are available
elp --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/weaversam8/asdf-elp/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Sam Weaver](https://github.com/weaversam8/)
