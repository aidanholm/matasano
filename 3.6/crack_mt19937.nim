from ../util/mt19937.nim import mt19937_init, mt19937_rand
from times import epochTime
from os import sleep

var window = 10*60

mt19937_init(int(epochTime()))
var t = mt19937_rand() mod window

echo "Waiting for ", window div 60, " minutes..."
sleep(t*1000)
var secret = int(epochTime())
mt19937_init(secret)
sleep((window-t)*1000)

var v = mt19937_rand()
echo "Value generated: ", v

# The window to search
var first = int(epochTime()) - window
var last = int(epochTime())
# The time at which cracking started
var start_time = epochTime()

# Brute-force:
for seed in first .. last:
    mt19937_init(seed)
    var tv = mt19937_rand()
    if tv == v:
        echo "Seed found: " , seed
        assert(seed == secret)
        break

echo "Time elapsed: ", epochTime()-start_time, " seconds"
