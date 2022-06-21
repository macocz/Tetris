function love.load()
require "conf"
    love.graphics.setBackgroundColor(.75, .41, .35)

    pieceStructures = {
        {
            {
                {' ', ' ', ' ', ' '},
                {'q', 'q', 'q', 'q'},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'q', ' ', ' '},
                {' ', 'q', ' ', ' '},
                {' ', 'q', ' ', ' '},
                {' ', 'q', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {' ', 'w', 'w', ' '},
                {' ', 'w', 'w', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {'e', 'e', 'e', ' '},
                {' ', ' ', 'e', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'e', ' ', ' '},
                {' ', 'e', ' ', ' '},
                {'e', 'e', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {'e', ' ', ' ', ' '},
                {'e', 'e', 'e', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'e', 'e', ' '},
                {' ', 'e', ' ', ' '},
                {' ', 'e', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {'r', 'r', 'r', ' '},
                {'r', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'r', ' ', ' '},
                {' ', 'r', ' ', ' '},
                {' ', 'r', 'r', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', ' ', 'r', ' '},
                {'r', 'r', 'r', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {'r', 'r', ' ', ' '},
                {' ', 'r', ' ', ' '},
                {' ', 'r', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {'t', 't', 't', ' '},
                {' ', 't', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 't', ' ', ' '},
                {' ', 't', 't', ' '},
                {' ', 't', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 't', ' ', ' '},
                {'t', 't', 't', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 't', ' ', ' '},
                {'t', 't', ' ', ' '},
                {' ', 't', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {' ', 'y', 'y', ' '},
                {'y', 'y', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {'y', ' ', ' ', ' '},
                {'y', 'y', ' ', ' '},
                {' ', 'y', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {'u', 'u', ' ', ' '},
                {' ', 'u', 'u', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'u', ' ', ' '},
                {'u', 'u', ' ', ' '},
                {'u', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
    }

    gridXCount = 17
    gridYCount = 26

    pieceXCount = 4
    pieceYCount = 4

    timerLimit = 0.4

    function canPieceMove(testX, testY, testRotation)
        for y = 1, pieceYCount do
            for x = 1, pieceXCount do
                local testBlockX = testX + x
                local testBlockY = testY + y

                if pieceStructures[pieceType][testRotation][y][x] ~= ' ' and (
                    testBlockX < 1
                    or testBlockX > gridXCount
                    or testBlockY > gridYCount
                    or inert[testBlockY][testBlockX] ~= ' '
                ) then
                    return false
                end
            end
        end

        return true
    end

    function newSequence()
        sequence = {}
        for pieceTypeIndex = 1, #pieceStructures do
            local position = love.math.random(#sequence + 1)
            table.insert(
                sequence,
                position,
                pieceTypeIndex
            )
        end
    end

    function newPiece()
        pieceX = 7
        pieceY = 0
        pieceRotation = 1
        pieceType = table.remove(sequence)

        if #sequence == 0 then
            newSequence()
        end
    end

    function reset()
        inert = {}
        for y = 1, gridYCount do
            inert[y] = {}
            for x = 1, gridXCount do
                inert[y][x] = ' '
            end
        end

        newSequence()
        newPiece()

        timer = 0
    end

    reset()
end

function love.update(dt)
    timer = timer + dt
    
    if timer >= timerLimit then
        timer = 0

        local testY = pieceY + 1
        if canPieceMove(pieceX, testY, pieceRotation) then
            pieceY = testY
        else
            
            for y = 1, pieceYCount do
                for x = 1, pieceXCount do
                    local block =
                        pieceStructures[pieceType][pieceRotation][y][x]
                    if block ~= ' ' then
                        inert[pieceY + y][pieceX + x] = block
                    end
                end
            end

            
            for y = 1, gridYCount do
                local complete = true
                for x = 1, gridXCount do
                    if inert[y][x] == ' ' then
                        complete = false
                        break
                    end
                end

                if complete then
                    for removeY = y, 2, -1 do
                        for removeX = 1, gridXCount do
                            inert[removeY][removeX] = inert[removeY - 1][removeX]
                        end
                    end

                    for removeX = 1, gridXCount do
                        inert[1][removeX] = ' '
                    end
                end
            end

            newPiece()

            if not canPieceMove(pieceX, pieceY, pieceRotation) then
                reset()
            end
        end
    end
end

function love.keypressed(key)
    if key == '.' then
        local testRotation = pieceRotation + 1
        if testRotation > #pieceStructures[pieceType] then
            testRotation = 1
        end

        if canPieceMove(pieceX, pieceY, testRotation) then
            pieceRotation = testRotation
        end

    elseif key == ',' then
        local testRotation = pieceRotation - 1
        if testRotation < 1 then
            testRotation = #pieceStructures[pieceType]
        end

        if canPieceMove(pieceX, pieceY, testRotation) then
            pieceRotation = testRotation
        end

    elseif key == 'left' then
        local testX = pieceX - 1

        if canPieceMove(testX, pieceY, pieceRotation) then
            pieceX = testX
        end

    elseif key == 'right' then
        local testX = pieceX + 1

        if canPieceMove(testX, pieceY, pieceRotation) then
            pieceX = testX
        end

    elseif key == '/' then
        while canPieceMove(pieceX, pieceY + 1, pieceRotation) do
            pieceY = pieceY + 1
            timer = timerLimit
        end
    end
end

function love.draw()
    local function drawBlock(block, x, y)
        local colors = {
            [' '] = {.65, .65, .65},
            q = {.32, .47, .56},
            w = {.14, .35, .98},
            e = {.75, .65, .81},
            r = {.35, .43, .98},
            t = {.47, .36, .24},
            y = {.85, .65, .45},
            u = {.75, .36, .22},
            preview = {.45, .45, .45},
        }
        local color = colors[block]
        love.graphics.setColor(color)

        local blockSize = 20
        local blockDrawSize = blockSize - 1
        love.graphics.rectangle(
            'fill',
            (x - 1) * blockSize,
            (y - 1) * blockSize,
            blockDrawSize,
            blockDrawSize
        )
    end

    local offsetX = 2
    local offsetY = 5

    for y = 1, gridYCount do
        for x = 1, gridXCount do
            drawBlock(inert[y][x], x + offsetX, y + offsetY)
        end
    end

    for y = 1, pieceYCount do
        for x = 1, pieceXCount do
            local block = pieceStructures[pieceType][pieceRotation][y][x]
            if block ~= ' ' then
                drawBlock(block, x + pieceX + offsetX, y + pieceY + offsetY)
            end
        end
    end

    for y = 1, pieceYCount do
        for x = 1, pieceXCount do
            local block = pieceStructures[sequence[#sequence]][1][y][x]
            if block ~= ' ' then
                drawBlock('preview', x + 9, y + 1)
            end
        end
    end
end