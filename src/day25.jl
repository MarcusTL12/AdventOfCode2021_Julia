using CircularArrays

function parse_input(filename)
    data = read(filename)
    w = findfirst(==(0xa), data)
    h = length(data) ÷ w
    @view reshape(data, w, h)[1:end-1, :]
end

function display_board(m)
    for i in 1:size(m)[1]
        for j in 1:size(m)[2]
            if m[i, j] == 0
                print(' ')
            elseif m[i, j] == 1
                print('>')
            elseif m[i, j] == 2
                print('v')
            else
                print('x')
            end
        end
        println()
    end
end

function part1()
    inp = parse_input("input/day25/input")

    m = CircularArray([
        if c == Int('.')
            0
        elseif c == Int('>')
            1
        elseif c == Int('v')
            2
        else
            error()
        end for c in inp'
    ])

    nm = copy(m)

    done = false

    i = 0

    while !done
        i += 1
        done = true
        copyto!(nm, m)
        for j in 1:size(m)[2], i in 1:size(m)[1]
            if m[i, j] == 1
                if m[i, j+1] == 0
                    done = false
                    nm[i, j] = 0
                    nm[i, j+1] = 1
                else
                    nm[i, j] = 1
                end
            end
        end
        m, nm = nm, m
        copyto!(nm, m)
        for j in 1:size(m)[2], i in 1:size(m)[1]
            if m[i, j] == 2
                if m[i+1, j] == 0
                    done = false
                    nm[i, j] = 0
                    nm[i+1, j] = 2
                else
                    nm[i, j] = 2
                end
            end
        end
        m, nm = nm, m
    end

    i
end
