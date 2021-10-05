# ModuleDocstrings

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaDocs.github.io/ModuleDocstrings.jl/stable)
[![Build Status](https://github.com/JuliaDocs/ModuleDocstrings.jl/workflows/CI/badge.svg)](https://github.com/JuliaDocs/ModuleDocstrings.jl/actions)
[![Coverage](https://codecov.io/gh/JuliaDocs/ModuleDocstrings.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaDocs/ModuleDocstrings.jl)

A package to create simple "module docstrings" for Julia packages. These are targeted at summarizing the main components of your package, essentially as a prompt or reminder to users.  For example:

```julia
julia> using ModuleDocstrings

help?> ModuleDocstrings
search: ModuleDocstrings

    •  ModuleDocstrings.generate: Create an API summary docstring for a
       module.

    •  ModuleDocstrings.write: add an API summary docstring to a package.
```

Then, to learn more about `generate`:

```julia
help?> ModuleDocstrings.generate
  ModuleDocstrings.generate(mod::Module)

  Return an API summary string for mod.

  The summary is assembled from all docstrings in the package, picking the
  first sentence of each docstring. Expect to need to edit these by hand to
  produce something truly useful.

```
