using OffsetArrays
using Plots

function part1()
    inp = parse.(Int, split(first(eachline("input/day6/input")), ','))

    fish = OffsetArray(zeros(Int, 9), 0:8)

    for t in inp
        fish[t] += 1
    end

    for _ in 1:80
        amt_new = fish[0]
        for i in 1:8
            fish[i - 1] = fish[i]
        end

        fish[6] += amt_new
        fish[8] = amt_new
    end

    sum(fish)
end

function part2()
    inp = parse.(Int, split(first(eachline("input/day6/input")), ','))

    fish = OffsetArray(zeros(Int, 9), 0:8)

    for t in inp
        fish[t] += 1
    end

    for _ in 1:256
        amt_new = fish[0]
        for i in 1:8
            fish[i - 1] = fish[i]
        end

        fish[6] += amt_new
        fish[8] = amt_new
    end

    sum(fish)
end

function vizualize()
    
end
