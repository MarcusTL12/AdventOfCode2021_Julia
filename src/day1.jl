using DSP

function part1()
    s = [parse(Int, l) for l in eachline("input/day1/input")]

    c = 0

    for i = 1:length(s)-1
        if s[i+1] > s[i]
            c += 1
        end
    end
    c
end

function part1_conv()
    s = [parse(Int, l) for l in eachline("input/day1/input")]

    count((@view conv(s, [1, -1])[2:end-1]) .> 0)
end

function part2()
    s = [parse(Int, l) for l in eachline("input/day1/input")]

    c = 0

    sums = zeros(Int, length(s) - 2)

    for i in eachindex(sums)
        sums[i] = s[i] + s[i+1] + s[i+2]
    end

    for i = 1:length(sums)-1
        if sums[i+1] > sums[i]
            c += 1
        end
    end

    c
end

function part2_conv()
    s = [parse(Int, l) for l in eachline("input/day1/input")]

    count((@view conv(s, [1, 0, 0, -1])[4:end-3]) .> 0)
end
