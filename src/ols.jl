
using LinearAlgebra

function ols(y,x,title,depv,indv,prevest)
     if all(x[:,1].!=1)
        println("No constant term in regression")
    end
    if (@isdefined prevest) && prevest !=1
        prevest = 0
    end 
    if title == Nothing
        title = "Ordinary Least Squares"
    end
    if depv == 0 
        depv = "     "
    end 

    (N,K) = size(x)
    if indv == 0
        indv = vdummy("x",K)
    end

    data = cat(y,x,dims=2)
    data = packr(data)

    if size(data)[1] != N
        println("Missing values encountered")
        y = data[:,1]
        x = data[:,2:end]
        (N,K)=size(x)
    end 


    xxinv = inv(x'*x)
    beta  = xxinv*x'*y
    u     = y-x*beta
    dof   = N-K-prevest
    sigma2=u'*u/dof
    stdest=sqrt(sigma2)
    vcv   =sigma2*xxinv
    se    =sqrt(Diagonal(vcv))
    tstat = beta./se
    ybar  = 1/N*(ones(N,1)'*y)
    rsq   = 1 .- (u'*u)./([y'*y] .- N*ybar.^2)
    rbar  = 1 .- [sigma2]./(([y'*y] .- N*ybar.^2)./(N-1))
    
    robvcv=zeros(K,K);
    for i=1:N
        robvcv = robvcv .+ u[i]^2*x[i,:]'.*x[i,:]
    end
    robvcv = (N/(dof))*xxinv*robvcv*xxinv
    roberr = sqrt(Diagonal(robvcv))
    trob   = beta./roberr

    println("=============================================================================\n")
    println(" \n")
    println(" ")
    println("         ------------------------------------------------------------\n")
    println("                   ", title, "\n")
    println("         ------------------------------------------------------------\n")
    println(" \n")
    println("       NOBS:  ", N,"                Dependent Variable: ",depv,"\n")
    println("   RHS Vars: ", K,"\n")
    println("    D of F:  ", dof, "\n");
    println(" ")
    println("  R-Squared:  ", rsq,'\n')
    println("                        S.E.E.:  ", stdest, "\n")
    println("     RBar^2:  ", rbar,'\n')
    println("                   Residual SS:  ", u'*u, "\n")
    println(" ")
    println("                             Standard              Robust     Robust\n")
    println("Variable          Beta         Error    t-stat      Error     t-stat\n")
    println("--------          ----       --------   ------     ------     ------\n")
    println(" \n")
    results=cat(beta, diag(se) ,diag(tstat), diag(roberr),diag(trob),dims = 2)



    for i in range(1,K)
        println(indv[i,:],"       ")
        println(results[i,:],'\n')
        println('\n')
    end
    println(" \n")
    println(" \n")
    println("=============================================================================\n")



    K=K+prevest			#  Return Correct # of Estimated Pars

    return beta, diag(se) ,diag(tstat), diag(roberr),diag(trob);
end 