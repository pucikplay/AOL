using DelimitedFiles

REQUESTS = 65536
VERTICES = 64

function genRequests(p)
    return map(x -> rand() < p ? true : false, 1:REQUESTS), map(x -> rand(Int.(1:VERTICES)), 1:REQUESTS)
end

function isWaiting(copies, steps)
    return (count(copies) == 1 && steps[findfirst(copies)] == 4) ? true : false
end

function noOfCopies(copies)
    return count(x -> x == true, copies)
end

function processRequests(requests, D)
    copies = falses(VERTICES)
    copies[1] = true
    counters = zeros(Int16, VERTICES)
    steps = ones(Int8, VERTICES)
    steps[1] = 4
    cost = 0
    max_copies = 1

    for (req,p) in zip(requests[1], requests[2])
        # println("Write: $req, vertex: $p")
        if req
            if copies[p]
                cost += noOfCopies(copies) - 1
            else
                cost += noOfCopies(copies)
            end
        else
            if !copies[p]
                cost += 1
            end
        end

        for v in 1:VERTICES
            max_copies = max(max_copies, noOfCopies(copies))

            if steps[v] == 1
                if counters[v] >= D
                    steps[v] = 2
                end
                if p == v && (!req || isWaiting(copies, steps))
                    counters[v] += 1
                end
            end
            if steps[v] == 2
                copies[v] = true
                cost += D
                steps[v] = 3
            end
            if steps[v] == 3
                if p != v && req
                    counters[v] -= 1
                end
                if counters[v] <= 0
                    steps[v] = 4
                end
            end
            if steps[v] == 4
                if !isWaiting(copies, steps)
                    steps[v] = 5
                end
            end
            if steps[v] == 5
                copies[v] = false
                steps[v] = 1
            end
            # println("vertex: $v, counter: $(counters[v]), step: $(steps[v]), copy: $(copies[v])")
        end
        # println("cost: $cost")
    end

    return cost, max_copies
end

# println(processRequests(genRequests(0.5), 3))

function test(tests)
    D = [16 32 64 128 256]
    P = [0.01 0.02 0.05 0.1 0.2 0.5]
    averages = zeros(Float64, length(D), length(P))
    m_copies = zeros(Int8, length(D), length(P))

    for (i,d) in enumerate(D)
        for (j,p) in enumerate(P)
            total_cost = 0
            max_copies = 0
            for _ in 1:tests
                requests = genRequests(p)
                cost, m_copy = processRequests(requests, d)
                total_cost += cost
                max_copies = max(max_copies, m_copy)
            end
            averages[i,j] = total_cost/tests
            m_copies[i,j] = max_copies
            println("D = $d, p = $p, average = $(averages[i,j]), max_copies = $(m_copies[i,j])")
        end
    end

    return averages, m_copies
end

averages, m_copies = test(100)

writedlm("cost.csv", averages, ',')
writedlm("copies.csv", m_copies, ',')
