using PowerSystems
using PowerSimulationsDynamics

include("C:/Users/mariu/OneDrive/Masterarbeit/PowerSystems.jl/test/data_2_Bus_Test_Case.jl")
include("C:/Users/mariu/OneDrive/Masterarbeit/PowerSystems.jl/src/add_dyn_components.jl")

sys = generatePowerSystem();
dyn_sys = add_dyn_components(sys)

print(sys)