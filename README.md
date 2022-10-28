# venv

My personal virtualenvwrapper hooks

## 🗒️ Foreword

I was tired of making the same mistake that I would work on a project, run tests,
just to realise that I forgot to activate virtual environment. That's not ideal.

There are many auto-venv scripts, but I just find them too complicated for my
basic usage. Initially I wrote my entire wrapper for python's builtin venv module,
but I recently realised this was a tedious task, and so I went for a hunt and
discovered virtualenv and virtualenvwrapper.

While I love the idea of virtualenv, I don't necessarily enjoy virtualenvwrapper,
because of the following:

- It, in my humble opinion, lacks structure in the code.
- It does not support all shells that virtualenv does (and I personally wanted to
  move from zsh no nushell, which is not supported).
- It activates the virtual environment to perform pretty much anything, while it
  could just reference the python binary.
- It does not have single command, but it bloats the shell with so many that I can't
  even remember their names.
- Some hooks are executables, while some aren't.

I might actually rewrite virtualenvwrapper in my own style in the future, but that's
not what I'm aiming for with this repository. The goal of this one is to create
a set of hooks that I will use with virtualenvwrapper, and an auto venv activator
that works on zsh's chpwd().

## 📦 Installation

Required dependencies:

- [Virtualenvwrapper/virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/index.html)

Optional dependencies:

- [deshaw/pyflyby](https://github.com/deshaw/pyflyby)
- [cli/cli - aka gh](https://github.com/cli/cli)

Recommended way of installation:

```sh
# required
pipx install virtualenvwrapper

# optional
pipx install pyflyby
brew install gh

# this plugin
cd path/to/venv/plugin
git clone https://github.com/filipgodlewski/venv.git
source path/to/venv/plugin/venv.plugin.zsh
```

## ⚙️ Configuration

Please refer to [Virtualenvwrapper/virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/index.html).
But generally speaking everything is already set up for you. Just use it.

There is one additional env constant which you can set up:

```sh
export AUTO_VENV=false  # default: true, is type boolean
```

## 📢 Commands

Venv exposes one additional command to the already vast virtualenvwrapper's arsenal:

```sh
rmdeadrefs
# Clean up all project references in venv paths files that are unreachable.
```

## 🪝 Hooks information

### pyflyby

If pyflyby is installed, it will be used to potentially collect exports for
all installed packages (`collect-exports`). To read more about pyflyby,
please head on to [deshaw/pyflyby](https://github.com/deshaw/pyflyby).

It currently works on the following hooks:

- postactivate
- postdeactivate
- postmkvirtualenv

## gh

If gh is installed, it will be used to setup a git repo (`gh repo create`) in an
interactive mode. Otherwise, git will be used for that (that's not an option).

It currently works on the following hooks:

- postmkproject

## 🪢 Contributing

If you wish to help me extend those hooks with some useful cool functionalities,
please don't hesitate to do so! Please, create pull requests, issues,
or a fork and let me know about it.

## ✅ TODO

- [ ] python project templates to setup the git repo.

## 📚 License

Licensed under the [MIT](./LICENSE) license.
