# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.
import std/monotimes
from std/times import inMilliseconds
import unittest
import std/strformat
import fast_ttfe
from std/random import sample
from std/stats import mean

test "basic play":
  var ttfe = initTtfe()
  ttfe.print()
  echo "=up="
  discard ttfe.swipe(Direction.Up)
  ttfe.print()
  echo "=left="
  discard ttfe.swipe(Direction.Left)
  ttfe.print()
  echo "=down="
  discard ttfe.swipe(Direction.Down)
  ttfe.print()
  echo "=right="
  discard ttfe.swipe(Direction.Right)
  ttfe.print()
  check true

test "play 10000 games":
  var ttfe = initTtfe()

  # var directions = @[Direction.Up, Direction.Right, Direction.Down, Direction.Left] # avg 2000 score
  var directions = @[Direction.Up, Direction.Down, Direction.Left, Direction.Right] # avg 1000 score

  var scores = newSeq[int]()
  let startTime = getMonoTime()
  for i in 0..<10000:
    var j = 0
    discard ttfe.restart()
    while true:
      var dir = directions[j mod 4]
      j += 1
      discard ttfe.swipe(dir)
      if ttfe.stuck or ttfe.hasWon:
        scores.add(ttfe.score)
        break
  let duration = (getMonoTime() - startTime).inMilliseconds
  echo &"duration: {duration}"
  echo &"highscore: {max(scores)}"
  echo &"avg score: {mean(scores)}"

  check true

test "detect change":
  var ttfe = initTtfe()
  var grid = new(Grid)
  grid[0, 3] = 16
  ttfe.grid = grid
  ttfe.print()
  
  discard ttfe.swipe(Direction.Left)
  echo "=========================================="
  echo "DO SWIPE ", Direction.Left
  ttfe.print()