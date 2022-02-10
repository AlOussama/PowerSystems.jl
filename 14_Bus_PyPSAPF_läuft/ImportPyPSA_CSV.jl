using PowerSystems
using TimeSeries
using Dates
using Sundials
using OrdinaryDiffEq

using PowerSimulations
using PowerSimulationsDynamics
PSID = PowerSimulationsDynamics


include("C:/Users/mariu/OneDrive - bwedu/1 Universität Stuttgart/Masterarbeit/14_Bus_PyPSAPF/add_dyn_components_v1.0.jl")

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

# println(solve_powerflow(sys))
# return sys
# end;
stoerung =  PSID.BranchTrip(2.0,ACBranch,"10_to_3");

dyn_sys = add_dyn_components(sys)
println(solve_powerflow(dyn_sys))

to_json(dyn_sys, "02_PowerSystems/Output_PowerSystem/Dynamic_SciGrid_NNF_0.json", force = true)

time_span = (0.0, 5.0);
# model = PSID.ResidualModel
model = PSID.MassMatrixModel
sim = PSID.Simulation!(model, dyn_sys, pwd(), time_span)
# show_states_initial_value(sim)

PSID.execute!(
    sim, #simulation structure
    # IDA(), #Sundials DAE Solver (ImplicitModel, ResidualModel)
    Rodas5(), # OrdinaryDiffEq Paket für Mass Matrix Solver (ODE Solver)
    # Rodas4(), # OrdinaryDiffEq Paket für Mass Matrix Solver (ODE Solver)
    dtmax = 0.01,
);

res = read_results(sim)

# frequenz_Node_0 = get_state_series(res, ("Gas_0", :ω)).*50.0
# frequenz_Node_1 = get_state_series(res, ("Gas_1", :ω)).*50.0
# frequenz_Node_2 = get_state_series(res, ("Gas_2", :ω)).*50.0
# frequenz_Node_3 = get_state_series(res, ("Gas_3", :ω)).*50.0
# frequenz_Node_4 = get_state_series(res, ("Gas_4", :ω)).*50.0
# frequenz_Node_5 = get_state_series(res, ("Gas_5", :ω)).*50.0
# frequenz_Node_6 = get_state_series(res, ("Gas_6", :ω)).*50.0
# frequenz_Node_7 = get_state_series(res, ("Gas_7", :ω)).*50.0
# frequenz_Node_8 = get_state_series(res, ("Gas_8", :ω)).*50.0
# frequenz_Node_9 = get_state_series(res, ("Gas_9", :ω)).*50.0
# frequenz_Node_10 = get_state_series(res, ("Gas_10", :ω)).*50.0
# frequenz_Node_11 = get_state_series(res, ("Gas_11", :ω)).*50.0
# frequenz_Node_12 = get_state_series(res, ("Gas_12", :ω)).*50.0
# frequenz_Node_13 = get_state_series(res, ("Gas_13", :ω)).*50.0

# df_frequenz = DataFrame(
#     :time => frequenz_Node_0[1], 
#     :node_0 => frequenz_Node_0[2], 
#     :node_1 => frequenz_Node_1[2],
#     :node_2 => frequenz_Node_2[2],
#     :node_3 => frequenz_Node_3[2],
#     :node_4 => frequenz_Node_4[2],
#     :node_5 => frequenz_Node_5[2],
#     :node_6 => frequenz_Node_6[2],
#     :node_7 => frequenz_Node_7[2],
#     :node_8 => frequenz_Node_8[2],
#     :node_9 => frequenz_Node_9[2],
#     :node_10 => frequenz_Node_10[2],
#     :node_11 => frequenz_Node_11[2],
#     :node_12 => frequenz_Node_12[2],
#     :node_13 => frequenz_Node_13[2],
# )


    # CSV.write("02_PowerSystems/Output_PowerSystem/frequenz.csv", df_frequenz)

# active_power = get_activepower_series(res,"Wind Onshore_0").*100
# reactive_power = get_reactivepower_series(res,"Solar_0").*100
# active_power_1 = get_activepower_series(res,"Solar_2").*100
# reactive_power_1 = get_reactivepower_series(res,"Solar_2").*100

# df_results = DataFrame(:time => active_power[1],:active_power => active_power[2], :reactive_power => reactive_power[2])

# CSV.write("02_PowerSystems/Output_PowerSystem/results.csv", df_results)