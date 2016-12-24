This is a job for the Chinese Remainder Theorem.  No code here.

```
Disc #1 has 13 positions; at time=0, it is at position 1.
Disc #2 has 19 positions; at time=0, it is at position 10.
Disc #3 has 3 positions; at time=0, it is at position 2.
Disc #4 has 7 positions; at time=0, it is at position 1.
Disc #5 has 5 positions; at time=0, it is at position 3.
Disc #6 has 17 positions; at time=0, it is at position 5.
```

At time x, disk #1 is at position 1 + x mod 13, disk #2 is at position
10 + x mod 19 etc.
We want

```
(x+1+1) mod 13 = 0
(x+2+10) mod 19 = 0
(x+3+2) mod 3 = 0
(x+4+1) mod 7 = 0
(x+5+3) mod 5 = 0
(x+6+5) mod 17 = 0
```

or in standard form

```
x mod 13 = -2 
x mod 19 = -12
x mod 3 = -5
x mod 7 = -5 
x mod 5 = -8 
x mod 17 = -11
```
We'll get WolframAlpha to solve it for us:

```
ChineseRemainder[{-2,-12,-5,-5,-8,-11},{13,19,3,7,5,17}]
= 376777
```

The additional wheel for part 2 is

```
(x+7+0) mod 11 = 0
x mod 11 = -7
ChineseRemainder[{-2,-12,-5,-5,-8,-11,-7},{13,19,3,7,5,17,11}]
= 3903937
```
