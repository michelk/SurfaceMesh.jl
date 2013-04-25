require("SurfaceMesh")
using SurfaceMesh
(m,fr) = importFrom2dm("ex.2dm")
exportTo2dm(m, fr)

