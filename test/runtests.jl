using DRR
using Test

@testset "DRR.jl" begin
    @test size(DRR.read_dicom("../data/cxr")) == (133, 512, 512)
end