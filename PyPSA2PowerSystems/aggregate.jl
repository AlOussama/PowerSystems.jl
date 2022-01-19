using DataFrames
using CSV
# ==== Einlesen der DataFrames ====
df_gen = DataFrame(CSV.File("01_PyPSA/Input/generators.csv"))
df_bus = DataFrame(CSV.File("01_PyPSA/Input/buses.csv"))
df_lines = DataFrame(CSV.File("01_PyPSA/Input/lines.csv"))

# ==== Bestimmen der Sizes für Schleifen ======
size_gen = size(df_gen)
size_bus = size(df_bus)
size_lines = size(df_lines)
size_tech = 14
size_bus_tech = size_bus[1] * size_tech
println(size_bus_tech)


sum_gas = Vector{Union{Missing, Float64}}(missing, bus_count);
sum_HardCoal = Vector{Union{Missing, Float64}}(missing, bus_count);
sum_RunOfRiver = Vector{Union{Missing, Float64}}(missing, bus_count);
sum_Waste = Vector{Union{Missing, Float64}}(missing, bus_count);
sum_BrownCoal = Vector{Union{Missing, Float64}}(missing, bus_count);
sum_Oil = Vector{Union{Missing, Float64}}(missing, bus_count);
sum_StorageHydro = Vector{Union{Missing, Float64}}(missing, bus_count);
sum_Other = Vector{Union{Missing, Float64}}(missing, bus_count);
sum_Multiple = Vector{Union{Missing, Float64}}(missing, bus_count);
sum_Nuclear = Vector{Union{Missing, Float64}}(missing, bus_count);
sum_Geothermal = Vector{Union{Missing, Float64}}(missing, bus_count);
sum_WindOffshore = Vector{Union{Missing, Float64}}(missing, bus_count);
sum_WindOnshore = Vector{Union{Missing, Float64}}(missing, bus_count);
sum_Solar = Vector{Union{Missing, Float64}}(missing, bus_count);

sum_gas .= 0.0
sum_HardCoal  .= 0.0
sum_RunOfRiver  .= 0.0
sum_Waste  .= 0.0
sum_BrownCoal  .= 0.0
sum_Oil .= 0.0
sum_StorageHydro .= 0.0
sum_Other  .= 0.0
sum_Multiple  .= 0.0
sum_Nuclear .= 0.0
sum_Geothermal .= 0.0
sum_WindOffshore  .= 0.0
sum_WindOnshore .= 0.0
sum_Solar .= 0.0

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

tech = ["Gas";"Hard Coal";"Run of River";"Waste";"Brown Coal";"Oil";"Storage Hydro";"Other";"Multiple";"Nuclear";"Geothermal";"Wind Offshore";"Wind Onshore";"Solar"]

for i in 1:size_gen[1] 
    for x in 1:size_bus[1]
        if df_gen.bus[i] == x-1
            if df_gen.carrier[i] == "Gas"
                global sum_gas[x] = sum_gas[x] + df_gen.p_nom[i]
                cost_gas = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Hard Coal"
                global sum_HardCoal[x] = sum_HardCoal[x] + df_gen.p_nom[i]
                cost_HardCoal = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Run of River"
                global sum_RunOfRiver[x] = sum_RunOfRiver[x] + df_gen.p_nom[i]
                cost_RunOfRiver = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Waste"
                global sum_Waste[x] = sum_Waste[x] + df_gen.p_nom[i]
                cost_Waste = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Brown Coal"
                global sum_BrownCoal[x] = sum_BrownCoal[x] + df_gen.p_nom[i]
                cost_BrownCoal = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Oil"
                global sum_Oil[x] = sum_Oil[x] + df_gen.p_nom[i]
                cost_Oil = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Storage Hydro"
                global sum_StorageHydro[x] = sum_StorageHydro[x] + df_gen.p_nom[i]
                cost_StorageHydro = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Other"
                global sum_Other[x] = sum_Other[x] + df_gen.p_nom[i]
                cost_Other = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Multiple"
                global sum_Multiple[x] = sum_Multiple[x] + df_gen.p_nom[i]
                cost_Multiple = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Nuclear"
                global sum_Nuclear[x] = sum_Nuclear[x] + df_gen.p_nom[i]
                cost_Nuclear = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Geothermal"
                global sum_Geothermal[x] = sum_Geothermal[x] + df_gen.p_nom[i]
                cost_Geothermal = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Wind Offshore"
                global sum_WindOffshore[x] = sum_WindOffshore[x] + df_gen.p_nom[i]
                cost_WindOffshore = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Wind Onshore"
                global sum_WindOnshore[x] = sum_WindOnshore[x] + df_gen.p_nom[i]
                cost_WindOnshore = df_gen.marginal_cost[i]
            elseif df_gen.carrier[i] == "Solar"
                global sum_Solar[x] = sum_Solar[x] + df_gen.p_nom[i]
                cost_Solar = df_gen.marginal_cost[i]
            end
         end
    end
