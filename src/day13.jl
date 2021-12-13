
function part1()
    inp = String(open(read, "input/day13/input"))
    first, second = split(inp, "\n\n")

    coords = [parse.(Int, split(l, ',')) for l in split(first)]
    folds = [
        begin
            _, _, s = split(l)
            axis, n = split(s, '=')
            (axis, parse(Int, n))
        end for l in split(second, '\n')
    ]

    for (axis, n) in folds
        cn = axis == "x" ? 1 : 2
        for i = 1:length(coords)
            if coords[i][cn] > n
                coords[i][cn] = 2n - coords[i][cn]
            end
        end
        break
    end

    length(Set(coords))
end

function show_grid(coords)
    maxx = maximum(c[1] for c in coords)
    maxy = maximum(c[2] for c in coords)

    grid = falses(maxy + 1, maxx + 1)

    for (x, y) in coords
        grid[y+1, x+1] = true
    end

    for row in eachrow(grid)
        for b in row
            print(b ? '#' : ' ')
        end
        println()
    end
end

function part2()
    inp = String(open(read, "input/day13/input"))
    first, second = split(inp, "\n\n")

    coords = [parse.(Int, split(l, ',')) for l in split(first)]
    folds = [
        begin
            _, _, s = split(l)
            axis, n = split(s, '=')
            (axis, parse(Int, n))
        end for l in split(second, '\n')
    ]

    for (axis, n) in folds
        cn = axis == "x" ? 1 : 2
        for i = 1:length(coords)
            if coords[i][cn] > n
                coords[i][cn] = 2n - coords[i][cn]
            end
        end
    end

    show_grid(coords)
end
