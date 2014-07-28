Face(ifc::IndexedFace, nds :: VertexMap) =  Face(nds[ifc.v1], nds[ifc.v2], nds[ifc.v3])

# | Interpolate z-value of the vertices from one  'Mesh' to another 'Mesh'
function interpolateZ(m::IndexedFaceSet,from::IndexedFaceSet) #:: IndexedFaceSet 
    nds = (Index => Vertex)[i => interpolateZ(m.vs[i], from) for i = keys(m.vs)]
    IndexedFaceSet(nds,m.fcs)
end

# | Interpolate a single 'Vertex' from 'IndexedFaceSet'
function interpolateZ(v::Vertex, m :: IndexedFaceSet) # :: Vertex
        fc = filter(x -> contains(x,v), [Face(f,m.vs) for f = values(m.fcs)])
        if length(fc) == 0
            v
        else    
            interpolateZ(v,fc[1])
        end 
end

# | Filter those faces which contain the vertex
function whichFacesContain(v :: Vertex, m :: IndexedFaceSet)
    filter([(k,Face(f,m.vs)) for (k,f) = m.fcs]) do x
        (k,f) = x
        contains(f,v)
    end
end
export whichFacesContain

# | Interpolate a single vertex from 'IndexedFaceSet' with certain 'Face'-Id
function interpolateZ(v::Vertex, i :: Int, m :: IndexedFaceSet) # :: Vertex
        f = Face(m.fcs[i],m.vs)
        interpolateZ(v,f)
end

# | Interpolate elevation of a set of xy-vertices from an 'IndexedFaceSet'
function interpolateZ(vs::Vector{Vertex}, m :: IndexedFaceSet) # ::Vector{Vertex}
    map(v -> interpolateZ(v,m), vs)
end

# | Interpolate elevation of a set of xy-vertices from an 'IndexedFaceSet' with
#   certain face-ids to accelerate search
function interpolateZ(vs::Vector{Vertex}, is :: Vector{Int}, m :: IndexedFaceSet) # ::Vector{Vertex}
    Vertex[interpolateZ(vs[i],is[i],m) for i = 1:length(vs)]
end

# | Interpolate the elevation of 'Vertex' from a 'IndexedFace'
function interpolateZ(v::Vertex, f::Face) # :: Vertex
    if contains(f,v)
        interpolateZ(v, plane(f.v1, f.v2, f.v3))
    else
        v
    end
end

# | Interpolate the elevation 
function interpolateZ(v::Vertex,p::Plane) # :: Vertex
    z = -((p.e1*v.e1 + p.e2*v.e2 + p.e4)/p.e3)
    Vertex(v.e1, v.e2, z)
end
export  interpolateZ

import Base.sign
function sign(v1::Vertex,v2::Vertex,v3::Vertex)
    (v1.e1 - v3.e1) * (v2.e2 - v3.e2) - (v2.e1 - v3.e1) * (v1.e2 - v3.e2)
end

# | Checks if 'Vertex's xy-position lies inside a Face
#   Code from http://stackoverflow.com/questions/2049582/how-to-determine-a-point-in-a-triangle
import Base.contains
function contains(f::Face, v::Vertex) # :: Bool
    b1 = sign(v, f.v1, f.v2) < 0
    b2 = sign(v, f.v2, f.v3) < 0
    b3 = sign(v, f.v3, f.v1) < 0
    (b1 == b2) && (b2 == b3)
end
export contains

