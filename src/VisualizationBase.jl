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
  return :(visualize($(esc(x)); $(esc.(kwargs′)...)))
end

function visualize(io::IO, x; backend=Backend"Default", name=nothing, kwargs...)
  return visualize(io, to_backend(backend; kwargs...), x; name)
end

function visualize(x; backend=Backend"Default", name=nothing, io::IO=stdout, kwargs...)
  return visualize(io, to_backend(backend; kwargs...), x; name)
end

function visualize(io::IO, backend::Backend"Default", x; name=nothing)
  name = get(backend, :name, name)
  if !isnothing(name)
    return show_named(io, MIME"text/plain"(), name => x)
  end
  return show(io, MIME"text/plain"(), x)
end

function visualize(backend::Backend"Default", x; name=nothing)
  io = get(backend, :io, stdout)
  return visualize(io, backend, x; name)
end

function show_named(io::IO, mime, (name, x))
  println(io, name, " = ")
  return show_indented(io, mime, x)
end
function show_named(io::IO, named_x)
  return show_named(io, MIME"text/plain"(), named_x)
end
function show_named(named_x)
  return show_named(stdout, named_x)
end

function show_indented(io::IO, mime, x; indent=" ")
  str = sprint(show, mime, x)
  str = join((indent * s for s in split(str, '\n')), '\n')
  print(io, str)
  return nothing
end
function show_indented(io::IO, x; kwargs...)
  return show_indented(io, MIME"text/plain"(), x; indent)
end
function show_indented(x; kwargs...)
  return show_indented(stdout, x; kwargs...)
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
