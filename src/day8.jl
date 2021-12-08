using Combinatorics

function part1()
    counter = 0

    for l in eachline("input/day8/input")
        for part in split(split(l, '|')[2])
            if length(part) in (2, 3, 4, 7)
                counter += 1
            end
        end
    end

    counter
end

function part2()
    valid_segments = [
        1 0 1 1 0 1 1 1 1 1
        1 0 0 0 1 1 1 0 1 1
        1 1 1 1 1 0 0 1 1 1
        0 0 1 1 1 1 1 0 1 1
        1 0 1 0 0 0 1 0 1 0
        1 1 0 1 1 1 1 1 1 1
        1 0 1 1 0 1 1 0 1 1
    ]

    sum(begin
        firstparts, secondparts = split(l, '|')

        correctperm = first(Iterators.filter(perm -> all(begin
                segments = zeros(Int, 7)
                for c in part
                    i = c - 'a' + 1
                    segments[i] = 1
                end
                permute!(segments, perm)
                any((@view valid_segments[:, i+1]) == segments for i = 0:9)
            end for part in split(firstparts)), permutations(1:7)))

        num = 0

        for part in split(secondparts)
            segments = zeros(Int, 7)
            for c in part
                i = c - 'a' + 1
                segments[i] = 1
            end
            permute!(segments, correctperm)
            for i = 0:9
                if (@view valid_segments[:, i+1]) == segments
                    num = 10 * num + i
                end
            end
        end

        num
    end for l in eachline("input/day8/input"))
end

function part2_map()
    valid_segments = Dict([
        [1, 1, 1, 0, 1, 1, 1] => 0,
        [0, 0, 1, 0, 0, 1, 0] => 1,
        [1, 0, 1, 1, 1, 0, 1] => 2,
        [1, 0, 1, 1, 0, 1, 1] => 3,
        [0, 1, 1, 1, 0, 1, 0] => 4,
        [1, 1, 0, 1, 0, 1, 1] => 5,
        [1, 1, 0, 1, 1, 1, 1] => 6,
        [1, 0, 1, 0, 0, 1, 0] => 7,
        [1, 1, 1, 1, 1, 1, 1] => 8,
        [1, 1, 1, 1, 0, 1, 1] => 9,
    ])

    sum(begin
        firstparts, secondparts = split(l, '|')

        correctperm = first(Iterators.filter(perm -> all(begin
                segments = zeros(Int, 7)
                for c in part
                    i = c - 'a' + 1
                    segments[i] = 1
                end
                permute!(segments, perm)
                haskey(valid_segments, segments)
            end for part in split(firstparts)), permutations(1:7)))

        num = 0

        for part in split(secondparts)
            segments = zeros(Int, 7)
            for c in part
                i = c - 'a' + 1
                segments[i] = 1
            end
            permute!(segments, correctperm)
            num = num * 10 + valid_segments[segments]
        end

        num
    end for l in eachline("input/day8/input"))
end