end

name = Vector{Union{Missing, String}}(missing, bus_count*14);
bus_id = Vector{Union{Missing, Float64}}(missing, bus_count*14);
fuel = Vector{Union{Missing, String}}(missing, bus_count*14);
unit_type = Vector{Union{Missing, String}}(missing, bus_count*14);
fuel_price = Vector{Union{Missing, Float64}}(missing, bus_count*14);

for m in 1:df_gen_org_size[1]
    for n in 1:bus_count
        global name[m] = string(tech[n],"_",n)
        global bus_id[m] = n
        if tech[n]== "Gas"
            fuel[m] ="NATURAL_GAS"
            unit_type[m]="GT"
            fuel_price[m] = cost_gas
        elseif tech[n] == "Hard Coal"
                fuel[m]="COAL"
                unit_type[m]="ST"
                fuel_price[m] = cost_HardCoal
        elseif tech[n]== "Run of River"
                fuel[m]="HYDROROR"
                unit_type[m]="HA"
                fuel_price[m]=cost_RunOfRiver
        elseif tech[n] == "Waste"
                fuel[m]="MUNICIPAL_WASTE"
                unit_type[m]="ST"
                fuel_price[m] = cost_Waste
        elseif tech[n]== "Brown Coal"
                fuel[m]="COAL"
                unit_type[m]="ST"
                fuel_price[m] = cost_BrownCoal
        elseif tech[n]== "Oil"
                fuel[m]="RESIDUAL_FUEL_OIL"
                unit_type[m]="ST"
                fuel_price[m] = cost_Oil
        elseif tech[n]== "Storage Hydro"
                fuel[m]="HYDROST"
                unit_type[m]="PS"
                fuel_price[m] = cost_StorageHydro
            elseif tech[n]== "Other"
                fuel[m] ="OTHER"
                unit_type[m]="ST"
                fuel_price[m] = cost_Other
            elseif tech[n]== "Multiple"
                fuel[m]="OTHER"
                unit_type[m]="ST"
                fuel_price[m] = cost_Multiple
            elseif tech[n]== "Nuclear"
                fuel[m]="NUCLEAR"
                unit_type[m]="ST"
                fuel_price[m] = cost_Nuclear
            elseif tech[n]== "Geothermal"
                fuel[m]="GEOTHERMAL"
                unit_type[m]="ST"
                fuel_price[m] = cost_Geothermal
            elseif tech[n]== "Wind Offshore"
                fuel[m]="WINDOS"
                unit_type[m]="WS"
                fuel_price[m] = cost_WindOffshore
            elseif tech[n]== "Wind Onshore"
                fuel[m]="WINDOF"
                unit_type[m]="WT"
                fuel_price[m] = cost_WindOnshore
            elseif tech[n]== "Solar"
                fuel[m]="SOLAR"
                unit_type[m]="PVe"
                fuel_price[m] = cost_Solar
        end
       
        active_power =0.0

        # active_power_limits_max = pypsa_gen.p_nom,

        # active_power_limits_min = 0.01, # keine Vorgabe
        # reactive_power_limits_max = pypsa_gen.p_nom.*1.2,
        # reactive_power_limits_min = pypsa_gen.p_nom.*(-1.2),
        # min_down_time = 0.0, # Aus Generator File
        # min_up_time = 0.0, # Aus Generator File
        # # unit_type = pypsa_gen.control,
        # bace_mva = 100.0,# Notwendig
        # heat_rate_avg_0 = 0.1,
        # output_point_0 =1.0,
        # # generator_category = "", # Nicht Notwendig    
    end
    
end
println(name)

df_gen_out[!,:name] .=  name
df_gen_out[!, :bus_id] .= bus_id
df_gen_out[!, :fuel] .= fuel
df_gen_out[!, :unit_type] .= unit_type
df_gen_out[!, :fuel_price] .= fuel_price

println(df_gen_out)