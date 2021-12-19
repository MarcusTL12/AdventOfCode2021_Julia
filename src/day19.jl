using StaticArrays

function parse_input(filename)
    inp = String(open(read, filename))

    scanners = split.(split(inp, "\n\n"), "\n")

    coords = Vector{SVector{3,Int}}[]

    for l in scanners
        push!(coords, [(parse.(Int, split(s, ','))...,) for s in l[2:end]])
    end

    coords
end

# Rotations around x, y and z axis respectively
const rots = [
    SMatrix{3,3}(
        1, 0, 0,
        0, 0, -1,
        0, 1, 0),
    SMatrix{3,3}(
        0, 0, 1,
        0, 1, 0,
        -1, 0, 0),
    SMatrix{3,3}(
        0, -1, 0,
        1, 0, 0,
        0, 0, 1),
]

const facing_rots = [
    rots[3]^0, rots[3], rots[3]^2, rots[3]^3,
    rots[2], rots[2]^3,
]

function rotate_beacon(b, face, rot)
    facing_rots[face] * (rots[1]^(rot - 1) * b)
end

# Rotates all the beacon_coords relative to the scanner, such that it faces
# towards face gives the 6 faces (1:6)
# and for each of them, rot gives four rotations (1:4)
function rotate_scanner!(s, face, rot)
    for i = 1:length(s)
        s[i] = rotate_beacon(s[i], face, rot)
    end
    s
end

function offset_scanner!(s, off)
    for i = 1:length(s)
        s[i] += off
    end
end

function find_possible_overlap(s1, s2)
    for face = 1:6, rot = 1:4
        s2_r = rotate_scanner!(copy(s2), face, rot)
        for i = 1:length(s1), j = 1:length(s2)
            s2_pos = s1[i] - s2_r[j]
            amt_overlapping = 0
            for k = 1:length(s1), l = 1:length(s2)
                amt_overlapping += (s1[k] == (s2_r[l] + s2_pos))
                if amt_overlapping >= 12
                    return (face, rot, s2_pos)
                end
            end
        end
    end
end

function part1()
    inp = parse_input("input/day19/input")

    fixed = Set(1)

    while length(fixed) < length(inp)
        for i = 1:length(inp)
            for j = 1:length(inp)
                if i != j && i ∈ fixed && j ∉ fixed
                    ovlp = find_possible_overlap(inp[i], inp[j])
                    if !isnothing(ovlp)
                        push!(fixed, j)
                        face, rot, off = ovlp
                        rotate_scanner!(inp[j], face, rot)
                        offset_scanner!(inp[j], off)
                    end
                end
            end
        end
    end

    length(Set(Iterators.flatten(inp)))
end

function part2()
    inp = parse_input("input/day19/input")

    fixed = Set(1)

    scanner_coords = [@SVector [0, 0, 0]]

    while length(fixed) < length(inp)
        for i = 1:length(inp)
            for j = 1:length(inp)
                if i != j && i ∈ fixed && j ∉ fixed
                    ovlp = find_possible_overlap(inp[i], inp[j])
                    if !isnothing(ovlp)
                        push!(fixed, j)
                        face, rot, off = ovlp
                        rotate_scanner!(inp[j], face, rot)
                        offset_scanner!(inp[j], off)
                        push!(scanner_coords, off)
                    end
                end
            end
        end
    end

    maximum(sum(abs, a - b) for a in scanner_coords, b in scanner_coords)
end
