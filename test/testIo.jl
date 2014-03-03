require("SurfaceMesh")
using SurfaceMesh
(m,fr) = read2dm("ex.2dm")
write2dm(m, fr)

