# Readers
# =======

# | Read a .2dm (SMS Aquaveo) mesh-file and construct a 'IndexedFaceSet'
function importFrom2dm(con::IOStream) # :: SmsMesh
    parseNsLine(l::String) = replace(l, r"^NS\s*", "")
    # | Parse an array of nodes which are delimited by a zero-value and id
    function parseNss(x::String) # :: Dic{Int,Array{Int}}
        x_split = map(split, split(x, " -"))
        nss = Dict{Int,Array{Int}}()
        if length(x_split) == 2
            nss[1] = [int(x_split[1][2:length(x_split[1])]), int(x_split[2])]
        else
            for i = 1:(length(x_split)-1)
                nds = [int(x_split[i]), int(shift!(x_split[i+1]))]
                nss[int(shift!(x_split[i+1]))] = nds
            end
        end
        nss         # ^ Returns an array of NodeString
    end
    nsstr = ""
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
            error("Only triangular-meshes currently supported, sorry.")

        elseif w[1] == "NS"
            nsstr = join([nsstr, parseNsLine(line)], " ")
        else
            continue
        end
    end
    SmsMesh(IndexedFaceSet(nds,fcs), frs, parseNss(nsstr))
end

importFrom2dm(file::String) = open(importFrom2dm,file)
export importFrom2dm

# Writers
# =======
# | Write 'IndexedFaceSet' to an IOStream
function exportTo2dm(m::SmsMesh, con::IO)
    function renderVertex(i::Int,v::Vertex) # :: String
        "ND $i $(v.e1) $(v.e2) $(v.e3)\n"
    end
    function renderIndexedFace(i::Int, f::IndexedFace, fr::Index) # :: String
        "E3T $i $(f.v1) $(f.v2) $(f.v3) $fr\n"
    end
    write(con, "MESH2D\n")
    write(con, "NUM_MATERIALS_PER_ELEM 1\n")
    # Write faces
    # TODO use: sort(keys(m.msh.fcs)); currently there seems to be a bu
    for i = 1:length(m.msh.fcs)
        write(con, renderIndexedFace(i, m.msh.fcs[i], m.frs[i]))
    end
    # Write vertices
    # TODO use: sort(keys(m.msh.vs))
    for i = 1:length(m.msh.vs)
        write(con, renderVertex(i, m.msh.vs[i]))
    end
    nothing
end

exportTo2dm(m::SmsMesh) = exportTo2dm(m,STDOUT)

# | Write a 'IndexedFaceSet' to file in SMS-.2dm-file-format
function exportTo2dm(m:: SmsMesh, f::String)
    con = open(f, "w")
    exportTo2dm(m, con)
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
