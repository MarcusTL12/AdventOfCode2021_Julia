using DataStructures

function parse_input(filename)
    pod_order = Int[]
    for l in eachline(filename)
        for c in l
            if 'A' <= c <= 'D'
                push!(pod_order, c - 'A' + 1)
            end
        end
    end
    pod_order
end

function show_map(hallway, top_floor, bottom_floor)
    println("#"^13)
    print("#")
    for i in hallway
        if i == 0
            print('.')
        else
            print('A' + i - 1)
        end
    end
    println("#")
    print("###")
    for i in top_floor
        if i == 0
            print('.')
        else
            print('A' + i - 1)
        end
        print("#")
    end
    println("##")
    print("  #")
    for i in bottom_floor
        if i == 0
            print('.')
        else
            print('A' + i - 1)
        end
        print("#")
    end
    println("\n  " * "#"^9 * "  ")
end

function part1()
    pod_order = parse_input("input/day23/input")
    top_floor = pod_order[1:4]
    bottom_floor = pod_order[5:end]
    hallway = [0 for _ in 1:11]

    room_inds = 3:2:9

    queue = PriorityQueue(((top_floor, bottom_floor, hallway) => 0))
    visited = Set{NTuple{3,Vector{Int}}}()

    while !isempty(queue)
        (top_floor, bottom_floor, hallway), energy = dequeue_pair!(queue)
        push!(visited, (copy(top_floor), copy(bottom_floor), copy(hallway)))

        # show_map(hallway, top_floor, bottom_floor)
        # @show energy
        # println()
        # readline()
        if top_floor == [1, 2, 3, 4] && bottom_floor == [1, 2, 3, 4] &&
           all(==(0), hallway)
            return energy
        end

        for i in 1:4
            taken_floor, depth = if top_floor[i] != 0
                (top_floor, 1)
            else
                (bottom_floor, 2)
            end
            if taken_floor[i] != 0 && !(depth == 2 && bottom_floor[i] == i)
                for it in (room_inds[i]:-1:1, room_inds[i]:11)
                    for j in it
                        if hallway[j] != 0
                            break
                        elseif j ∉ room_inds
                            hallway[j] = taken_floor[i]
                            taken_floor[i] = 0
                            new_energy = energy +
                                         (depth + abs(room_inds[i] - j)) *
                                         10^(hallway[j] - 1)
                            if (top_floor, bottom_floor, hallway) ∉ visited &&
                               (!haskey(queue,
                                (top_floor, bottom_floor, hallway)) ||
                                new_energy <
                                queue[(top_floor, bottom_floor, hallway)])
                                queue[(
                                    copy(top_floor),
                                    copy(bottom_floor),
                                    copy(hallway)
                                )] = new_energy
                            end
                            taken_floor[i] = hallway[j]
                            hallway[j] = 0
                        end
                    end
                end
            end
        end

        for i in 1:11
            if hallway[i] != 0
                pod_ind = hallway[i]
                room_ind = room_inds[pod_ind]
                hallway[i] = 0
                if all(hallway[j] == 0
                       for j in i:sign(room_ind - i):room_ind) &&
                   top_floor[pod_ind] ∈ (0, pod_ind) &&
                   bottom_floor[pod_ind] ∈ (0, pod_ind)
                    taken_floor, depth = if bottom_floor[pod_ind] == 0
                        bottom_floor, 2
                    else
                        top_floor, 1
                    end
                    if taken_floor[pod_ind] == 0
                        # println("Putting into hole")
                        # @show i, pod_ind
                        new_energy = energy +
                                     (depth + abs(room_ind - i)) *
                                     10^(pod_ind - 1)
                        taken_floor[pod_ind] = pod_ind
                        # show_map(hallway, top_floor, bottom_floor)
                        # @show new_energy
                        # println()
                        if (top_floor, bottom_floor, hallway) ∉ visited &&
                           (!haskey(queue,
                            (top_floor, bottom_floor, hallway)) ||
                            new_energy <
                            queue[(top_floor, bottom_floor, hallway)])
                            queue[(
                                copy(top_floor),
                                copy(bottom_floor),
                                copy(hallway)
                            )] = new_energy
                        end
                        taken_floor[pod_ind] = 0
                    end
                end
                hallway[i] = pod_ind
            end
        end
    end
