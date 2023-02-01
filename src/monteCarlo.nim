import fast_ttfe
import std/strformat

proc evaluate(ttfe: Ttfe, depth = 5): (Direction, int) =
  var directions = @[Direction.Up, Direction.Right, Direction.Down, Direction.Left]
  # var sampleCount = if depth == 5: 5 else: 3
  var sampleCount = 5
  var bestDir: Direction
  var bestScore: int
  
  if depth == 0 or ttfe.stuck:
    return (bestDir, ttfe.score)

  for dir in directions:
    var scoreSum: int = 0

    for _ in 0..<sampleCount:
      var state = ttfe.getState()
      var gridCopy = state[0][]
      ttfe.swipe(dir)
      var (_, score) = evaluate(ttfe, depth - 1)
      scoreSum += score
      ttfe.setState((gridCopy, state[1], state[2], state[3]))
    
    if scoreSum > bestScore:
      bestDir = dir
      bestScore = scoreSum

  return (bestDir, bestScore)

proc pickBestMove*() =
  var ttfe = initTtfe()
  ttfe.print()
  while not ttfe.stuck:
    var (dir, score) = evaluate(ttfe, 6)
    echo &"Best swipe is {dir} with score {score / 5}"
    ttfe.swipe(dir)
    ttfe.print()