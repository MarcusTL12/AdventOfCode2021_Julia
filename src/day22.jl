
function part1()
    reg = r"(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)"

    screen = Dict{NTuple{3,Int},Bool}()

    for l in eachline("input/day22/input")
        m = match(reg, l)

        state = m.captures[1] == "on"

        ns = parse.(Int, m.captures[2:end])

        if abs(ns[1]) <= 50
            for x = ns[1]:ns[2], y = ns[3]:ns[4], z = ns[5]:ns[6]
                screen[(x, y, z)] = state
            end
        end
    end

    count(values(screen))
end

function is_any_overlap(a, b)
    !(a[1] > b[2] || a[2] < b[1] || a[3] > b[4] ||
      a[4] < b[3] || a[5] > b[6] || a[6] < b[5])
end

function box_difference(a, b)
    if !is_any_overlap(a, b)
        return [a]
    end

    b = (
        max(a[1], b[1]), min(a[2], b[2]),
        max(a[3], b[3]), min(a[4], b[4]),
        max(a[5], b[5]), min(a[6], b[6])
    )

    boxes = typeof(a)[]

    if a[1] < b[1]
        push!(boxes, (a[1], b[1] - 1, a[3:6]...))
    end

    if a[2] > b[2]
        push!(boxes, (b[2] + 1, a[2], a[3:6]...))
    end

    if a[3] < b[3]
        push!(boxes, (b[1:2]..., a[3], b[3] - 1, a[5:6]...))
    end

    if a[4] > b[4]
        push!(boxes, (b[1:2]..., b[4] + 1, a[4], a[5:6]...))
    end

    if a[5] < b[5]
        push!(boxes, (b[1:4]..., a[5], b[5] - 1))
    end

    if a[6] > b[6]
        push!(boxes, (b[1:4]..., b[6] + 1, a[6]))
    end

    boxes
end

function box_diff_from_list(list, subbox)
    nlist = eltype(list)[]
    for box in list
        append!(nlist, box_difference(box, subbox))
    end
    nlist
end

function volume(box)
    (box[2] - box[1] + 1) * (box[4] - box[3] + 1) * (box[6] - box[5] + 1)
end

function part2()
    reg = r"(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)"

    screen = NTuple{6,Int}[]

    for l in eachline("input/day22/input")
        m = match(reg, l)

        state = m.captures[1] == "on"

        curbox = (parse.(Int, m.captures[2:end])...,)

        if state
            cur_box_fragments = [curbox]
            for box in screen
                if !isempty(cur_box_fragments)
                    cur_box_fragments =
                        box_diff_from_list(cur_box_fragments, box)
                end
            end
            append!(screen, cur_box_fragments)
        else
            screen = box_diff_from_list(screen, curbox)
        end
    end

    sum(volume, screen)
end
