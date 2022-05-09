# DRR.jl

## Summary
Digitally reconstructed radiographs (DRR) are simulated projectional radiographs generated from volumetric CT imaging data.
This package provides parallelized, GPU-accelerated, and differentiable DRR generators in Julia.

## Examples

Read the CT volume data and define the camera/detector geometry:
```Julia
# Read the DICOM file
volume, ΔX, ΔY, ΔZ = read_dicom("../data/cxr"; pad=true)
grid, pixels = volume2grid(volume, ΔX, ΔY, ΔZ)  # The bottom-left corner of the CT is placed at (0,0,0)

# Define the camera
center = Vec3(180., 180., -100)
camera = Camera(center)

# Define the detector plane
center = Vec3(180., 180., 500.)
normal = Vec3(0., 0., -1.)
height, width = 601, 601
Δx, Δy = 2., 2.
detector = Detector(center, normal, height, width, Δx, Δy)
```

The CT volume is stored in a `RectangleGrid` object from [`GridInterpolations.jl`](https://github.com/sisl/GridInterpolations.jl), which provides an API for computer trilinear interpolation. To generate a DRR using this method run
```Julia
julia> spacing = 0.5

julia> drr = make_drr(grid, pixels, camera, detector, spacing)

julia> heatmap(drr, c=:grays)
```
which generates the following projection:

<img width="604" alt="Screen Shot 2022-05-09 at 3 04 09 PM" src="https://user-images.githubusercontent.com/29757116/167479789-ecdc3900-8df8-4774-b3f0-836be8bb40fd.png">
