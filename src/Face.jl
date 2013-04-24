function area(e::Face)
    push!(e.nds, e.nds[1])
    a = Array(FloatingPoint,0)
    for i = 1:(length(e.nds)-1)
        push!(a, e.nds[i].x * e.nds[i+1].y - e.nds[i+1].x *e.nds[i].y)
    end
    sum(a)
end

function normal(f::Face)
    a = (f.v2 - f.v1)
    b = (f.v3 - f.v2)
    cross(a,b)
end
export normal
