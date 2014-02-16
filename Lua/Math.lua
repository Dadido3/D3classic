-- #################################################################
-- #                 Math-Functions by Dadido3                     #
-- #                                                               #
-- #################################################################

-- Returns the scalar product of point(0) and point(1)
function Scalar_2D(X_0, Y_0, X_1, Y_1)
	return X_0*X_1 + Y_0*Y_1
end

-- Returns the Area of a Triangle
function Area_Triangle_2D(A, B, C)
    local S = (A + B + C) / 2
    return math.sqrt(S*(S-A)*(S-B)*(S-C))
end

-- Returns the barycentric coordinates of a Point(P) and a Triangle(0,1,2)
function Barycentric_Point_Triangle_2D(X_P, Y_P, X_0, Y_0, X_1, Y_1, X_2, Y_2)
    -- compute the area of the big triangle
    local A = Dist_Point_Point_2D(X_0, Y_0, X_1, Y_1)
    local B = Dist_Point_Point_2D(X_1, Y_1, X_2, Y_2)
    local C = Dist_Point_Point_2D(X_2, Y_2, X_0, Y_0)
    local Area = Area_Triangle_2D(A, B, C)
	
    -- compute the distances from the outer vertices to the inner vertex
    local Length_0 = Dist_Point_Point_2D(X_0, Y_0, X_P, Y_P)
    local Length_1 = Dist_Point_Point_2D(X_1, Y_1, X_P, Y_P)
    local Length_2 = Dist_Point_Point_2D(X_2, Y_2, X_P, Y_P)
	
    -- divide the area of each small triangle by the area of the big triangle
    local U = Area_Triangle_2D(B, Length_1, Length_2)/Area
    local V = Area_Triangle_2D(C, Length_0, Length_2)/Area
    local W = Area_Triangle_2D(A, Length_0, Length_1)/Area
	return U, V, W
end

-- Returns if the Point(P) is inside the Triangle(0,1,2)
function Is_Point_In_Triangle(X_P, Y_P, X_0, Y_0, X_1, Y_1, X_2, Y_2)
	-- compute the area of the big triangle
    local A = Dist_Point_Point_2D(X_0, Y_0, X_1, Y_1)
    local B = Dist_Point_Point_2D(X_1, Y_1, X_2, Y_2)
    local C = Dist_Point_Point_2D(X_2, Y_2, X_0, Y_0)
    local Area = Area_Triangle_2D(A, B, C)
	
    -- compute the distances from the outer vertices to the inner vertex
    local Length_0 = Dist_Point_Point_2D(X_0, Y_0, X_P, Y_P)
    local Length_1 = Dist_Point_Point_2D(X_1, Y_1, X_P, Y_P)
    local Length_2 = Dist_Point_Point_2D(X_2, Y_2, X_P, Y_P)
	
	local Area_A = Area_Triangle_2D(A, Length_0, Length_1)
	local Area_B = Area_Triangle_2D(B, Length_1, Length_2)
	local Area_C = Area_Triangle_2D(C, Length_2, Length_0)
	
	if Area_A+Area_B+Area_C - Area <= 0.000001 then
		return true
	else
		return false
	end
end

-- Returns the shortest distance between a point(0) and a point(1)
function Dist_Point_Point_2D(X_0, Y_0, X_1, Y_1)
	return math.sqrt(math.pow(X_0-X_1,2)+math.pow(Y_0-Y_1,2))
end

-- Returns the shortest distance between a point(0) and a point(1)
function Dist_Point_Point_3D(X_0, Y_0, Z_0, X_1, Y_1, Z_1)
	return math.sqrt(math.pow(X_0-X_1,2)+math.pow(Y_0-Y_1,2)+math.pow(Z_0-Z_1,2))
end

-- Returns the shortest distance between a point(0) and a line(1,2)
function Dist_Line_Point_2D(X_0, Y_0, X_1, Y_1, X_2, Y_2)
    local LineMag = Dist_Point_Point_2D(X_2, Y_2, X_1, Y_1)
 
    local U = ( ( (X_0-X_1) * (X_2-X_1) ) + ( (Y_0-Y_1) * (Y_2-Y_1) ) ) / (LineMag^2)
	
    --if U < 0.0 or U > 1.0 then
    --    return -1 -- closest point does not fall within the line segment
	--end
 
    local In_X = X_1 + U * (X_2-X_1)
    local In_Y = Y_1 + U * (Y_2-Y_1)
	
    return Dist_Point_Point_2D(X_0, Y_0, In_X, In_Y)
end

-- Mixes two values
function Mix(A, B, V)
	return (A*V) + (B*(1-V))
end