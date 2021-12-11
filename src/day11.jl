
const dirs = [
    (0, 1),
    (1, 1),
    (1, 0),
    (1, -1),
    (0, -1),
    (-1, -1),
    (-1, 0),
    (-1, 1),
]

function parse_input(filename)
    data = read(filename)
    w = findfirst(==(0xa), data)
    h = length(data) ÷ w
    data .-= 0x30
    @view reshape(data, w, h)[1:end-1, :]
end

function part1()
    m = parse_input("input/day11/input")
    w, h = size(m)

    total = 0

    for _ = 1:100
        for i = 1:h, j = 1:w
            m[i, j] += 1
        end

        while true
            didflash = false
            for i = 1:h, j = 1:w
                if m[i, j] > 9
                    m[i, j] = 0
                    didflash = true
                    total += 1
                    for d in dirs
                        (ni, nj) = (i, j) .+ d
                        if ni in 1:w && nj in 1:h && m[ni, nj] != 0
                            m[ni, nj] += 1
                        end
                    end
                end
            end
            if !didflash
                break
            end
        end
    end

    total
end

function part2()
    m = parse_input("input/day11/input")
    w, h = size(m)

    for stepnumber in Iterators.countfrom(1)
        for i = 1:h, j = 1:w
            m[i, j] += 1
        end

        while true
            didflash = false
            for i = 1:h, j = 1:w
                if m[i, j] > 9
                    m[i, j] = 0
                    didflash = true
                    for d in dirs
                        (ni, nj) = (i, j) .+ d
                        if ni in 1:w && nj in 1:h && m[ni, nj] != 0
                            m[ni, nj] += 1
                        end
                    end
                end
            end
            if !didflash
                break
            end
        end

        if all(==(0), m)
            return stepnumber
        end
    end
end
