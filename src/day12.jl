
function parse_input(filename)
    node_translation = Dict([
        "start" => 1,
        "end" => 2,
    ])

    small_caves = Set{Int}()

    graph = Dict{Int,Vector{Int}}()

    for l in eachline(filename)
        s = split(l, '-')
        for i = 1:2
            if !haskey(node_translation, s[i])
                node_translation[s[i]] = length(node_translation) + 1
            end
            if !haskey(graph, node_translation[s[i]])
                graph[node_translation[s[i]]] = Int[]
            end
            if all(islowercase, s[i])
                push!(small_caves, node_translation[s[i]])
            end
        end
        i1 = node_translation[s[1]]
        i2 = node_translation[s[2]]
        push!(graph[i1], i2)
        push!(graph[i2], i1)
    end

    delete!(small_caves, 1)
    delete!(small_caves, 2)

    graph, small_caves
end

function amt_remaining_paths1(graph, small_caves, curpos, remaining_nodes)
    amt = 0
    for node in graph[curpos]
        if node == 2
            amt += 1
        elseif node in remaining_nodes
            if node in small_caves
                delete!(remaining_nodes, node)
            end
            amt += amt_remaining_paths1(
                graph, small_caves, node, remaining_nodes
            )
            push!(remaining_nodes, node)
        end
    end
    amt
end

function part1()
    graph, small_caves = parse_input("input/day12/input")

    remaining = Set(collect(keys(graph)))
    start = 1
    delete!(remaining, start)

    amt_remaining_paths1(graph, small_caves, start, remaining)
end

function amt_remaining_paths2(graph, small_caves, curpos, remaining_nodes,
    spent_double)
    amt = 0
    for node in graph[curpos]
        if node == 2
            amt += 1
        elseif node != 1 && (node in remaining_nodes || !spent_double)
            removed = false
            n_spent_double = spent_double
            if node in small_caves
                if node in remaining_nodes
                    removed = true
                    delete!(remaining_nodes, node)
                else
                    n_spent_double = true
                end
            end
            amt += amt_remaining_paths2_tmp(graph, small_caves, node,
                remaining_nodes, n_spent_double)
            if removed
                push!(remaining_nodes, node)
            end
        end
    end
    amt
end

function part2()
    graph, small_caves = parse_input("input/day12/input")

    remaining = Set(collect(keys(graph)))
    start = 1
    delete!(remaining, start)

    amt_remaining_paths2_tmp(graph, small_caves, 1, remaining, false)
end

function amt_remaining_paths2_memo(graph, small_caves, curpos, remaining_nodes,
    spent_double, memo)
    if haskey(memo, (curpos, remaining_nodes, spent_double))
        memo[(curpos, remaining_nodes, spent_double)]
    else
        key = (curpos, copy(remaining_nodes), spent_double)
        amt = 0
        for node in graph[curpos]
            if node == 2
                amt += 1
            elseif node != 1 && (node in remaining_nodes || !spent_double)
                removed = false
                n_spent_double = spent_double
                if node in small_caves
                    if node in remaining_nodes
                        removed = true
                        delete!(remaining_nodes, node)
                    else
                        n_spent_double = true
                    end
                end
                amt += amt_remaining_paths2_memo(graph, small_caves, node,
                    remaining_nodes, n_spent_double, memo)
                if removed
                    push!(remaining_nodes, node)
                end
            end
        end
        memo[key] = amt
        amt
    end
end

function part2_memo()
    graph, small_caves = parse_input("input/day12/input")

    remaining = Set(collect(keys(graph)))
    start = 1
    delete!(remaining, start)

    memo = Dict{Tuple{Int,Set{Int},Bool},Int}()

    amt_remaining_paths2_memo(graph, small_caves, 1, remaining, false, memo)
end
