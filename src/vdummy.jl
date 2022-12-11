function vdummy(name::String,len::Int64)
    f = Array{String}(undef, len, 1)
    for i in range(1,len)
        f[i] = name * string(i)
    end 
    return f
end     