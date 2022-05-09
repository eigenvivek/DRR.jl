module DRR

export read_dicom
include("io.jl")

export Vec3, Ray, trace
include("ray.jl")

export make_coordinate_matrix, make_inverse_coordinate_matrix
include("trilinear.jl")

end # module