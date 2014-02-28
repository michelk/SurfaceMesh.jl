`julia`-package to work with triangle-surface-meshes.

# Excutables

2dmTransform
:   Transform a 2dm-mesh (currently translation or scaling).
    [More](doc/2dmTransform.md)...

    Usage:

        2dmTransform --transX 49237 --transY 28385 < mesh.2md > mesh_trans.2dm

2dmDiffZ
:   Compare node-z-values of two meshes (.2dm); results in a new diff-mesh

    Usage:

        2dmDiffZ m1.2dm m2.2dm > m_diff.2dm

2dmInterpolate
:   Interpolate node-z-values from another mes

    Usage:

        1dmInterpolate to.2dm from.2dm > dest.2dm

triangleMeshToSms
:   Convert a mesh created by triangle to 2dm

    Usage:

        trianglemeshToSms triMesh.1 > triMesh.2dm"

2dmRmBcEle
:   Remove elements with certain BC_VAL

    Usage:

        2dmRmBcEle --name wall:quai mesh.2dm > mesh_holes.2dm
