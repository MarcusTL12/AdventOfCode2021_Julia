
function part1()
    inp = parse.(Int, split(first(eachline("input/day7/input")), ','))

    minimum(sum(abs(x - i) for x in inp) for i = minimum(inp):maximum(inp))
end

trig_num(x) = (x * (x + 1)) ÷ 2

function part2()
    inp = parse.(Int, split(first(eachline("input/day7/input")), ','))

    minimum(sum(trig_num(abs(x - i)) for x in inp)
            for i = minimum(inp):maximum(inp))
end
