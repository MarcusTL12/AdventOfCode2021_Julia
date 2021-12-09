
function part1()
    inp = [l for l in eachline("input/day9/input")]

    m = zeros(Int, length(inp), length(inp[1]))

    for (i, l) in enumerate(inp)
        for (j, c) in enumerate(l)
            m[i, j] = c - '0'
        end
    end

    h, w = size(m)

    total = 0

    dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]

    for i = 1:h, j = 1:w
        if all(m[i, j] < get(m, (i, j) .+ d, typemax(Int)) for d in dirs)
            total += 1 + m[i, j]
        end
    end

    total
end

function traverse_from!((i, j), m, basins, num, s)
    dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]

    s[] += 1
    basins[i, j] = num

    h, w = size(m)

    for d in dirs
        (ni, nj) = (i, j) .+ d
        if ni in 1:h && nj in 1:w && 9 > m[ni, nj] > m[i, j] &&
           basins[ni, nj] == 0
            traverse_from!((ni, nj), m, basins, num, s)
        end
    end
end

function part2()
    inp = [l for l in eachline("input/day9/input")]

    m = zeros(Int, length(inp), length(inp[1]))

    for (i, l) in enumerate(inp)
        for (j, c) in enumerate(l)
            m[i, j] = c - '0'
        end
    end

    h, w = size(m)

    dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]

    basin_mins = Tuple{Int,Int}[]

    for i = 1:h, j = 1:w
        if all(m[i, j] < get(m, (i, j) .+ d, typemax(Int)) for d in dirs)
            push!(basin_mins, (i, j))
        end
    end

    basins = zeros(Int, size(m))
    basin_sizes = Int[]

    for (i, pos) in enumerate(basin_mins)
        s = Ref(0)
        traverse_from!(pos, m, basins, i, s)
        push!(basin_sizes, s[])
    end

    sort!(basin_sizes)

    prod(basin_sizes[end-2:end])
end
