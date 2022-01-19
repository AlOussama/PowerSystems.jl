using PowerSystems

function generateStaticGenerator(sys,NNF,df_loads,df_inst_leistung,df_re_gen,df_thermal_gen)
    fall = 0
    bus_numbers = get_bus_numbers(sys);
    gen_name_x = Vector{Union{Missing, String}}(missing, length(bus_numbers));
    load_name_x = Vector{Union{Missing, String}}(missing, length(bus_numbers));
    conv_name_x = Vector{Union{Missing, String}}(missing, length(bus_numbers));

    println("=====EINSELEN SYS ", NNF)
    sys = System("PowerSystems.jl/Marius/03_PyPSA2PowerSytsems/Output/SciGrid_14Bus.json")
    println("=== ENDE EINLESEN ===")

    for i in 1:length(bus_numbers);
        # println("This is Bus Nr: ", bus_numbers[i])
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
        max_gen_thermal = df_inst_leistung[2,i+1]
        max_gen_re = df_inst_leistung[1,i+1]
        max_gen = df_inst_leistung[3,i+1]

        thermal_gen_pu = df_thermal_gen[NNF,i+1]
        re_gen_pu = df_re_gen[NNF,i+1]



        stat_gen =
            ThermalStandard(
                name = gen_name,
                available = true,
                status = true,
                bus = get_bus(sys, bus_name),
                active_power = 3.0, # --> Hier müssen Loads eingefügt werden
                reactive_power = 0.5,
                rating = 1.0,
                prime_mover = PrimeMovers.GT,
                fuel = ThermalFuels.NATURAL_GAS,
                active_power_limits = (min = 0.0, max = max_gen_thermal),
                reactive_power_limits = (min = -500, max = 500),
                time_limits = nothing,
                ramp_limits = nothing,
                operation_cost = ThreePartCost((0.0, 1400.0), 0.0, 4.0, 2.0),
                base_power = 100.0,
            );
            add_component!(sys,stat_gen)

            h_tech = (4.2/100)*max_gen_thermal
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
                active_power = 1.0, # --> Hier müssen Loads eingefügt werden...
                reactive_power = 0.3,
                base_power = 100.0 ,
                max_active_power = max_loads,
                max_reactive_power = 100.0,
            );
            add_component!(sys,stat_load)

            re_stat_gen = RenewableDispatch(
                name = conv_name,
                available = true,
                bus = get_bus(sys, bus_name),
                active_power = 2.0,#re_gen_pu,
                reactive_power = 0.0,
                rating = 1.2,
                prime_mover = PrimeMovers.WT,
                reactive_power_limits = (min = 0.0, max = 0.0),
                base_power = 100.0,
                operation_cost = TwoPartCost(22.0, 0.0),
                power_factor = 1.0
            )
            add_component!(sys,re_stat_gen)

        invertertype = "GridForming"
        
        if invertertype == "GridFollowing"
        
            re_converter = AverageConverter(
            rated_voltage = 380.0, 
            rated_current = 100.0,
            );
            
            re_outer_control = OuterControl(
                ActivePowerPI(
                    Kp_p = 0.2,
                    Ki_p = 0.1,
                    ωz = 1000,
                    P_ref = 1.0,
                ),
                ReactivePowerPI(
                    Kp_q=0.2, #Proportional Gain, validation range: `(0, nothing)
                    Ki_q=0.1, #Integral Gain, validation range: `(0, nothing)`
                    ωf=100,
                    V_ref=1.0,
                    Q_ref=1.0,
                )
            );
        
            re_inner_control = CurrentModeControl(
                kffv = 0.0,     #Binary variable enabling the voltage feed-forward in output of current controllers
                kpc = 1.27,     #Current controller proportional gain
                kic = 14.3,     #Current controller integral gain
            );
        
        
        
            re_dc_source = FixedDCSource(
            voltage = 380.0
            );
        
            re_freq_estimator = KauraPLL(
                ω_lp = 500.0, #Cut-off frequency for LowPass filter of PLL filter.
                kp_pll = 0.084,  #PLL proportional gain
                ki_pll = 4.69,   #PLL integral gain
            );
        
            re_filter = LCLFilter(
            lf = 0.08, 
            rf = 0.003, 
            cf = 0.074, 
            lg = 0.2, 
            rg = 0.01
            );
        
        elseif invertertype == "GridForming"
            re_converter = AverageConverter(
            rated_voltage = 380.0, 
            rated_current = 100.0,
            );
        
            re_outer_control = OuterControl(
                VirtualInertia( # Active PowerControl
                    Ta = 2.0,
                    kd = 400.0, 
                    kω = 20.0
                ),
                ReactivePowerDroop( # Rective Power Control
                    kq = 0.2,
                    ωf = 1000.0,
                    V_ref = 380.0,
                    )
            );
        
            re_inner_control = VoltageModeControl(
                kpv = 0.59,     #Voltage controller proportional gain
                kiv = 736.0,    #Voltage controller integral gain
                kffv = 0.0,     #Binary variable enabling the voltage feed-forward in output of current controllers
                rv = 0.0,       #Virtual resistance in pu
                lv = 0.2,       #Virtual inductance in pu
                kpc = 1.27,     #Current controller proportional gain
                kic = 14.3,     #Current controller integral gain
                kffi = 0.0,     #Binary variable enabling the current feed-forward in output of current controllers
                ωad = 50.0,     #Active damping low pass filter cut-off frequency
                kad = 0.2,
            );
            re_dc_source = FixedDCSource(
            voltage = 380.0
            );
        
            re_freq_estimator = KauraPLL(
                ω_lp = 500.0, #Cut-off frequency for LowPass filter of PLL filter.
                kp_pll = 0.084,  #PLL proportional gain
                ki_pll = 4.69,   #PLL integral gain
            );
        
           
        
            re_filter = LCLFilter(
            lf = 0.08, 
            rf = 0.003, 
            cf = 0.074, 
            lg = 0.2, 
            rg = 0.01
            );
        end
        inverter = DynamicInverter(
            name = get_name(re_stat_gen),
            ω_ref = 1.0, # ω_ref,
            converter = re_converter,
            outer_control = re_outer_control,
            inner_control = re_inner_control,
            dc_source = re_dc_source,
            freq_estimator = re_freq_estimator,
            filter = re_filter,
        );
        add_component!(sys, inverter, re_stat_gen);

            
    end
    to_json(sys,string("PowerSystems.jl/Marius/02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/System/Output/",fall,"/DynamicSystem_NNF_",NNF,"_Fall_",fall, ".json"),force = true)
    # return sys, gen_name_x, load_name_x
end