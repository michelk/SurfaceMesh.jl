const na = -99999
function area(e::Face)
    push!(e.nds, e.nds[1])
    a = Array(FloatingPoint,0)
    for i = 1:(length(e.nds)-1)
        push!(a, e.nds[i].x * e.nds[i+1].y - e.nds[i+1].x *e.nds[i].y)
    end
    sum(a)
end
export area

function normal(f::Face)
    a = (f.v2 - f.v1)
    b = (f.v3 - f.v2)
    cross(a,b)
end
export normal

# | Find the face-id of the axis-vertices
function findFacesId(m::IndexedFaceSet, vs:: Array{Vertex}) # :: Arrays{Int}
    ifs = [whichFacesContain(v,m) for v = vs]
    map(ifs) do x
        if length(x) == 0
            na
        else
            (k,v) = x[1]
            k
        end
    end
end
export findFacesId
