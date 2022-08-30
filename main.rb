require 'dxopal'
include DXOpal
Window.load_resources do
  Window.bgcolor = C_BLACK

  # 1: block(while)
  # 2: start(red)
  # 3: goal(green)
  # 9: already(grey)
  map = [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1],
      [1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  ]

  Window.width = 320
  Window.height = 320

  block = Image.new(20, 20, C_WHITE)
  player = Image.new(20, 20, C_BLUE)
  start = Image.new(20, 20, C_RED)
  goal = Image.new(20, 20, C_GREEN)
  already = Image.new(20, 20, [192, 192, 192])

  def draw_map(map, block, start, goal, already)   
      (0..15).each do |i|
          (0..15).each do |j|
              if map[i][j] == 1
                  Window.draw(j * 20, i * 20, block)
              elsif map[i][j] == 2
                  Window.draw(j * 20, i * 20, start)
              elsif map[i][j] == 3
                  Window.draw(j * 20, i * 20, goal)
              elsif map[i][j] == 5
                  Window.draw(j * 20, i * 20, already)
              end
          end
      end
  end

  def dfs(map, ar, x, y)
      if map[x][y] == 0
          ar << [x, y]
      end
      map[x][y] = 9
      dx = [1, -1, 0, 0]
      dy = [0, 0, 1, -1]
      4.times do |i|
          newx = x + dx[i]
          newy = y + dy[i]
          next if map[newx][newy] == 1 || map[newx][newy] == 9
          dfs(map, ar, newx, newy)
          ar << [x, y]
      end
  end

  ar = []
  dfs(map, ar, 1, 1)
  # p ar
  x = 1
  y = 1
  status = 0

  Window.loop do
      draw_map(map, block, start, goal, already)  
      Window.draw(1 * 20, 1 * 20, start)
      Window.draw(12 * 20, 12 * 20, goal)
      case status
      when 0
          i = ar[0][0]
          j = ar[0][1]
          Window.draw(j * 20, i * 20, player)
          ar.shift
          map[i][j] = 5
          sleep(0.1)
          status = 1 if i == 12 && j == 12
      end
  end
end
