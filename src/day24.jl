using PyCall

z3 = pyimport("z3")

function compileprogram(filename)
    code = IOBuffer()

    println(code, "function decoded(inp)")
    println(code, "    x = y = z = w = 0")
    i = 1

    for l in eachline(filename)
        s = split(l)
        if length(s) == 2
            println(code, "    ", s[2], " = inp[$i]")
            i += 1
        else
            symbol = if s[1] == "add"
                "+"
            elseif s[1] == "mul"
                "*"
            elseif s[1] == "div"
                "÷"
            elseif s[1] == "mod"
                "%"
            elseif s[1] == "eql"
                "=="
            end

            println(code, "    ", s[2], " = ", s[2], symbol, s[3])
        end
    end

    println(code, "    z")
    println(code, "end")

    String(take!(code))
end

function find_parameters(filename)
    reg = r"inp w
mul x 0
add x z
mod x 26
div z (1|26)
add x (-?\d+)
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y (-?\d+)
mul y x
add z y"
    s = String(open(read, filename))
    a = Int[]
    b = Int[]
    c = Bool[]
    for m in eachmatch(reg, s)
        push!(a, parse(Int, m.captures[2]))
        push!(b, parse(Int, m.captures[3]))
        push!(c, m.captures[1] == "26")
    end

    a, b, c
end

function fancy_func(z, a, b, c, d)
    x = (z % 26 + a)
    if c
        z ÷= 26
    end

    if x != d
        println("In ", c)
        return 26 * z + d + b
    end

    println("Out ", c)

    z
end

function fancy_func2(z, a, b, c, d)
    x = (z % 26 + a)
    if c
        z /= 26
    end

    z3.If(x != d, 26 * z + d + b, z)
end

function run_through_num(n)
    a, b, c = find_parameters("input/day24/input")
    z = 0
    d = reverse!([
        begin
            x = n % 10
            n ÷= 10
            x
        end for _ in 1:14
    ])

    for i in 1:14
        z = fancy_func(z, a[i], b[i], c[i], d[i])
        @show z
    end
end

function part1()
    a, b, c = find_parameters("input/day24/input_sander")

    d = [z3.Int("d$i") for i in 1:14]

    z = 0

    for i in 1:14
        z = fancy_func2(z, a[i], b[i], c[i], d[i])
    end

    n = foldl((a, b) -> 10 * a + b, d)
    o = z3.Optimize()
    o.add(z == 0)
    for i in 1:14
        o.add(d[i] >= 1)
        o.add(d[i] <= 9)
    end
    o.maximize(n)
    o.check()
    m = o.model()

    n = 0
    for di in d
        n = 10n + m.__getitem__(di).as_long()
    end
    n
end

function part2()
    a, b, c = find_parameters("input/day24/input")

    d = [z3.Int("d$i") for i in 1:14]

    z = 0

    for i in 1:14
        z = fancy_func2(z, a[i], b[i], c[i], d[i])
    end

    n = foldl((a, b) -> 10 * a + b, d)
    o = z3.Optimize()
    o.add(z == 0)
    for i in 1:14
        o.add(d[i] >= 1)
        o.add(d[i] <= 9)
    end
    o.minimize(n)
    o.check()
    m = o.model()

    n = 0
    for di in d
        n = 10n + m.__getitem__(di).as_long()
    end
    n
end

function rec(z, i, a, b, c, n, rev)
    if i > 14
        return z == 0 ? n : nothing
    end
    if c[i]
        d = (z % 26) + a[i]
        if 1 <= d <= 9
            rec(z ÷ 26, i + 1, a, b, c, n * 10 + d, rev)
        end
    else
        for d in (rev ? (1:9) : (9:-1:1))
            res = rec(26z + b[i] + d, i + 1, a, b, c, 10 * n + d, rev)
            if !isnothing(res)
                return res
            end
        end
    end
end

function part1_smart()
    a, b, c = find_parameters("input/day24/input")

    rec(0, 1, a, b, c, 0, false)
end

function part2_smart()
    a, b, c = find_parameters("input/day24/input")

    rec(0, 1, a, b, c, 0, true)
end
