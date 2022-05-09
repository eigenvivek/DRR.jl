function make_coordinate_matrix(x0, y0, z0, x1, y1, z1)
    M = [
        1 x0 y0 z0 x0*y0 x0*z0 y0*z0 x0*y0*z0
        1 x1 y0 z0 x1*y0 x1*z0 y0*z0 x1*y0*z0
        1 x0 y1 z0 x0*y1 x0*z0 y1*z0 x0*y1*z0
        1 x0 y1 z1 x0*y1 x0*z1 y1*z1 x0*y1*z1
        1 x0 y0 z1 x0*y0 x0*z1 y0*z1 x0*y0*z1
        1 x1 y0 z1 x1*y0 x1*z1 y0*z1 x1*y0*z1
        1 x1 y1 z0 x1*y1 x1*z0 y1*z0 x1*y1*z0
        1 x1 y1 z1 x1*y1 x1*z1 y1*z1 x1*y1*z1
    ]
    return M
end


function make_inverse_coordinate_matrix(x0, y0, z0, x1, y1, z1)
    volume = (x1 - x0) * (y1 - y0) * (z1 - z0)
    Minv = [
        x1*y1*z1 -x0*y1*z1 -x1*y0*z1 x1*y0*z0 -x1*y1*z0 x0*y1*z0 x0*y0*z1 -x0*y0*z0
        -y1*z1 y1*z1 y0*z1 -y0*z0 y1*z0 -y1*z0 -y0*z1 y0*z0
        -x1*z1 x0*z1 x1*z1 -x1*z0 x1*z0 -x0*z0 -x0*z1 x0*z0
        -x1*y1 x0*y1 x1*y0 -x1*y0 x1*y1 -x0*y1 -x0*y0 x0*y0
        z1 -z1 -z1 z0 -z0 z0 z1 -z0
        y1 -y1 -y0 y0 -y1 y1 y0 -y0
        x1 -x0 -x1 x1 -x1 x0 x0 -x0
        -1 1 1 -1 1 -1 -1 1
    ]
    return Minv / volume
end
