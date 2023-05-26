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

function getGeometric()
    r = rand(Float64)
    sum = 0
    for i in 1:63
        sum += 2.0^(-i)
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

    manhatt_dist = 0
    manhatt_dist += mod((level_i - level_j), 4)
    manhatt_dist += mod((row_i - row_j), 4)
    manhatt_dist += mod((column_i - column_j), 4)

    return manhatt_dist
end

function genRequests(distribution)
    list = zeros(Float64, REC_LEN)
    for i in 1:REC_LEN
        list[i] = distribution()
    end

    return list
end

function moveToMin(request_list)
    
end

function flip(request_list)

end