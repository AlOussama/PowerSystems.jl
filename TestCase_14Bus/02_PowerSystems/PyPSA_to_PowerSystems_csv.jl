using DataFrames
using CSV

println("==== START PyPSA2PowerSystems.jl ====")

# ==== Einlesen der DataFrames ====
df_gen = DataFrame(CSV.File("01_PyPSA/Input/generators.csv"));
df_bus = DataFrame(CSV.File("01_PyPSA/Input/buses.csv"));
df_lines = DataFrame(CSV.File("01_PyPSA/Input/lines.csv"));
df_gen_ts = DataFrame(CSV.File("01_PyPSA/Input/tech_at_bus_used_per_hour.csv"));
df_loads = DataFrame(CSV.File("01_PyPSA/Input/loads_at_bus_per_hour.csv"));

# ==== Bestimmen der Sizes für Schleifen ======
size_gen = size(df_gen);
size_bus = size(df_bus);
size_lines = size(df_lines);
size_tech = 13;
size_bus_tech = size_bus[1] * size_tech;
# println(size_bus_tech);

# ==== Definition Summen Vektoren für aggregierte inst. Leistung der Generatoren ===
sum_gas = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
sum_HardCoal = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
sum_RunOfRiver = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
sum_Waste = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
sum_BrownCoal = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
sum_Oil = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
sum_StorageHydro = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
sum_Other = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
sum_Multiple = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
sum_Nuclear = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
sum_Geothermal = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
sum_WindOffshore = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
sum_WindOnshore = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
sum_Solar = Vector{Union{Missing, Float64}}(missing, size_bus[1]);

# ==== initialisierung Summenvektoren ====
sum_gas .= 0.0;
sum_HardCoal  .= 0.0;
sum_RunOfRiver  .= 0.0;
sum_Waste  .= 0.0;
sum_BrownCoal  .= 0.0;
sum_Oil .= 0.0;
sum_StorageHydro .= 0.0;
sum_Other  .= 0.0;
sum_Multiple  .= 0.0;
sum_Nuclear .= 0.0;
sum_Geothermal .= 0.0;
sum_WindOffshore  .= 0.0;
sum_WindOnshore .= 0.0;
sum_Solar .= 0.0;

# ===== Initialisierung costen Variablen
cost_gas = 0.0
cost_HardCoal  = 0.0
cost_RunOfRiver  = 0.0
cost_Waste  = 0.0
cost_BrownCoal  = 0.0
cost_Oil = 0.0
cost_StorageHydro = 0.0
cost_Other  = 0.0
cost_Multiple  = 0.0
cost_Nuclear = 0.0
cost_Geothermal = 0.0
cost_WindOffshore  = 0.0
cost_WindOnshore = 0.0
cost_Solar = 0.0

name = Vector{Union{Missing, String}}(missing, size_bus_tech);
p_nom = Vector{Union{Missing, Float64}}(missing, size_bus_tech);
bus_id = Vector{Union{Missing, Int}}(missing, size_bus_tech);
fuel = Vector{Union{Missing, String}}(missing, size_bus_tech);
unit_type = Vector{Union{Missing, String}}(missing, size_bus_tech);
active_power_limits_min = Vector{Union{Missing, Float64}}(missing, size_bus_tech);
reactive_power_limits_max = Vector{Union{Missing, Float64}}(missing, size_bus_tech);
reactive_power_limits_min = Vector{Union{Missing, Float64}}(missing, size_bus_tech);
min_down_time = Vector{Union{Missing, Float64}}(missing, size_bus_tech);
min_up_time = Vector{Union{Missing, Float64}}(missing, size_bus_tech);
base_mva  = Vector{Union{Missing, Float64}}(missing, size_bus_tech);
heat_rate_avg_0  = Vector{Union{Missing, Float64}}(missing, size_bus_tech);
output_point_0  = Vector{Union{Missing, Float64}}(missing, size_bus_tech);
active_power = Vector{Union{Missing, Float64}}(missing, size_bus_tech);
fuel_price = Vector{Union{Missing, Float64}}(missing, size_bus_tech);

p_q_ratio = 1.2
active_power_limits_min .= 0.1
min_down_time .= 1.0
min_up_time .= 3.0
base_mva .= 100.0
heat_rate_avg_0  .= 0.1
output_point_0.= 1.0


