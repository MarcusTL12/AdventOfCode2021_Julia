
function part1()
    lines = Iterators.Stateful(eachline("input/day14/input"))

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
    new_counters = Dict{String,Int}()

    for (k, v) in counters
        if haskey(insertions, k)
            c = insertions[k]

            a = k[1] * c
            b = c * k[2]
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

    insertions = Dict(split(l, " -> ") for l in lines)

    counters = Dict{String,Int}()

    for i = 1:length(firstline)-1
        if !haskey(counters, firstline[i:i+1])
            counters[firstline[i:i+1]] = 1
        else
            counters[firstline[i:i+1]] += 1
        end
    end

    for _ in 1:40
        counters = do_step(insertions, counters)
    end

    char_counters = Dict{Char,Int}(last(firstline) => 1)

    for (k, v) in counters
        char_counters[k[1]] = get(char_counters, k[1], 0) + v
    end

    maximum(values(char_counters)) - minimum(values(char_counters))
end
