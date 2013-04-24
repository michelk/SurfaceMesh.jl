require("SurfaceMesh")
using SurfaceMesh
m = importFrom2dm("ex.2dm")
exportTo2dm(m, "exOut.2dm")
