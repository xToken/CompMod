//Dont want to always replace random files, so this.

function Exosuit:OnAdjustModelCoords(modelCoords)
    local coords = modelCoords
    coords.xAxis = coords.xAxis * kExosuitScale
    coords.yAxis = coords.yAxis * kExosuitScale
    coords.zAxis = coords.zAxis * kExosuitScale
    return coords
end