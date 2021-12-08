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

function find_smart_perm!(nums, cf, bd, eg)
    empty!(cf)

    for num in nums
        if length(num) == 2
            union!(cf, c - 'a' + 1 for c in num)
        end
    end

    a = -1

    for num in nums
        if length(num) == 3
            for c in num
                i = c - 'a' + 1
                if i ∉ cf
                    a = i
                    break
                end
            end
        end
        if a != -1
            break
        end
    end

    empty!(bd)

    for num in nums
        if length(num) == 4
            union!(bd, c - 'a' + 1 for c in num)
            setdiff!(bd, cf)
        end
    end

    empty!(eg)
    append!(eg, 1:7)
    setdiff!(eg, a)
    setdiff!(eg, cf)
    setdiff!(eg, bd)

    e = -1
    g = -1

    for num in nums
        x = -1
        y = -1
        for c in num
            i = c - 'a' + 1
            if i in eg
                if x == -1
                    x = i
                else
                    y = i
                end
            end
        end
        if x != -1 && y == -1
            g = x
            setdiff!(eg, g)
            e = first(eg)
            break
        end
    end

    b = -1
    d = -1

    for num in nums
        if length(num) in (5, 6)
            x = -1
            y = -1
            for c in num
                i = c - 'a' + 1
                if i in bd
                    if x == -1
                        x = i
                    else
                        y = i
                    end
                end
            end
            if y == -1
                if length(num) == 5
                    d = x
                    setdiff!(bd, d)
                    b = first(bd)
                else
                    b = x
                    setdiff!(bd, b)
                    d = first(bd)
                end
                break
            end
        end
    end

    c = -1
    f = -1

    for num in nums
        if length(num) in (5, 6)
            x = -1
            y = -1
            for c in num
                i = c - 'a' + 1
                if i in cf
                    if x == -1
                        x = i
                    else
                        y = i
                    end
                end
            end
            if y == -1
                if length(num) == 6
                    f = x
                    setdiff!(cf, f)
                    c = first(cf)
                else
                    has_e = false
                    for c in num
                        i = c - 'a' + 1
                        if i == e
                            has_e = true
                            break
                        end
                    end
                    if has_e
                        c = x
                        setdiff!(cf, c)
                        f = first(cf)
                    else
                        f = x
                        setdiff!(cf, f)
                        c = first(cf)
                    end
                end
                break
            end
        end
    end

    [a, b, c, d, e, f, g]
end

function part2_smart()
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

    cf = Set{Int}()
    bd = Set{Int}()
    eg = Int[]

    for l in eachline("input/day8/input")
        firstparts, secondparts = split(l, '|')

        perm = find_smart_perm!(split(firstparts), cf, bd, eg)

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
