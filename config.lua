Config = {
    MinimumPlayers = 2,
    MaximumPlayers = 10,

    Locations = {
        [1] = {
            name = 'Maze Bank',
            coords = {
                [1] = vector4(235.90,215.79,106.29,325.99),
                [2] = vector4(240.18,233.00,108.72,212.45),
                [3] = vector4(236.61,221.71,110.28,225.69),
                [4] = vector4(251.40,210.50,110.28,338.92),
                [5] = vector4(258.30,207.71,110.28,332.32),
                [6] = vector4(266.13,218.55,110.28,6.24),
                [7] = vector4(260.04,206.07,106.28,350.21),
                [8] = vector4(268.34,223.18,103.48,151.91), 
            }
        },
        [2] = {
            name = 'Happy Hour',
            coords = {
                [1] = vector4(228.58,301.96,105.38,251.61),
                
            }
        },
        [3] = {
            name = 'Shod Hanot',
            coords = {
                [1] = vector4(371.70,321.32,103.52,269.69),
                
            }
        },
        [4] = {
            name = 'Hanaya',
            coords = {
                [1] = vector4(440.29,259.28,103.21,217.95),
                
            }
        },
    }
}

States = {
    WAITING = 0,
    STARTING = 1,
    IN_PROGRESS = 2,
    ENDING = 3,
    OFF = 4,
}