for i in 1:size_gen[1] 
    for x in 1:size_bus[1]
        if df_gen.bus[i] == x-1
            if df_gen.carrier[i] == "Gas"
                global sum_gas[x] = sum_gas[x] + df_gen.p_nom[i]
                global cost_gas = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Hard Coal"
                global sum_HardCoal[x] = sum_HardCoal[x] + df_gen.p_nom[i]
                global cost_HardCoal = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Run of River"
                global sum_RunOfRiver[x] = sum_RunOfRiver[x] + df_gen.p_nom[i]
                global cost_RunOfRiver = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Waste"
                global sum_Waste[x] = sum_Waste[x] + df_gen.p_nom[i]
                global cost_Waste = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Brown Coal"
                global sum_BrownCoal[x] = sum_BrownCoal[x] + df_gen.p_nom[i]
                global cost_BrownCoal = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Oil"
                global sum_Oil[x] = sum_Oil[x] + df_gen.p_nom[i]
                global cost_Oil = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Storage Hydro"
                global sum_StorageHydro[x] = sum_StorageHydro[x] + df_gen.p_nom[i]
                global cost_StorageHydro = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Other"
                global sum_Other[x] = sum_Other[x] + df_gen.p_nom[i]
                global cost_Other = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Multiple"
                global sum_Multiple[x] = sum_Multiple[x] + df_gen.p_nom[i]
                global cost_Multiple = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Nuclear"
                global sum_Nuclear[x] = sum_Nuclear[x] + df_gen.p_nom[i]
                global cost_Nuclear = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Geothermal"
                global sum_Geothermal[x] = sum_Geothermal[x] + df_gen.p_nom[i]
                global cost_Geothermal = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Wind Offshore"
                global sum_WindOffshore[x] = sum_WindOffshore[x] + df_gen.p_nom[i]
                global cost_WindOffshore = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Wind Onshore"
                global sum_WindOnshore[x] = sum_WindOnshore[x] + df_gen.p_nom[i]
                global cost_WindOnshore = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Solar"
                global sum_Solar[x] = sum_Solar[x] + df_gen.p_nom[i]
                global cost_Solar = df_gen.marginal_cost[i]
            end
         end
    end
