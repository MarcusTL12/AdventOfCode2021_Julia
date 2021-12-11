
function part1()
    inp = [l for l in eachline("input/day11/input")]

    w = length(inp[1])
    h = length(inp)

    m = zeros(Int, w, h)

    for (i, l) in enumerate(inp)
        for (j, c) in enumerate(l)
            m[i, j] = c - '0'
        end
    end

    dirs = [
        (0, 1),
        (1, 1),
        (1, 0),
        (1, -1),
        (0, -1),
        (-1, -1),
        (-1, 0),
        (-1, 1),
    ]

    flashed = falses(w, h)

    total = 0

    for _ = 1:100
        for i = 1:h, j = 1:w
            m[i, j] += 1
        end

        flashed .= false

        while true
            didflash = false
            for i = 1:h, j = 1:w
                if m[i, j] > 9 && !flashed[i, j]
                    flashed[i, j] = true
                    didflash = true
                    total += 1
                    for d in dirs
                        (ni, nj) = (i, j) .+ d
                        if ni in 1:w && nj in 1:h
                            m[ni, nj] += 1
                        end
                    end
                end
            end
            if !didflash
                break
            end
        end

        for i = 1:h, j = 1:w
            if flashed[i, j]
                m[i, j] = 0
            end
        end
    end

    total
end

function part2()
    inp = [l for l in eachline("input/day11/input")]

    w = length(inp[1])
    h = length(inp)

    m = zeros(Int, w, h)

    for (i, l) in enumerate(inp)
        for (j, c) in enumerate(l)
            m[i, j] = c - '0'
        end
    end

    dirs = [
        (0, 1),
        (1, 1),
        (1, 0),
        (1, -1),
        (0, -1),
        (-1, -1),
        (-1, 0),
        (-1, 1),
    ]

    flashed = falses(w, h)

    for stepnumber = Iterators.countfrom(1)
        for i = 1:h, j = 1:w
            m[i, j] += 1
        end

        flashed .= false

        while true
            didflash = false
            for i = 1:h, j = 1:w
                if m[i, j] > 9 && !flashed[i, j]
                    flashed[i, j] = true
                    didflash = true
                    for d in dirs
                        (ni, nj) = (i, j) .+ d
                        if ni in 1:w && nj in 1:h
                            m[ni, nj] += 1
                        end
                    end
                end
            end
            if !didflash
                break
            end
        end

        for i = 1:h, j = 1:w
            if flashed[i, j]
                m[i, j] = 0
            end
        end

        if all(flashed)
            return stepnumber
        end
    end
end
