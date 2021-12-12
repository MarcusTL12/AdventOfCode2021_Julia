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

function part2_mean()
    inp = parse.(Int, split(readline("input/day7/input"), ','))

    mid = mean(inp)
    l = floor(Int, mid)
    h = ceil(Int, mid)

    min(sum(trig_num(abs(x - l)) for x in inp),
        sum(trig_num(abs(x - l)) for x in inp))
end

function part2_binary()
    inp = parse.(Int, split(readline("input/day7/input"), ','))

    cost(x) = sum(trig_num(abs(x_ - x)) for x_ in inp)

    dir(x) = sign(cost(x + 1) - cost(x))

    l, h = extrema(inp)

    while h - l > 1
        m = (l + h) ÷ 2

        d = dir(m)

        if d > 0
            h = m
        elseif d < 0
            l = m
        else
            break
        end
    end

    minimum(cost, l:h)
end
