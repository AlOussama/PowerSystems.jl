using PowerSystems
using TimeSeries
using Dates

PATH = "04_PyPSA2PowerSystems/00_Input"

rawsys = PowerSystems.PowerSystemTableData(
    "05_Julia_Packages/PowerSystems.jl-master/data/RTS_GMLC", # Pfad zum CSV Ordner
    100.0, # Basepower
    "05_Julia_Packages/PowerSystems.jl-master/data/RTS_GMLC/user_descriptors.yaml", # Pfad zur user descriptors
    # timeseries_metadata_file = "05_Julia_Packages/PowerSystems.jl-master/data/RTS_GMLC/timeseries_pointers.json",
    generator_mapping_file = "05_Julia_Packages/PowerSystems.jl-master/data/RTS_GMLC/generator_mapping.yaml", # generator mapping file
)

sys = System(rawsys);

print(sys)