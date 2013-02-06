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

type NodeString
    id :: String
    nds :: Array{Int}
end
type Mesh
    id   :: String
    ele  :: Array{Element}
    nd   :: Array{Node}
    ns   :: Array{NodeString}
end
# | Read a .2dm (SMS Aquaveo) mesh
function read2dm(file)
    parseNode(w::Array{String}) = Node(int(w[2]), float(w[3]), float(w[4]), float(w[5]))
    parseTriangle(w::Array{String}) = Element(int(w[2]), int(w[2:4]), int(w[5]))
    parseQuad(w::Array{String}) = Element(int(w[2]), int(w[2:5]), int(w[6]))
    parseNsLine(l::String) = replace(l, r"^NS\s*", "")
    # | Parse an array of nodes which are delimited by a zero-value and id
    function parseNss(x::String)
        x_split = map(split, split(x, " -"))
        nss = Array(NodeString, 0)
        for i = 1:(length(x_split)-1)
            nds = [int(x_split[i]), int(shift!(x_split[i+1]))]
            push!(nss, NodeString(shift!(x_split[i+1]), nds))
        end
        nss
        # ^ Returns an array of NodeString
    end
    con = open(file, "r")
    nds = Array(Node,0)
    ele = Array(Element, 0)
    nsstr = ""
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
          nsstr = join([nsstr, parseNsLine(line)], " ")
        else
          continue
        end
    end
    close(con)
    nss = parseNss(nsstr)
    Mesh(replace(basename(file), ".2dm", ""), ele, nds, nss)
end

end                                     # module SurfaceMesh
