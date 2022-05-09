export Camera, Detector, make_plane, get_rays

import Base: product

"""
    Camera
"""
mutable struct Camera
    center::Vec3
end

"""
    Detector Plane
"""
mutable struct Detector
    center::Vec3
    normal::Vec3
    height::Int64
    width::Int64
    Δx::Float64
    Δy::Float64
end

findz(x, y; a, b, c, d) = (d - a * x - b * y) / c
findz(x::Tuple{Float64,Float64}; a, b, c, d) = findz(x[1], x[2]; a, b, c, d)
append(xy, z) = Vec3(xy..., z)

# Construct the detector array
function make_plane(detector::Detector)
    d = dotprod(detector.center, detector.normal)
    xs = (-detector.height÷2:1:detector.height÷2) * detector.Δx
    ys = (-detector.width÷2:1:detector.width÷2) * detector.Δy
    xys = product(xs, ys) |> collect
    zs = findz.(xys; a=detector.normal.x, b=detector.normal.y, c=detector.normal.z, d=d)
    return append.(xys, zs)
end
get_rays(camera, plane) = [Ray(camera.center, pixel - camera.center) for pixel in plane]
