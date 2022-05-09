export make_coordinate_matrix, make_inverse_coordinate_matrix, make_drr

import DRR: interpolate

using LinearAlgebra

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

function trilinearinterpolate(x, y, z, Minv, c)
    p = [
        1
        x
        y
        z
        x * y
        x * z
        y * z
        x * y * z
    ]
    return dot(p, Minv, c)
end


function raytrace_trilinear(ray, spacing::Float64, grid, pixels)
    pts = trace.(0:spacing:1; ray=ray)
    interpolations = interpolate.(pts; grid, pixels)
    return sum(interpolations) / length(pts)
end


function make_drr(grid, pixels, camera, detector, spacing)

    # Set up the detector plane
    plane = make_plane(detector)
    projector = get_rays(camera, plane)

    # Trace rays through the voxel grid
    drr = [raytrace_trilinear(ray, spacing, grid, pixels) for ray in projector]
    return drr

end