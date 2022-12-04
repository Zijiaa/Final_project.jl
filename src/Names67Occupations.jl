

function logical(a)
    return [(x==1) for x in a]
end

OccupationNames= ["Home ","Executives, Administrative, and Managerial","Management Related  ","Architects  ","Engineers   ","Math and Computer Science                 ","Natural Science                           ","Doctors                                   ","Health Assessment                         ","Therapists                                ","Professors                                ","Teachers          Non-Postsecondary       ","Librarians  and Curators                  ","Social Scientists and Urban Planners      ","Social Work                               ","Lawyers       and Judges                  ","Arts and Athletes                         ","Health Technicians                        ","Engineering Technicians                   ","Science Technicians                       ","Technicians, Other                        ","Sales, all                                ","Secretaries                               ","Info. Clerks                              ","Records Processing, Non-Financial         ","Financial Records Processing              ","Office Machine Operator                   ","Computer/Communications Equip. Operator   ","Mail Distribution                         ","Scheduling and Distributing Clerks        ","Adjusters and Investigators               ","Misc. Admin Support                       ","Private Household Occupations             ","Firefighting                              ","Police                                    ","Guards                                    ","Food Prep    and Service                  ","Health Service                            ","Cleaning and Building Service             ","Personal Service                          ","Farm Managers                             ","Farm Work                                 ","Related Agriculture                       ","Forest, Logging, Fishers and Hunter       ","Mechanics                                 ","Elec. Repairer                            ","Misc. Repairer                            ","Construction Trade                        ","Extractive                                ","Supervisor(P)                             ","Precision Metal                           ","Precision Wood                            ","Precision, Textile                        ","Precision, Other                          ","Precision, Food                           ","Plant Operator                            ","Metal and Plastic Machine Operator        ","Metal and Plastic Processing Operator     ","Woodworking Machine Operator              ","Textile Machine Operator                  ","Print Machine Operator                    ","Machine Operator, Other                   ","Fabricators                               ","Production Inspectors                     ","Motor Vehicle Operator  ","Non Motor Vehicle Operator","Freight, Stock, Material Handler"]

ShortNames=["Home","Managers","MgmtRelated","Architects","Engineers","Math/CompSci","Science","Doctors","Nurses","Therapists","Professors","Teachers","Librarians","Soc.Scientists","SocialWork","Lawyers","Arts/Athletes","HealthTechs","Eng.Techs","ScienceTechs","OtherTechs","Sales","Secretaries","Info.Clerks","Records","FinancialClerk","OfficeMachine","ComputerTech","Mail","Clerks","Insurance","Misc.Admin","PrivateHshld","Firefighting","Police","Guards","FoodPrep","HealthService","Cleaning","PersonalService","FarmMgrs","FarmWork","Agriculture","Forest","Mechanics","Elec.Repairer","Misc.Repairer","Construction","Extractive","Supervisor(P)","MetalWork","WoodWork","Textiles","Other","Food","PlantOperator","MetalMach.","MetalProc.","WoodMach.","TextileMach.","PrintMach.","OtherMach.","Fabricators","Prod.Inspectors","MotorVehicle","OtherVehicle","Freight"]

# Define BrawnyOccupations = 1 for "brawny" occs (mfg, firefighting, farm, etc)
# See Rendall-Brawniness-Index.xls spreadsheet


