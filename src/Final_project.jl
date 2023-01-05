module Final_project

export fixmissing, chadminus, packr, vdummy, showparameters, ols

include("fixmissing.jl")
include("chadminus.jl")
include("packr.jl")
include("vdummy.jl")
# possibly declare the variables in the next two files as const
include("Names67Occupations.jl") 
include("SetParameters.jl")

include("ShowParameters.jl")
#include("ReadCohortData.jl") # commented out so code can be loaded without data

println("Finish the calibration part")

include("ols.jl")



end



