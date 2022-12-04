
# ReadCohhortData

# % Reads the cohort data assembled by Erik in chad_output_file_[Date].csv
# % (see the .xls file for more details).
using Pkg
Pkg.add("CSV")
using Pkg
Pkg.add("DataFrames")
using CSV
using DataFrames



if ~@isdefined CaseName
    CaseName=input("What would you like to call the Case Name?")
end



    

#Year,Group,Cohort,Occupation Number,Weighted Total People in Occ,Avg Occ Income,Education,Wage
#2010,10,1,0,7610209.5,,12.7,
#2010,10,1,1,1965792.0,54377.4,15.0,

# #year,group,cohort,occ_code,num,occ_income,occ_grade,occ_wage
# 2010,0,0,0,2.43E+07,3208.442,12.60451,
# 2010,0,0,1,8273344,82963.73,15.10609,
# 2010,0,0,2,4476900,68100.81,15.21636,
    
#     # Version 6 code


file = CSV.read("C:\\Users\\liu_z\\Talent_python\\chad_output_file_2019_01_24.csv", DataFrame)
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
print("Putting earnings / wage in \$2009 constant using PCE Deflator")
# See PCEDeflatorNIPA.txt from https://research.stlouisfed.org/fred2/series/DPCERD3A086NBEA
pce=[17.535,22.311,43.959,67.44,83.131,101.653]

# Totals across all groups (provided by Erik in the .xls file)

AllNumPeople=zeros(Noccs,Ncohorts,Nyears)
AllEducation=copy(AllNumPeople)
AllEarnings=copy(AllNumPeople)


# ##########################################
# Reshape into the multidimensional matrices
# ##########################################



def find(lst, a, b):
    result = 0
    for i, x in enumerate(lst):
        if x == a[b]:
            result = i
    return result
#function as find() in matlab

for i in range(0,Nrecords):
    if cohort[i] != 0:
        if group[i] == 0:
                AllEducation[int(occnum[i]-1),int(cohort[i]-1),find(Decades,year,i)]=dataEducation[i]
                AllNumPeople[int(occnum[i]-1),int(cohort[i]-1),find(Decades,year,i)]=dataNumPeople[i]
                AllEarnings[int(occnum[i]-1),int(cohort[i]-1),find(Decades,year,i)]=dataEarnings[i]
        else:
            if year[i] > 1950:
                decindx= find(Decades,year,i)
                NumPeople[int(occnum[i]-1),int(group[i]-1),int(cohort[i]-1),decindx]=dataNumPeople[i]
                if dataEarnings[i] == 0:
                    dataEarnings[i]=math.nan
                EarningsNominal[int(occnum[i]-1),int(group[i]-1),int(cohort[i]-1),decindx]=dataEarnings[i]
                Earnings[int(occnum[i]-1),int(group[i]-1),int(cohort[i]-1),decindx]=dataEarnings[i]/pce[decindx]*pce[Nyears-1]
                Education[int(occnum[i]-1),int(group[i]-1),int(cohort[i]-1),decindx]=dataEducation[i]
                WageNominal[int(occnum[i]-1),int(group[i]-1),int(cohort[i]-1),decindx]=dataWage[i]
                Wage[int(occnum[i]-1),int(group[i]-1),int(cohort[i]-1),decindx]=dataWage[i]/pce[decindx]*pce[Nyears-1]
                Earn_arith[int(occnum[i]-1),int(group[i]-1),int(cohort[i]-1),decindx]=math.exp(dataLnEarn_arith[i]) / pce[decindx]*pce[Nyears-1]
                Earn_geo[int(occnum[i]-1),int(group[i]-1),int(cohort[i]-1),decindx]=math.exp(dataLnEarn_geo[i]) / pce[decindx]*pce[Nyears-1]
                Var_lnIncome[int(occnum[i]-1),int(group[i]-1),int(cohort[i]-1),decindx]=datavar_lninc[i]
                Var_lnWage[int(occnum[i]-1),int(group[i]-1),int(cohort[i]-1),decindx]=datavar_lnwage[i]




# Shut off any earnings in the Home sector -- remnants of Erik"s program 7/25/16
#AllEarnings[0,:,:]=math.nan
EarningsNominal[1,:,:,:]=NaN
Earnings[1,:,:,:]=NaN
Earn_arith[1,:,:,:]=NaN
Earn_geo[1,:,:,:]=NaN




# ###############################################################
# Compute p == fraction of WW in Cohort 3 in 2000 who are lawyers
# ###############################################################

p=np.zeros(NumPeople.shape)
# Treat "NaN as 0 for purposes of computing p
xNumPeople=np.copy(NumPeople)
xNumPeople[np.isnan(xNumPeople)]=0
total=np.sum(xNumPeople,axis=0)


for i in range(0,Noccs):
    #p[i]=np.divide(xNumPeople[i] , total)
    p[i]=xNumPeople[i]/total

pDataYWM = np.zeros((Noccs,Nyears))
#where does pDataYWM come from?


# pDataYWM -- p in the data for Young WM
for t in range(0,Nyears):
     pDataYWM[:,t]=p[:,0,5-t,t]


# #########################################################################
# Compute q(g,c,t) == fraction of Population who are WW in Cohort 3 in 2000 
# #########################################################################
import math
xNumPeople_t=sum(np.squeeze(sum(sum(xNumPeople))))
xNumPeople_gct=np.squeeze(sum(xNumPeople))
q=np.zeros((Ngroups,Ncohorts,Nyears)) * math.nan

for t in range(0,Nyears):
    q[:,:,t]=np.squeeze(xNumPeople_gct[:,:,t]) / xNumPeople_t[t]


# Adjust Earnings if WageGapAdjustmentFactor=1/2 or Zero.
#  That is, Earnings = (1-WageGapAdjustmentFactor)*Earnings(WM) + WageGapAdjustmentFactor*Earnings(g)
#   Zero ==> Earnings = WM earnings, so no wage gap.
#   1/2  ==>  equally-weighted average of own and WM earnings.








for g in range(0,Ngroups):
    Earnings[:,g,:,:]=np.dot((1 - WageGapAdjustmentFactor),Earnings[:,WM-1,:,:]) + np.dot(WageGapAdjustmentFactor,Earnings[:,g,:,:])
    Wage[:,g,:,:]=np.dot((1 - WageGapAdjustmentFactor),Wage[:,WM-1,:,:]) + np.dot(WageGapAdjustmentFactor,Wage[:,g,:,:])
    Earn_arith[:,g,:,:]=np.dot((1 - WageGapAdjustmentFactor),Earn_arith[:,WM-1,:,:]) + np.dot(WageGapAdjustmentFactor,Earn_arith[:,g,:,:])
    Earn_geo[:,g,:,:]=np.dot((1 - WageGapAdjustmentFactor),Earn_geo[:,WM-1,:,:]) + np.dot(WageGapAdjustmentFactor,Earn_geo[:,g,:,:])


Wage[0,:,:,:] = math.nan

# Education YWM for calibrating phiFARM
EducationYWM=np.zeros((Noccs,Nyears))

for t in range(0,Nyears):
    EducationYWM[:,t]=Education[:,0,5 - t,t]


fprintf(" ")
fprintf("Education of Young WM")
#cshow(ShortNames,EducationYWM,"%8.4f","1960 1970 1980 1990 2000 2010")
fprintf(" ")


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

#LookatCohortData
logging.shutdown()

