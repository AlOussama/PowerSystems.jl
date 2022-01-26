using PowerSystems
using CSV
using DataFrames

function add_dyn_components(sys)
    df_gen = DataFrame(CSV.File("02_PowerSystems/Input_CSV/gen.csv"));
    
    gen_name = df_gen.name;
    inst_power = df_gen.active_power_limits_max


    size_gen = length(gen_name);

    for i in 1:size_gen
        tech_name = split(gen_name[i],"_")
        tech = tech_name[1]
        bus_nr = tech_name[2]
        bus_type = string(get_bustype(get_component(Bus,sys,string("Bus_",bus_nr))));
        
        if bus_type == "PV"
            inverter_type = "GridForming"
        elseif bus_type == "REF"
            inverter_type = "GridForming"
        elseif bus_type == "PQ"
            inverter_type = "GridFollowing"
        end


        if tech == "Gas"

            stat_gen = get_component(ThermalStandard,sys,gen_name[i])
            
            h_gas = 4.2
            d_gas = 3.0
            R_gas = 1.0
            Xd_p_gas = 1.0
            eq_p_gas = 1.0
            Vf_gas = 1.0
            efficiency_gas = 1.0
            V_pss_gas = 0.0
           
            machine_gen = BaseMachine(
                R = R_gas,
                Xd_p = Xd_p_gas,
                eq_p = eq_p_gas,
            );

            shaft_gen = SingleMass(
                H =h_gas,
                D = d_gas,
            );

            avr_gen = AVRFixed(
                Vf = Vf_gas
            );

             tg_gen = TGFixed(
                efficiency = efficiency_gas
            );

            pss_gen = PSSFixed(
                V_pss = V_pss_gas
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

            add_component!(sys, dyn_gen, stat_gen);

        elseif tech == "Hard Coal"

            stat_gen = get_component(ThermalStandard,sys,gen_name[i])

            h_hardcoal = 4.2
            d_hardcoal = 3.0
            R_hardcoal = 1.0
            Xd_p_hardcoal = 1.0
            eq_p_hardcoal = 1.0
            Vf_hardcoal = 1.0
            efficiency_hardcoal = 1.0
            V_pss_hardcoal = 0.0

            machine_gen = BaseMachine(
                R = R_hardcoal,
                Xd_p = Xd_p_hardcoal,
                eq_p = eq_p_hardcoal,
            );

            shaft_gen = SingleMass(
                H =h_hardcoal,
                D = d_hardcoal,
            );

            avr_gen = AVRFixed(
                Vf = Vf_hardcoal
            );

             tg_gen = TGFixed(
                efficiency = efficiency_hardcoal
            );

            pss_gen = PSSFixed(
                V_pss = V_pss_hardcoal
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

            add_component!(sys, dyn_gen, stat_gen);

        elseif tech == "Waste"
            stat_gen = get_component(ThermalStandard,sys,gen_name[i])

            h_waste = 3.8
            d_waste = 3.0
            R_waste = 1.0
            Xd_p_waste = 1.0
            eq_p_waste = 1.0
            Vf_waste = 1.0
            efficiency_waste = 1.0
            V_pss_waste = 0.0

            machine_gen = BaseMachine(
                R = R_waste,
                Xd_p = Xd_p_waste,
                eq_p = eq_p_waste,
            );

            shaft_gen = SingleMass(
                H =h_waste,
                D = d_waste,
            );

            avr_gen = AVRFixed(
                Vf = Vf_waste
            );

             tg_gen = TGFixed(
                efficiency = efficiency_waste
            );

            pss_gen = PSSFixed(
                V_pss = V_pss_waste
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

            add_component!(sys, dyn_gen, stat_gen);

        elseif tech == "Brown Coal"

            stat_gen = get_component(ThermalStandard,sys,gen_name[i])

            h_browncoal = 3.8
            d_browncoal = 3.0
            R_browncoal = 1.0
            Xd_p_browncoal = 1.0
            eq_p_browncoal = 1.0
            Vf_browncoal = 1.0
            efficiency_browncoal = 1.0
            V_pss_browncoal = 0.0

            machine_gen = BaseMachine(
                R = R_browncoal,
                Xd_p = Xd_p_browncoal,
                eq_p = eq_p_browncoal,
            );

            shaft_gen = SingleMass(
                H =h_browncoal,
                D = d_browncoal,
            );

            avr_gen = AVRFixed(
                Vf = Vf_browncoal
            );

             tg_gen = TGFixed(
                efficiency = efficiency_browncoal
            );

            pss_gen = PSSFixed(
                V_pss = V_pss_browncoal
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

            add_component!(sys, dyn_gen, stat_gen);

        elseif tech == "Oil"
            stat_gen = get_component(ThermalStandard,sys,gen_name[i])
            
            h_oil = 4.3
            d_oil = 3.0
            R_oil = 1.0
            Xd_p_oil = 1.0
            eq_p_oil = 1.0
            Vf_oil = 1.0
            efficiency_oil = 1.0
            V_pss_oil = 0.0

            machine_gen = BaseMachine(
                R = R_oil,
                Xd_p = Xd_p_oil,
                eq_p = eq_p_oil,
            );

            shaft_gen = SingleMass(
                H =h_oil,
                D = d_oil,
            );

            avr_gen = AVRFixed(
                Vf = Vf_oil
            );

             tg_gen = TGFixed(
                efficiency = efficiency_oil
            );

            pss_gen = PSSFixed(
                V_pss = V_pss_oil
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

            add_component!(sys, dyn_gen, stat_gen);

        elseif tech == "Other"

            stat_gen = get_component(ThermalStandard,sys,gen_name[i])

            h_other = 3.8
            d_other = 3.0
            R_other = 1.0
            Xd_p_other = 1.0
            eq_p_other = 1.0
            Vf_other = 1.0
            efficiency_other = 1.0
            V_pss_other = 0.0

            machine_gen = BaseMachine(
                R = R_other,
                Xd_p = Xd_p_other,
                eq_p = eq_p_other,
            );

            shaft_gen = SingleMass(
                H =h_other,
                D = d_other,
            );

            avr_gen = AVRFixed(
                Vf = Vf_other
            );

             tg_gen = TGFixed(
                efficiency = efficiency_other
            );

            pss_gen = PSSFixed(
                V_pss = V_pss_other
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

            add_component!(sys, dyn_gen, stat_gen);

        elseif tech == "Multiple"
            stat_gen = get_component(ThermalStandard,sys,gen_name[i])
            h_multiple = 3.8
            d_multiple = 3.0
            R_multiple = 1.0
            Xd_p_multiple = 1.0
            eq_p_multiple = 1.0
            Vf_multiple = 1.0
            efficiency_multiple = 1.0
            V_pss_multiple = 0.0

            machine_gen = BaseMachine(
                R = R_multiple,
                Xd_p = Xd_p_multiple,
                eq_p = eq_p_multiple,
            );

            shaft_gen = SingleMass(
                H =h_multiple,
                D = d_multiple,
            );

            avr_gen = AVRFixed(
                Vf = Vf_multiple
            );

             tg_gen = TGFixed(
                efficiency = efficiency_multiple
            );

            pss_gen = PSSFixed(
                V_pss = V_pss_multiple
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

            add_component!(sys, dyn_gen, stat_gen);

        elseif tech == "Nuclear"
            stat_gen = get_component(ThermalStandard,sys,gen_name[i])
            h_nuclear = 5.9
            d_nuclear = 3.0
            R_nuclear = 1.0
            Xd_p_nuclear = 1.0
            eq_p_nuclear = 1.0
            Vf_nuclear = 1.0
            efficiency_nuclear = 1.0
            V_pss_nuclear = 0.0
            machine_gen = BaseMachine(
                R = R_nuclear,
                Xd_p = Xd_p_nuclear,
                eq_p = eq_p_nuclear,
            );

            shaft_gen = SingleMass(
                H =h_nuclear,
                D = d_nuclear,
            );

            avr_gen = AVRFixed(
                Vf = Vf_nuclear
            );

             tg_gen = TGFixed(
                efficiency = efficiency_nuclear
            );

            pss_gen = PSSFixed(
                V_pss = V_pss_nuclear
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

            add_component!(sys, dyn_gen, stat_gen);

        elseif tech == "Geothermal"
            stat_gen = get_component(ThermalStandard,sys,gen_name[i])
            h_geothermal = 3.5
            d_geothermal = 3.0
            R_geothermal = 1.0
            Xd_p_geothermal = 1.0
            eq_p_geothermal = 1.0
            Vf_geothermal = 1.0
            efficiency_geothermal = 1.0
            V_pss_geothermal = 0.0

            machine_gen = BaseMachine(
                R = R_geothermal,
                Xd_p = Xd_p_geothermal,
                eq_p = eq_p_geothermal,
            );

            shaft_gen = SingleMass(
                H =h_geothermal,
                D = d_geothermal,
            );

            avr_gen = AVRFixed(
                Vf = Vf_geothermal
            );

             tg_gen = TGFixed(
                efficiency = efficiency_geothermal
            );

            pss_gen = PSSFixed(
                V_pss = V_pss_geothermal
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

            add_component!(sys, dyn_gen, stat_gen);

        elseif tech == "Solar"
            re_stat_gen = get_component(RenewableDispatch,sys,gen_name[i])
            if inverter_type  == "GridFollowing"
            
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

             
            
            elseif inverter_type  =="GridForming"
                
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

        elseif tech == "Wind Offshore"
            re_stat_gen = get_component(RenewableDispatch,sys,gen_name[i])
            if inverter_type  == "GridFollowing"
            
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

             
            
            elseif inverter_type  =="GridForming"
                
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

        elseif tech == "Wind Onshore"
            re_stat_gen = get_component(RenewableDispatch,sys,gen_name[i])
            if inverter_type  == "GridFollowing"
            
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

             
            
            elseif inverter_type  =="GridForming"
                
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

        elseif tech == "Run of River"
            hy_stat_gen = get_component(HydroDispatch,sys,gen_name[i])

            machine_gen = BaseMachine(
                R = 1.0,
                Xd_p = 1.0,
                eq_p = 1.0,
            );
            shaft_gen = SingleMass(
                H = 2.7,
                D = 3.0,
            );
            avr_gen = AVRFixed(
                Vf = 1.0
            );
            tg_gen = TGFixed(
                efficiency = 1.0
            );
            pss_gen = PSSFixed(
                V_pss = 0.0
            );
            dyn_gen = DynamicGenerator(
                name = get_name(hy_stat_gen),
                ω_ref = 1.0,
                machine = machine_gen,
                shaft = shaft_gen,
                avr = avr_gen,
                prime_mover = tg_gen,
                pss = pss_gen,
            );
            add_component!(sys, dyn_gen, hy_stat_gen);
            
        end

    
    end


     

    return sys
end;