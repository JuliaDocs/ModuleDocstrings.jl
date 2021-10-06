```@meta
CurrentModule = ModuleDocstrings
```

# ModuleDocstrings

This package aims to make it easier to attach a docstring to a module, providing users with a quick summary of the core functionality in a package.

To demonstrate, let's create a module with a few docstrings. This module has two functions: `radius` with a single method,
and `distance` with two methods (the details of the methods don't really matter much for this demonstration):

```jldoctest example
julia> module TestDocStrings
       
       export radius, distance
       
       """
           radius(x, y, z)
       
       Compute the radius of the cartesian-coordinate position `[x, y, z]`.
       
       There really isn't much more to say; it's pretty straightforward.
       """
       radius(x, y, z) = sqrt(x^2 + y^2 + z^2)
       
       
       """
           distance(pos1::AbstractVector, pos2::AbstractVector)
       
       Compute the distance between points `pos1` and `pos2`.
       """
       distance(pos1::AbstractVector, pos2::AbstractVector) = radius((pos1 - pos2)...)
       
       """
           distance(pos::AbstractVector, points::PointCollection)
       
       Compute the minimum distance between `pos` and any point in `points`.
       """
       distance(pos::AbstractVector, points::AbstractVector{<:AbstractVector}) = minimum(p -> distance(pos, p), points)
       
       end
TestDocStrings
```

Now let's generate a module doctring:

```jldoctest example
julia> using ModuleDocstrings

julia> print(ModuleDocstrings.generate(TestDocStrings))
- `distance`:
  + Compute the minimum distance between `pos` and any point in `points`.
  + Compute the distance between points `pos1` and `pos2`.
- `radius`: Compute the radius of the cartesian-coordinate position `[x, y, z]`.
```

From this, you can see that both methods of `distance` are listed, as well as the single method for `radius`.
For each, only the first sentence is used in the summary.

If this were a package that you have in `Pkg.develop` mode, you could insert this string into the package with [`ModuleDocstrings.write`](@ref).  However, in this case, you get

```jldoctest example; filter=(r"julia/dev/.*")
julia> ModuleDocstrings.write(TestDocStrings)
ERROR: TestDocStrings must be a writable package, but there is no corresponding file, suggesting it wasn't loaded from a package.
Stacktrace:
 [1] error(s::String)
   @ Base ./error.jl:33
 [2] error_write(mod::Module, #unused#::Nothing)
   @ ModuleDocstrings ~/.julia/dev/ModuleDocstrings/src/ModuleDocstrings.jl:101
 [3] write(mod::Module, str::String)
   @ ModuleDocstrings ~/.julia/dev/ModuleDocstrings/src/ModuleDocstrings.jl:79
 [4] write(mod::Module)
   @ ModuleDocstrings ~/.julia/dev/ModuleDocstrings/src/ModuleDocstrings.jl:96
 [5] top-level scope
   @ none:1
```

This error ocurred because we defined the module at the REPL; it will likewise error if you have `Pkg.add`ed rather than `Pkg.develop`ed.  But for a package checked out in `develop` mode it will modify the main package file.

!!! warning
    Be sure you've saved any work *before* running `ModuleDocstrings.write`.

Generally speaking, you should then edit the docstring to trim any methods that don't merit a mention in the summary, and/or to improve the clarity, brevity, or organization of the summaries.  Sometimes, you may discover that you can improve the original source docstring as well.

Your changes can then be submitted as a pull request.

## API

Documentation for [ModuleDocstrings](https://github.com/JuliaDocs/ModuleDocstrings.jl).

```@docs
ModuleDocstrings.generate
ModuleDocstrings.write
```
