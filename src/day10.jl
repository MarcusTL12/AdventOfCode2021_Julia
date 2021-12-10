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
