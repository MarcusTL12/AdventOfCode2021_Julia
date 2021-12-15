using DataStructures

const dirs = [
    (1, 0),
    (0, 1),
    (-1, 0),
    (0, -1),
]

function parse_input(filename)
    data = read(filename)
    w = findfirst(==(0xa), data)
    h = length(data) ÷ w
    data .-= 0x30
    @view reshape(data, w, h)[1:end-1, :]
end

function part1()
    inp = parse_input("input/day15/input")

    queue = PriorityQueue((1, 1) => 0)

    visited = Set(((1, 1),))

    while !isempty(queue)
        (i, j), l = dequeue_pair!(queue)
        push!(visited, (i, j))

        if (i, j) == size(inp)
            return l
        end

        for d in dirs
            (ni, nj) = (i, j) .+ d
            h, w = size(inp)
            if ni in 1:h && nj in 1:w && (ni, nj) ∉ visited
                nl = l + Int(inp[ni, nj])
                if nl < get(queue, (ni, nj), typemax(Int))
                    queue[(ni, nj)] = nl
                end
            end
        end
    end
end

function part2()
    inp = Int.(parse_input("input/day15/input"))

    inp = ([
        inp inp.+1 inp.+2 inp.+3 inp.+4
        inp.+1 inp.+2 inp.+3 inp.+4 inp.+5
        inp.+2 inp.+3 inp.+4 inp.+5 inp.+6
        inp.+3 inp.+4 inp.+5 inp.+6 inp.+7
        inp.+4 inp.+5 inp.+6 inp.+7 inp.+8
    ] .- 1) .% 9 .+ 1

    queue = PriorityQueue((1, 1) => 0)

    visited = Set(((1, 1),))

    while !isempty(queue)
        (i, j), l = dequeue_pair!(queue)
        push!(visited, (i, j))

        if (i, j) == size(inp)
            return l
        end

        for d in dirs
            (ni, nj) = (i, j) .+ d
            h, w = size(inp)
            if ni in 1:h && nj in 1:w && (ni, nj) ∉ visited
                nl = l + Int(inp[ni, nj])
                if nl < get(queue, (ni, nj), typemax(Int))
                    queue[(ni, nj)] = nl
                end
            end
        end
    end
end
