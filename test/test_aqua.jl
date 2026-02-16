using Aqua: Aqua
using Test: @testset
using VisualizationBase: VisualizationBase

@testset "Code quality (Aqua.jl)" begin
    Aqua.test_all(VisualizationBase)
end
