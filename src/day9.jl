
const dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]

function parse_input(filename)
    data = read(filename)
    w = findfirst(==(0xa), data)
    h = length(data) ÷ w
    data .-= 0x30
    @view reshape(data, w, h)[1:end-1, :]
end

function part1()
    m = parse_input("input/day9/input")

    h, w = size(m)

    total = 0

    for i = 1:h, j = 1:w
        if all(m[i, j] < get(m, (i, j) .+ d, 9) for d in dirs)
            total += 1 + m[i, j]
        end
    end

    total
end

function traverse_from!((i, j), m)
    s = 1
    m[i, j] = 9

    h, w = size(m)

    for d in dirs
        (ni, nj) = (i, j) .+ d
        if ni in 1:h && nj in 1:w && 9 != m[ni, nj]
            s += traverse_from!((ni, nj), m)
        end
    end

    s
end

function part2()
    m = parse_input("input/day9/input")

    h, w = size(m)

    basin_sizes = [0, 0, 0]

    for j = 1:w, i = 1:h
        if m[i, j] != 9
            s = traverse_from!((i, j), m)
            push!(basin_sizes, s)
            deleteat!(basin_sizes, findmin(basin_sizes)[2])
        end
    end

    prod(basin_sizes)
end
