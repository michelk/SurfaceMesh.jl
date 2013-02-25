module SurfaceMesh
using Base
export
  read2dm
 
# Indexed Face Mesh Represenation
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
    mat  :: Dict{Int, String}
end

# Face Mesh Representation
#============================

type Face
    n   :: Int
    nds :: Array{Vertex}
    mat :: Array{String}
end
# | Read a .2dm (SMS Aquaveo) mesh
function read2dm(file)
    #file = "../test/ex.2dm"
    parseNode(w::Array{String}) = (int(w[2]), float(w[3]), float(w[4]), float(w[5]))
    parseTriangle(w::Array{String}) = (int(w[2]), int(w[2:4]), [int(w[5])])
    parseQuad(w::Array{String}) = (int(w[2]), int(w[2:5]), [int(w[6])])
    parseNsLine(l::String) = replace(l, r"^NS\s*", "")
    # | Parse an array of nodes which are delimited by a zero-value and id
    function parseNss(x::String)
        x_split = map(split, split(x, " -"))
        nss = Dict{Int,Array{Int}}()
        for i = 1:(length(x_split)-1)
            nds = [int(x_split[i]), int(shift!(x_split[i+1]))]
            nss[int(shift!(x_split[i+1]))] = nds
        end
        nss
        # ^ Returns an array of NodeString
    end
    con = open(file, "r")
    nd = Dict{Int,Vertex}() 
    ele = Dict{Int, IndexedFace}()
    nsstr = ""
    mat = Dict{Int, String}()
    #line = readline(con)
    for line = readlines(con)
        line = chomp(line)
        w = split(line)
        if w[1] == "ND"
            (i,x,y,z) = parseNode(w)
            nd[i] = Vertex(x,y,z)
        elseif w[1] == "E3T"
            (i,n,m) = parseTriangle(w)
            ele[i] = IndexedFace(n,m)
        elseif w[1] == "E4Q"
            (i,n,m) = parseQuad(w)
            ele[i] = IndexedFace(n,m)
        elseif w[1] == "NS"
            nsstr = join([nsstr, parseNsLine(line)], " ")
        elseif w[1] == "MAT"
            mat[int(w[2])] = w[3]
        else
            continue
        end
    end
    close(con)
    nss = parseNss(nsstr)
    IndexedFaceMesh(replace(basename(file), ".2dm", ""), ele, nd, nss, mat)
end
end                                     # module SurfaceMesh
