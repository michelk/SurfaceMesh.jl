module SurfaceMesh
    import Base.show
    include("Types.jl")
    include("IndexedFaceMesh.jl")
    include("Face.jl")

    #Types
    export Vertex, IndexedFace, IndexedFaceMesh, Face

    # Functions
    export read2dm, area, show
end
