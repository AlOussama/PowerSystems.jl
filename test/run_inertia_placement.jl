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


# sys = generateSystem();
# new_sys = generateStaticGenerator(sys)

bus_numbers_norden = [0;6;5]
bus_numbers_sueden = [3;13; 1; 11;4 ;9; 10]
bus_numbers_ost = [12;7;8;2]

# Simulation Nr.1
#=
Annahme: Last ist in den südlichen/westlichen Knoten doppelt so hoch wie in den anderen Knoten.
         Erzeugung ist im Norden doppelt so hoch wie in den anderen Knoten.
=#

for i in 1:length(bus_numbers_norden) 
    p_load_nord[i] = rand(Uniform(1.0,10.0))
    p_gen_nord[i] = rand(Uniform(1.0,10.0))
end

println(p_load_nord)
prntln(p_gen_nord)