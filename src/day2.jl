
function part1()
    depth = 0
    x = 0

    for l in eachline("input/day2/input")
        d, n = split(l)
        n = parse(Int, n)

        if d == "forward"
            x += n
        elseif d == "down"
            depth += n
        else
            depth -= n
        end
    end

    depth * x
end

function part2()
    depth = 0
    x = 0
    aim = 0

    for l in eachline("input/day2/input")
        d, n = split(l)
        n = parse(Int, n)

        if d == "forward"
            x += n
            depth += aim * n
        elseif d == "down"
            aim += n
        elseif d == "up"
            aim -= n
        end
    end

    depth * x
end
