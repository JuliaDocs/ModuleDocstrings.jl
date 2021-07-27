using ModuleDocstrings
using Test

@testset "ModuleDocstrings.jl" begin
    str = ModuleDocstrings.generate(ModuleDocstrings)
    @test occursin("ModuleDocstrings.generate", str)
    @test occursin("ModuleDocstrings.write", str)
end
