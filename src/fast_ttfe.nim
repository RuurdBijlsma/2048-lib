import nimpy
from std/random import sample, randomize, rand
import std/strformat

type Direction* = enum
  Up, Left, Down, Right
const Width = 4
const Height = 4
const lx = Width - 1
const ly = Height - 1
type Grid* = ref array[Width, array[Height, int]]

proc `[]`*(g: Grid, x, y: int): int =
  return g[x][y]
proc `[]=`*(g: Grid, x, y, val: int) = 
  g[x][y] = val

proc `[]`*(g: Grid, x, y: int, dir: Direction): int = 
  case dir:
    of Direction.Up: return g[x][y]
    of Direction.Left: return g[y][lx - x]
    of Direction.Down: return g[lx - x][ly -  y]
    of Direction.Right: return g[ly - y][lx - x]
proc `[]=`*(g: Grid, x, y: int, dir: Direction, val: int) = 
  case dir:
    of Direction.Up: g[x][y] = val
    of Direction.Left: g[y][lx - x] = val
    of Direction.Down: g[lx - x][ly -  y] = val
    of Direction.Right: g[ly - y][lx - x] = val

type Ttfe* = ref object of PyNimObjectExperimental 
  grid*: Grid
  stuck*: bool
  hasWon*: bool
  score*: int
  startTileCount: int

proc spawn(self: Ttfe) =
  var emptyTiles = newSeq[(int, int)]()
  for x in 0..<Width:
    for y in 0..<Height:
      if self.grid[x, y] == 0:
        emptyTiles.add((x, y))

  if emptyTiles.len > 0:
    var (x, y) = emptyTiles.sample()
    self.grid[x, y] = if rand(1.0) < 0.5: 4 else: 2

  var stuck = false
  if emptyTiles.len <= 1:
    stuck = true
    block outer:
      for x in 0..<Width:
        for y in 0..<Height:
          var value = self.grid[x, y]
          if y < Height - 1:
            var belowValue = self.grid[x, y + 1]
            if value == belowValue:
              stuck = false
              break outer
          if x < Width - 1:
            var rightValue = self.grid[x + 1, y]
            if value == rightValue:
              stuck = false
              break outer
            
  if stuck: self.stuck = true

proc getState*(self: Ttfe): (array[Width * Height, int], int, bool, bool) {.exportpy.} =
  var flattened: array[Width * Height, int]
  var index = 0
  for x in 0..<Width:
    for y in 0..<Height:
      flattened[index] = self.grid[x, y]
      index += 1
  return (flattened, self.score, self.stuck, self.hasWon)

proc restart*(self: Ttfe):  (array[Width * Height, int], int, bool, bool) {.exportpy.} =
  self.hasWon = false
  self.score = 0
  self.stuck = false

  for x in 0..<Width:
    for y in 0..<Height:
      self.grid[x, y] = 0

  for i in 0..<self.startTileCount:
    self.spawn()

  return self.getState()

proc initTtfe*(): Ttfe {.exportpy.} =
  randomize()
  let ttfe = Ttfe(startTileCount: 2)
  ttfe.grid = new(Grid)
  discard ttfe.restart()
  return ttfe

proc swipe*(self: Ttfe, dir: Direction): (array[Width * Height, int], int, bool, bool) {.exportpy.} =
  var changed = false

  for x in 0..<Width:
    var encounteredEmpty = false
    var prevValue = 0
    var arrIndex = 0
    template addValue(v: int, change=true) = 
      self.grid[x, arrIndex, dir] = v
      arrIndex += 1
      if encounteredEmpty and change:
        changed = true

    for y in 0..<Height:
      var value = self.grid[x, y, dir]
      self.grid[x, y, dir] = 0
      if value == 0: 
        encounteredEmpty = true
      elif value == prevValue:
        addValue(value * 2)
        prevValue = 0
        self.score += value * 2
        if value * 2 == 2048 and not self.hasWon:
          self.hasWon = true
      elif prevValue != 0:
        addValue(prevValue)
        prevValue = value
      else:
        prevValue = value
        if encounteredEmpty:
          changed = true

    if prevValue != 0:
      addValue(prevValue, false)

  if changed:
    self.spawn()

  return self.getState()

proc print*(self: Ttfe) {.exportpy.} =
  echo "====================================="
  echo &"Score = {self.score}"
  for y in 0..<Height:
    for x in 0..<Width:
      let val = self.grid[x, y]
      stdout.write(&"{val} ")
      if val < 100: stdout.write(" ")
      if val < 10: stdout.write(" ")
    stdout.write("\n")
  flushFile(stdout)