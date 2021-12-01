
function part1()
    s = open("input/day1/input") do io
        [parse(Int, l) for l in eachline(io)]
    end

    c = 0

    for i = 1:length(s)-1
        if s[i+1] > s[i]
            c += 1
        end
    end
    c
end

function part2()
    s = open("input/day1/input") do io
        [parse(Int, l) for l in eachline(io)]
    end

    c = 0

    sums = zeros(Int, length(s) - 2)

    for i in eachindex(sums)
        sums[i] = s[i] + s[i + 1] + s[i + 2]
    end

    for i = 1:length(sums)-1
        if sums[i+1] > sums[i]
            c += 1
        end
    end

    c
end
