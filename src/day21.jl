
function part1()
    pos = [parse(Int, split(l)[end]) for l in eachline("input/day21/input")]

    die = Iterators.Stateful(Iterators.cycle(1:100))
    die_amt = 0

    score = [0, 0]

    inds = [2, 1]

    i = 1

    while all(<(1000), score)
        n = 0
        for _ = 1:3
            n += popfirst!(die)
            die_amt += 1
        end
        pos[i] = (pos[i] + n - 1) % 10 + 1
        score[i] += pos[i]
        i = inds[i]
    end

    minimum(score) * die_amt
end

function rec(pos_a, pos_b, score_a, score_b, turn, memo)
    k = (pos_a, pos_b, score_a, score_b, turn)
    if haskey(memo, k)
        memo[k]
    elseif score_a < 21 && score_b < 21
        acc = (0, 0)
        for die1 = 1:3, die2 = 1:3, die3 = 1:3
            n = die1 + die2 + die3
            n_pos_a = turn ? (pos_a + n - 1) % 10 + 1 : pos_a
            n_pos_b = turn ? pos_b : (pos_b + n - 1) % 10 + 1
            n_score_a = score_a + (turn ? n_pos_a : 0)
            n_score_b = score_b + (turn ? 0 : n_pos_b)
            n_turn = !turn
            acc = acc .+
                  rec(n_pos_a, n_pos_b, n_score_a, n_score_b, n_turn, memo)
        end
        memo[k] = acc
    elseif score_a < 21
        memo[k] = (0, 1)
    elseif score_b < 21
        memo[k] = (1, 0)
    else
        println("HEEELP!")
    end
end

function part2()
    pos_a, pos_b =
        [parse(Int, split(l)[end]) for l in eachline("input/day21/input")]

    score_a = score_b = 0

    maximum(rec(pos_a, pos_b, score_a, score_b, true,
        Dict{Tuple{Int,Int,Int,Int,Bool},Tuple{Int,Int}}()))
end
