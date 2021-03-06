using Statistics

function part1()
    total = 0

    brackets = Dict([
        '(' => ')',
        '[' => ']',
        '{' => '}',
        '<' => '>',
    ])

    points = Dict([
        ')' => 3,
        ']' => 57,
        '}' => 1197,
        '>' => 25137,
    ])

    stack = Char[]

    for l in eachline("input/day10/input")
        empty!(stack)
        for c in l
            if haskey(brackets, c)
                push!(stack, c)
            elseif c != brackets[pop!(stack)]
                total += points[c]
                break
            end
        end
    end

    total
end

function part1_rec()
    brackets = Dict([
        '(' => ')',
        '[' => ']',
        '{' => '}',
        '<' => '>',
    ])

    points = Dict([
        ')' => 3,
        ']' => 57,
        '}' => 1197,
        '>' => 25137,
    ])

    function rec(opener, it)
        while !isempty(it)
            c = popfirst!(it)
            if haskey(brackets, c)
                res = rec(c, it)
                if res != 0
                    return res
                end
            elseif c != brackets[opener]
                return points[c]
            else
                return 0
            end
        end
        0
    end

    sum(rec(' ', Iterators.Stateful(l)) for l in eachline("input/day10/input"))
end

function part2()
    allpoints = Int[]

    brackets = Dict([
        '(' => (')', 1),
        '[' => (']', 2),
        '{' => ('}', 3),
        '<' => ('>', 4),
    ])

    stack = Char[]

    for l in eachline("input/day10/input")
        empty!(stack)
        corrupted = false
        for c in l
            if haskey(brackets, c)
                push!(stack, c)
            else
                if c != brackets[pop!(stack)][1]
                    corrupted = true
                    break
                end
            end
        end
        if !corrupted && !isempty(stack)
            score = 0
            while !isempty(stack)
                score = score * 5 + brackets[pop!(stack)][2]
            end
            push!(allpoints, score)
        end
    end

    Int(median(allpoints))
end
