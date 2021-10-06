# ModuleDocstrings

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaDocs.github.io/ModuleDocstrings.jl/stable)
[![Build Status](https://github.com/JuliaDocs/ModuleDocstrings.jl/workflows/CI/badge.svg)](https://github.com/JuliaDocs/ModuleDocstrings.jl/actions)
[![Coverage](https://codecov.io/gh/JuliaDocs/ModuleDocstrings.jl/branch/main/graph/badge.svg?token=5Wdh1eXbGc)](https://codecov.io/gh/JuliaDocs/ModuleDocstrings.jl)

A package to create simple "module docstrings" for Julia packages. These are targeted at summarizing the main components of your package, essentially as a prompt or reminder to users.  For example:

```julia
julia> using ModuleDocstrings

help?> ModuleDocstrings
search: ModuleDocstrings

    •  ModuleDocstrings.generate: Create an API summary docstring for a
       module.

    •  ModuleDocstrings.write: add an API summary docstring to a package.
```

This reminds users that the two main functions are `ModuleDocstrings.generate` and `ModuleDocstrings.write`.

These summaries are brief; to learn more about a particular function, read its help in full:

```julia
help?> ModuleDocstrings.generate
  ModuleDocstrings.generate(mod::Module)

  Return an API summary string for mod.

  The summary is assembled from all docstrings in the package, picking the first sentence of each docstring. When added to the
  package (see ModuleDocstrings.write), you should expect to make edits by hand:

    •  exclude docstrings that shouldn't appear in the API summary

    •  rephrase summaries for greater clarity or compactness (alternatively, consider making such changes to the original
       docstring)
```

Once you've added the docstring to a `Pkg.develop`ed package, it can be submitted as a pull request.
