
# fixmissing.m

function fixmissing(x,missval)

    k = findfirst(isequal(0),missval)

    # for k in range(1,length(x))
    #     if isnan.(x[k]) == false
    #         break
    #     end
    # end

    for m in range(1,k-1)
        x[m]=x[k]
    end

    return x
end 

