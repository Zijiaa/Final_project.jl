# % LookatCohortData.m
# %
# % Called from ReadCohortData
# %  Makes some plots to check that things look okay

# % 1990 bw cohort 5 architects missing, whereas small #s in 1970 and 1980!


using Pkg
pkg"add https://github.com/brenhinkeller/NaNStatistics.jl.git"
using NaNStatistics
using Statistics
using Printf

Occs=[1,8,12,16,23]

# CohortConcordance: c=CohortConcordance(1,2) returns Young in Year1 = cohort 6
CohortConcordance=reverse([
[2010 ,1 ,2, 3],
[2000, 2, 3 ,4],
[1990, 3, 4, 5],
[1980, 4 ,5, 6], 
[1970 ,5, 6 ,7 ],
[1960 ,6 ,7, 8]])

CohortConcordance=reduce(vcat,transpose.(CohortConcordance))

# % YearConcordance: yr=YearConcordance(6,2) 
# %    returns Year in which Cohort 6 is young = Year 1 (1960)
YearConcordance=[
[2010 ,6  ], 
[2000 ,5  ],
[1990 ,4  ],
[1980 ,3  ],
[1970 ,2  ],
[1960, 1  ]]

YearConcordance=reduce(vcat,transpose.(YearConcordance));
AggIncomeData=NumPeople.*Earnings;


AggIncomeData_igt=dropdims(nansum(AggIncomeData,dims=3);dims=3);
AggIncomeData_it=dropdims(sum(AggIncomeData_igt,dims=2);dims=2);

