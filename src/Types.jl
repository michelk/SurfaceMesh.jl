#s Index Face Mesh Represenation
#=================================
type Vertex
    x :: FloatingPoint
    y :: FloatingPoint
    z :: FloatingPoint
end

type IndexedFace
    nds :: Array{Int}
    mat :: Array{Int}
end

type IndexedFaceMesh
    id   :: String
    ele  :: Dict{Int, IndexedFace}
    nd   :: Dict{Int,Vertex}
    ns   :: Dict{Int,Array{Int}}
    mat  :: Dict{Int,String}
end

# Face Mesh Representation
#============================

type Face
    nds :: Array{Vertex}
    mat :: Array{Int}
end

