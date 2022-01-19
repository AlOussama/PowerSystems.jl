using PowerSystems
using TimeSeries
using Dates
using Sundials
using OrdinaryDiffEq

using PowerSimulations
using PowerSimulationsDynamics
PSID = PowerSimulationsDynamics


include("C:/Users/mariu/OneDrive - bwedu/1 Universität Stuttgart/Masterarbeit/PyPSA2PowerSystems/add_dyn_components_v1.0.jl")

# PATH = "04_PyPSA2PowerSystems/00_Input"
println("====START====")
rawsys = PowerSystems.PowerSystemTableData(
    "02_PowerSystems/Input_CSV", # Pfad zum CSV Ordner
    100.0, # Basepower
    "user_descriptors.yaml", # Pfad zur user descriptors
    # timeseries_metadata_file = "05_Julia_Packages/PowerSystems.jl-master/data/RTS_GMLC/timeseries_pointers.json",
    generator_mapping_file = "generator_mapping.yaml", # generator mapping file
)

sys = System(rawsys, frequency = 50.0);
to_json(sys, "02_PowerSystems/Output_PowerSystem/Static_SciGrid_NNF_0.json", force = true)

println(solve_powerflow(sys))
# return sys
# end;
stoerung =  PSID.BranchTrip(5.0,ACBranch,"3_to_9");

dyn_sys = add_dyn_components(sys)
println(solve_powerflow(dyn_sys))
time_span = (0.0, 30.0);
# model = PSID.ResidualModel
model = PSID.MassMatrixModel
sim = PSID.Simulation!(model, dyn_sys, pwd(), time_span, stoerung)
show_states_initial_value(sim)

# PSID.execute!(
#     sim, #simulation structure
#     # IDA(), #Sundials DAE Solver (ImplicitModel, ResidualModel)
#     # Rodas5(), # OrdinaryDiffEq Paket für Mass Matrix Solver (ODE Solver)
#     Rodas4(), # OrdinaryDiffEq Paket für Mass Matrix Solver (ODE Solver)
#     dtmax = 0.01,
# );