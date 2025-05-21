using VisualizationBase: VisualizationBase, visualize
using Test: @test, @testset
using TestExtras: @constinferred

@testset "VisualizationBase" begin
  x = [2, 3]
  @test sprint(visualize, x) == sprint(show, MIME"text/plain"(), x)
  @test sprint((io, x) -> visualize(io, x; name="y"), x) ==
    sprint(VisualizationBase.show_named, "y" => x)
  @test sprint((io, x) -> @visualize(x, io=io), x) ==
    sprint(VisualizationBase.show_named, "x" => x)
  @test sprint((io, x) -> @visualize(x, io=io, name="y"), x) ==
    sprint(VisualizationBase.show_named, "y" => x)
end
