using Combinatorics

function amt_remaining_paths1(graph, curpos, remaining_nodes)
    amt = 0
    for node in graph[curpos]
        if node == "end"
            amt += 1
        elseif node in remaining_nodes
            if all(islowercase, node)
                delete!(remaining_nodes, node)
            end
            amt += amt_remaining_paths1(graph, node, remaining_nodes)
            push!(remaining_nodes, node)
        end
    end
    amt
end

function part1()
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

    amt_remaining_paths1(graph, start, remaining)
end

function amt_remaining_paths2(graph, curpos, paths, curpath, remaining_nodes,
    allowed_small, spent_double)
    for node in graph[curpos]
        if node == "end"
            push!(curpath, "end")
            push!(paths, copy(curpath))
            pop!(curpath)
        elseif node in remaining_nodes || (node == allowed_small && !spent_double)
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
                allowed_small, n_spent_double)
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

    for k in keys(graph)
        if all(islowercase, k) && k != "end" && k != "start"
            amt_remaining_paths2(graph, start, allpaths, String["start"],
                remaining, k, false)
        end
    end

    length(allpaths)
end