end

    for x in 1:size_bus_tech
        
            if x <= size_bus[1]
                name[x] = string("Gas_",x-1)
                p_nom[x] = sum_gas[x]
                bus_id[x] = x-1
                fuel[x] = "NATURAL_GAS"
                unit_type[x] = "GT"
                fuel_price[x] = cost_gas
                reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
                reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
                active_power[x] = df_gen_ts[1,name[x]]
                
                
            elseif x > size_bus[1] && x <= 2*size_bus[1]
                name[x] = string("Hard Coal_", (x-1)-size_bus[1] )
                p_nom[x] = sum_HardCoal[x-size_bus[1]]
                bus_id[x] = (x-1)-size_bus[1]
                fuel[x]= "COAL"
                unit_type[x] = "ST"
                fuel_price[x] = cost_HardCoal
                reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
                reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
                active_power[x] = df_gen_ts[1,name[x]]

            elseif x > 2*size_bus[1] && x <= 3*size_bus[1]
                name[x] = string("Run of River_", (x-1)-2*size_bus[1] )
                p_nom[x] = sum_RunOfRiver[x-2*size_bus[1]]
                bus_id[x] = (x-1)-2*size_bus[1]
                fuel[x]= "HYDROROR"
                unit_type[x] = "HA"
                fuel_price[x] = cost_RunOfRiver
                reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
                reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
                active_power[x] = df_gen_ts[1,name[x]]

            elseif x > 3*size_bus[1] && x <= 4*size_bus[1]
                name[x] = string("Waste_", (x-1)-3*size_bus[1] )
                p_nom[x] = sum_Waste[x-3*size_bus[1]]
                bus_id[x] = (x-1)-3*size_bus[1]
                fuel[x] = "MUNICIPAL_WASTE"
                unit_type[x] = "ST"
                fuel_price[x] = cost_Waste
                reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
                reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
                active_power[x] = df_gen_ts[1,name[x]]

            elseif x > 4*size_bus[1] && x <= 5*size_bus[1]
                name[x] = string("Brown Coal_", (x-1)-4*size_bus[1] )
                p_nom[x] = sum_BrownCoal[x-4*size_bus[1]]
                bus_id[x] = (x-1)-4*size_bus[1]
                fuel[x] = "COAL"
                unit_type[x] = "ST"
                fuel_price[x] = cost_BrownCoal
                reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
                reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
                active_power[x] = df_gen_ts[1,name[x]]

            elseif x > 5*size_bus[1] && x <= 6*size_bus[1]
                name[x] = string("Oil_", (x-1)-5*size_bus[1] )
                p_nom[x] = sum_Oil[x-5*size_bus[1]]
                bus_id[x] = (x-1)-5*size_bus[1]
                fuel[x] = "RESIDUAL_FUEL_OIL"
                unit_type[x] = "ST"
                fuel_price[x] = cost_Oil
                reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
                reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
                active_power[x] = df_gen_ts[1,name[x]]

            # elseif x > 6*size_bus[1] && x <= 7*size_bus[1]
            #     name[x] = string("Storage Hydro_", (x-1)-6*size_bus[1] )
            #     p_nom[x] = sum_StorageHydro[x-6*size_bus[1]]
            #     bus_id[x] = (x-1)-6*size_bus[1]
            #     fuel[x] = "HYDROST"
            #     unit_type[x] = "PS"
            #     fuel_price[x] = cost_StorageHydro
            #     reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
            #     reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
            #     active_power[x] = df_gen_ts[1,name[x]]

            elseif x > 6*size_bus[1] && x <= 7*size_bus[1]
                name[x] = string("Other_", (x-1)-6*size_bus[1] )
                p_nom[x] = sum_Other[x-6*size_bus[1]]
                bus_id[x] = (x-1)-6*size_bus[1]
                fuel[x] = "OTHER"
                unit_type[x] = "OT"
                fuel_price[x] = cost_Other
                reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
                reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
                active_power[x] = df_gen_ts[1,name[x]]

            elseif x > 7*size_bus[1] && x <= 8*size_bus[1]
                name[x] = string("Multiple_", (x-1)-7*size_bus[1] )
                p_nom[x] = sum_Multiple[x-7*size_bus[1]]
                bus_id[x] = (x-1)-7*size_bus[1]
                fuel[x] = "OTHER"
                unit_type[x] = "OT"
                fuel_price[x] = cost_Multiple
                reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
                reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
                # active_power[x] = df_gen_ts[1,name[x]]
                active_power[x] = 0.0

            elseif x > 8*size_bus[1] && x <=9*size_bus[1]
                name[x] = string("Nuclear_", (x-1)-8*size_bus[1] )
                p_nom[x] = sum_Nuclear[x-8*size_bus[1]]
                bus_id[x] = (x-1)-8*size_bus[1]
                fuel[x] = "NUCLEAR"
                unit_type[x] = "ST"
                fuel_price[x] = cost_Nuclear
                reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
                reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
                active_power[x] = df_gen_ts[1,name[x]]

            elseif x > 9*size_bus[1] && x <= 10*size_bus[1]
                name[x] = string("Geothermal_", (x-1)-9*size_bus[1] )
                p_nom[x] = sum_Geothermal[x-9*size_bus[1]]
                bus_id[x] = (x-1)-9*size_bus[1]
                fuel[x] = "GEOTHERMAL"
                unit_type[x] = "ST"
                fuel_price[x] = cost_Geothermal
                reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
                reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
                active_power[x] = df_gen_ts[1,name[x]]

            elseif x > 10*size_bus[1] && x <= 11*size_bus[1]
                name[x] = string("Wind Offshore_", (x-1)-10*size_bus[1] )
                p_nom[x] = sum_WindOffshore[x-10*size_bus[1]]
                bus_id[x] = (x-1)-10*size_bus[1]
                fuel[x] = "WINDOS"
                unit_type[x] = "WS"
                fuel_price[x] = cost_WindOffshore
                reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
                reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
                active_power[x] = df_gen_ts[1,name[x]]

            elseif x > 11*size_bus[1] && x <= 12*size_bus[1]
                name[x] = string("Wind Onshore_", (x-1)-11*size_bus[1] )
                p_nom[x] = sum_WindOnshore[x-11*size_bus[1]]
                bus_id[x] = (x-1)-11*size_bus[1]
                fuel[x] = "WINDOF"
                unit_type[x] = "WT"
                fuel_price[x] = cost_WindOnshore
                reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
                reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
                active_power[x] = df_gen_ts[1,name[x]]

            elseif x > 12*size_bus[1] && x <= 13*size_bus[1]
                name[x] = string("Solar_", (x-1)-12*size_bus[1] )
                p_nom[x] = sum_Solar[x-12*size_bus[1]]
                bus_id[x] = (x-1)-12*size_bus[1]
                fuel[x] = "SOLAR"
                unit_type[x] = "PV"
                fuel_price[x] = cost_Solar
                reactive_power_limits_max[x] = p_nom[x] * p_q_ratio
                reactive_power_limits_min[x] = p_nom[x] * (-p_q_ratio)
                active_power[x] = df_gen_ts[1,name[x]]

            end
    end


    
    df_gen_out = DataFrame(
        :name => name,
        :bus_id => bus_id,
        :fuel => fuel, 
        :unit_type => unit_type, 
        :fuel_price => fuel_price,
        :active_power => active_power,
        :active_power_limits_max => p_nom, 
        :active_power_limits_min => active_power_limits_min,
        :reactive_power_limits_max => reactive_power_limits_max,
        :reactive_power_limits_min => reactive_power_limits_min,
        :min_down_time => min_down_time, 
        :min_up_time => min_up_time,
        :base_mva =>base_mva, 
        :heat_rate_avg_0 => heat_rate_avg_0,
        :output_point_0 => output_point_0
    )


    CSV.write("02_PowerSystems/Input_CSV/gen.csv",df_gen_out)

    # ===== Import Bus ====
    bus_name = Vector{Union{Missing, String}}(missing, size_bus[1]);
    bus_id_bus = Vector{Union{Missing, Int}}(missing, size_bus[1]);
    base_voltage = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
    voltage = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
    vol_angle = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
    bus_type = Vector{Union{Missing, String}}(missing, size_bus[1]);
    voltage_limits_min = Vector{Union{Missing, Float64}}(missing, size_bus[1]);
    voltage_limits_max = Vector{Union{Missing, Float64}}(missing, size_bus[1]);

    for i in 1:size_bus[1]
        global bus_name[i] = string("Bus_", df_bus.name[i])
        global bus_id_bus[i] = df_bus.name[i]
        global base_voltage[i] = df_bus.v_nom[i]
        global voltage[i] = 1.0
        global vol_angle[i] = 0.0
        if df_bus.control[i] == "Slack"
            global bus_type[i] = "REF"
        # elseif df_bus.control[i] == "PV"
        #     global bus_type[i] = "PQ" #ACHTUNG --> Muss wieder angepasst werden
        else
            global bus_type[i] = df_bus.control[i]
        end
        global voltage_limits_min[i] = 0.9
        global voltage_limits_max = 1.1
    end

    df_bus_out = DataFrame( :name => bus_name, :bus_id => bus_id_bus, :base_voltage => base_voltage,
    :voltage => voltage, :angle => vol_angle, :bus_type => bus_type,:voltage_limits_min => voltage_limits_min,
    :voltage_limits_max => voltage_limits_max)

    CSV.write("02_PowerSystems/Input_CSV/bus.csv",df_bus_out);

