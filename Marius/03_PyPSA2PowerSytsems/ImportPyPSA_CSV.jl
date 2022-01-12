using PowerSystems
using TimeSeries
using Dates


# function generateSystem()
    

# PATH = "04_PyPSA2PowerSystems/00_Input"
println("====START====")
rawsys = PowerSystems.PowerSystemTableData(
    "03_PyPSA2PowerSytsems/Output", # Pfad zum CSV Ordner
    100.0, # Basepower
    "03_PyPSA2PowerSytsems/user_descriptors.yaml", # Pfad zur user descriptors
    # timeseries_metadata_file = "05_Julia_Packages/PowerSystems.jl-master/data/RTS_GMLC/timeseries_pointers.json",
    #generator_mapping_file = "src/parsers/PyPSA2PowerSystems/generator_mapping.yaml", # generator mapping file
)

sys = System(rawsys);
to_json(sys, "03_PyPSA2PowerSytsems/Output/SciGrid_14Bus.json", force = true)

# return sys
# end;