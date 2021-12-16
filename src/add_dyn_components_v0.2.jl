
using PowerSystems
function add_dyn_components(sys,fileformat)
    # Urspungsversion 


#=
Statische Generatoren werden Ausgelesen und deren Namen in einem Vektor gespeichert.
=#

# ThermalStandard Generator Name
stat_gen = get_components(ThermalStandard,sys);
anzahl_stat_gen = length(stat_gen);
stat_gen_str = string(stat_gen);
split_stat_gen_str =  split(stat_gen_str, ",")
len_split_stat_gen_str = length(split_stat_gen_str)

# ============

# == RE  Gen ====
re_gen = get_components(RenewableDispatch,sys);
anzahl_re_gen = length(re_gen)
re_gen_str = string(re_gen)
split_str_re_gen = split(re_gen_str,",")
len_split_re_gen_str = length(split_str_re_gen)
# println(re_gen)
println(split_str_re_gen)

# =============
if fileformat == "raw"
    file_numb = 45
    println("Eingelesene Datei ist eine raw Datei")
elseif fileformat == "m"
        file_numb = 44
        println("Eingelesene Datei ist eine m Datei")

elseif fileformat == "csv"
    println("Eingelesene Datei ist eine csv Datei")
    file_numb = 44
    re_numb = 28

else
    println("Datenformat wird nicht unterstützt! Bitte Eingabe Überprüfen!")
end


# ===== Thermal Standard Generator Name
stat_gen_name = Vector{Union{Missing, String}}(missing, anzahl_stat_gen);



for i in 1:anzahl_stat_gen
    a = i - 1;
    b = a * file_numb + 2;
    stat_gen_name_hilf = split_stat_gen_str[b]
    ende_str_idx = findfirst("ThermalStandard(", split_stat_gen_str[b])
    ende_str_idx_1 = ende_str_idx[lastindex(ende_str_idx)]
    stat_gen_name[i] = stat_gen_name_hilf[ende_str_idx_1+1:end]
    # println(stat_gen_name[i])
    


    gen_name = stat_gen_name[i]
    stat_gen = get_component(ThermalStandard,sys,gen_name)
    
    tech = split(gen_name,"_")
    # println(tech[1])

    if tech[1] == "Gas"
        h_tech = 4.0
        d_tech = 3.0
        R_tech = 1.0
        Xd_p_tech = 1.0
        eq_p_tech = 1.0
        Vf_tech = 1.0
        efficiency_tech = 1.0
        V_pss_tech = 0.0

        elseif tech[1] == "Hard Coal"
            h_tech = 4.0
            d_tech = 3.0
            R_tech = 1.0
            Xd_p_tech = 1.0
            eq_p_tech = 1.0
            Vf_tech = 1.0
            efficiency_tech = 1.0
            V_pss_tech = 0.0

        elseif tech[1] == "Waste"
            h_tech = 4.0
            d_tech = 3.0
            R_tech = 1.0
            Xd_p_tech = 1.0
            eq_p_tech = 1.0
            Vf_tech = 1.0
            efficiency_tech = 1.0
            V_pss_tech = 0.0

        elseif tech[1] == "Brown Coal"
            h_tech = 4.0
            d_tech = 3.0
            R_tech = 1.0
            Xd_p_tech = 1.0
            eq_p_tech = 1.0
            Vf_tech = 1.0
            efficiency_tech = 1.0
            V_pss_tech = 0.0

        elseif tech[1] == "Oil"
            h_tech = 4.0
            d_tech = 3.0
            R_tech = 1.0
            Xd_p_tech = 1.0
            eq_p_tech = 1.0
            Vf_tech = 1.0
            efficiency_tech = 1.0
            V_pss_tech = 0.0

        elseif tech[1] == "Other"
            h_tech = 4.0
            d_tech = 3.0
            R_tech = 1.0
            Xd_p_tech = 1.0
            eq_p_tech = 1.0
            Vf_tech = 1.0
            efficiency_tech = 1.0
            V_pss_tech = 0.0

        elseif tech[1] == "Multiple"
            h_tech = 4.0
            d_tech = 3.0
            R_tech = 1.0
            Xd_p_tech = 1.0
            eq_p_tech = 1.0
            Vf_tech = 1.0
            efficiency_tech = 1.0
            V_pss_tech = 0.0

        elseif tech[1] == "Nuclear"
            h_tech = 4.0
            d_tech = 3.0
            R_tech = 1.0
            Xd_p_tech = 1.0
            eq_p_tech = 1.0
            Vf_tech = 1.0
            efficiency_tech = 1.0
            V_pss_tech = 0.0

        elseif tech[1] == "Geothermal"
            h_tech = 4.0
            d_tech = 3.0
            R_tech = 1.0
            Xd_p_tech = 1.0
            eq_p_tech = 1.0
            Vf_tech = 1.0
            efficiency_tech = 1.0
            V_pss_tech = 0.0
    end


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
    add_component!(sys, dyn_gen, stat_gen);
end;


re_gen_name = Vector{Union{Missing, String}}(missing, anzahl_re_gen);

for x in 1:anzahl_re_gen
    a = x - 1;
    b = a * re_numb + 2;
    re_gen_name_hilf = split_str_re_gen[b]
    ende_str_idx = findfirst("RenewableDispatch(", split_str_re_gen[b])
    ende_str_idx_1 = ende_str_idx[lastindex(ende_str_idx)]
    re_gen_name[x] = re_gen_name_hilf[ende_str_idx_1+1:end]
    # println(re_gen_name[x])

    re_stat_gen = get_component(RenewableDispatch,sys,re_gen_name[x])


inverter = DynamicInverter(
    name = get_name(re_stat_gen),
    ω_ref = 1.0, # ω_ref,
    converter = AverageConverter(rated_voltage = 380.0, rated_current = 100.0),
    outer_control = OuterControl(
        VirtualInertia(Ta = 2.0, kd = 400.0, kω = 20.0),
        ReactivePowerDroop(kq = 0.2, ωf = 1000.0),
    ),
    inner_control = CurrentControl(
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
    ),
    dc_source = FixedDCSource(voltage = 380.0),
    freq_estimator = KauraPLL(
        ω_lp = 500.0, #Cut-off frequency for LowPass filter of PLL filter.
        kp_pll = 0.084,  #PLL proportional gain
        ki_pll = 4.69,   #PLL integral gain
    ),
    filter = LCLFilter(lf = 0.08, rf = 0.003, cf = 0.074, lg = 0.2, rg = 0.01),
)
add_component!(sys, inverter, re_stat_gen);

end;



return sys
end;