earningsweights=AggIncomeData_it./nansum(AggIncomeData_it;dims=1);
earningsweights_avg=mean(earningsweights',dims=1)';
AggIncomeData_gt=dropdims(nansum(AggIncomeData_igt,dims=1),dims=1);
earningsweights_gt=AggIncomeData_gt./nansum(AggIncomeData_gt,dims=1);
earningsweights_g=mean(earningsweights_gt',dims=1)';

EarningsWeights_igt=Array{Float64}(undef, 67,4,6)
# EarningsWeights_igt = weights that sum to one, across occupations, for each group in each year
for g in range(1,Ngroups)
    EarningsWeights_igt[:,g,:]=AggIncomeData_igt[:,g,:]./(nansum(AggIncomeData_igt[:,g,:];dims=1))
end

AggIncomeDataYoung=zeros(Nyears,1)
NumYoung=zeros(Nyears,1)
NumPeoplet=dropdims(dropdims(nansum(nansum(nansum(NumPeople,dims=3),dims=2),dims=1),dims=1),dims=2)'


NumPeople_igt=dropdims(nansum(NumPeople,dims=3),dims=3)
NumPeople_gt=dropdims(nansum(NumPeople_igt,dims=1),dims=1)







# EARNINGS 
AggEarningsperPerson=dropdims(dropdims(nansum(nansum(nansum(AggIncomeData,dims=1),dims=2),dims=3),dims=1),dims=1)'./NumPeoplet
print("Total earnings per person")
print("Decade            Earnings")
display(cat(Decades,AggEarningsperPerson;dims=2))


Earn=copy(AggEarningsperPerson)
print("   \n")
print("Average growth rates of Earnings\n")
print("---------------------------\n")
g=log.(Earn[2:end]./Earn[1:end-1])./(Decades[2:end]-Decades[1:(end-1)])
gAll=log(Earn[end]/Earn[1])/(2010-1960)
yr0=copy(Decades)
yr0[end]=1960
yrT=vcat(Decades[2:end],2010)
display(cat(yr0,yrT,cat(g,gAll,dims=1);dims=2))


# EARNINGS by group
AggEarningsperPerson_g=(AggIncomeData_gt./NumPeople_gt)'
print("  \n")
print("Total earnings per person by group\n")
print("Decade     WM       WW        BM        BW\n")
display(cat(Decades,AggEarningsperPerson_g,dims=2))

Earn_g=copy(AggEarningsperPerson_g)

print("   \n")
print("Average growth rates of Earnings by Group\n")
print("---------------------------\n")

g=log.(Earn_g[2:end,:]./Earn_g[1:end-1,:])./(Decades[2:end]-Decades[1:(end-1)])
gAll_g=(log.(Earn_g[end,:]./Earn_g[1,:])/(2010-1960))'
yr0=copy(Decades)
yr0[end]=1960
yrT=vcat(Decades[2:end],2010)
print("Year0       YearT        WM       WW        BM        BW\n")

display(cat(yr0,yrT,cat(g,gAll_g,dims=1);dims=2))


print(" \n")
print("================================\n")
print("BACK OF THE ENVELOPE CALCULATION\n")
print("================================\n")
print("   \n")

print("Growth rate of all people:",gAll,"\n")
print("Growth rate of    WM     : ",gAll_g[1],"\n")
BOFEshare=1-gAll_g[1]/gAll
print("Rough share of growth from closing gaps: ",BOFEshare,"\n")
print("   \n")


# EARNINGS YOUNG
for t in range(1,Nyears)
    AggIncomeDataYoung[t]=nansum(AggIncomeData[:,:,7-t,t])
    NumYoung[t]=nansum(NumPeople[:,:,7-t,t])
end
print(" \n")
print("Earnings of Young: Per total population and Per person\n")
print("Year   PerTotalPop    PerYoung   Young\n")
display(cat(Decades,AggIncomeDataYoung./NumPeoplet,AggIncomeDataYoung./NumYoung,NumYoung./NumPeoplet*100,dims=2))


# Relative propensity
relp=zeros(size(p))
for g in range(1,Ngroups)
    relp[:,g,:,:]=p[:,g,:,:]./p[:,1,:,:]
end



# % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# % WageBar as Geometric Average
# %  -- from the Arithmetic average variable "Earnings"
# % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if @isdefined Wage
    Wage_controls=copy(Wage)
    WageNominal_controls= copy(WageNominal)
    Wage = nothing
    WageNominal = nothing # To avoid confusion Wage_control is a regression residual
end
# WageBar=GammaBar/GammaBase*Earnings % Using *inflated* Arithmetic mean for WageBar for now.

# 2019: Now using Erik's geometric mean for WageBar
# EarningsWeights_igt=Array{Float64}(undef, size(Earn_geo))
WageBar=copy(Earn_geo)
# % Wage Gap -- Ratio of WageBar
# %   Graph of earnings-weighted average for each group
wagegap=Array{Float64}(undef, size(p))
wagegap_gct = Array{Float64}(undef, 4,8,6)

for g in range(1,Ngroups)
    wagegap[:,g,:,:]=WageBar[:,g,:,:]./WageBar[:,WM,:,:]
    for c in range(1,Ncohorts)
        wagegap_gct[g,c,:]=nansum(wagegap[:,g,c,:].*earningsweights_avg,dims=1)
    end
end 

# % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# % Wage Gaps versus Relative Propensity Graphs (as in Version 3.0)
# %  -- use young cohort and the Earnings = WageBar series from Erik
# % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Occupational wage gaps for white women in 1980 vs relative p's
ymo=1+1 # Young
year =[1980]
t80=find(Decades,year,1)
cYMO80=CohortConcordance[t80,ymo]
relpWW80=relp[:,WW,cYMO80,t80]
# occwagegaps1980=-log(Wage_controls(:,WW,cYMO80,t80)./Wage_controls(:,WM,cYMO80,t80))
occwagegaps1980=-log.(WageBar[:,WW,cYMO80,t80]./WageBar[:,WM,cYMO80,t80])






print("               RelP             Gap")

display(cat(ShortNames,relpWW80,occwagegaps1980,dims=2))


ols(occwagegaps1980,cat(ones(Noccs,1),log.(relpWW80),dims=2),"ols: Levels","logwagegap",["Constant", "logRelProp"],0)







year =[1960]
t60=find(Decades,year,1)
cYMO60=CohortConcordance[t60,ymo]
relpWW60=relp[:,WW,cYMO60,t60]
occwagegaps1960=-log.(WageBar[:,WW,cYMO60,t60]./WageBar[:,WM,cYMO60,t60])


year =[2010]
t10=find(Decades,year,1)
cYMO10=CohortConcordance[t10,ymo]
relpWW10=relp[:,WW,cYMO10,t10]
occwagegaps2010=-log.(WageBar[:,WW,cYMO10,t10]./WageBar[:,WM,cYMO10,t10])




changewage=occwagegaps2010-occwagegaps1960
changelogp=log.(relpWW10)-log.(relpWW60)



print("                 DlnRelP             DlnGap")

display(cat(ShortNames,changelogp,changewage,dims=2))


ols(changewage,cat(ones(Noccs,1),changelogp,dims=2),"ols: Changes","Dlogwagegap",["Constant","DlogRelProp"],0)


# % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# % Var_lnIncome and Var_lnWage versus Relative Propensity Graphs 
# % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# if 'CaseName' in locals():
#     if CaseName =='BenchMark':
#         exec(open('Variance_IncomeWages.py').read())


# % tauhat -- wage gap by Occupation/group/cohort/year...
# %   
# %   relp = tauhat^(-theta) * [wage(g)/wage(wm)]^(-theta(1-eta))
# %
# %   tauhat = relp^(-1/theta) * [wage(g)/wage(wm)]^(-(1-eta))



# % tauhat=zeros(size(p))
# % for i=1:Noccs
# %     tauhat(i,:,:,:)=squeeze(relp(i,:,:,:)).^(-1/theta) .* wagegap.^(-(1-eta))
# % end

print("   \n")
print("   \n")
print("Computing tauhat for *all* c,t:   tauhat=relp.^(-(1-dlta)/theta) .* wagegap.^(-(1-eta))\n")
print("just to see what they look like. We only use the Young (c,c) version.\n")
print("This version ignores the Tbar/gamma stuff. But for baseline case and Young = correct.\n")
print("    \n")
tauhat_all=relp.^(-(1-dlta)/theta) .* wagegap.^(-(1-eta))
tauhat_all[1,:,:,:].=1 # Fix HOME


tauhat=Array{Float64}(undef, 67,4,Nyears)

for t in range(1,Nyears)
    ct=7-t
    tauhat[:,:,t]=tauhat_all[:,:,ct,t] # Noccs x Ngroups x Nyears.  Previously tauhat_y
end
tauhat_y=copy(tauhat) # legacy

# % Copying code from EstimateTauZ to fix missing tauhat_y for use in NoBrawny case
# % (where we use tauhat_y to infer T(i,g) to eliminate frictions)
# % Fix missing values in a systematic way
print("     \n")
print("===========================================================\n")
print("Fixing tauhat missing values --> tauhat_y_cleaned (just for robustness cases)\n")
print(" -- Use first non-missing value\n")
print("      \n")
print("===========================================================\n")
# tauhat_y
tauhat_y_cleaned=copy(tauhat)
for g in range(2,Ngroups)
    print("                     ")
    print("*********************")
    print(GroupNames[g])
    print("*********************") 
    print("                     ")
    for i in range(2,Noccs)
        # tauhat_y
        missingtauhat_y_cleaned=np.logical_or(np.isnan(np.squeeze(tauhat_y_cleaned[i,g,:])), np.isinf(np.squeeze(tauhat_y_cleaned[i,g,:])))

        if all(missingtauhat_y_cleaned): 
            print ('All tauhat_y_cleaned missing. Stopping...' )
            ipdb.set_trace()
        elif any(missingtauhat_y_cleaned):
            print(['tauhat_y_cleaned ' ,ShortNames[i]],np.squeeze(tauhat_y_cleaned[i,g,:]).T)
            tauhat_y_cleaned[i,g,:]=fixmissing(np.squeeze(tauhat_y_cleaned[i,g,:]),missingtauhat_y_cleaned)
            print(['tauhat_y_cleaned ', ShortNames[i]],np.squeeze(tauhat_y_cleaned[i,g,:]).T)





occExe=1+1
occDoc=7+1
occTea=11+1
occLaw=15+1
occSal=21+1
occSec=22+1
occFoo=36+1
occCst=47+1
myoccs=np.array((occDoc, occLaw ,occSec ,occCst ,occTea))


ShortNames=np.array(ShortNames)
# Doctors Lawyer Home Secretaries
# ytle='{\bf Barrier measure, $$\hat\tau$$}'
# ytle='Composite barrier, \tau'
# ytle='Composite barrier'
# if HighQualityFigures ytle=' ' end
for g in range(1,Ngroups):
    print(GroupNames[g])
    print('1960 1970 1980 1990 2000 2010')
    print(np.concatenate((np.reshape((ShortNames[myoccs-1]).T,(5,1)),np.squeeze(tauhat_y[myoccs-1,g,:])),axis=1))



    
    
# % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# % Plot mean and var of composite tau
# % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


meannames='MeanTauHat'
varnames='VarTauHat'
relpnames='StdlnRelP'
gapnames='StdWageGap'
Mkt=range(1,Noccs)

meantau = np.empty((Nyears,4))
meanlogtau= np.empty((Nyears,4))
varlogtau = np.empty((Nyears,4))
lnrelp_young=np.empty((67,4,Nyears))
std_relp_young=np.empty((Nyears,4))
wage_young=np.empty((67,4,Nyears))
gap=np.empty((67,4,Nyears))
std_wagegap=np.empty((Nyears,4))
earningsweights_avg = np.reshape(earningsweights_avg,(67,1))
for t in range(0,Nyears):
    meantau[t,:]=np.nansum(np.multiply(tauhat_y_cleaned[:,:,t],earningsweights_avg),axis=0)
    meanlogtau[t,:]=np.nansum(np.multiply(np.log(tauhat_y_cleaned[:,:,t]),earningsweights_avg),axis=0)
    
    diff=chadminus(np.log(tauhat_y_cleaned[:,:,t]),np.reshape(meanlogtau[t,:],(1,4)))
    varlogtau[t,:]=np.nansum(np.multiply(diff**2,earningsweights_avg),axis=0)


    # std of log(relp)
    
    lnrelp_young[:,:,t]=np.log(relp[:,:,5-t,t])
    lnrelp_young[np.isinf(lnrelp_young)]=math.nan
    lnrelp_young[np.isnan(lnrelp_young)]=math.log(0.001) #min(nanmin(lnrelp_young(:,:,t)))
    meanrelp=np.nansum(np.multiply(lnrelp_young[:,:,t],earningsweights_avg),axis=0)
    meanrelp = np.reshape(meanrelp,(1,4))
    diff=chadminus(lnrelp_young[:,:,t],meanrelp)
    std_relp_young[t,:]=np.sqrt(np.nansum(np.multiply(diff**2,earningsweights_avg),axis=0))

    # std of gap := log(wage ratio)
    wage_young[:,:,t]=Earnings[:,:,5-t,t]
    gap[:,:,t]=np.log(((wage_young[:,:,t]).T/(wage_young[:,WM-1,t])).T)
    gap[np.isinf(gap)]=math.nan
    missinggap=np.isnan(gap[:,:,t])
    missinggap[0,:]=0
    meangap=np.nansum(np.multiply(gap[:,:,t],earningsweights_avg),axis=0)
    meangap=np.reshape(meangap,(1,4))
    gap[missinggap[:,WW-1],WW-1,t]=meangap[:,WW-1] # nanmean(gap(~missinggap(:,WW),WW,t))
    gap[missinggap[:,BM-1],BM-1,t]=meangap[:,BM-1] # nanmean(gap(~missinggap(:,BM),BM,t))
    gap[missinggap[:,BW-1],BW-1,t]=meangap[:,BW-1] # nanmean(gap(~missinggap(:,BW),BW,t))
    diff=chadminus(gap[:,:,t],meangap)
    std_wagegap[t,:]=np.sqrt(np.nansum(np.multiply(diff**2,earningsweights_avg),axis=0))


    




print (' ') 
print(tle)
print( 'Year    WM    WW    BM    BW')
print(np.concatenate((np.reshape(Decades,(6,1)),std_relp_young),axis=1))


tle='Stdev of log(Wage Gap) across occupations'
# title(tle)
# print('-dpsc','-append',pname3)
print (' ') 
print(tle)
print( 'Year    WM    WW    BM    BW')
print(np.concatenate((np.reshape(Decades,(6,1)),std_wagegap),axis=1))

   
    
# Note, clearing stuff...
# clear data*
# clear c Cohort i decindx fmt fname g group occnum tf tle total xNumPeople year yrs yy
# save(['CohortData_' CaseName])