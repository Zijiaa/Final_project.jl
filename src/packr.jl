function packr(x)
    (n,k)=size(x)
    if k == 1
        if all(isfinite.(x))==false
            x = [ ] 
        end 
    else
        nanrows = any(isnan.(x), dims=2) 
        x=x[.!vec(nanrows), :]
    end
    return x
end 

