
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
if fileformat == "raw"
    file_numb = 45
    println("Eingelesene Datei ist eine raw Datei")
elseif fileformat == "m"
        file_numb = 44
        println("Eingelesene Datei ist eine m Datei")

elseif fileformat == "csv"
    println("Eingelesene Datei ist eine csv Datei")
    file_numb = 44

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
    println(stat_gen_name[i])


    gen_name = stat_gen_name[i]
    stat_gen = get_component(ThermalStandard,sys,gen_name)
    # print(stat_gen)
    machine_gen = BaseMachine(
        R = 1.0,
        Xd_p = 1.0,
        eq_p = 1.0,
    );
    shaft_gen = SingleMass(
        H =3.148,
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



return sys, stat_gen_name
end;