
function isbingo(board)
    any(all(row) for row in eachrow(board)) || any(all(col) for col in eachcol(board))
end

function part1()
    inp = String(open(read, "input/day4/input"))

    s = split(inp, "\n\n")

    list = eval(Meta.parse("[" * s[1] * "]"))

    boards = [eval(Meta.parse("[" * m * "]")) for m in s[2:end]]

    board_checks = [falses(5, 5) for _ in boards]

    for n in list
        for (board, check) in zip(boards, board_checks)
            ind = findfirst(==(n), board)
            if !isnothing(ind)
                check[ind] = true
            end

            if isbingo(check)
                score = sum((1 .- check) .* board) * n

                return score
            end
        end
    end
end

function part2()
    inp = String(open(read, "input/day4/input"))

    s = split(inp, "\n\n")

    list = eval(Meta.parse("[" * s[1] * "]"))

    boards = [eval(Meta.parse("[" * m * "]")) for m in s[2:end]]

    board_checks = [falses(5, 5) for _ in boards]

    won = falses(length(boards))

    last_score = 0

    for n in list
        for (i, (board, check)) in enumerate(zip(boards, board_checks))
            if !won[i]
                ind = findfirst(==(n), board)
                if !isnothing(ind)
                    check[ind] = true
                end

                if isbingo(check)
                    last_score = sum((1 .- check) .* board) * n
                    won[i] = true
                end
            end
        end
    end

    last_score
end
