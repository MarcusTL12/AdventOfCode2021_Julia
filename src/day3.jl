
function part1()
    ls = [Vector{Char}(l) .- '0' for l in eachline("input/day3/input")]

    bitcounts = sum(ls)

    most_common = bitcounts .> (length(ls) / 2)
    reverse!(most_common)

    g = sum(2^i * x for (i, x) in zip(0:length(bitcounts)-1, most_common))

    e = sum(2^i * (1 - x) for (i, x) in zip(0:length(bitcounts)-1, most_common))

    g * e
end

function part2()
    ls = [Vector{Char}(l) .- '0' for l in eachline("input/day3/input")]

    len = length(ls[1])

    ls_c = copy(ls)

    for i = 1:len
        c = sum(l[i] for l in ls_c)
        most_common = c .>= (length(ls_c) / 2)
        filter!(x -> x[i] == most_common, ls_c)
        if length(ls_c) == 1
            break
        end
    end

    ox = sum(2^i * x for (i, x) in zip(0:len-1, reverse(ls_c[1])))

    ls_c = copy(ls)

    for i = 1:len
        c = sum(l[i] for l in ls_c)
        most_common = c .>= (length(ls_c) / 2)
        filter!(x -> x[i] != most_common, ls_c)
        if length(ls_c) == 1
            break
        end
    end

    co2 = sum(2^i * x for (i, x) in zip(0:len-1, reverse(ls_c[1])))

    ox * co2
end
