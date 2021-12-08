using Combinatorics

function part1()
    sum(sum(length(part) in (2, 3, 4, 7) for part in split(split(l, '|')[2]))
        for l in eachline("input/day8/input"))
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

function get_segment_matrix!(segs, nums)
    fill!(segs, false)
    for (i, num) in enumerate(nums)
        for c in num
            j = c - 'a' + 1
            segs[i, j] = true
        end
    end
    segs
end

function find_very_smart_perm!(segs, nums)
    get_segment_matrix!(segs, nums)

    v = @view segs[:, sort(1:7; by=i->sum(@view segs[:, i]))]
    v = @view v[:, [5, 2, 6, 3, 1, 7, 4]]

    rsums = map(sum, eachrow(v))
    one_ind = findfirst(==(2), rsums)
    four_ind = findfirst(==(4), rsums)

    if v[one_ind, 1]
        v = @view v[:, [3, 2, 1, 4, 5, 6, 7]]
    end

    if !v[four_ind, 4]
        v = @view v[:, [1, 2, 3, 7, 5, 6, 4]]
    end

    v.indices[2]
end

function part2_very_smart()
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

    total = 0

    segs = falses(10, 7)

    for l in eachline("input/day8/input")
        firstparts, secondparts = split(l, '|')

        perm = find_very_smart_perm!(segs, split(firstparts))

        num = 0

        for part in split(secondparts)
            segments = zeros(Int, 7)
            for c in part
                i = c - 'a' + 1
                segments[i] = 1
            end
            permute!(segments, perm)
            num = num * 10 + valid_segments[segments]
        end

        total += num
    end

    total
end
