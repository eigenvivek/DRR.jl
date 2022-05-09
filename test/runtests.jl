using DRR
using Test

@testset "DRR.jl" begin

    @info "Testing DICOM I/O..."
    @testset "I/O" begin
        volume, ΔX, ΔY, ΔZ = DRR.read_dicom("../data/cxr")
        @test size(volume) == (514, 514, 135)
        @test ΔX == ΔY
    end

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

    @info "Testing camera/detector setup..."
    @testset "Camera Geometry" begin
        include("camera.jl")
    end

end

