using VisualizationBase: VisualizationBase
using Documenter: Documenter, DocMeta, deploydocs, makedocs

DocMeta.setdocmeta!(
  VisualizationBase, :DocTestSetup, :(using VisualizationBase); recursive=true
)

include("make_index.jl")

makedocs(;
  modules=[VisualizationBase],
  authors="ITensor developers <support@itensor.org> and contributors",
  sitename="VisualizationBase.jl",
  format=Documenter.HTML(;
    canonical="https://itensor.github.io/VisualizationBase.jl",
    edit_link="main",
    assets=["assets/favicon.ico", "assets/extras.css"],
  ),
  pages=["Home" => "index.md", "Reference" => "reference.md"],
)

deploydocs(;
  repo="github.com/ITensor/VisualizationBase.jl", devbranch="main", push_preview=true
)
