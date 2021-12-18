
function snail_add(a, b)
    Any[a, b]
end

function find_first_left(n, x::Int)
    if n[2] isa Int
        n[2] += x
    else
        find_first_left(n[2], x)
    end
end

function find_first_right(n, x::Int)
    if n[1] isa Int
        n[1] += x
    else
        find_first_right(n[1], x)
    end
end

function snail_explode(n, depth, stuff_happened)
    if n isa Int
        return
    end
    if depth >= 4 && !stuff_happened[]
        # @show n
        if !(n[1] isa Int) && (n[1][1] isa Int) && (n[1][2] isa Int)
            # println("Hei1")
            stuff_happened[] = true
            (l, r) = n[1]
            n[1] = 0
            if n[2] isa Int
                n[2] += r
            else
                find_first_right(n[2], r)
            end
            return (false, l)
        elseif !(n[2] isa Int) && (n[2][1] isa Int) && (n[2][2] isa Int)
            # println("Hei2")
            stuff_happened[] = true
            (l, r) = n[2]
            n[2] = 0
            if n[1] isa Int
                n[1] += l
            else
                find_first_right(n[1], l)
            end
            return (true, r)
        end
    end
    x = snail_explode(n[1], depth + 1, stuff_happened)
    if !isnothing(x)
        rl, x = x
        if rl
            if n[2] isa Int
                n[2] += x
            else
                find_first_right(n[2], x)
            end
        else
            return (false, x)
        end
        return
    end
    x = snail_explode(n[2], depth + 1, stuff_happened)
    if !isnothing(x)
        rl, x = x
        if rl
            return (true, x)
        else
            if n[1] isa Int
                n[1] += x
            else
                find_first_left(n[1], x)
            end
        end
    end
    return
end

function snail_split(n)
    for i = 1:2
        if n[i] isa Int
            if n[i] >= 10
                n[i] = Any[fld(n[i], 2), cld(n[i], 2)]
                return true
            end
        else
            if snail_split(n[i])
                return true
            end
        end
    end
    false
end

function snail_reduce(n)
    stuff_happened = Ref(true)
    while stuff_happened[]
        stuff_happened[] = true
        while stuff_happened[]
            stuff_happened[] = false
            snail_explode(n, 1, stuff_happened)
        end
        stuff_happened[] |= snail_split(n)
    end
end

function get_magnitude(n)
    acc = 0
    if n[1] isa Int
        acc += 3 * n[1]
    else
        acc += 3 * get_magnitude(n[1])
    end

    if n[2] isa Int
        acc += 2 * n[2]
    else
        acc += 2 * get_magnitude(n[2])
    end

    acc
end

function part1()
    inp = Any[eval(Meta.parse(replace(l, "[" => "Any[")))
              for l in eachline("input/day18/input")]

    acc = popfirst!(inp)

    while !isempty(inp)
        acc = snail_add(acc, popfirst!(inp))

        snail_reduce(acc)
    end

    get_magnitude(acc)
end

function part2()
    inp = Any[eval(Meta.parse(replace(l, "[" => "Any[")))
              for l in eachline("input/day18/input")]

    maximum(begin
        if i != j
            s = snail_add(deepcopy(inp[i]), deepcopy(inp[j]))
            snail_reduce(s)
            get_magnitude(s)
        else
            0
        end
    end for i = 1:length(inp), j = 1:length(inp))
end
