#!/usr/bin/env julia
if length(ARGS) != 1
    error("Usage: perf.jl <2dm>")
end
require("SurfaceMesh")
using SurfaceMesh
m = read2dm(ARGS[1])
a = area(m)
exit()
