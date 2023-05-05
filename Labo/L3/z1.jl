H_10 = sum(1 / i for i in 1:10)
Hb_10 = sum(1 / (i*i) for i in 1:10)

function getUniform()
    return rand(1:10)
end

function getHarmonic()
    r = rand(Float64)
    sum = 0
    for i in 1:9
        sum += 1 / (i * H_10)
        if r < sum
            return i
        end
    end
    return 10
end

function getBiharmonic()
    r = rand(Float64)
    sum = 0
    for i in 1:9
        sum += 1 / (i * i * Hb_10)
        if r < sum
            return i
        end
    end
    return 10
end

function getGeometric()
    r = rand(Float64)
    sum = 0
    for i in 1:9
        sum += 2.0^(-i)
        if r < sum
            return i
        end
    end
    return 10
end

function test()
    a = 0
    b = 0
    c = 0
    d = 0

    for i in 1:100000
        a += getUniform()
        b += getHarmonic()
        c += getBiharmonic()
        d += getGeometric()
    end

    println(a/100000)
    println(b/100000)
    println(c/100000)
    println(d/100000)
end

function getList(dist)
    list = zeros(Float64, 100)
    i = 1
    while i <= 100
        r = rand(Float64)
        k = dist()
        j = i
        while i <= 100 && i < j+k
            list[i] = r
            i += 1
        end
    end

    return list
end

function nextFit(list)
    counter = 0
    space = 0.0

    for x in list
        if x <= space
            space -= x
        else
            counter += 1
            space = 1.0-x
        end
    end

    return counter
end

function randomFit(list)
    counter = 1
    spaces = [1.0]

    for x in list
        r = rand(1:counter)
        if spaces[r] >= x
            spaces[r] -= x
        else
            

    end

end

function firstFit(list)
    counter = 0

end

function bestFit(list)
    counter = 0

end

function worstFit(list)
    counter = 0

end

function main()
    
end

main()