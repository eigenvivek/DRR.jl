export volume2grid

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