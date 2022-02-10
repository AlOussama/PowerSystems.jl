using DataFrames
using CSV
using PowerSystems


# === Definition Bus ===
df_bus = DataFrame(CSV.File("01_PyPSA/Input/buses.csv"))
df_bus_angle = DataFrame(CSV.File("01_PyPSA/Input/buses-v_ang.csv"))
df_bus_magnitude = DataFrame(CSV.File("01_PyPSA/Input/buses-v_mag_pu.csv"))

df_gen_ts = DataFrame(CSV.File("01_PyPSA/Input/tech_at_bus_used_per_hour.csv"));

size_bus = size(df_bus)

print(names(df_bus_angle))

test = names(df_bus_angle)
if test[2] == "0"
    print("geht")
else
    println("geht nicht")
end

# i =10
# if df_bus_magnitude. == true
#     print("geht!")

# else
#     "geht nicht"

# end

# for i in 1:size_bus[1]
#     global bus_name[i] = string("Bus_", df_bus.name[i])
#     global bus_id_bus[i] = df_bus.name[i]
#     global base_voltage[i] = df_bus.v_nom[i]
# #     # if df_bus_magnitude.i == true
# #     #     global voltage[i] = df_bus_magnitude.i[0]
# #     # else global voltage[i] = 1.0
#         # end
    
#     # if df_bus_angle.i == true
#     #     global vol_angle[i] =df_bus_angle.i[0]
#     # else global vol_angle[i] = 0.0
#         # end
#     if df_bus.control[i] == "Slack"
#         global bus_type[i] = "REF"
#     else
#         global bus_type[i] = df_bus.control[i]
#     end
#     global voltage_limits_min[i] = 0.9
#     global voltage_limits_max = 1.1
# end

# df_bus_out = DataFrame( 
#     :name => bus_name, 
#     :bus_id => bus_id_bus, 
#     :base_voltage => base_voltage,
#     :voltage => voltage,
#     :angle => vol_angle, 
#     :bus_type => bus_type,
#     :voltage_limits_min => voltage_limits_min,
#     :voltage_limits_max => voltage_limits_max
#     )

    # println(df_bus_out)
