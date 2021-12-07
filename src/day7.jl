
function part1()
    inp = parse.(Int, split(first(eachline("input/day7/input")), ','))

    itr = minimum(inp):maximum(inp)

    minimum(sum(abs(x - i) for x in inp) for i in itr)
end

trig_num(x) = (x * (x + 1)) ÷ 2

function part2()
    inp = parse.(Int, split(first(eachline("input/day7/input")), ','))

    itr = minimum(inp):maximum(inp)

    minimum(sum(trig_num(abs(x - i)) for x in inp) for i in itr)
end
