using Statistics

function part1()
    inp = parse.(Int, split(readline("input/day7/input"), ','))

    minimum(sum(abs(x - i) for x in inp) for i = minimum(inp):maximum(inp))
end

function part1_median()
    inp = parse.(Int, split(readline("input/day7/input"), ','))

    mid = round(Int, (median!(inp)))

    sum(abs(x - mid) for x in inp)
end

trig_num(x) = (x * (x + 1)) ÷ 2

function part2()
    inp = parse.(Int, split(readline("input/day7/input"), ','))

    minimum(sum(trig_num(abs(x - i)) for x in inp)
            for i = minimum(inp):maximum(inp))
end
