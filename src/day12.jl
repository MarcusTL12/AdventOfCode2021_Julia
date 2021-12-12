
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
    node_translation = Dict([
        "start" => 1,
        "end" => 2,
    ])

    small_caves = Set{Int}()

    graph = Dict{Int,Vector{Int}}()

    for l in eachline("input/day12/input")
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

    remaining = Set(collect(keys(graph)))
    start = 1
    delete!(remaining, start)

    amt_remaining_paths1(graph, small_caves, start, remaining)
end

function amt_remaining_paths2(graph, curpos, paths, curpath, remaining_nodes,
    spent_double)
    for node in graph[curpos]
        if node == "end"
            push!(curpath, "end")
            push!(paths, copy(curpath))
            pop!(curpath)
        elseif (node in remaining_nodes || !spent_double) && node != "start"
            nnodes = copy(remaining_nodes)
            if all(islowercase, node)
                delete!(nnodes, node)
            end
            n_spent_double = spent_double
            if node ∉ remaining_nodes
                n_spent_double = true
            end
            push!(curpath, node)
            amt_remaining_paths2(graph, node, paths, curpath, nnodes,
                n_spent_double)
            pop!(curpath)
        end
    end
end

function part2()
    graph = Dict{String,Vector{String}}()

    for l in eachline("input/day12/input")
        s = split(l, '-')
        for i = 1:2
            if !haskey(graph, s[i])
                graph[s[i]] = String[]
            end
        end
        push!(graph[s[1]], s[2])
        push!(graph[s[2]], s[1])
    end

    remaining = Set(collect(keys(graph)))
    start = "start"
    delete!(remaining, start)

    allpaths = Set{Vector{String}}()

    amt_remaining_paths2(graph, start, allpaths, String["start"],
        remaining, false)

    length(allpaths)
end
