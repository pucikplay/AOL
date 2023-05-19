import kotlin.random.Random
import kotlin.math.pow
import java.util.Arrays

var H = Array(100) {0.0}
var Hb = Array(100) {0.0}
val n_vals = arrayOf(20, 30, 40, 50, 60, 70, 80, 90, 100)

fun getUniform(n: Int): Int {
    return (1..n).random()
}

fun getHarmonic(n: Int): Int {
    val r: Double = Random.nextDouble()
    var sum = 0.0
    for (i in 1..n-1) {
        sum += 1 / (i * H[n-1])
        if (r < sum) {
            return i
        }
    }
    return n
}

fun getBiharmonic(n: Int): Int {
    val r: Double = Random.nextDouble()
    var sum = 0.0
    for (i in 1..n-1) {
        sum += 1 / (i * i * Hb[n-1])
        if (r < sum) {
            return i
        }
    }
    return n
}

fun getGeometric(n: Int): Int {
    val r: Double = Random.nextDouble()
    var sum = 0.0
    for (i in 1..n-1) {
        sum += 0.5.pow(i)
        if (r < sum) {
            return i
        }
    }
    return n
}

class FIFO(k: Int, n: Int) {
    val _k = k
    val cache = mutableListOf<Int>()

    fun cacheReq(x: Int): Int {
        if (cache.contains(x)) return 0
        if (cache.size >= _k) cache.removeFirst()
        cache.add(x)
        return 1
    }
}

class FWF(k: Int, n: Int) {
    val _k = k
    val cache = mutableListOf<Int>()

    fun cacheReq(x: Int): Int {
        if (cache.contains(x)) return 0
        if (cache.size >= _k) cache.clear()
        cache.add(x)
        return 1
    }
}

class LRU(k: Int, n: Int) {
    val _k = k
    val cache = mutableListOf<Int>()

    fun cacheReq(x: Int): Int {
        if (cache.contains(x)) {
            cache.remove(x)
            cache.add(0,x)
            return 0
        }
        if (cache.size >= _k) cache.removeLast()
        cache.add(0,x)
        return 1
    }
}

class LFU(k: Int, n: Int) {
    val _k = k
    val cache = mutableListOf<Int>()
    val frequency = IntArray(n) {0}

    fun cacheReq(x: Int): Int {
        if (cache.contains(x)) {
            frequency[x-1]++
            return 0
        }
        if (cache.size >= _k) {
            var min = 1000000000
            var id_min = 0
            cache.forEachIndexed{ idx, elem ->
                if (frequency[elem-1] < min) {
                    min = frequency[elem-1]
                    id_min = idx
                }
            }
            cache.removeAt(id_min)
        }
        frequency[x-1]++
        cache.add(x)
        return 1
    }
}

class RAND(k: Int, n: Int) {
    val _k = k
    val cache = mutableListOf<Int>()

    fun cacheReq(x: Int): Int {
        if (cache.contains(x)) return 0
        if (cache.size >= _k) {cache.removeAt((0.._k-1).random())}
        cache.add(x)
        return 1
    }
}

class RMA(k: Int, n: Int) {
    val _k = k
    val cache = mutableListOf<Int>()
    val mark = BooleanArray(n) {false}

    fun cacheReq(x: Int): Int {
        if (cache.contains(x)) {
            mark[x-1] = true
            return 0
        }
        if (cache.size >= _k) {
            val unmarked = mutableListOf<Int>()
            for (p in cache) {
                if (!mark[p-1]) {unmarked.add(p)}
            }
            var idx = 0
            if (unmarked.size == 0) {
                for (i in (0..mark.size-1)) {mark[i] = false}
                idx = (0.._k-1).random()
            }
            else {
                val elem = unmarked.random()
                idx = cache.indexOf(elem)
            }
            cache.removeAt(idx)
        }
        cache.add(x)
        mark[x-1] = true
        return 1
    }
}

fun getDist(d: Int, n: Int): Int {
    if (d == 0) return getUniform(n)
    if (d == 1) return getHarmonic(n)
    if (d == 2) return getBiharmonic(n)
    if (d == 3) return getGeometric(n)
    return 0
}

fun main() {
    var sum1: Double = 0.0
    var sum2: Double = 0.0
    for (i in 1..100) {
        sum1 += 1.0/i
        sum2 += 1.0/(i*i)
        H[i-1] = sum1
        Hb[i-1] = sum2
    }

    val noOfTests = 10000000
    var sum = 0
    var x = 0
    var c = 0
    var avg = 0.0

    for (n in n_vals) {
        for (k_ in (10 downTo 5)) {
            for (dist in (0..3)) {
                for (method in (0..5)) {
                    sum = 0
                    if (method == 0) {
                        var M0 = FIFO(n/k_,n)
                        for (test in (1..noOfTests)) {
                            x = getDist(dist,n)
                            c = M0.cacheReq(x)
                            sum += c
                        }
                        avg = sum/noOfTests.toDouble()
                    }
                    if (method == 1) {
                        var M1 = FWF(n/k_,n)
                        for (test in (1..noOfTests)) {
                            x = getDist(dist,n)
                            c = M1.cacheReq(x)
                            sum += c
                        }
                        avg = sum/noOfTests.toDouble()
                    }
                    if (method == 2) {
                        var M2 = LRU(n/k_,n)
                        for (test in (1..noOfTests)) {
                            x = getDist(dist,n)
                            c = M2.cacheReq(x)
                            sum += c
                        }
                        avg = sum/noOfTests.toDouble()
                    }
                    if (method == 3) {
                        var M3 = LFU(n/k_,n)
                        for (test in (1..noOfTests)) {
                            x = getDist(dist,n)
                            c = M3.cacheReq(x)
                            sum += c
                        }
                        avg = sum/noOfTests.toDouble()
                    }
                    if (method == 4) {
                        var M4 = RAND(n/k_,n)
                        for (test in (1..noOfTests)) {
                            x = getDist(dist,n)
                            c = M4.cacheReq(x)
                            sum += c
                        }
                        avg = sum/noOfTests.toDouble()
                    }
                    if (method == 5) {
                        var M5 = RMA(n/k_,n)
                        for (test in (1..noOfTests)) {
                            x = getDist(dist,n)
                            c = M5.cacheReq(x)
                            sum += c
                        }
                        avg = sum/noOfTests.toDouble()
                    }
                    println("%d;%d;%d;%d;%f".format(n,k_,dist,method,avg))
                }
            }
        }
    }
}