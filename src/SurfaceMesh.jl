module SurfaceMesh
using Base
export
  read2dm
 
type Node
    n :: Int
    x :: FloatingPoint
    y :: FloatingPoint
    z :: FloatingPoint
end

type Element
    n   :: Int
    ndi :: Array{Int}
    mat :: Int
end

type Mesh
    id   :: String
    ele  :: Array{Element}
    nd   :: Array{Node}
    ns   :: Array{Int}
end

function read2dm(file)
    parseNode(w) = Node(int(w[2]), float(w[3]), float(w[4]), float(w[5]))
    parseTriangle(w) = Element(int(w[2]), int(w[2:4]), int(w[5]))
    parseQuad(w) = Element(int(w[2]), int(w[2:5]), int(w[6]))
    parseNs(w) = int(w[2:(length(w))])
    con = open(file, "r")
    nds = Array(Node,0)
    ele = Array(Element, 0)
    nss = Array(Int, 0)
    for line = readlines(con)
        line = chomp(line)
        w = split(line)
        if w[1] == "ND"
          push!(nds, parseNode(w))
        elseif w[1] == "E3T"
          push!(ele, parseTriangle(w))
        elseif w[1] == "E4Q"
          push!(ele, parseQuad(w))
        elseif w[1] == "NS"
          append!(nss, parseNs(w))
        else
          continue
        end
    end
    close(con)
    Mesh(replace(basename(file), ".2dm", ""), ele, nds, nss)
end

end                                     # module SurfaceMesh
