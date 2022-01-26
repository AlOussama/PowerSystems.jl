using PowerSimulations
using PowerSystems
using PowerSimulationsDynamics
PSID = PowerSimulationsDynamics
using Sundials
using OrdinaryDiffEq
using CSV
using Plots
println("======START======")
include("C:/Users/mariu/OneDrive - bwedu/1 Universität Stuttgart/Masterarbeit/PowerSystems.jl/Marius/02_Berechnungen/01_TestSharedFunctions/data_2_Bus_Test_Case.jl")
include("C:/Users/mariu/OneDrive - bwedu/1 Universität Stuttgart/Masterarbeit/PowerSystems.jl/Marius/02_Berechnungen/01_TestSharedFunctions/add_dyn_components_v0.5.jl")

sys = generatePowerSystem();
println(solve_powerflow(sys))
# print(sys)
dyn_sys = add_dyn_components(sys,"csv");
# ptintln(dyn_sys)

gen_stoerung = get_component(DynamicGenerator, dyn_sys, "00001_Gas_01")
stoerung = GeneratorTrip(5.0, gen_stoerung)

# # println(solve_powerflow(sys))

time_span = (0.0, 30.0);
# model = PSID.ResidualModel
model = PSID.MassMatrixModel
sim = PSID.Simulation!(model, dyn_sys, pwd(), time_span, stoerung)
show_states_initial_value(sim)

PSID.execute!(
    sim, #simulation structure
    # IDA(), #Sundials DAE Solver (ImplicitModel, ResidualModel)
    Rodas5(), # OrdinaryDiffEq Paket für Mass Matrix Solver (ODE Solver)
    # Rodas4(), # OrdinaryDiffEq Paket für Mass Matrix Solver (ODE Solver)
    dtmax = 0.01,
    
);

# results = read_results(sim);
# println(results)
# CSV.write(results, "Test.csv")
# open("myfile.txt", "w") do io
#     write(io, string(results))
# end;

# # print(results)
# # print(sys)
println("=====ENDE=====")

# v1 = PSID.get_voltage_magnitude_series(results,1);
# v2 = PSID.get_voltage_magnitude_series(results,2);


# # v1_winkel = PSID.get_voltage_angle_series(results,1);
# # v2_winkel = PSID.get_voltage_angle_series(results,2);


# # ang1 = get_state_series(results, ("00001_Solar_2", :δ));
# # omega1 = PSID.get_state_series(results, ("00001_Solar_2", :ω));
# # # ang2 = get_state_series(results, ("00001_Gas_01", :δ));
# # omega2 = PSID.get_state_series(results, ("00001_Gas_01", :ω));

# println("============== ENDE ==============")

# # vol =Plots. plot( 
# plot(v1 , xlabel = "time", ylabel = "Voltage p.u.", label = "Knoten 1"),
# plot!(v2 , label = "Knoten 2"),
# );
# savefig(vol,"Voltage.png")

# win = Plots.plot(
# plot(v1_winkel , xlabel = "time", ylabel = "Winkel rad", label = "Knoten 1"),
# plot!(v2_winkel , label = "Knoten 2"),
# );
# savefig(win,"Winkel.png")

# om = Plots.plot(
# plot(v1_winkel , xlabel = "time", ylabel = "Winkel rad", label = "Knoten 1"),
# plot!(v2_winkel , label = "Knoten 2"),
# );
# savefig(om,"Omega.png")