BrawnyOccupations=[0, # "Executives, Administrative, and Managerial"        
0, # "Management Related"                                
0, # "Architects"                                        
0, # "Engineers "                                        
0, # "Math and Computer Science "                        
0, # "Natural Science "                                  
0, # "Doctors " # Health Diagnosing                      
0, # "Health Assessment "                                
0, # "Therapists"                                        
0, # "Professors" #Teachers, Postsecondary               
0, # "TeachersNon-Postsecondary "                        
0, # "Librariansand Curators"                            
0, # "Social Scientists and Urban Planners"              
0, # "Social Work "                                      
0, # "Lawyers and Judges"                                
0, # "Arts and Athletes "                                
0, # "Health Technicians"                                
0, # "Engineering Technicians "                          
0, # "Science Technicians "                              
0, # "Technicians, Other"                                
0, # "Sales, all"                                        
0, # "Secretaries "                                      
0, # "Info. Clerks"                                      
0, # "Records Processing, Non-Financial "                
0, # "Financial Records Processing"                      
0, # "Office Machine Operator "                          
0, # "Computer/Communications Equip. Operator "          
0, # "Mail Distribution "                                
0, # "Scheduling and Distributing Clerks"                
0, # "Adjusters and Investigators "                      
0, # "Misc. Admin Support "                              
0, # "Private Household Occupations "                    
1, # "Firefighting"                                      
1, # "Police"                                            
1, # "Guards"                                            
0, # "Food Prepand Service"                              
0, # "Health Service"                                    
1, # "Cleaning and Building Service "                    
0, # "Personal Service"                                  
1, # "Farm Managers "                                    
1, # "Farm Work "                                        
1, # "Related Agriculture "                              
1, # "Forest, Logging, Fishers and Hunter "              
1, # "Mechanics " #Vehicle                               
0, # "Elec. Repairer"                                    
1, # "Misc. Repairer"                                    
1, # "Construction Trade"                                
1, # "Extractive"                                        
1, # "Supervisor(P) " # Precision supervisor             
1, # "Precision Metal "                                  
1, # "Precision Wood"                                    
1, # "Precision, Textile"                                
0, # "Precision, Other"                                  
1, # "Precision, Food "                                  
1, # "Plant Operator"                                    
1, # "Metal and Plastic Machine Operator"                
1, # "Metal and Plastic Processing Operator "            
1, # "Woodworking Machine Operator"                      
1, # "Textile Machine Operator"                          
1, # "Print Machine Operator"                            
1, # "Machine Operator, Other "                          
1, # "Fabricators "                                      
0, # "Production Inspectors "                            
1, # "Motor Vehicle Operator"                            
1, # "Non Motor Vehicle Operator"                        
1, # "Freight, Stock, Material Handler"                  
]

BrawnyOccupations=logical(BrawnyOccupations)

# T(i,g,Age) -- returns to experience
# From Erik, Jan 26, 2015 -- 
# As of Jan 2016, we are no longer using this. Chang has cohort-specific code in EsstimateTauZ.m
TigYMO_Erik=[[NaN,NaN,NaN],[1.0,1.581,1.785],[1.0,1.735,2.099],[1.0,1.871,2.387],[1.0,1.863,2.382],[1.0,1.731,2.141],[1.0,1.812,2.168],[1.0,2.089,2.465],[1.0,1.999,2.708],[1.0,1.808,2.26],[1.0,1.952,2.412],[1.0,1.904,2.469],[1.0,1.752,2.113],[1.0,1.851,2.245],[1.0,1.77,2.174],[1.0,2.207,2.769],[1.0,1.713,2.095],[1.0,1.728,2.235],[1.0,1.752,2.338],[1.0,1.682,2.128],[1.0,1.791,2.298],[1.0,1.597,1.871],[1.0,1.63,1.962],[1.0,1.675,2.111],[1.0,1.637,1.973],[1.0,1.664,2.103],[1.0,1.571,1.893],[1.0,1.698,2.194],[1.0,1.626,2.035],[1.0,1.643,2.105],[1.0,1.734,2.257],[1.0,1.639,2.005],[1.0,1.546,1.882],[1.0,1.717,2.294],[1.0,1.688,2.164],[1.0,1.56,1.835],[1.0,1.718,2.348],[1.0,1.616,1.997],[1.0,1.523,1.809],[1.0,1.62,2.017],[1.0,1.485,1.661],[1.0,1.517,1.871],[1.0,1.585,2.009],[1.0,1.474,1.688],[1.0,1.598,2.007],[1.0,1.642,2.1],[1.0,1.563,1.913],[1.0,1.584,1.987],[1.0,1.558,1.932],[1.0,1.581,1.923],[1.0,1.591,1.991],[1.0,1.571,1.951],[1.0,1.528,1.885],[1.0,1.625,2.043],[1.0,1.556,1.926],[1.0,1.651,2.071],[1.0,1.555,1.912],[1.0,1.572,1.964],[1.0,1.623,2.098],[1.0,1.597,1.997],[1.0,1.485,1.753],[1.0,1.511,1.797],[1.0,1.576,1.965],[1.0,1.627,2.066],[1.0,1.578,1.967],[1.0,1.578,1.962],[1.0,1.543,1.881]]

DecadeNames=[1960,1970,1980,1990,2000,2010]'

GroupNames=["White Men","White Women","Black Men","Black Women"]
WM=1
WW=2
BM=3
BW=4


