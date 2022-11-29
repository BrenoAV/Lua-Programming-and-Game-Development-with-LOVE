local u = {}

u.angleTwoPoints = function(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

u.distanceBetween = function(x1, y1, x2, y2)
    return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end

return u
