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

function part2_analytic()
    inp = parse.(Int, split(readline("input/day7/input"), ','))

    x1 = 0
    x2 = 500
    x3 = 1000

    y1 = sum(trig_num(abs(x - x1)) for x in inp)
    y2 = sum(trig_num(abs(x - x2)) for x in inp)
    y3 = sum(trig_num(abs(x - x3)) for x in inp)

    z = (
        x1^2 * y2 - x1^2 * y3 - x2^2 * y1 + x2^2 * y3 + x3^2 * y1 - x3^2 * y2
    ) / (2 * (x1 * y2 - x1 * y3 - x2 * y1 + x2 * y3 + x3 * y1 - x3 * y2))
    z = round(Int, z)

    sum(trig_num(abs(x - z)) for x in inp)
end
