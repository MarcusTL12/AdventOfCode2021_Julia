
function parse_input(filename)
    inp = String(open(read, filename))

    a, b = split(inp, "\n\n")

    a = BitVector(c == '#' for c in a)
    m = Dict{Tuple{Int,Int},Bool}()
    for (i, l) in enumerate(split(b, '\n')), (j, c) in enumerate(l)
        m[(i, j)] = c == '#'
    end

    a, m
end

function find_corners(image)
    minx = maxx = miny = maxy = 0
    for ((x, y), _) in image
        minx = min(minx, x)
        maxx = max(maxx, x)
        miny = min(miny, y)
        maxy = max(maxy, y)
    end
    minx, maxx, miny, maxy
end

function part1()
    kernels, image = parse_input("input/day20/input")

    default = false

    for _ = 1:2
        minx, maxx, miny, maxy = find_corners(image)
        new_image = typeof(image)()
        for y = miny-3:maxy+3, x = minx-3:maxx+3
            n = 0
            for dy = 0:2, dx = 0:2
                n = 2n + get(image, (y + dy, x + dx), default)
            end
            new_image[(y, x)] = kernels[n+1]
        end
        image = new_image
        default ⊻= kernels[1]
    end

    count(values(image))
end

function part2()
    kernels, image = parse_input("input/day20/input")

    default = false

    for _ = 1:50
        minx, maxx, miny, maxy = find_corners(image)
        new_image = typeof(image)()
        for y = miny-3:maxy+3, x = minx-3:maxx+3
            n = 0
            for dy = 0:2, dx = 0:2
                n = 2n + get(image, (y + dy, x + dx), default)
            end
            new_image[(y, x)] = kernels[n+1]
        end
        image = new_image
        default ⊻= kernels[1]
    end

    count(values(image))
end
