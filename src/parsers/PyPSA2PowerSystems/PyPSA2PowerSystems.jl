using CSV
using DataFrames

println("=====START=====")
pypsa_bus = DataFrame(CSV.File("04_PyPSA2PowerSystems/00_Input/buses.csv"));
pypsa_gen_p_max = DataFrame(CSV.File("04_PyPSA2PowerSystems/00_Input/generators-p_max_pu.csv"));
pypsa_gen = DataFrame(CSV.File("04_PyPSA2PowerSystems/00_Input/generators.csv"));
pypsa_lines = DataFrame(CSV.File("04_PyPSA2PowerSystems/00_Input/lines.csv"));
pypsa_loads = DataFrame(CSV.File("04_PyPSA2PowerSystems/00_Input/loads.csv"));
pypsa_loads_p_set = DataFrame(CSV.File("04_PyPSA2PowerSystems/00_Input/loads-p_set.csv"));
pypsa_storage = DataFrame(CSV.File("04_PyPSA2PowerSystems/00_Input/storage_units.csv"));


size_bus = size(pypsa_bus);
size_gen_p_max = size(pypsa_gen_p_max);
size_gen = size(pypsa_gen);
size_lines = size(pypsa_lines);
size_loads = size(pypsa_loads);
size_loads_p_set = size(pypsa_loads_p_set);
size_storage = size(pypsa_storage);

nnf = 0 # Netznutzungsfall von 0 bis 24

# Bus Schleife für Slack und Bus Namen.
name_bus=Vector{Union{Missing, String}}(missing, size_bus[1]);
for x in 1:size_bus[1]
    name_bus[x]= string("Bus ",pypsa_bus.name[x]);
    if pypsa_bus.control[x] == "Slack"
        pypsa_bus.control[x] = "REF"
    end
end
pypsa_bus[!, "bus_name"] .= name_bus


# Bus Dataframe
ps_bus = DataFrame(
    name= pypsa_bus.bus_name,
    bus_id= pypsa_bus.name,
    bus_type = pypsa_bus.control, # Nicht notwendiger Parameter
    voltage = pypsa_bus.v_nom,
);

# Generaotrschleife für Generatornamen

for x in 1:size_gen[1] 
    if pypsa_gen.control[x] == "Slack"
        pypsa_gen.control[x] = "PV"
    end
end


# Generator DataFrame
ps_gen = DataFrame(
    name=pypsa_gen.name,
    bus_id = pypsa_gen.bus,
    fuel = "OTHER",#pypsa_gen.carrier,
    fuel_price =  pypsa_gen.marginal_cost,
    active_power =pypsa_gen.p_nom, # Keine Vorgabe --> Lieber bei 0?
    active_power_limits_max = pypsa_gen.p_nom,
    active_power_limits_min = 0.1, # keine Vorgabe
    reactive_power_limits_max = 100.0,
    reactive_power_limits_min = 0.1,
    min_down_time = 1.0, # Realistische Werte?
    min_up_time = 3.0, # Realistische Werte
    unit_type = pypsa_gen.control,
    bace_mva = 100.0,# Notwendig
    # generator_category = "", # Nicht Notwendig
);

# Branch DataFrame
r_ohm_km =0.04 # Median der Werte im SciGrid (PyPSA Orginal)
x_ohm_km = 0.32 # Median der Werte im SciGrid (PyPSA Orginal)
c_nf_km = 11.5 # Median der Werte im SciGrid (PyPSA Orginal)

branch_name=Vector{Union{Missing, String}}(missing, size_lines[1]);
for x in 1:size_lines[1]
    branch_name[x] = string(pypsa_lines.bus0[x],"_to_", pypsa_lines.bus1[x])
end
pypsa_lines[!, "branch_name"] .= branch_name



ps_branch = DataFrame(
    name = pypsa_lines.branch_name,
    connection_points_from = pypsa_lines.bus0,
    connection_points_to = pypsa_lines.bus1,
    r =((pypsa_lines.length.*r_ohm_km)./pypsa_lines.num_parallel), # Diskussion, Werte zu hoch?
    x = ((pypsa_lines.length.*x_ohm_km)./pypsa_lines.num_parallel),# Diskussion, Werte zu hoch?
    primary_shunt = ((pypsa_lines.length.*c_nf_km)./pypsa_lines.num_parallel),# Diskussion, Werte zu hoch?
    rate =pypsa_lines.s_nom.*pypsa_lines.s_max_pu,
);

# Storage DataFrame
ps_storage = DataFrame(
    name =pypsa_storage.name,
    bus_id = pypsa_storage.bus,
    input_active_power_limit_max = pypsa_storage.p_nom,
    rating =pypsa_storage.p_nom,
    base_power = 100,
    storage_capacity = pypsa_storage.p_nom.*pypsa_storage.max_hours,
    input_efficiency = pypsa_storage.efficiency_store,
    # output_efficiency = efficiency_dispatch,
);

load_name=Vector{Union{Missing, String}}(missing, size_loads[1]);
for i in 1:size_loads[1]
    load_name[i] = string("Load_",pypsa_loads.name[i],"_",pypsa_loads.bus[i])
end
pypsa_loads[!, "load_name"] .= load_name
println(pypsa_loads_p_set[1,1])

println("====== Loads:", size_loads[1])
println("====== Loads_p-set:", size_loads_p_set[2])
for x in 2:size_loads_p_set[2]
    for i in 1:size_loads[1]
    # rename(pypsa_loads_p_set, pypsa_loads_p_set[1, x] =>:load_name[i])
    
    end
end


# CSV.write("04_PyPSA2PowerSystems/01_Output/Test.csv",pypsa_loads_p_set)

# Load DataFrame
ps_load = DataFrame(
    name= pypsa_loads.load_name,
    max_active_power = 100.0,
    bus_id = pypsa_loads.bus,

);





# DC-Branch DataFrame
ps_dc_branch = DataFrame(
    name = "",
    connection_points_from = "",
    connection_points_to = "",
    dc_line_category = "",
);


# Resevre DataFrame
ps_reserves = DataFrame(
    name ="",
    requirement = "",
    timeframe	="",
    direction ="",
);

CSV.write("04_PyPSA2PowerSystems/01_Output/bus.csv",ps_bus)
CSV.write("04_PyPSA2PowerSystems/01_Output/branch.csv",ps_branch)
CSV.write("04_PyPSA2PowerSystems/01_Output/gen.csv",ps_gen)
# CSV.write("04_PyPSA2PowerSystems/01_Output/storage.csv",ps_storage);
CSV.write("04_PyPSA2PowerSystems/01_Output/load.csv",ps_load);
# CSV.write("04_PyPSA2PowerSystems/01_Output/reserves.csv",ps_reserves);
# CSV.write("04_PyPSA2PowerSystems/01_Output/ps_dc_branch.csv",ps_dc_branch);
println("===== ENDE =====")