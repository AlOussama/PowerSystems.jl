using PowerSystems
using PowerSimulationsDynamics
using CSV

sys = System("02_PowerSystems/Output_PowerSystem/Dynamic_SciGrid_NNF_0.json", frequency = 50.0);


# println(sys)
anzahl_knoten = length(get_bus_numbers(sys));
anzahl_dyn_gen = length(get_components(DynamicGenerator, sys));
anzahl_dyn_con = length(get_components(DynamicInverter, sys));
anzahl_dyn_components = anzahl_dyn_con + anzahl_dyn_gen;
M = zeros(Float64, anzahl_dyn_gen,anzahl_dyn_gen);
D = zeros(Float64, anzahl_dyn_gen,anzahl_dyn_gen);
L = zeros(ComplexF64, anzahl_dyn_gen, anzahl_dyn_gen);

ω = 2*pi*50

y_bus = Ybus(sys)

# print(y_bus)
y_bus_array = get_data(y_bus)
L = Matrix(y_bus_array)


for componet in get_components(DynamicGenerator, sys)
    gen_name = get_name(componet)
    bus_number = get_number(get_bus(get_component(ThermalStandard,sys,gen_name)))+1
    # println(bus_number)
    H_gen = get_H(get_shaft(componet))
    S_n = sqrt(get_max_active_power(get_component(ThermalStandard,sys,gen_name))^2 + get_max_reactive_power(get_component(ThermalStandard,sys,gen_name))^2)
    m = (2*H_gen*S_n)/ω;
    M[bus_number,bus_number] = m + M[bus_number,bus_number]
    D_gen = get_D(get_shaft(componet))
    d = (D_gen*S_n)/ω;  
    D[bus_number,bus_number] = d + D[bus_number,bus_number]
end
   

for componet in get_components(DynamicInverter, sys)
   
    inv_name =get_name(componet)
    bus_number = get_number(get_bus(get_component(RenewableDispatch,sys,inv_name)))+1
    bus_type = string(get_bustype(get_bus(get_component(RenewableDispatch,sys,inv_name))))
    print(bus_type)
    S_n = sqrt(get_max_active_power(get_component(RenewableDispatch,sys,inv_name))^2 + get_max_reactive_power(get_component(RenewableDispatch,sys,inv_name))^2)
   
    if bus_type == "PV"
        test = get_outer_control(componet)
        # println(get_inertia(get_component(RenewableDispatch,sys,inv_name)))
        t_a= 2.0
        kd = 400
        m_inv = (t_a * S_n)/ω
        d_inv = (kd*S_n)/ω
        M[bus_number,bus_number] = m_inv + M[bus_number,bus_number]
        D[bus_number,bus_number] = d_inv + D[bus_number,bus_number]
    else
        m_inv = 0
        d_inv = 0
    end
    # test = get_outer_control(componet)
    # println(test)

    # println(get_virtual_inertia(test))
    # println(get_Ta(test))
    # println(PowerSystems.VirtualInertia.Ta)
    # test_1 = test.VirtualInertia
    
    # print(test)
    # H_inv = (get_Ta(get_outer_control(componet)))/2

    # println(H_inv)
    # D_inv = get_kd(get_outer_control(component))
    # println(D_inv)

end

# println(M)
# println(D)

A =-inv(M)*L
C = -inv(M)*D

results = solve_powerflow(sys);
println(results["bus_results"])
p_netto = results["bus_results"].P_net
θ_ = results["bus_results"].θ

# ACHTUNG: Rotorwinkel nicht Spannungswinkel
ω_ableitung = A*θ_ + C*ω + inv(M)*p_netto
