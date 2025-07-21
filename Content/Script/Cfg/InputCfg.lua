local InputCfg = {}

InputCfg.IA_Paths = {
    IA_Jump = "/Script/EnhancedInput.InputAction'/Game/Input/Actions/IA_Jump.IA_Jump'",
    IA_Look = "/Script/EnhancedInput.InputAction'/Game/Input/Actions/IA_Look.IA_Look'",
    IA_MouseLook = "/Script/EnhancedInput.InputAction'/Game/Input/Actions/IA_MouseLook.IA_MouseLook'",
    IA_Move = "/Script/EnhancedInput.InputAction'/Game/Input/Actions/IA_Move.IA_Move'",
    IA_ChangePawn = "/Script/EnhancedInput.InputAction'/Game/Input/Actions/IA_ChangePawn.IA_ChangePawn'",
}

InputCfg.IA_Defauts = {
    "IA_Look", "IA_MouseLook", "IA_Move", "IA_Jump", "IA_ChangePawn"
}

InputCfg.LevelMap = {
    -- Demo2 = {
    --     "IA_Look", "IA_MouseLook", "IA_Move"
    -- }
}

InputCfg.ActionEvent = {
    Triggered = "Triggered",
    Started = "Started",
    Ongoing = "Ongoing",
    Canceled = "Canceled",
    Completed = "Completed",
}

return InputCfg