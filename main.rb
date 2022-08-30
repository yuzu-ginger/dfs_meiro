require 'dxopal'
include DXOpal
Window.load_resources do
    Window.bgcolor = C_BLACK

    # 迷路マップ(1->壁, 0->道)
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

    # ウィンドウの大きさ
    Window.width = 320
    Window.height = 320

    # ブロック
    block = Image.new(20, 20, C_WHITE)         # 壁
    player = Image.new(20, 20, C_BLUE)         # プレイヤー(自分)
    start = Image.new(20, 20, C_RED)           # スタート地点
    goal = Image.new(20, 20, C_GREEN)          # ゴール地点
    pass = Image.new(20, 20, [192, 192, 192])  # 通った道

    # 迷路を表示
    def draw_map(map, block, pass)   
        (0..15).each do |i|
            (0..15).each do |j|
                if map[i][j] == 1
                    Window.draw(j * 20, i * 20, block)
                elsif map[i][j] == 5
                    Window.draw(j * 20, i * 20, pass)
                end
            end
        end
    end

    # DFS(深さ優先探索)
    def dfs(map, ar, x, y)
        if map[x][y] == 0
            ar << [x, y]
        end
        map[x][y] = 9       # 通った道->9
        dx = [1, -1, 0, 0]
        dy = [0, 0, 1, -1]

        # 進める方向を探索
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
    x = 1
    y = 1
    status = 0

    Window.loop do
        draw_map(map, block, pass)           # 迷路
        Window.draw(1 * 20, 1 * 20, start)   # スタート地点
        Window.draw(12 * 20, 12 * 20, goal)  # ゴール地点

        # ゴールでないとき
        case status
        when 0
            i = ar[0][0]
            j = ar[0][1]
            Window.draw(j * 20, i * 20, player)
            ar.shift
            map[i][j] = 5
            sleep(0.1)
            status = 1 if i == 12 && j == 12  # ゴールに着いたら
        end
    end
end