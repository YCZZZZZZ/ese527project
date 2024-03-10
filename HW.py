import math

Hp = -0.5 * math.log2(0.5) - 0.125 * math.log2(0.125) * 3 - (1/16) * math.log2(1/16) * 2
Hq = -0.5 * math.log2(0.5) - 0.25 * math.log2(0.25) - 4 * (1/16) * math.log2(1/16)
print(Hq)