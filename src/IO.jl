# Readers
#========

# | Read a .2dm (SMS Aquaveo) mesh-file and construct a 'IndexedFaceSet'
function importFrom2dm(con::IOStream)
    function parseNode(w::Array{String})
        
    end
    nds = VertexMap()
    fcs = IndexedFaceMap()
    frs = Dict{Index,Index}()
    for line = readlines(con)
        line = chomp(line)
        w = split(line)
        if w[1] == "ND"
            nds[int(w[2])] = Vertex(float(w[3]), float(w[4]), float(w[5]))
        elseif w[1] == "E3T"
            i = int(w[2])
            fcs[i] = IndexedFace(int(w[3]), int(w[4]), int(w[5]))  
            frs[i] = int(w[6])
        elseif w[1] == "E4Q"
            error("Only triangular-meshes currently supported")
        else
            continue
        end
    end
    (IndexedFaceSet(nds,fcs), frs)
end

importFrom2dm(file::String) = open(importFrom2dm,file)
export importFrom2dm
# Writers
#========

# | Write 'IndexedFaceSet' to an IOStream
function exportTo2dm(m::IndexedFaceSet, frs :: Dict{Index, Index}, con::IO)
    function renderVertex(i::Int,v::Vertex) # :: String
        "ND $i $(v.e1) $(v.e2) $(v.e3)\n"
    end
    function renderIndexedFace(i::Int, f::IndexedFace, fr::Index) # :: String
        "E3T $i $(f.v1) $(f.v2) $(f.v3) $fr\n"
    end
    write(con, "MESH2D\n")
    write(con, "NUM_MATERIALS_PER_ELEM 1\n")
    for i = sort(keys(m.fcs))
        write(con, renderIndexedFace(i, m.fcs[i], frs[i]))
    end
    for i = sort(keys(m.vs))
        write(con, renderVertex(i, m.vs[i]))
    end
    nothing
end

exportTo2dm(m::IndexedFaceSet, frs :: Dict{Index, Index}) = exportTo2dm(m,frs,STDOUT)

# | Write a 'IndexedFaceSet' to file in SMS-.2dm-file-format
function exportTo2dm(m::IndexedFaceSet, frs :: Dict{Index, Index}, f::String)
    con = open(f, "w")
    exportTo2dm(m, frs, con)
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
