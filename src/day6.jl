using OffsetArrays
using Plots
using Polynomials
using StaticArrays

function part1()
    inp = parse.(Int, split(readline("input/day6/input"), ','))

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
    inp = parse.(Int, split(readline("input/day6/input"), ','))

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

function vizualize(days)
    inp = parse.(Int, split(first(eachline("input/day6/input")), ','))

    fish = OffsetArray(zeros(BigInt, 9), 0:8)

    for t in inp
        fish[t] += 1
    end

    fishes = [sum(fish)]

    for _ in 1:days
        amt_new = fish[0]
        for i in 1:8
            fish[i - 1] = fish[i]
        end

        fish[6] += amt_new
        fish[8] = amt_new

        push!(fishes, sum(fish))
    end

    log_fish = log10.(fishes)

    p = fit(0:days, log_fish, 1)

    display(p)

    plot(0:days, fishes; leg=false, yscale=:log10)
end

function matrix_solution()
    inp = parse.(Int, split(readline("input/day6/input"), ','))

    fish = zeros(Int, 9)

    for t in inp
        fish[t + 1] += 1
    end

    A = @SMatrix [
        0 1 0 0 0 0 0 0 0
        0 0 1 0 0 0 0 0 0
        0 0 0 1 0 0 0 0 0
        0 0 0 0 1 0 0 0 0
        0 0 0 0 0 1 0 0 0
        0 0 0 0 0 0 1 0 0
        1 0 0 0 0 0 0 1 0
        0 0 0 0 0 0 0 0 1
        1 0 0 0 0 0 0 0 0
    ]

    sum(A^256 * fish)
end
