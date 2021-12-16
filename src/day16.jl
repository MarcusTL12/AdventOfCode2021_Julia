
function parse_packet(biterator, amt, bits_or_packets, len, vernumsum)
    amt_bits = 0
    amt_packets = 0

    function takebit()
        amt_bits += 1
        len[] -= 1
        popfirst!(biterator)
    end

    packets = Int[]

    while (!bits_or_packets && amt_bits < amt ||
           bits_or_packets && amt_packets < amt) && len[] > 6
        amt_packets += 1
        v = Char[]
        for _ = 1:3
            push!(v, takebit())
        end
        vernumsum[] += parse(Int, String(v); base = 2)

        t = Char[]
        for _ = 1:3
            push!(t, takebit())
        end
        t = parse(Int, String(t); base = 2)

        if t == 4
            bits = Char[]
            keep_on = true
            while keep_on
                keep_on = takebit() == '1'
                for _ = 1:4
                    push!(bits, takebit())
                end
            end
            push!(packets, parse(Int, String(bits); base = 2))
        else
            subpackets = if takebit() == '0'
                num = Char[]
                for _ = 1:15
                    push!(num, takebit())
                end
                n = parse(Int, String(num); base = 2)
                (a, b) = parse_packet(biterator, n, false, len, vernumsum)
                amt_bits += b
                a
            else
                num = Char[]
                for _ = 1:11
                    push!(num, takebit())
                end
                n = parse(Int, String(num); base = 2)
                (a, b) = parse_packet(biterator, n, true, len, vernumsum)
                amt_bits += b
                a
            end

            if t == 0
                push!(packets, sum(subpackets))
            elseif t == 1
                push!(packets, prod(subpackets))
            elseif t == 2
                push!(packets, minimum(subpackets))
            elseif t == 3
                push!(packets, maximum(subpackets))
            elseif t == 5
                push!(packets, subpackets[1] > subpackets[2] ? 1 : 0)
            elseif t == 6
                push!(packets, subpackets[1] < subpackets[2] ? 1 : 0)
            elseif t == 7
                push!(packets, subpackets[1] == subpackets[2] ? 1 : 0)
            end
        end
    end
    packets, amt_bits
end

function part1()
    inp = readline("input/day16/input")

    translation = Dict([
        '0' => "0000",
        '1' => "0001",
        '2' => "0010",
        '3' => "0011",
        '4' => "0100",
        '5' => "0101",
        '6' => "0110",
        '7' => "0111",
        '8' => "1000",
        '9' => "1001",
        'A' => "1010",
        'B' => "1011",
        'C' => "1100",
        'D' => "1101",
        'E' => "1110",
        'F' => "1111",
    ])

    biterator = Iterators.Stateful(
        Iterators.flatten(translation[c] for c in inp))

    vernumsum = Ref(0)

    parse_packet(
        biterator, 4 * length(inp), false, Ref(4 * length(inp)), vernumsum)

    vernumsum[]
end

function part2()
    inp = readline("input/day16/input")

    translation = Dict([
        '0' => "0000",
        '1' => "0001",
        '2' => "0010",
        '3' => "0011",
        '4' => "0100",
        '5' => "0101",
        '6' => "0110",
        '7' => "0111",
        '8' => "1000",
        '9' => "1001",
        'A' => "1010",
        'B' => "1011",
        'C' => "1100",
        'D' => "1101",
        'E' => "1110",
        'F' => "1111",
    ])

    biterator = Iterators.Stateful(
        Iterators.flatten(translation[c] for c in inp))

    parse_packet(
        biterator, 4 * length(inp), false, Ref(4 * length(inp)), Ref(0))[1][1]
end
