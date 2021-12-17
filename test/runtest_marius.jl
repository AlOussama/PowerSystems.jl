using PowerSimulations
using PowerSystems
using PowerSimulationsDynamics
PSID = PowerSimulationsDynamics
using Sundials
using OrdinaryDiffEq
println("======START======")
include("C:/Users/mariu/OneDrive/Masterarbeit/PowerSystems.jl/test/data_2_Bus_Test_Case.jl")
include("C:/Users/mariu/OneDrive/Masterarbeit/PowerSystems.jl/src/add_dyn_components_v0.2.jl")

sys = generatePowerSystem();
dyn_sys = add_dyn_components(sys,"csv");
# ptintln(dyn_sys)

gen_stoerung = get_component(DynamicGenerator, dyn_sys, "00001_Gas_01")
stoerung = GeneratorTrip(5.0, gen_stoerung)

println(solve_powerflow(sys))

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
# print(results)
# print(sys)
println("=====ENDE=====")