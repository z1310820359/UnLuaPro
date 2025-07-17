local InputCfg = {}

InputCfg.IA_Paths = {
    IA_Jump = "/Script/EnhancedInput.InputAction'/Game/Input/Actions/IA_Jump.IA_Jump'",
    IA_Look = "/Script/EnhancedInput.InputAction'/Game/Input/Actions/IA_Look.IA_Look'",
    IA_MouseLook = "/Script/EnhancedInput.InputAction'/Game/Input/Actions/IA_MouseLook.IA_MouseLook'",
    IA_Move = "/Script/EnhancedInput.InputAction'/Game/Input/Actions/IA_Move.IA_Move'",
}

InputCfg.IA_Defauts = {
    --IA_Jump,

}

InputCfg.LevelMap = {
    Demo = {
        IA_Look, IA_MouseLook, IA_Move
    }
}

return InputCfg