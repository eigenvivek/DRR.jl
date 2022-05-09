using DRR
using Test

@testset "DRR.jl" begin

    @test size(DRR.read_dicom("../data/cxr")) == (133, 512, 512)

    x = DRR.Vec3(0.0)
    d = DRR.Vec3(1, 1, 0)
    r = DRR.Ray(x, d)
    @test x.x == 0 && x.y == 0 && x.z == 0
    @test x == r.origin
    @test d != r.direction

    @info "Testing trilinear interpolation..."
    @testset "Trilinear Interpolation" begin
        include("trilinear.jl")
    end

end

