using VisualizationBase: VisualizationBase, @visualize, visualize
using Test: @test, @testset

@testset "VisualizationBase" begin
  x = [2, 3]
  @test sprint(visualize, x) ==
    "2-element Vector{Int64}:\n 2\n 3\n" ==
    sprint((io, x) -> display(TextDisplay(io), x), x)
  @test sprint((io, x) -> visualize(io, x; name="y"), x) ==
    "y = \n 2-element Vector{Int64}:\n  2\n  3\n"
  @test sprint((io, x) -> @visualize(x, io=io), x) ==
    "x = \n 2-element Vector{Int64}:\n  2\n  3\n"
  @test sprint((io, x) -> @visualize(x, io=io, name="y"), x) ==
    "y = \n 2-element Vector{Int64}:\n  2\n  3\n"
end
