export volume2grid, interpolate

import GridInterpolations: interpolate

using GridInterpolations

function volume2grid(volume, ΔX, ΔY, ΔZ)

    # Construct the RectangleGrid
    nx, ny, nz = size(volume)
    xs = 0:ΔX:(nx-1)*ΔX
    ys = 0:ΔY:(ny-1)*ΔY
    zs = 0:ΔZ:(nz-1)*ΔZ
    grid = RectangleGrid(xs, ys, zs)

    # Get the grid values
    grid_values = vec(volume)

    return grid, grid_values
end

interpolate(pt::Vec3{Float64}; grid, pixels) = interpolate(grid, pixels, [pt.x, pt.y, pt.z])