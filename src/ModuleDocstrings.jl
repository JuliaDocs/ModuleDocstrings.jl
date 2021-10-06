"""
- `ModuleDocstrings.generate`: Create an API summary docstring for a module.
- `ModuleDocstrings.write`: add an API summary docstring to a package.
"""
module ModuleDocstrings

"""
    ModuleDocstrings.generate(mod::Module)

Return an API summary string for `mod`.

The summary is assembled from all docstrings in the package, picking the first sentence of each docstring.
Expect to need to edit these by hand to produce something truly useful.
"""
function generate(mod::Module)
    exported = Set(names(mod))
    docex, docpriv = Pair{String,Vector{String}}[], Pair{String,Vector{String}}[]
    for (bind, doc) in Base.Docs.meta(mod)
        tgt, key = bind.var ∈ exported ? (docex, String(bind.var)) : (docpriv, string(bind))
        push!(tgt, key => firstsentences(doc))
    end
    sort!(docex; by=first)
    sort!(docpriv; by=first)
    io = IOBuffer()
    for doc in (docex, docpriv)
        for (key, methsummaries) in doc
            print(io, "- `", key, "`:")
            if length(methsummaries) == 1
                print(io, ' ', methsummaries[1])
            else
                for msum in methsummaries
                    print(io, "\n  + ", msum)
                end
            end
            print(io, '\n')
        end
    end
    return String(take!(io))
end

firstsentences(docs::Base.Docs.MultiDoc) = String[firstsentences(docstr) for (sig, docstr) in docs.docs]
firstsentences(doc) = firstsentence(doc)
firstsentence(docstr::Base.Docs.DocStr) = firstsentence(docstr.text)
firstsentence(itr) = firstsentence(join(itr))
function firstsentence(d::AbstractDict)
    @assert length(d) == 1 "multiple entries ($(length(itr))) for a given signature"
    return firstsentence(first(d).second)
end
function firstsentence(str::AbstractString)
    # @show str
    io = IOBuffer()
    for line in split(str, '\n')
        startswith(line, "    ") && continue   # code line
        all(isspace, line) && continue
        idx = findfirst(r"\.(\s|$)", line)
        if idx === nothing
            print(io, line, ' ')
            continue
        end
        print(io, line[1:first(idx)])
        return String(take!(io))
    end
    return String(take!(io))
end

"""
    ModuleDocstrings.write(mod, str)

Edit the module-defining file to insert `str` as a docstring for `mod`.

The package should be checked out in `develop` mode before calling `write`.
"""
function write(mod::Module, str)
    path = pathof(mod)
    (path === nothing || !iswritable(path)) && error_write(mod, path)
    modstr = read(path, String)
    idxs = findfirst("module $mod", modstr)
    idxs === nothing && error("could not identify start of module")
    open(path, "w") do io
        print(io, modstr[1:first(idxs)-1], "\"\"\"\n", str, "\"\"\"\n", modstr[first(idxs):end])
    end
end

"""
    ModuleDocstrings.write(mod)

Modify the source file for `mod` to add an API summary docstring.

The docstring is produced by [ModuleDocstrings.generate](@ref).
The package should be checked out in `develop` mode before calling `write`.
"""
write(mod::Module) = write(mod, generate(mod))

# this is replacing, not extending, the Base function of the same name
iswritable(filename::AbstractString) = isfile(filename) && (uperm(filename) & 0x02) != 0x00

error_write(mod, ::Nothing) = error("$mod must be a writable package, but there is no corresponding file, suggesting it wasn't loaded from a package.")
error_write(mod, path::AbstractString) = error("$mod must be a writable package, but the path \"$path\" is not writable.\nDid you forget to `Pkg.develop` the package?")

end
