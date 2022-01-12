using PowerSimulations
using PowerSystems
using PowerSimulationsDynamics
PSID = PowerSimulationsDynamics
using Sundials
using OrdinaryDiffEq
using Random
using Distributions

include("C:/Users/mariu/OneDrive/Masterarbeit/PowerSystems.jl/src/parsers/PyPSA2PowerSystems/ImportPyPSA_CSV.jl")
include("C:/Users/mariu/OneDrive/Masterarbeit/PowerSystems.jl/test/generateStaticGenerator.jl")


sys = generateSystem();
new_sys, gen_name, load_name = generateStaticGenerator(sys)
print(new_sys)

bus_numbers_norden = [0;6;5]
bus_numbers_sueden = [3;13; 1; 11;4 ;9; 10]
bus_numbers_ost = [12;7;8;2]

# Simulation Nr.1
#=
Annahme: Last ist in den südlichen/westlichen Knoten doppelt so hoch wie in den anderen Knoten.
         Erzeugung ist im Norden doppelt so hoch wie in den anderen Knoten.
=#
load_all = Vector{Union{Missing, Float64}}(missing, 14);
gen_all = Vector{Union{Missing, Float64}}(missing, 14);
for i in 1:14
    load_all[i]=rand(Uniform(0.1,2.5))
    gen_all[i]=rand(Uniform(0.1,2.5))
end

p_load_nord = Vector{Union{Missing, Float64}}(missing, length(bus_numbers_norden));
p_gen_nord = Vector{Union{Missing, Float64}}(missing, length(bus_numbers_norden));

p_load_ost = Vector{Union{Missing, Float64}}(missing, length(bus_numbers_ost));
p_gen_ost = Vector{Union{Missing, Float64}}(missing, length(bus_numbers_ost));

p_load_south = Vector{Union{Missing, Float64}}(missing, length(bus_numbers_sueden));
p_gen_south = Vector{Union{Missing, Float64}}(missing, length(bus_numbers_sueden));

load_factor_south= rand(Uniform(1.5,5.0))
gen_factor_nord = rand(Uniform(1.5,5.0))

p_load_nord = load_all[1:3]
p_gen_nord = gen_all[1:3]*gen_factor_nord
p_gen_ost = gen_all[4:7]
p_load_ost = load_all[4:7]
p_load_south = load_all[8:end]*load_factor_south
p_gen_south = gen_all[8:end]

# for i in 1:length(bus_numbers_norden)
#     x = bus_numbers_norden[i]
#     name_gen = string("gen_",x)
#     name_load = string("load_",x)
#     set_active_power!(get_component(ThermalStandard,new_sys,name_gen),p_gen_nord[i])
#     set_active_power!(get_component(PowerLoad,new_sys,name_load),p_load_nord[i])
# end

# for i in 1:length(bus_numbers_ost)
#     x = bus_numbers_ost[i]
#     name_gen = string("gen_",x)
#     name_load = string("load_",x)
#     set_active_power!(get_component(ThermalStandard,new_sys,name_gen),p_gen_ost[i])
#     set_active_power!(get_component(PowerLoad,new_sys,name_load),p_load_ost[i])
# end

# for i in 1:length(bus_numbers_sueden)
#     x = bus_numbers_sueden[i]
#     name_gen = string("gen_",x)
#     name_load = string("load_",x)
#     # println(get_component(ThermalStandard,sys,name_gen))
#     # println(get_component(PowerLoad,sys,name_load))
#     set_active_power!(get_component(ThermalStandard,new_sys,name_gen),p_gen_south[i])
#     set_active_power!(get_component(PowerLoad,new_sys,name_load),p_load_south[i])
# end

# print(new_sys)


res = solve_powerflow(new_sys)

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

# results = read_results(sim);