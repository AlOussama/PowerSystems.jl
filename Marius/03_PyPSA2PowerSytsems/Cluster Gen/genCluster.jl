using CSV
using DataFrames

#=
Grundlegende Idee: Input Generatorfile wird geclustert, dann wird ein PowerFlow gerechnet mit dem Geclusterten Netz
und den geclusterten Generatoren --> Eingabe für unser Netz.
=#
anzahl_cluster_busses = 14
input_gen_df = DataFrame(CSV.File("PowerSystems.jl/Marius/03_PyPSA2PowerSytsems/Cluster Gen/Input/generators.csv"));

inst_gas = 0.0;
inst_

for i in 1:anzahl_cluster_busses
    


end