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

function delThermGen(sys,NNF)
    fall = 1
    bus_numbers = get_bus_numbers(sys);
    gen_name = Vector{Union{Missing, String}}(missing, length(bus_numbers));

for i in 1:14
    if i == 6
        i = 7
    end
    gen_name[i] = string("gen_",i-1)
    gen = get_component(ThermalStandard,sys,gen_name[i])
    set_available!(gen, false)
    to_json(sys,string("02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/System/Output/",fall,"/DynamicSystem_NNF_",NNF,"_Fall_",fall, ".json"),force=true)
    fall = fall + 1;
end


end