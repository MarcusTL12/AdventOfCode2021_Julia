
function makeset(x1, y1, x2, y2)
    slope = (y2 - y1) // (x2 - x1)
    dx = abs(denominator(slope)) * sign(x2 - x1)
    dy = abs(numerator(slope)) * sign(y2 - y1)

    s = Set{Tuple{Int,Int}}(((x1, y1),))
    while (x1, y1) != (x2, y2)
        x1 += dx
        y1 += dy
        push!(s, (x1, y1))
    end
    s
end

function part1()
    reg = r"(\d+),(\d+) -> (\d+),(\d+)"

    inp = [
        parse.(Int, match(reg, l).captures)
        for l in eachline("input/day5/input")
    ]

    filter!(((x1, y1, x2, y2),) -> x1 == x2 || y1 == y2, inp)

    lines = [makeset(l...) for l in inp]

    allpoints = eltype(lines)()
    for l in lines
        union!(allpoints, l)
    end

    counter = 0
    for p in allpoints
        c = count(s -> p in s, lines)
        counter += c >= 2
    end
    counter
end

function part2()
    reg = r"(\d+),(\d+) -> (\d+),(\d+)"

    inp = [
        parse.(Int, match(reg, l).captures)
        for l in eachline("input/day5/input")
    ]

    lines = [makeset(l...) for l in inp]

    allpoints = eltype(lines)()
    for l in lines
        union!(allpoints, l)
    end

    counter = 0
    for p in allpoints
        c = count(s -> p in s, lines)
        counter += c >= 2
    end
    counter
end
