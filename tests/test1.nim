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

test "can add":
  check add(5, 5) == 10

test "basic play":
  var ttfe = initTtfe()
  ttfe.print()
  echo "=up="
  ttfe.swipe(Direction.Up)
  ttfe.print()
  echo "=left="
  ttfe.swipe(Direction.Left)
  ttfe.print()
  echo "=down="
  ttfe.swipe(Direction.Down)
  ttfe.print()
  echo "=right="
  ttfe.swipe(Direction.Right)
  ttfe.print()
  check true

test "play game":
  var ttfe = initTtfe()

  var directions = @[Direction.Up, Direction.Right, Direction.Down, Direction.Left]

  let startTime = getMonoTime()
  var scores = newSeq[int]()
  for _ in 0..<10000:
    ttfe.restart()
    while true:
      var dir = directions.sample()
      ttfe.swipe(dir)
      # ttfe.print()
      if ttfe.stuck or ttfe.hasWon:
        scores.add(ttfe.score)
        break
  let duration = (getMonoTime() - startTime).inMilliseconds
  echo &"duration: {duration}"
  echo &"highscore: {max(scores)}"
  echo &"avg score: {mean(scores)}"

  check true