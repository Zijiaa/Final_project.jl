
# ReadCohhortData

# % Reads the cohort data assembled by Erik in chad_output_file_[Date].csv
# % (see the .xls file for more details).
using Pkg
Pkg.add("CSV")
using Pkg
Pkg.add("DataFrames")
using CSV
using DataFrames

# like ShowParameters, it would be better to put this code in a function

if ~@isdefined CaseName
    println("What would you like to call the CaseName?")
    CaseName = readline()
    println("CaseName= ",CaseName)
end



    

#Year,Group,Cohort,Occupation Number,Weighted Total People in Occ,Avg Occ Income,Education,Wage
#2010,10,1,0,7610209.5,,12.7,
#2010,10,1,1,1965792.0,54377.4,15.0,

# #year,group,cohort,occ_code,num,occ_income,occ_grade,occ_wage
# 2010,0,0,0,2.43E+07,3208.442,12.60451,
# 2010,0,0,1,8273344,82963.73,15.10609,
# 2010,0,0,2,4476900,68100.81,15.21636,
    
#     # Version 6 code

# if allowed, it would be better to include the data in the repository and use a relative path
file = CSV.read("C:\\Users\\liu_z\\Talent_python\\chad_output_file_2019_01_24.csv", DataFrame)
for c ∈ eachcol(file)
    replace!(c, missing => NaN)
end
# file = CSV.read(r"C:\Users\liu_z\Talent_python\chad_output_file_2019_01_24.csv",skiprows = 0,keep_default_na = True,header=0,dtype = float)
#year,group,cohort,occnum,dataNumPeople,dataEarnings,dataEducation,dataWage,dataLnEarn_arith,dataLnEarn_geo,dataLnWage_arith,dataLnWage_geo,datavar_lninc,datavar_lnwage=textread(fname,fmt,"headerlines",1,"delimiter",",","emptyvalue",NaN,nargout=14)
year = file.year
group= file.group
cohort= file.cohort
occnum= file.occ_code
dataNumPeople= file.num
dataEarnings= file.occ_income
dataEducation = file.occ_grade
dataWage = file.occ_wage
dataLnEarn_arith = file.occ_ln_income_arith
dataLnEarn_geo =file.occ_ln_income_geo
dataLnWage_arith=file.occ_ln_wage_arith
dataLnWage_geo =file.occ_ln_wage_geo
datavar_lninc = file.occ_var_ln_income
datavar_lnwage = file.occ_var_ln_wage
year[year.==2012].=2010
occnum = [x+1 for x in occnum] # % So Home=1 rather than Home=0

# #################################
# Initialize key variables
# #################################
    
Nrecords=length(dataNumPeople)
Noccs=67
Ngroups=4
Ncohorts=8
Decades=[1960,1970,1980,1990,2000,2010]'
Decades=reduce(vcat,(Decades))

Nyears=length(Decades)
NumPeople=zeros(Noccs,Ngroups,Ncohorts,Nyears)
Education=copy(NumPeople)
EarningsNominal=copy(NumPeople)
WageNominal=copy(NumPeople)
Earnings=copy(NumPeople)
Wage=copy(NumPeople)
Earn_arith=copy(NumPeople)
Earn_geo=copy(NumPeople)
Wage_arith=copy(NumPeople)
Wage_geo=copy(NumPeople)
Var_lnIncome=copy(NumPeople)
Var_lnWage=copy(NumPeople)
println("Putting earnings / wage in \$2009 constant using PCE Deflator")
# See PCEDeflatorNIPA.txt from https://research.stlouisfed.org/fred2/series/DPCERD3A086NBEA
pce=[17.535,22.311,43.959,67.44,83.131,101.653]

# Totals across all groups (provided by Erik in the .xls file)

AllNumPeople=zeros(Noccs,Ncohorts,Nyears)
AllEducation=copy(AllNumPeople)
AllEarnings=copy(AllNumPeople)


# ##########################################
# Reshape into the multidimensional matrices
# ##########################################



function find(lst, a, b)
    result = 0
    for (i, x) in enumerate(lst)
        if x == a[b]
            result = i
        end
    end
    return result
end
#function as find() in matlab

