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
        possible = filter(s -> s-x >= 0, spaces)
        if length(possible) == 0
            counter += 1
            spaces = append!(spaces, 1.0 - x)
        else
            r = rand(1:length(possible))
            bin = possible[r]
            idx = (indexin(bin, spaces))[1]
            spaces[idx] -= x
        end
    end
    return counter
end

function firstFit(list)
    counter = 1
    spaces = [1.0]
    for x in list
        i = 1
        while i <= counter
            if spaces[i] >= x
                spaces[i] -= x
                break
            end
            i += 1
        end
        if i > counter
            counter += 1
            spaces = append!(spaces, 1.0 - x)
        end
    end
    return counter
end

function bestFit(list)
    counter = 1
    spaces = [1.0]
    for x in list
        i = 1
        while i <= counter && spaces[i] < x
            i += 1
        end
        if i > counter
            counter += 1
            spaces = append!(spaces, 1.0 - x)
        else
            spaces[i] -= x
        end
        j = i - 1
        while j >= 1 && spaces[j] > spaces[i]
            j -= 1
        end
        tmp = spaces[i]
        spaces = deleteat!(spaces, i)
        spaces = insert!(spaces, j+1, tmp)
    end
    return counter
end

function worstFit(list)
    counter = 1
    spaces = [1.0]
    for x in list
        i = counter
        if spaces[counter] < x
            i += 1
            counter += 1
            spaces = append!(spaces, 1.0 - x)
        else
            spaces[i] -= x
        end
        j = i - 1
        while j >= 1 && spaces[j] > spaces[i]
            j -= 1
        end
        tmp = spaces[i]
        spaces = deleteat!(spaces, i)
        spaces = insert!(spaces, j+1, tmp)
    end
    return counter
end

function getOptimum(list)
    return ceil(sum(list))
end

F = [getUniform, getHarmonic, getBiharmonic, getGeometric]
G = [nextFit, randomFit, firstFit, bestFit, worstFit]

function main()
    noOfTests = 100000
    for f in F
        for g in G
            counter = 0
            opt = 0
            for i in 1:noOfTests
                list = getList(f)
                counter += g(list)
                opt += getOptimum(list)
            end
            print("$(counter/opt);")
        end
        print("\n")
    end
end

main()