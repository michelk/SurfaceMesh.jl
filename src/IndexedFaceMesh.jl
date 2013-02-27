function show(io::IO, x::IndexedFaceMesh)
    println("Elements")
    show(show(values(x.ele)))
    println("Vertices")
    show(show(values(x.nd)))
    println("Node-Strings")
    dump(x.ns)
    println("Materials")
    dump(x.mat)
end

# | Read a .2dm (SMS Aquaveo) mesh
function read2dm(file::String)
    # | Parse an array of nodes which are delimited by a zero-value and id
    function parseNss(x::String)
        x_split = map(split, split(x, " -"))
        nss = Dict{Int,Array{Int}}()
        for i = 1:(length(x_split)-1)
            nds = [int(x_split[i]), int(shift!(x_split[i+1]))]
            nss[int(shift!(x_split[i+1]))] = nds
        end
        nss         # ^ Returns an array of NodeString
    end
    parseNode(w::Array{String}) = (int(w[2]), float(w[3]), float(w[4]), float(w[5]))
    parseTriangle(w::Array{String}) = (int(w[2]), int(w[2:4]), [int(w[5])])
    parseQuad(w::Array{String}) = (int(w[2]), int(w[2:5]), [int(w[6])])
    parseNsLine(l::String) = replace(l, r"^NS\s*", "")
    con = open(file, "r")
    nd = Dict{Int,Vertex}() 
    ele = Dict{Int, IndexedFace}()
    nsstr = ""
    mat = Dict{Int, String}()
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

function area(m::IndexedFaceMesh)
    iEleToEle(ie::IndexedFace, ndM::Dict{Int,Vertex}) = Face(map(x->ndM[x], ie.nds), ie.mat)
    ele = map(x -> iEleToEle(x,m.nd), values(m.ele))
    map(area, ele)
end
# | Merge two IndexedFaceMeshes by looking for identical boundary-edges
function merge(x::IndexedFaceMesh,y::IndexedFaceMesh)
    # Transform mesh into half-edge-representation
    # Look for identical edges in both meshes
    # Adjust numbering of mesh y
    # Merge the two meshes
    error("Undefined")
    # ^ Returns a merged mesh
end
# | Calculate the difference in elevation between two meshes
function diff(x::IndexedFaceMesh,y::IndexedFaceMesh)
    # Calculate distance for each vertex from x to y
    # Calculate distance for each vertex from y to x
    # Create a new mesh based on distances
    error("Undefined")
    # ^ Returns a difference mesh
end
