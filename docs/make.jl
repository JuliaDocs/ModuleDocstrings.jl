using ModuleDocstrings
using Documenter

DocMeta.setdocmeta!(ModuleDocstrings, :DocTestSetup, :(using ModuleDocstrings); recursive=true)

makedocs(;
    modules=[ModuleDocstrings],
    authors="Tim Holy <tim.holy@gmail.com> and contributors",
    # repo="https://github.com/JuliaDocs/ModuleDocstrings.jl/blob/{commit}{path}#{line}",
    sitename="ModuleDocstrings.jl",
    format=Documenter.HTML(;
        canonical="https://JuliaDocs.github.io/ModuleDocstrings.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
    warnonly=[:missing_docs],
)

deploydocs(;
    repo="github.com/JuliaDocs/ModuleDocstrings.jl",
    devbranch="main",
    push_preview = true,
)
