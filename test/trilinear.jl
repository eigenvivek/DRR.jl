@testset "Trilinear Matrices" begin
    x0, y0, z0, x1, y1, z1 = randn(6)
    M = make_coordinate_matrix(x0, y0, z0, x1, y1, z1)
    Minv = make_inverse_coordinate_matrix(x0, y0, z0, x1, y1, z1)
    @test size(M) == size(Minv)
    @test inv(M) ≈ Minv
end

@info "Testing DRR generation..."
@testset "DRR Generation" begin
    volume, ΔX, ΔY, ΔZ = read_dicom("../data/cxr")
    grid, pixels = volume2grid(volume, ΔX, ΔY, ΔZ)

    camera = Camera(Vec3(-300.0))
    height, width = 201, 201
    detector = Detector(Vec3(360, 360, 300.0), Vec3(-1.0), height, width, 2, 2)

    drr = make_drr(grid, pixels, camera, detector, 0.1)
    @test size(drr) == (height, width)
end