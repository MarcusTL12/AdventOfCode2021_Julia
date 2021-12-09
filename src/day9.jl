
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
        is_low = all(m[i, j] < get(m, (i, j) .+ d, typemax(Int)) for d in dirs)

        if is_low
            total += 1 + m[i, j]
        end
    end

    total
end

function traverse_from!((i, j), m, locs)
    dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]

    push!(locs, (i, j))

    h, w = size(m)

    for d in dirs
        (ni, nj) = (i, j) .+ d
        if ni in 1:h && nj in 1:w && m[ni, nj] < m[i, j]
            traverse_from!((ni, nj), m, locs)
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

    amt_basins = 0

    basins = zeros(Int, size(m))

    for i = 1:h, j = 1:w
        is_low = all(m[i, j] < get(m, (i, j) .+ d, typemax(Int)) for d in dirs)

        if is_low
            amt_basins += 1
            basins[i, j] = amt_basins
        end
    end

    loc_buf = Tuple{Int,Int}[]

    for i = 1:h, j = 1:w
        if basins[i, j] == 0 && m[i, j] != 9
            empty!(loc_buf)
            traverse_from!((i, j), m, loc_buf)

            basin_num = basins[last(loc_buf)...]

            for (i_, j_) in loc_buf
                basins[i_, j_] = basin_num
            end
        end
    end

    basin_sizes = zeros(Int, amt_basins)

    for i = 1:h, j = 1:w
        if basins[i, j] != 0
            basin_sizes[basins[i, j]] += 1
        end
    end

    sort!(basin_sizes)

    prod(basin_sizes[end-2:end])
end
