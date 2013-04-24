# Readers
#========

# | Read a .2dm (SMS Aquaveo) mesh-file and construct a 'IndexedFaceSet'
function importFrom2dm(con::IOStream)
    function parseNode(w::Array{String})
        [int(w[2]) => Vertex(float(w[3]), float(w[4]), float(w[5]))]
    end
    function parseTriangle(w::Array{String})
        [int(w[2]) => IndexedFace(int(w[3]), int(w[4]), int(w[5]))]
    end 
    nds =  VertexMap()
    fcs = IndexedFaceMap()
    for line = readlines(con)
        line = chomp(line)
        w = split(line)
        if w[1] == "ND"
            merge!(nds, parseNode(w))
        elseif w[1] == "E3T"
            merge!(fcs, parseTriangle(w))
        elseif w[1] == "E4Q"
            error("Only triangular-meshes currently supported")
        else
            continue
        end
    end
    IndexedFaceSet(nds,fcs)
end

function importFrom2dm(file::String)
    open(importFrom2dm,file)
end
export importFrom2dm
# Writers
#========

# | Write 'IndexedFaceSet' to an IOStream
function exportTo2dm(con::IO,m::IndexedFaceSet)
    function renderVertex(i::Int,v::Vertex) # :: String
        "ND $i $(v.e1) $(v.e2) $(v.e3)\n"
    end
    function renderIndexedFace(i::Int, f::IndexedFace) # :: String
        "E3T $i $(f.v1) $(f.v2) $(f.v3) 0\n"
    end
    write(con, "MESH2D\n")
    for i = keys(m.fcs)
        write(con, renderIndexedFace(i, m.fcs[i]))
    end
    for i = keys(m.vs)
        write(con, renderVertex(i, m.vs[i]))
    end
    nothing
end

# | Write a 'IndexedFaceSet' to file in SMS-.2dm-file-format
function exportTo2dm(f::String,m::IndexedFaceSet)
    con = open(f, "w")
    exportTo2dm(con, m)
    close(con)
    nothing
end
export exportTo2dm

# | Render 'FaceSet' as Stl-string
function exportToStl(m::FaceSet)
    renderVertex(v)  = "    vertex $(v.x) $(v.y)  $(v.z)"
    function renderFace(f)
        fn = normal(f)
        fn_header= "facet normal $(fn.x) $(fn.y) $(fn.z)" 
        v_start  = "  outer loop"
        v        = join(map(renderVertex, [f.v1,f.v2,f.v3]), "\n")
        v_end    = "  endloop"
        f_footer = "endfacet"
        join([fn_header,v_start, v, v_end,f_footer], "\n")
    end
    header = "solid "
    fs = join(map(renderFace, m.faces), "\n")
    footer = "endsolid "                     
    join([header, fs, footer], "\n")
end

# | Write an 'FaceSet' as Stl to 'IOStream'
function exportToStl(m::FaceSet, con::IOStream)
    write(con, exportToStl(m))
end

# | Write an 'FaceSet' as Stl into a file
function exportToStl(m::FaceSet, f::String)
    con = open(f, "w")
    exportToStl(m, con)
    close(con)
    nothing
end
export exportToStl
