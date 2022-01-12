using PowerSimulations
using PowerSystems
using PowerSimulationsDynamics
PSID = PowerSimulationsDynamics
using Sundials
using OrdinaryDiffEq
using Random
using Distributions
using DataFrames
using CSV

# include("C:/Users/mariu/OneDrive/Masterarbeit/PowerSystems.jl/src/parsers/PyPSA2PowerSystems/ImportPyPSA_CSV.jl")
include("C:/Users/mariu/OneDrive/Dokumente/Masterarbeit Lokal/02_Berechnungen/02_TestSciGrid/generateStaticGenerator.jl")
include("C:/Users/mariu/OneDrive/Dokumente/Masterarbeit Lokal/04_SharedFunctions/add_dyn_components_v0.5.jl")

println("===START===")
# sys = generateSystem();
# to_json(sys, "Sci_grid.json", force=true)

sys = System("03_PyPSA2PowerSytsems/Output/SciGrid_14Bus.json")

NNF = 1;
df_loads = DataFrame(CSV.File("03_PyPSA2PowerSytsems/Input/Loads_Clustering/input_loads.csv"))
df_inst_leistung = DataFrame(CSV.File("03_PyPSA2PowerSytsems/Input/Gen_Clustering/inst_gen_p.u.csv"))

size_loads = size(df_loads)
len_loads = size_loads[1]
    
for NNF in 1:len_loads
    generateStaticGenerator(sys,NNF,df_loads,df_inst_leistung)
    println("System: ", NNF, " loaded")
end






# res = solve_powerflow(sys)
# # print(res)

# time_span = (0.0, 30.0);
# # model = PSID.ResidualModel
# model = PSID.MassMatrixModel
# sim = PSID.Simulation!(model, sys, pwd(), time_span)
# show_states_initial_value(sim)

# PSID.execute!(
#     sim, #simulation structure
#     # IDA(), #Sundials DAE Solver (ImplicitModel, ResidualModel)
#     Rodas5(), # OrdinaryDiffEq Paket für Mass Matrix Solver (ODE Solver)
#     # Rodas4(), # OrdinaryDiffEq Paket für Mass Matrix Solver (ODE Solver)
#     dtmax = 0.01,
# );
# sys = System("03_PyPSA2PowerSytsems/Output/SciGrid_14Bus.json")
# end