end

function show_big_map(hallway, floors)
    println("#"^13)
    print("#")
    for i in hallway
        if i == 0
            print('.')
        else
            print('A' + i - 1)
        end
    end
    println("#")
    print("###")
    for i in floors[1]
        if i == 0
            print('.')
        else
            print('A' + i - 1)
        end
        print("#")
    end
    println("##")
    for floor in floors[2:end]
        print("  #")
        for i in floor
            if i == 0
                print('.')
            else
                print('A' + i - 1)
            end
            print("#")
        end
        println()
    end
    println("  " * "#"^9 * "  ")
end

function part2()
    pod_order = parse_input("input/day23/input")
    top_floor = pod_order[1:4]
    bottom_floor = pod_order[5:end]
    hallway = [0 for _ in 1:11]

    low_mid_floor = [4, 2, 1, 3]
    high_mid_floor = [4, 3, 2, 1]

    floors = [top_floor, high_mid_floor, low_mid_floor, bottom_floor]

    room_inds = 3:2:9

    queue = PriorityQueue(((floors, hallway) => 0))
    visited = Set(((deepcopy(floors), copy(hallway)),))

    while !isempty(queue)
        (floors, hallway), energy = dequeue_pair!(queue)
        push!(visited, (deepcopy(floors), copy(hallway)))

        # show_big_map(hallway, floors)
        # @show energy
        # println()
        # readline()
        if all(==([1, 2, 3, 4]), floors) &&
           all(==(0), hallway)
            return energy
        end

        for i in 1:4
            depth = 1
            taken_floor = floors[1]
            while taken_floor[i] == 0 && depth < 4
                depth += 1
                taken_floor = floors[depth]
            end
            if taken_floor[i] != 0 && !(depth == 4 && bottom_floor[i] == i)
                for it in (room_inds[i]:-1:1, room_inds[i]:11)
                    for j in it
                        if hallway[j] != 0
                            break
                        elseif j ∉ room_inds
                            hallway[j] = taken_floor[i]
                            taken_floor[i] = 0
                            new_energy = energy +
                                         (depth + abs(room_inds[i] - j)) *
                                         10^(hallway[j] - 1)
                            if (floors, hallway) ∉ visited &&
                               (!haskey(queue,
                                (floors, hallway)) ||
                                new_energy <
                                queue[(floors, hallway)])
                                queue[(
                                    deepcopy(floors), copy(hallway)
                                )] = new_energy
                            end
                            taken_floor[i] = hallway[j]
                            hallway[j] = 0
                        end
                    end
                end
            end
        end

        for i in 1:11
            if hallway[i] != 0
                pod_ind = hallway[i]
                room_ind = room_inds[pod_ind]
                hallway[i] = 0
                if all(hallway[j] == 0
                       for j in i:sign(room_ind - i):room_ind) &&
                        all(f[pod_ind] ∈ (0, pod_ind) for f in floors)
                    depth = 4
                    taken_floor = floors[4]
                    while taken_floor[pod_ind] != 0 && depth > 1
                        depth -= 1
                        taken_floor = floors[depth]
                    end

                    if taken_floor[pod_ind] == 0
                        # println("Putting into hole")
                        # @show i, pod_ind
                        new_energy = energy +
                                     (depth + abs(room_ind - i)) *
                                     10^(pod_ind - 1)
                        taken_floor[pod_ind] = pod_ind
                        # show_map(hallway, top_floor, bottom_floor)
                        # @show new_energy
                        # println()
                        if (floors, hallway) ∉ visited &&
                           (!haskey(queue, (floors, hallway)) ||
                            new_energy <
                            queue[(floors, hallway)])
                            queue[(
                                deepcopy(floors),
                                copy(hallway)
                            )] = new_energy
                        end
                        taken_floor[pod_ind] = 0
                    end
                end
                hallway[i] = pod_ind
            end
        end
    end
end
