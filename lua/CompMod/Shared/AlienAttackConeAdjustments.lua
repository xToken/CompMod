//Dont want to always replace random files, so this.

// Comp Mod change, remove enzyme bite cone adjustments and increased range from skulk bite.
function BiteLeap:GetMeleeBase()
    // Width of box, height of box
    return 0.7, 1
end

ReplaceLocals(BiteLeap.OnTag, { kEnzymedRange = 1.42 })

function Gore:GetMeleeBase()
    return 1, 1.4
end

function LerkBite:GetMeleeBase()
    return 0.9, 1.2  
end

function StabBlink:GetMeleeBase()
    return .7, 1
end

function SwipeBlink:GetMeleeBase()
    return .7, 1  
end