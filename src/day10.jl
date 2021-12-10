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
            else
                opener = pop!(stack)
                if c != brackets[opener]
                    total += points[c]
                    break
                end
            end
        end
    end

    total
end

function part2()
    allpoints = Int[]

    brackets = Dict([
        '(' => ')',
        '[' => ']',
        '{' => '}',
        '<' => '>',
    ])

    points = Dict([
        '(' => 1,
        '[' => 2,
        '{' => 3,
        '<' => 4,
    ])

    stack = Char[]

    for l in eachline("input/day10/input")
        empty!(stack)
        corrupted = false
        for c in l
            if haskey(brackets, c)
                push!(stack, c)
            else
                opener = pop!(stack)
                if c != brackets[opener]
                    corrupted = true
                end
            end
        end
        if !corrupted && !isempty(stack)
            score = 0
            while !isempty(stack)
                score = score * 5 + points[pop!(stack)]
            end
            push!(allpoints, score)
        end
    end

    Int(median(allpoints))
end
