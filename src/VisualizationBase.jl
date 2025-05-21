module VisualizationBase

using BackendSelection: @Backend_str, AbstractBackend, Backend

export @visualize, visualize

macro visualize(x, kwargs...)
  all(kwarg -> Meta.isexpr(kwarg, :(=)), kwargs) ||
    throw(ArgumentError("All keyword arguments must be of the form `kw=value`."))
  kwargs′ = if all(kwarg -> kwarg.args[1] ≠ :name, kwargs)
    (kwargs..., :(name=$(string(x))))
  else
    kwargs
  end
  return :(visualize($(esc(x)); $(esc.(kwargs′)...)); $(esc(x)))
end

function visualize(io::IO, x; backend=Backend"Default", name=nothing, kwargs...)
  return visualize(io, to_backend(backend; kwargs...), x; name)
end

function visualize(x; backend=Backend"Default", name=nothing, io::IO=stdout, kwargs...)
  return visualize(io, to_backend(backend; kwargs...), x; name)
end

function visualize(io::IO, backend::AbstractBackend, x; name=nothing)
  name = get(backend, :name, name)
  if isnothing(name)
    visualize_unnamed(io, backend, x)
    return nothing
  end
  visualize_named(io, backend, name, x)
  return nothing
end

function visualize(backend::Backend"Default", x; name=nothing)
  io = get(backend, :io, stdout)
  visualize(io, backend, x; name)
  return nothing
end

function visualize_named(io::IO, backend::Backend"Default", name, x)
  mime = get(backend, :mime, MIME"text/plain"())
  println(io, name, " = ")
  show_indented(io, mime, x)
  println(io)
  return nothing
end

function visualize_unnamed(io::IO, ::Backend"Default", x)
  show(io, MIME"text/plain"(), x)
  println(io)
  return nothing
end

function show_indented(io::IO, mime::MIME, x; indent=" ")
  str = sprint(show, mime, x)
  str = join((indent * s for s in split(str, '\n')), '\n')
  print(io, str)
  return nothing
end

function to_backend(::Type{B}; kwargs...) where {B}
  return B(; kwargs...)
end
function to_backend(backend::Union{Symbol,String}; kwargs...)
  return Backend(backend; kwargs...)
end
function to_backend(backend::AbstractBackend; kwargs...)
  isempty(kwargs) ||
    throw(ArgumentError("Keyword arguments must be passed as part of the backend object."))
  return backend
end

end