# =====  Lines =======

r_ohm_km =0.04 
x_ohm_km = 0.16
c_nf_km = 11.5
z_base = 1444

lines_name = Vector{Union{Missing, String}}(missing, size_lines[1]);
connection_points_from= Vector{Union{Missing, Int}}(missing, size_lines[1]);
connection_points_to= Vector{Union{Missing, Int}}(missing, size_lines[1]);
r= Vector{Union{Missing, Float64}}(missing, size_lines[1]);
x= Vector{Union{Missing, Float64}}(missing, size_lines[1]);
primary_shunt= Vector{Union{Missing, Float64}}(missing, size_lines[1]);
rate= Vector{Union{Missing, Float64}}(missing, size_lines[1]);
active_power_flow= Vector{Union{Missing, Float64}}(missing, size_lines[1]);
reactive_power_flow= Vector{Union{Missing, Float64}}(missing, size_lines[1]);


for i in 1:size_lines[1]
    lines_name[i] = string(df_lines.bus0[i],"_to_",df_lines.bus1[i])
    connection_points_from[i] = df_lines.bus0[i]
    connection_points_to[i] = df_lines.bus1[i]
    r[i] = ((r_ohm_km*df_lines.length[i])/df_lines.num_parallel[i])/z_base
    x[i] = ((x_ohm_km*df_lines.length[i])/df_lines.num_parallel[i])/z_base
    primary_shunt[i] = (c_nf_km*df_lines.length[i]*df_lines.num_parallel[i])*z_base*2*50*pi*10E-9
    rate[i] = df_lines.s_nom[i]*df_lines.s_max_pu[i]
    active_power_flow[i] = 0.0
    reactive_power_flow[i] = 0.0
end

df_lines_out = DataFrame( :name => lines_name, :connection_points_from => connection_points_from, :connection_points_to => connection_points_to,
:r =>r, :x=> x,:primary_shunt=> primary_shunt,:rate => rate, :active_power_flow => active_power_flow, :reactive_power_flow => reactive_power_flow
)

CSV.write("02_PowerSystems/Input_CSV/branch.csv",df_lines_out);

# ==== Loads =====
loads_name = Vector{Union{Missing, String}}(missing, 14);
loads_bus  = Vector{Union{Missing, Int}}(missing, 14);
loads_active_power  = Vector{Union{Missing, Float64}}(missing, 14);
loads_max_active_power  = Vector{Union{Missing, Float64}}(missing, 14);
loads_max_reactive_power = Vector{Union{Missing, Float64}}(missing, 14);

for i in 1:14
   global loads_name[i] = string("Load_", i-1)
    global loads_bus[i] = i-1
    column_name = string(i-1)
    global loads_active_power[i] = df_loads[1,column_name]
    global loads_max_active_power[i] = active_power[i] * 1.5
    global loads_max_reactive_power[i] = loads_max_active_power[i]*1.2
end

df_loads_out = DataFrame(
    :name =>loads_name, :bus_id =>loads_bus, :active_power => loads_active_power, 
    :max_active_power => loads_max_active_power, :max_reactive_power => loads_max_reactive_power
)

CSV.write("02_PowerSystems/Input_CSV/load.csv",df_loads_out);