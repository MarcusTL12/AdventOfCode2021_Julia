
function parse_input(filename)
    coords = Vector{Int}[]
    folds = Tuple{Int,Int}[]

    lines = Iterators.Stateful(eachline(filename))

    for l in lines
        if isempty(l)
            break
        end
        s = split(l, ',')
        push!(coords, parse.(Int, s))
    end

    for l in lines
        _, _, s = split(l)
        axis, n = split(s, '=')
        push!(folds, (axis == "x" ? 1 : 2, parse(Int, n)))
    end

    coords, folds
end

function part1()
    coords, folds = parse_input("input/day13/input")

    (cn, n) = folds[1]
    for i = 1:length(coords)
        if coords[i][cn] > n
            coords[i][cn] = 2n - coords[i][cn]
        end
    end

    length(Set(coords))
end

function show_grid(coords)
    s = Set(coords)

    maxx = maximum(c[1] for c in s)
    maxy = maximum(c[2] for c in s)

    for i = 0:maxy
        for j = 0:maxx
            print([j, i] in s ? '#' : ' ')
        end
        println()
    end
end

function part2()
    coords, folds = parse_input("input/day13/input")

    for (cn, n) in folds
        for i = 1:length(coords)
            if coords[i][cn] > n
                coords[i][cn] = 2n - coords[i][cn]
            end
        end
    end

    show_grid(coords)
end
