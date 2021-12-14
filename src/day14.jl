
function part1()
    lines = Iterators.Stateful(eachline("input/day14/ex1"))

    firstline = popfirst!(lines)
    popfirst!(lines)

    insertions = Dict(split(l, " -> ") for l in lines)

    polymer = Vector{Char}(firstline)

    for _ = 1:10
        i = 1
        while i < length(polymer)
            k = polymer[i] * polymer[i+1]
            if haskey(insertions, k)
                insert!(polymer, i + 1, first(insertions[k]))
                i += 1
            end
            i += 1
        end
    end

    counter = Dict{Char,Int}()

    for c in polymer
        if !haskey(counter, c)
            counter[c] = 1
        else
            counter[c] += 1
        end
    end

    maximum(values(counter)) - minimum(values(counter))
end

function do_step(insertions, counters)
    new_counters = Dict{Tuple{Char,Char},Int}()

    for (k, v) in counters
        if haskey(insertions, k)
            c = insertions[k]

            ka, kb = k

            a = (ka, c)
            b = (c, kb)
            new_counters[a] = get(new_counters, a, 0) + v
            new_counters[b] = get(new_counters, b, 0) + v
        else
            new_counters[k] = v
        end
    end

    new_counters
end

function part2()
    lines = Iterators.Stateful(eachline("input/day14/input"))

    firstline = popfirst!(lines)
    popfirst!(lines)

    insertions = Dict(begin
        a, b = split(l, " -> ")
        (a[1], a[2]) => b[1]
    end for l in lines)

    counters = Dict{Tuple{Char,Char},Int}()

    for k in zip(firstline, Iterators.Drop(firstline, 1))
        counters[k] = get(counters, k, 0) + 1
    end

    for _ = 1:40
        counters = do_step(insertions, counters)
    end

    char_counters = Dict{Char,Int}(last(firstline) => 1)

    for (k, v) in counters
        char_counters[k[1]] = get(char_counters, k[1], 0) + v
    end

    maximum(values(char_counters)) - minimum(values(char_counters))
end

function do_step_matrix(insertions, counters)
    new_counters = zeros(Int, 26, 26)

    for j = 1:26, i = 1:26
        if insertions[i, j] != 0
            c = insertions[i, j]
            new_counters[i, c] += counters[i, j]
            new_counters[c, j] += counters[i, j]
        else
            new_counters[i, j] = counters[i, j]
        end
    end

    new_counters
end

function part2_matrix()
    lines = Iterators.Stateful(eachline("input/day14/input"))

    firstline = popfirst!(lines)
    popfirst!(lines)

    insertions = zeros(Int, 26, 26)

    for l in lines
        (a1, a2), (b,) = split(l, " -> ")

        insertions[a1-'A'+1, a2-'A'+1] = b - 'A' + 1
    end

    counters = zeros(Int, 26, 26)

    for k in zip(firstline, Iterators.Drop(firstline, 1))
        i, j = k .- ('A' - 1)
        counters[i, j] += 1
    end

    for _ = 1:40
        counters = do_step_matrix(insertions, counters)
    end

    char_counters = map(sum, eachrow(counters))

    char_counters[last(firstline)-'A'+1] += 1

    maximum(char_counters) - minimum(Iterators.filter(!iszero, char_counters))
end
