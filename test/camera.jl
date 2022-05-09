@testset "Setup camera/detector parameters" begin
    camera = Camera(Vec3(-1.0))
    detector = Detector(Vec3(1.0), Vec3(-1.0), 101, 101, 0.2, 0.2)
    projector = get_rays(camera, make_plane(detector))
    @test size(projector) == (101, 101)
end