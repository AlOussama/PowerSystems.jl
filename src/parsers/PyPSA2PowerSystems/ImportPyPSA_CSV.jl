using PowerSystems
using TimeSeries
using Dates



PATH = "04_PyPSA2PowerSystems/00_Input"

rawsys = PowerSystems.PowerSystemTableData(
    "src/parsers/PyPSA2PowerSystems/01_Output", # Pfad zum CSV Ordner
    100.0, # Basepower
    "src/parsers/PyPSA2PowerSystems/user_descriptors.yaml", # Pfad zur user descriptors
    # timeseries_metadata_file = "05_Julia_Packages/PowerSystems.jl-master/data/RTS_GMLC/timeseries_pointers.json",
    generator_mapping_file = "src/parsers/PyPSA2PowerSystems/generator_mapping.yaml", # generator mapping file
)

sys = System(rawsys);

print(sys)