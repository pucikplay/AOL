H_64 = sum(1 / i for i in 1:64)
Hb_64 = sum(1 / (i*i) for i in 1:64)
D = 32
REC_LEN = 1024

function getUniform()
    return rand(1:64)
end

function getHarmonic()
    r = rand(Float64)
    sum = 0
    for i in 1:63
        sum += 1 / (i * H_64)
        if r < sum
            return i
        end
    end
    return 64
end

function getBiharmonic()
    r = rand(Float64)
    sum = 0
    for i in 1:63
        sum += 1 / (i * i * Hb_64)
        if r < sum
            return i
        end
    end
    return 64
end

function hyperCubeDist(i, j)
    bits_i = digits(i-1, base=2, pad=6)
    bits_j = digits(j-1, base=2, pad=6)
    count = 0
    for t in 1:6
        if bits_i[t] != bits_j[t]
            count += 1
        end
    end

    return count
end

function torusDist(i, j)
    _i, _j = i-1, j-1
    level_i, row_i, column_i = _i ÷ 16, (_i % 16) ÷ 4, _i % 4
    level_j, row_j, column_j = _j ÷ 16, (_j % 16) ÷ 4, _j % 4

    level_dist = abs(level_i - level_j)
    row_dist = abs(row_i - row_j)
    column_dist = abs(column_i - column_j)

    manhatt_dist = 0
    manhatt_dist += min(level_dist, 4 - level_dist)
    manhatt_dist += min(row_dist, 4 - row_dist)
    manhatt_dist += min(column_dist, 4 - column_dist)

    return manhatt_dist
end

function genRequests(distribution)
    list = zeros(Int8, REC_LEN)
    for i in 1:REC_LEN
        list[i] = distribution()
    end

    return list
end

function getReqCost(request_subset, server, distFun)
    total_cost = 0
    for j in request_subset
        total_cost += distFun(server, j)
    end
    return total_cost
end

function getDistMin(request_subset, distFun)
    min_vert = 0
    min_dist = 999999
    for i in 1:64
        curr_dist = sum(distFun(i,j) for j in request_subset)
        if curr_dist < min_dist
            min_dist = curr_dist
            min_vert = i
        end
    end
    return min_vert
end

function MTM(request_list, distFun)
    total_cost = 0
    server = 1
    for t in 0:31
        request_subset = request_list[D*t+1:D*(t+1)]
        total_cost += getReqCost(request_subset, server, distFun)
        new_server = getDistMin(request_subset, distFun)
        total_cost += D*distFun(server, new_server)
        server = new_server
    end
    return total_cost
end

function FLIP(request_list, distFun)
    total_cost = 0
    server = 1
    for j in request_list
        total_cost += distFun(server, j)
        if rand(Float64) < 1/(2*D)
            total_cost += D*distFun(server, j)
            server = j
        end
    end
    return total_cost
end

dist_funs = [hyperCubeDist, torusDist]
algs = [MTM, FLIP]
distributions = [getUniform, getHarmonic, getBiharmonic]

function main()
    no_of_tests = 5000
    for distribution in distributions
        for algorithm in algs
            for dist_fun in dist_funs
                total_cost = 0
                for t in 1:no_of_tests
                    request_list = genRequests(distribution)
                    total_cost += algorithm(request_list, dist_fun)
                end
                println("$(distribution),$(algorithm),$(dist_fun):$(total_cost/no_of_tests)")
            end
        end
    end
end

main()
# println(1/(2*D))
function getAvgDist(distFun)
    counter = 0
    avg_dist = 0
    for i in 1:64
        for j in 1:64
            counter += 1
            avg_dist += hyperCubeDist(i, j)
        end
    end
    return avg_dist/counter
end
# println(getAvgDist(hyperCubeDist))
# println(getAvgDist(torusDist))

