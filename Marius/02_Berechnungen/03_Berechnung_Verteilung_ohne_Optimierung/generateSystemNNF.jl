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


include("C:/Users/mariu/OneDrive/Dokumente/Masterarbeit Lokal/02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/generateStaticGenerator.jl")
include("C:/Users/mariu/OneDrive/Dokumente/Masterarbeit Lokal/02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/deleadThermGen.jl")
println("===START===")

NNF = 1;
sys = System("03_PyPSA2PowerSytsems/Output/SciGrid_14Bus.json")
df_loads = DataFrame(CSV.File("02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/System/Input/01_PyPSA/loads_input_pu.csv"))
df_inst_leistung = DataFrame(CSV.File("02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/System/Input/01_PyPSA/inst_leistung_pu.csv"))
df_re_gen = DataFrame(CSV.File("02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/System/Input/01_PyPSA/re_gen_pu.csv"))
df_thermal_gen = DataFrame(CSV.File("02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/System/Input/01_PyPSA/thermal_gen_pu.csv"))

# println(df_re_gen)
# println(df_re_gen[NNF,2])

size_loads = size(df_loads)
len_loads = size_loads[1]

for NNF in 1:len_loads
        generateStaticGenerator(sys,NNF,df_loads,df_inst_leistung,df_re_gen,df_thermal_gen)
        println("System: ", NNF, " erstellt!")
end

for NNF in 1:len_loads
    sys = System(string("02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/System/Output/0/DynamicSystem_NNF_",NNF,"_Fall_0.json"))
    delThermGen(sys,NNF)
end




# sys = System("02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/System/Output/DynamicSystem_NNF_1.json")

# res = solve_powerflow(sys)
# print(res)

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
