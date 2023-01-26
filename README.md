# 2048-lib
Nim library that runs 2048, exports to Python lib for future reinforcement learning purposes

Can complete 10000 games in under 129 milliseconds (faster than competing Rust solution lmao)

```
=====================================
Score = 0
0  0  0  0  
2  4  0  0  
0  0  0  0  
0  0  0  0  
=up=
=====================================
Score = 0
2  4  0  0  
0  0  0  0  
0  0  0  0  
0  4  0  0  
=left=
=====================================
Score = 0
2  4  0  0
0  0  0  2
0  0  0  0
4  0  0  0
=down=
=====================================
Score = 0
0  0  0  0
0  0  4  0
2  0  0  0
4  4  0  2
=right=
=====================================
Score = 8
2  0  0  0
0  0  0  4
0  0  0  2
0  0  8  2
[OK] basic play
duration: 129
highscore: 4300
avg score: 952.1484
[OK] play game
```
