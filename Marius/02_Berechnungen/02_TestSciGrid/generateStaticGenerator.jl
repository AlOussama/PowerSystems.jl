using PowerSystems

function generateStaticGenerator(sys,NNF,df_loads,df_inst_leistung)
    bus_numbers = get_bus_numbers(sys);
    gen_name_x = Vector{Union{Missing, String}}(missing, length(bus_numbers));
    load_name_x = Vector{Union{Missing, String}}(missing, length(bus_numbers));
    conv_name_x = Vector{Union{Missing, String}}(missing, length(bus_numbers));

    println("=====EINSELEN SYS ", NNF)
    sys = System("03_PyPSA2PowerSytsems/Output/SciGrid_14Bus.json")
    println("=== ENDE EINLESEN ===")

    for i in 1:length(bus_numbers);
        println("This is Bus Nr: ", bus_numbers[i])
        bus_name = string("Bus ",i-1)
        # println(bus_name)
        # println(get_bus(sys,bus_name))
        gen_name = string("gen_", i-1)
        load_name = string("load_", i-1)
        conv_name = string("conv_",i-1)
        gen_name_x[i] = gen_name
        load_name_x[i] = load_name
        conv_name_x[i] = conv_name
        max_loads = df_loads[NNF,i+1]
        max_gen_thermal = df_inst_leistung[1,i+1]
        max_gen_re = df_inst_leistung[2,i+1]
        max_gen = df_inst_leistung[3,i+1]



        stat_gen =
            ThermalStandard(
                name = gen_name,
                available = true,
                status = true,
                bus = get_bus(sys, bus_name),
                active_power = 3.0,
                reactive_power = 0.5,
                rating = 1.0,
                prime_mover = PrimeMovers.GT,
                fuel = ThermalFuels.NATURAL_GAS,
                active_power_limits = (min = 0.0, max = max_gen),
                reactive_power_limits = (min = -500, max = 500),
                time_limits = nothing,
                ramp_limits = nothing,
                operation_cost = ThreePartCost((0.0, 1400.0), 0.0, 4.0, 2.0),
                base_power = 100.0,
            );
            add_component!(sys,stat_gen)

            h_tech = (4.2/100)*max_gen
            d_tech = (2.0/3.148)*h_tech
            R_tech = 1.0
            Xd_p_tech = 1.0
            eq_p_tech = 1.0
            Vf_tech = 1.0
            efficiency_tech = 1.0
            V_pss_tech = 0.0


            machine_gen = BaseMachine(
                R = R_tech,
                Xd_p = Xd_p_tech,
                eq_p = eq_p_tech,
            );
            shaft_gen = SingleMass(
                H =h_tech,
                D = d_tech,
            );
            avr_gen = AVRFixed(
                Vf = Vf_tech
            );
            tg_gen = TGFixed(
                efficiency = efficiency_tech
            );
            pss_gen = PSSFixed(
                V_pss = V_pss_tech
            );
            dyn_gen = DynamicGenerator(
                name = get_name(stat_gen),
                ω_ref = 1.0,
                machine = machine_gen,
                shaft = shaft_gen,
                avr = avr_gen,
                prime_mover = tg_gen,
                pss = pss_gen,
            );

            add_component!(sys,dyn_gen,stat_gen)

        stat_load =  PowerLoad(
                name = load_name,
                available = true,
                bus = get_bus(sys, bus_name),
                model = LoadModels.ConstantPower,
                active_power = max_loads,
                reactive_power = 0.1,
                base_power = 100.0 ,
                max_active_power = max_loads,
                max_reactive_power = 100.0,
            );
            add_component!(sys,stat_load)

            to_json(sys,string("DynamicSystem_NNF_",NNF,".json"),force = true)
    end
    
    # return sys, gen_name_x, load_name_x
end