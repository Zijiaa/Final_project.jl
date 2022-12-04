

# %  Show the key parameters for the Talent project
# def fprintf(format, *args):
#     sys.stdout.write(format % args)
using Pkg
Pkg.add("SpecialFunctions");
using Printf


using SpecialFunctions;
mu=1/theta*1/(1-eta);

GammaBase=gamma(1 - 1 / (theta*(1-eta)));
GammaTilde=exp(0.57721566 / (theta*(1-eta)));
GammaBar=GammaTilde^(1-dlta)*GammaBase^dlta;
gam= GammaBar;
if ~(FiftyFiftyTauHat==0)
    AlphaSplitTauW1960=1 / 2
end

print(" ")
print("=============================================================\n")
#print("KEY PARAMETER VALUES:    CaseName = "+CaseName)
print(["KEY PARAMETER VALUES:    CaseName = "  CaseName],'\n')

print("                   theta =  $(@sprintf("%8.4f", theta))\n")
print("                     eta =  $(@sprintf("%8.4f", eta))\n")
print("           theta*(1-eta) =  $(@sprintf("%8.4f", theta*(1-eta)))\n")
print("                    dlta =  $(@sprintf("%8.4f", dlta))\n")
print("                      mu =  $(@sprintf("%8.4f", mu))\n")
print("                   sigma =  $(@sprintf("%8.4f", sigma))\n")
print("           EstimateDelta =  $(@sprintf("%8.4f", EstimateDelta))\n")
print("           ConstrainTauH =  $(@sprintf("%8.4f", ConstrainTauH))\n")
print("PurgeWageGrowthSelection =  $(@sprintf("%8.4f", PurgeWageGrowthSelection))\n")


# if "AlphaSplitTauW1960" in locals()
if @isdefined AlphaSplitTauW1960
    print("      AlphaSplitTauW1960 =  $(@sprintf("%8.4f", AlphaSplitTauW1960))\n")
end

print("   OccupationforWageHome = ",OccupationtoIdentifyWageHome,OccupationNames[OccupationtoIdentifyWageHome],'\n')


# # if exist("PhiKeyOcc");
#     fprintf("       phi(KeyOcc) = "); fprintf("#7.4f",PhiKeyOcc); disp " ";
# end;
# fprintf("         phi(Home) = "); fprintf("#7.4f",phiHome); disp " ";
if ~(FiftyFiftyTauHat==0)
    print("FiftyFiftyTauHat = 1 -- robust 50/50 split of tauhat\n")
end
if ~(IgnoreBrawnyOccupations==0)
    print("IgnoreBrawnyOccupations = 1 -- choosing T(i,g) to zero out tauw/h there\n")
end
if (SameExperience == 0)
    print("SameExperience = 0 -- all occs have different returns to experience\n")
end
if ~isnan(ConstantAlpha) 
    print("           ConstantAlpha =  $(@sprintf("%8.4f", ConstantAlpha))\n")
end
if ~isnan(Alpha0FixedSplit)
    print("       Alpha0FixedSplit =  $(@sprintf("%8.4f", Alpha0FixedSplit))\n")
end

if ~(NoFrictions2010==0)
    print("NoFrictions2010 = 1 -- choosing T(i,g,2010) s.t. set tauw(2010)=tauh(2010)=0\n")
end
if (WageGapAdjustmentFactor != 1)
    print("           WageGapAdjustmentFactor =  $(@sprintf("%8.4f", WageGapAdjustmentFactor))\n")
    if (WageGapAdjustmentFactor == 0)
        print("  (i.e. using WM wages for all groups, so no wage gaps")
    end
end
if ~(HalfExperience==0)
    NoGroupAdj=1
    print("HalfExperience= 1 -- Give WW/BM/BW half the returns to experience")
end
if ~(NoGroupExpAdj==0)
    print("NoGroupExpAdj = 1 -- Do not adjust wage growth for experience Y->M\n")
end
if (WhichWageGrowth == 1)
    print("WhichWageGrowth==1 -- Use Y->M wage growth when estimating TauW\n")
end
if (WhichWageGrowth == 2)
    print("WhichWageGrowth==2 -- Use M->O wage growth when estimating TauW\n")
end
if CaseName=="TauWWisZero"
    print(" ")
    print("********************************************************\n")
    print("NOTE WELL: WW and WM are *swtiched* in everything that follows\n")
    print("   in order to check robustness to assuming tau(WW)=0 as our\n")
    print("   normalization\n")
    print("********************************************************\n")
    print(" ")
    print("=============================================================")
    print(" ")
end

print(" \n")
print("********************************************************\n")
