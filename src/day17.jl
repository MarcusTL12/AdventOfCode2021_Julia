
function part1()
    reg = r"target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)"
    xmin, xmax, ymin, ymax =
        parse.(Int, match(reg, readline("input/day17/input")).captures)

    x_t = xmin:xmax
    y_t = ymin:ymax

    max_max_y = 0

    for vx = 1:xmax, vy = 1:200
        x = 0
        y = 0
        hit = false
        max_y = 0
        while x < xmax && y > ymax
            x += vx
            y += vy
            max_y = max(max_y, y)
            vx -= sign(vx)
            vy -= 1
            if x in x_t && y in y_t
                hit = true
                break
            end
        end
        if hit
            max_max_y = max(max_max_y, max_y)
        end
    end

    max_max_y
end

function part2()
    reg = r"target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)"
    xmin, xmax, ymin, ymax =
        parse.(Int, match(reg, readline("input/day17/input")).captures)

    x_t = xmin:xmax
    y_t = ymin:ymax

    amt_hit = 0

    for vx = 1:xmax, vy = ymin:200
        x = 0
        y = 0
        while x <= xmax && y >= ymin
            x += vx
            y += vy
            vx -= sign(vx)
            vy -= 1
            if x in x_t && y in y_t
                amt_hit += 1
                break
            end
        end
    end

    amt_hit
end
