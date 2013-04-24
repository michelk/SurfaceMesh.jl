function show(io::IO, x::IndexedFaceSet)
    println("Elements")
    show(show(values(x.ele)))
    println("Vertices")
    show(show(values(x.nd)))
    println("Node-Strings")
    dump(x.ns)
    println("Materials")
    dump(x.mat)
end

function area(m::IndexedFaceSet)
    iEleToEle(ie::IndexedFace, ndM::Dict{Int,Vertex}) = Face(map(x->ndM[x], ie.nds), ie.mat)
    ele = map(x -> iEleToEle(x,m.nd), values(m.ele))
    map(area, ele)
end
# | Merge two IndexedFaceSetes by looking for identical boundary-edges
function merge(x::IndexedFaceSet,y::IndexedFaceSet)
    # Transform mesh into half-edge-representation
    # Look for identical edges in both meshes
    # Adjust numbering of mesh y
    # Merge the two meshes
    error("Undefined")
    # ^ Returns a merged mesh
end
# | Calculate the difference in elevation between two meshes
function diff(x::IndexedFaceSet,y::IndexedFaceSet)
    # Calculate distance for each vertex from x to y
    # Calculate distance for each vertex from y to x
    # Create a new mesh based on distances
    error("Undefined")
    # ^ Returns a difference mesh
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
        merge!(vertices,[i => Vertex(v1.x, v1.y, v2.z - v1.z)])
    end
    IndexedFaceSet(vertices, m1.fcs)
end
export diff

import Base.convert
convert(::Type{FaceSet},x::IndexedFaceSet) = 
    FaceSet(Face[Face(x.vs[f.e1], x.vs[f.e2], x.vs[f.e3]) for f = values(x.fcs)])
export convert
