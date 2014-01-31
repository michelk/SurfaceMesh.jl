import Base.show
function show(io::IO, x::IndexedFaceSet)
    println("")
end
export show

function area(m::IndexedFaceSet)
    iEleToEle(ie::IndexedFace, ndM::Dict{Int,Vertex}) = Face(map(x->ndM[x], ie.nds), ie.mat)
    ele = map(x -> iEleToEle(x,m.nd), values(m.ele))
    map(area, ele)
end
export area

# | Merge two IndexedFaceSetes by looking for identical boundary-edges
function merge(x::IndexedFaceSet,y::IndexedFaceSet)
    # Transform mesh into half-edge-representation
    # Look for identical edges in both meshes
    # Adjust numbering of mesh y
    # Merge the two meshes
    error("Undefined")
    # ^ Returns a merged mesh
end

# | Difference between two meshes as new mesh ; currently they could
#   only differ in vertex-z values
# 
#   TODO : Implement difference between arbitrary surfaces
function diff(m1::IndexedFaceSet,m2::IndexedFaceSet)
    vertices = VertexMap()
    for i = keys(m1.vs)
        v1 = m1.vs[i]
        v2 = m2.vs[i]
        merge!(vertices,[i => Vertex(v1.e1, v1.e2, v2.e3 - v1.e3)])
    end
    IndexedFaceSet(vertices, m1.fcs)
end
export diff

import Base.convert
convert(::Type{FaceSet},x::IndexedFaceSet) =
    FaceSet(Face[Face(x.vs[f.e1], x.vs[f.e2], x.vs[f.e3]) for f = values(x.fcs)])
export convert
