module SurfaceMesh
using Base
export
  read2dm
 
type Node
    n :: Int32
    x :: Float32
    y :: Float32
    z :: Float32
end

type Element
    n   :: Int32
    ndi :: Array{Int32}
    mat :: Int32
end


type Mesh
    id   :: String
    ele  :: Array{Element}
    nd   :: Array{Node}
    ns   :: Array{Int32}
end

function read2dm(file)
    parseNode(w) = Node(int32(w[2]), float32(w[3]), float32(w[4]), float32(w[5]))
    parseTriangle(w) = Element(int32(w[2]), int32(w[2:4]), int32(w[5]))
    parseQuad(w) = Element(int32(w[2]), int32(w[2:5]), int32(w[6]))
    parseNs(w) = int32(w[2:(length(w))])
    con = open(file, "r")
    nds = Array(Node,0)
    ele = Array(Element, 0)
    nss = Array(Int32, 0)
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
          push!(nss, parseNs(w))
        else
          continue
        end
    end
    close(con)
    Mesh(file, parse2dmElements(f))
end
function parse2dm(file)
    nodes = parse2dmNodes(file)
    parse2dmElements(con, nodes)
end

function parse2dmNodes(file)
    con = open(file, "r")
    nodes = Array(Node,0)
    nodes
end

function parse2dmElements(file, nds::Array{Node})
    con = open(file, "r")
    elements = Array(Element,0)
    nds_inds = map(x -> x.n, nds)
    for line = readlines(con)
        line = chomp(line)
        m = match(r"^ *E", line)
        if m != nothing
            dim = int(string(line[2]))
            n = split(line, " ")[2:(2+dim)]
            c = map(int, n)
            nele = shift(c)
            nodes = map(x -> ,c)
            ele = parse("Element($(c[1]), $(join(c[2:length(c)], ',')))")
            insert(nodes, nd)
        end
    end
    nodes[2:length(nodes)]
end

function center(e::Element)
    des = Dict{Int64,Coord} 
end

end                                     # module SurfaceMesh
