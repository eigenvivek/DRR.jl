@info "Testing trilinear matrices"
@testset "Trilinear Matrices" begin
    x0, y0, z0, x1, y1, z1 = randn(6)
    M = make_coordinate_matrix(x0, y0, z0, x1, y1, z1)
    Minv = make_inverse_coordinate_matrix(x0, y0, z0, x1, y1, z1)
    @test size(M) == size(Minv)
    @test inv(M) ≈ Minv
end