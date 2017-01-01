Annotated assembunny code:

```
cpy a d
cpy 9 c
cpy 282 b   # L1 
inc d       # loop to add b to d
dec b
jnz b -2 
dec c       #
jnz c -5    # BIG2 execute L1 9 times, Now d = a + 9 * 282
cpy d a     # a = a_input + 9 * 282
jnz 0 0     # BIG1
cpy a b     # a = b = d = a_input + 9 * 282, c = 0 the first time
            # a' = a / 2 on subsequent iterations
cpy 0 a     # Set up division result
cpy 2 c     # L3: execute loop L2 up to 3 times
jnz b 2     # L2 if b == 0, jump to L4, otherwise decrement b and c
jnz 1 6     
dec b       
dec c       
jnz c -4    # After running twice, c = 0,
            # b' = b - 2, d unchanged
inc a        
jnz 1 -7    # unconditional back to L3
cpy 2 b     # L4, we've divided by 2, so a = (input + 9 * 282)/2,
            # c = remainder, b = 2, d = input + 9 * 282
jnz c 2     # L6: skip over unconditional jump
jnz 1 4     # unconditional to L5 if c == 0, ensure c == 1 to get b = 1
dec b       
dec c
jnz 1 -4    # unconditional to L6
jnz 0 0     # L5 no-op
out b       
jnz a -19   # back up to BIG1, resets b and c
jnz 1 -21   # unconditional to BIG2, c = 0 already so resets a to d
```

So, we want a value which gives remainder 1, then 0, then 1, then 0, etc.
and it must end with a = 0 so we can fall through?

In binary we want

...0101010101

but it has to be at least 2538

0101010101 = 341
010101010101 = 1365
01010101010101 = 5461

5461 - 2538 = 2923

execept when a = 0 we get a '1', so we have to lead with a zero instead of a 1?

10 = 2
101010101010 = 2730

2730 - 2538 = 192





