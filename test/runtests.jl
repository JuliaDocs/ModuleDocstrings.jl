using ModuleDocstrings
using Example   # test error on a non-devved package
using Pkg
using Test

@testset "ModuleDocstrings.jl" begin
    str = ModuleDocstrings.generate(ModuleDocstrings)
    @test occursin("ModuleDocstrings.generate", str)
    @test occursin("ModuleDocstrings.write", str)

    m = @eval Module() begin
        """
            foo1()

        `foo1` is pretty useful.
        """
        foo1() = 0

        """
        `foo2` doesn't show the signature.
        """
        foo2() = 0

        """
            foo3()

        `foo3` contains a [`$(string(@__MODULE__)).foo1`](@ref) that contains a period.
        """
        foo3()

        @__MODULE__
    end
    str = ModuleDocstrings.generate(m)
    @test occursin("- `Main.anonymous.foo1`: `foo1` is pretty useful.", str)
    @test occursin("- `Main.anonymous.foo2`: `foo2` doesn't show the signature.", str)
    @test occursin("- `Main.anonymous.foo3`: `foo3` contains a [`Main.anonymous.foo1`](@ref) that contains a period.", str)

    if Base.VERSION >= v"1.8.0-DEV.363"   # use strings in @test_throws; we don't care what type of error this is
        @test_throws "must be a writable package, but there is no corresponding file" ModuleDocstrings.write(m)
        @test_throws r"must be a writable package, but the path \".*\" is not writable" ModuleDocstrings.write(Example)
    else
        @test_throws Exception ModuleDocstrings.write(m)
        @test_throws Exception ModuleDocstrings.write(Example)
    end

    mktempdir() do pkgs
        push!(LOAD_PATH, pkgs)
        newpkgdir = joinpath(pkgs, "DevDummy")
        Pkg.generate(newpkgdir)
        open(joinpath(newpkgdir, "src", "DevDummy.jl"), "w") do io
            print(io,
"""
module DevDummy

\"\"\"
    greet()

Print a delightful greeting.
\"\"\"
greet() = print("Hello World!")

end # module
"""
            )
        end
        @eval using DevDummy
        ModuleDocstrings.write(DevDummy)
        str = read(joinpath(newpkgdir, "src", "DevDummy.jl"), String)
        @test occursin(
"""
\"\"\"
- `DevDummy.greet`: Print a delightful greeting.
\"\"\"
module DevDummy
""", str)
    end
end
