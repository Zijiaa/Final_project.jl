###1###
#test packr function
using Test

@testset "packr.jl" begin
    X = ones(6,3)
    X[1,1]=NaN

    t2= packr(X)

    @test t2 == ones(5,3)

end



###2###
#test ols function
using LinearAlgebra

@testset "ols.jl" begin

    y =[NaN,
    1,
    2,
    3,
    4]

    y =reshape(y,5,1)

    x=   [ [1.0000 ,   1]
    [1.0000 ,  1]
    [1.0000 ,  2]
    [1.0000 ,  3]
    [1.0000 ,  4]]
    x=reshape(x,5,2)

    title = "test_ols"
    depv = "Chang_dVar(Wage)"
    indv = ["Constant"," DlogRelProp"]
    prevest = 0
    a,b,c,d,e=ols(y,x,title,depv,indv,prevest)
    a[1]=round(a[1];digits=3)
    a[2]=round(a[2];digits=3)
    @test a≈ [1.333,0.519]

end


###3###
#test vdummy function
@testset "vdummy.jl" begin
    name = "x"
    len = 5
    t3= vdummy(name,len)
    @test t3 ==  reshape(["x1","x2","x3","x4","x5"],5,1)
end


###4###
#test fixmissing function
@testset "fixmissing.jl" begin
    x = [NaN,2.45,5,6,8,9,3,3.65]
    missval = isnan.(x) + isinf.(x) 
    missval = Vector{Bool}(missval) 
    t3= fixmissing(x,missval)
    @test t3 ==  [2.45,2.45,5,6,8,9,3,3.65]
end

###5###
#test chadminus function
@testset "chadminus.jl" begin
    X = ones(67,4)
    Y = ones(4,1)
    t3= chadminus(X,Y)
    @test t3 ==  zeros(67,4)
end

