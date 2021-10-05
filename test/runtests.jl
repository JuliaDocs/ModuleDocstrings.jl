using ModuleDocstrings
using Test

@testset "ModuleDocstrings.jl" begin
    str = ModuleDocstrings.generate(ModuleDocstrings)
    @test occursin("ModuleDocstrings.generate", str)
    @test occursin("ModuleDocstrings.write", str)

    str = ModuleDocstrings.generate(@eval Module() begin
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
    end)
    @test occursin("- `Main.anonymous.foo1`: `foo1` is pretty useful.", str)
    @test occursin("- `Main.anonymous.foo2`: `foo2` doesn't show the signature.", str)
    @test occursin("- `Main.anonymous.foo3`: `foo3` contains a [`Main.anonymous.foo1`](@ref) that contains a period.", str)
end