for i in range(1,Nrecords)
    if cohort[i] != 0
        if group[i] == 0
                AllNumPeople[occnum[i],cohort[i],find(Decades,year,i)]=dataNumPeople[i]
                AllEarnings[occnum[i],cohort[i],find(Decades,year,i)]=dataEarnings[i]
                AllEducation[occnum[i],cohort[i],find(Decades,year,i)]=dataEducation[i]
        else
            if year[i] > 1950
                decindx= find(Decades,year,i)
                NumPeople[occnum[i],group[i],cohort[i],decindx]=dataNumPeople[i]
                if dataEarnings[i] == 0
                    dataEarnings[i]=NaN
                end
                EarningsNominal[occnum[i],group[i],cohort[i],decindx]=dataEarnings[i]
                Earnings[occnum[i],group[i],cohort[i],decindx]=dataEarnings[i]/pce[decindx]*pce[Nyears]
                Education[occnum[i],group[i],cohort[i],decindx]=dataEducation[i]
                WageNominal[occnum[i],group[i],cohort[i],decindx]=dataWage[i]
                Wage[occnum[i],group[i],cohort[i],decindx]=dataWage[i]/pce[decindx]*pce[Nyears]
                Earn_arith[occnum[i],group[i],cohort[i],decindx]=exp(dataLnEarn_arith[i]) / pce[decindx]*pce[Nyears]
                Earn_geo[occnum[i],group[i],cohort[i],decindx]=exp(dataLnEarn_geo[i]) / pce[decindx]*pce[Nyears]
                Var_lnIncome[occnum[i],group[i],cohort[i],decindx]=datavar_lninc[i]
                Var_lnWage[occnum[i],group[i],cohort[i],decindx]=datavar_lnwage[i]
            end
        end
    end
end 
    


# Shut off any earnings in the Home sector -- remnants of Erik"s program 7/25/16
AllEarnings[1,:,:,:].=NaN
EarningsNominal[1,:,:,:].=NaN
Earnings[1,:,:,:].=NaN
Earn_arith[1,:,:,:].=NaN
Earn_geo[1,:,:,:].=NaN




# ###############################################################
# Compute p == fraction of WW in Cohort 3 in 2000 who are lawyers
# ###############################################################

p=zeros(size(NumPeople))
# Treat "NaN as 0 for purposes of computing p
xNumPeople=copy(NumPeople)
xNumPeople=coalesce.(xNumPeople, 0)
total=sum(xNumPeople,dims= 1)

total=dropdims(total;dims=1)
for i in range(1,Noccs)
    p[i,:,:,:]=xNumPeople[i,:,:,:]./total
end


pDataYWM = zeros(Noccs,Nyears)
#where does pDataYWM come from?


# pDataYWM -- p in the data for Young WM
for t in range(1,Nyears)
     pDataYWM[:,t]=p[:,1,7-t,t]
end

# #########################################################################
# Compute q(g,c,t) == fraction of Population who are WW in Cohort 3 in 2000 
# #########################################################################
xNumPeople_t=dropdims(sum(sum(dropdims(sum(sum(xNumPeople;dims=1);dims=1);dims=1);dims=1);dims=2);dims=1)
xNumPeople_gct=dropdims(sum(xNumPeople;dims=1);dims=1)
q=zeros(Ngroups,Ncohorts,Nyears) * NaN

for t in range(1,Nyears)
    q[:,:,t]=xNumPeople_gct[:,:,t] / xNumPeople_t[t]
end

# Adjust Earnings if WageGapAdjustmentFactor=1/2 or Zero.
#  That is, Earnings = (1-WageGapAdjustmentFactor)*Earnings(WM) + WageGapAdjustmentFactor*Earnings(g)
#   Zero ==> Earnings = WM earnings, so no wage gap.
#   1/2  ==>  equally-weighted average of own and WM earnings.








for g in range(1,Ngroups)
    Earnings[:,g,:,:]=(1-WageGapAdjustmentFactor)*Earnings[:,WM,:,:] + WageGapAdjustmentFactor*Earnings[:,g,:,:]
    Wage[:,g,:,:]=(1-WageGapAdjustmentFactor)*Wage[:,WM,:,:] + WageGapAdjustmentFactor*Wage[:,g,:,:]
    Earn_arith[:,g,:,:]=(1-WageGapAdjustmentFactor)*Earn_arith[:,WM,:,:] + WageGapAdjustmentFactor*Earn_arith[:,g,:,:]
    Earn_geo[:,g,:,:]=(1-WageGapAdjustmentFactor)*Earn_geo[:,WM,:,:] + WageGapAdjustmentFactor*Earn_geo[:,g,:,:]
end

Wage[1,:,:,:] .= NaN

# Education YWM for calibrating phiFARM
EducationYWM=zeros(Noccs,Nyears)

for t in range(1,Nyears)
    EducationYWM[:,t]=Education[:,1,7 - t,t]
end

println(" ")
println("Education of Young WM")
println("                    1960       1970     1980      1990     2000    2010")

display(cat(ShortNames,EducationYWM;dims=2))
println(" ")


# disp " ";
# fprintf(["OccupationtoIdentifyPhi = #2.0f " OccupationNames(OccupationtoIdentifyPhi,:) "\n"],OccupationtoIdentifyPhi);

# # Allow use of FARM explicitly
# # (comment out next "if" line when using sales.)
# #if OccupationtoIdentifyPhi~=42;
#     disp "Implied values of Phi for this occupation:"
#     sKey=EducationYWM(OccupationtoIdentifyPhi,:)/25; # 25 years is denominator
#     PhiKeyOcc=(1-eta)/beta.*sKey./(1-sKey)
#     #else;
#     #PhiKeyOcc=phiFarm
#     #end;

#     #wait;

# Now call LookatCohortData to create some graphs
# and save the data for estimation.

# LookatCohortData

