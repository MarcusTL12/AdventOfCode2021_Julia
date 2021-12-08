using Combinatorics

function part1()
    # counts = zeros(Int, 9)
    counter = 0

    for l in eachline("input/day8/input")
        lastpart = split(l, '|')[2]
        parts = split(lastpart)
        for part in parts
            if length(part) == 2
                counter += 1
            elseif length(part) == 4
                counter += 1
            elseif length(part) == 3
                counter += 1
            elseif length(part) == 7
                counter += 1
            end
        end
    end

    counter
end

function part2()
    valid_segments = [
        1 1 1 0 1 1 1
        0 0 1 0 0 1 0
        1 0 1 1 1 0 1
        1 0 1 1 0 1 1
        0 1 1 1 0 1 0
        1 1 0 1 0 1 1
        1 1 0 1 1 1 1
        1 0 1 0 0 1 0
        1 1 1 1 1 1 1
        1 1 1 1 0 1 1
    ]

    total = 0

    for l in eachline("input/day8/input")
        firstparts, secondparts = split(l, '|')

        correctperm = nothing

        for perm in permutations(1:7)
            iscorrect = true
            for part in split(firstparts)
                segments = zeros(Int, 7)
                for c in part
                    i = c - 'a' + 1
                    segments[i] = 1
                end
                permute!(segments, perm)
                haspossiblenum = false
                for i = 0:9
                    if valid_segments[i+1, :] == segments
                        haspossiblenum = true
                        break
                    end
                end
                iscorrect &= haspossiblenum
            end
            if iscorrect
                correctperm = perm
                break
            end
        end

        num = 0

        for part in split(secondparts)
            segments = zeros(Int, 7)
            for c in part
                i = c - 'a' + 1
                segments[i] = 1
            end
            permute!(segments, correctperm)
            for i = 0:9
                if valid_segments[i+1, :] == segments
                    num = 10 * num + i
                end
            end
        end

        total += num
    end

    total
end
