
using Test

@testset "packr.jl" begin
    X = ones(6,3)
    X[1,1]=NaN

    t2= packr(X)

    @test t2 == ones(5,3)

end

@testset "ols.jl" begin
    


end