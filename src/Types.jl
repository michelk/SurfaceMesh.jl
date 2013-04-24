#s Index Face Represenation
#==========================
# Takes so long for loading; currently disabled
#using ImmutableArrays
#typealias Vertex         Vector3{Float64}
immutable Vertex
  e1 :: Vertex
  e2 :: Vertex
  e3 :: Vertex
end

typealias Index          Int
typealias VertexMap      Dict{Index, Vertex}

immutable IndexedFace
    v1 :: Index
    v2 :: Index
    v3 :: Index
end

typealias IndexedFaceMap Dict{Index, IndexedFace}


type IndexedFaceSet
    vs  :: VertexMap
    fcs :: IndexedFaceMap
end


# Face Mesh Representation
#=========================
immutable Face
    v1 :: Vertex
    v2 :: Vertex
    v3 :: Vertex
end

typealias FaceSet Array{Face}


# Misc Types
#===========

# Planes (copied from the Meshes module)
# --------------------------------------

#typealias Plane Vector4{Float64}
immutable Plane
    e1 :: Float64
    e2 :: Float64
    e3 :: Float64
    e4 :: Float64
end

# Given three vertices, determines coefficients of the
# corresponding plane equation
function plane(v1::Vertex,v2::Vertex,v3::Vertex)
    n = unit(cross(v1-v2,v3-v2))
    d = dot(n,v2)
    p = Plane(n.e1,n.e2,n.e3,-d)
end
