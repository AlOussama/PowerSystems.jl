using PowerSimulations
using PowerSystems
using PowerSimulationsDynamics
PSID = PowerSimulationsDynamics
using Sundials
using OrdinaryDiffEq
using Random
using Distributions
using DataFrames
using CSV


for NNF in 1:24
  for i in 1:14
        fall = i-1
        # fall = 0
            println("==========================================")
            println("Simulation: NNF = ",NNF, " Fall = ",fall)
            println("==========================================")
            sys = System(string("PowerSystems.jl/Marius/02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/System/Output/",fall,"/DynamicSystem_NNF_",NNF,"_Fall_",fall, ".json"))

        # res = solve_powerflow(sys)
        # print(res)

        stoerung =  PSID.BranchTrip(5.0,ACBranch,"0_to_5");

        time_span = (0.0, 30.0);
        # model = PSID.ResidualModel
        model = PSID.MassMatrixModel
        sim = PSID.Simulation!(model, sys, pwd(), time_span,stoerung )
        show_states_initial_value(sim)

        PSID.execute!(
            sim, #simulation structure
            # IDA(), #Sundials DAE Solver (ImplicitModel, ResidualModel)
            Rodas5(), # OrdinaryDiffEq Paket für Mass Matrix Solver (ODE Solver)
            # Rodas4(), # OrdinaryDiffEq Paket für Mass Matrix Solver (ODE Solver)
            dtmax = 0.01,
        );

        results = read_results(sim);
        v0 = PSID.get_voltage_magnitude_series(results,0);
        v1 = PSID.get_voltage_magnitude_series(results,1);
        v2 = PSID.get_voltage_magnitude_series(results,2);
        v3 = PSID.get_voltage_magnitude_series(results,3);
        v4 = PSID.get_voltage_magnitude_series(results,4);
        v5 = PSID.get_voltage_magnitude_series(results,5);
        v6 = PSID.get_voltage_magnitude_series(results,6);
        v7 = PSID.get_voltage_magnitude_series(results,7);
        v8 = PSID.get_voltage_magnitude_series(results,8);
        v9 = PSID.get_voltage_magnitude_series(results,9);
        v10 = PSID.get_voltage_magnitude_series(results,10);
        v11 = PSID.get_voltage_magnitude_series(results,11);
        v12 = PSID.get_voltage_magnitude_series(results,12);
        v13 = PSID.get_voltage_magnitude_series(results,13);

        va0 = PSID.get_voltage_angle_series(results,0);
        va1 = PSID.get_voltage_angle_series(results,1);
        va2 = PSID.get_voltage_angle_series(results,2);
        va3 = PSID.get_voltage_angle_series(results,3);
        va4 = PSID.get_voltage_angle_series(results,4);
        va5 = PSID.get_voltage_angle_series(results,5);
        va6 = PSID.get_voltage_angle_series(results,6);
        va7 = PSID.get_voltage_angle_series(results,7);
        va8 = PSID.get_voltage_angle_series(results,8);
        va9 = PSID.get_voltage_angle_series(results,9);
        va10 = PSID.get_voltage_angle_series(results,10);
        va11 = PSID.get_voltage_angle_series(results,11);
        va12 = PSID.get_voltage_angle_series(results,12);
        va13 = PSID.get_voltage_angle_series(results,13);


        results_omega = DataFrame()

        if fall ==0
            o0 = PSID.get_state_series(results, ("gen_0", :ω));
            o1 = PSID.get_state_series(results, ("gen_1", :ω));
            o2 = PSID.get_state_series(results, ("gen_2", :ω));
            o3 = PSID.get_state_series(results, ("gen_3", :ω));
            o4 = PSID.get_state_series(results, ("gen_4", :ω));
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o6 = PSID.get_state_series(results, ("gen_6", :ω));
            o7 = PSID.get_state_series(results, ("gen_7", :ω));
            o8 = PSID.get_state_series(results, ("gen_8", :ω));
            o9 = PSID.get_state_series(results, ("gen_9", :ω));
            o10 = PSID.get_state_series(results, ("gen_10", :ω));
            o11 = PSID.get_state_series(results, ("gen_11", :ω));
            o12 = PSID.get_state_series(results, ("gen_12", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));

            results_omega.time = va1[1]
            results_omega.o0 = o0[2]
            results_omega.o1 = o1[2]
            results_omega.o2 = o2[2]
            results_omega.o3 = o3[2]
            results_omega.o4 = o4[2]
            results_omega.o5 = o5[2]
            results_omega.o6 = o6[2]
            results_omega.o7 = o7[2]
            results_omega.o8 = o8[2]
            results_omega.o9 = o9[2]
            results_omega.o10 = o10[2]
            results_omega.o11 = o11[2]
            results_omega.o12 = o12[2]
            results_omega.o13 = o13[2]
        elseif fall ==1
            # o0 = PSID.get_state_series(results, ("conv_0", :ω));
            o1 = PSID.get_state_series(results, ("gen_1", :ω));
            o2 = PSID.get_state_series(results, ("gen_2", :ω));
            o3 = PSID.get_state_series(results, ("gen_3", :ω));
            o4 = PSID.get_state_series(results, ("gen_4", :ω));
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o6 = PSID.get_state_series(results, ("gen_6", :ω));
            o7 = PSID.get_state_series(results, ("gen_7", :ω));
            o8 = PSID.get_state_series(results, ("gen_8", :ω));
            o9 = PSID.get_state_series(results, ("gen_9", :ω));
            o10 = PSID.get_state_series(results, ("gen_10", :ω));
            o11 = PSID.get_state_series(results, ("gen_11", :ω));
            o12 = PSID.get_state_series(results, ("gen_12", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));

            results_omega.time = va1[1]
            results_omega.o1 = o1[2]
            results_omega.o2 = o2[2]
            results_omega.o3 = o3[2]
            results_omega.o4 = o4[2]
            results_omega.o5 = o5[2]
            results_omega.o6 = o6[2]
            results_omega.o7 = o7[2]
            results_omega.o8 = o8[2]
            results_omega.o9 = o9[2]
            results_omega.o10 = o10[2]
            results_omega.o11 = o11[2]
            results_omega.o12 = o12[2]
            results_omega.o13 = o13[2]
        elseif fall == 2
            o2 = PSID.get_state_series(results, ("gen_2", :ω));
            o3 = PSID.get_state_series(results, ("gen_3", :ω));
            o4 = PSID.get_state_series(results, ("gen_4", :ω));
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o6 = PSID.get_state_series(results, ("gen_6", :ω));
            o7 = PSID.get_state_series(results, ("gen_7", :ω));
            o8 = PSID.get_state_series(results, ("gen_8", :ω));
            o9 = PSID.get_state_series(results, ("gen_9", :ω));
            o10 = PSID.get_state_series(results, ("gen_10", :ω));
            o11 = PSID.get_state_series(results, ("gen_11", :ω));
            o12 = PSID.get_state_series(results, ("gen_12", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));

            results_omega.time = va1[1]
            results_omega.o3 = o3[2]
            results_omega.o4 = o4[2]
            results_omega.o5 = o5[2]
            results_omega.o6 = o6[2]
            results_omega.o7 = o7[2]
            results_omega.o8 = o8[2]
            results_omega.o9 = o9[2]
            results_omega.o10 = o10[2]
            results_omega.o11 = o11[2]
            results_omega.o12 = o12[2]
            results_omega.o13 = o13[2]
        elseif fall ==3
            o3 = PSID.get_state_series(results, ("gen_3", :ω));
            o4 = PSID.get_state_series(results, ("gen_4", :ω));
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o6 = PSID.get_state_series(results, ("gen_6", :ω));
            o7 = PSID.get_state_series(results, ("gen_7", :ω));
            o8 = PSID.get_state_series(results, ("gen_8", :ω));
            o9 = PSID.get_state_series(results, ("gen_9", :ω));
            o10 = PSID.get_state_series(results, ("gen_10", :ω));
            o11 = PSID.get_state_series(results, ("gen_11", :ω));
            o12 = PSID.get_state_series(results, ("gen_12", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));

            results_omega.time = va1[1]
            results_omega.o4 = o4[2]
            results_omega.o5 = o5[2]
            results_omega.o6 = o6[2]
            results_omega.o7 = o7[2]
            results_omega.o8 = o8[2]
            results_omega.o9 = o9[2]
            results_omega.o10 = o10[2]
            results_omega.o11 = o11[2]
            results_omega.o12 = o12[2]
            results_omega.o13 = o13[2]
        elseif fall == 4
            o4 = PSID.get_state_series(results, ("gen_4", :ω));
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o6 = PSID.get_state_series(results, ("gen_6", :ω));
            o7 = PSID.get_state_series(results, ("gen_7", :ω));
            o8 = PSID.get_state_series(results, ("gen_8", :ω));
            o9 = PSID.get_state_series(results, ("gen_9", :ω));
            o10 = PSID.get_state_series(results, ("gen_10", :ω));
            o11 = PSID.get_state_series(results, ("gen_11", :ω));
            o12 = PSID.get_state_series(results, ("gen_12", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));

            results_omega.time = va1[1]
            results_omega.o4 = o4[2]
            results_omega.o5 = o5[2]
            results_omega.o6 = o6[2]
            results_omega.o7 = o7[2]
            results_omega.o8 = o8[2]
            results_omega.o9 = o9[2]
            results_omega.o10 = o10[2]
            results_omega.o11 = o11[2]
            results_omega.o12 = o12[2]
            results_omega.o13 = o13[2]
        elseif fall == 5
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o6 = PSID.get_state_series(results, ("gen_6", :ω));
            o7 = PSID.get_state_series(results, ("gen_7", :ω));
            o8 = PSID.get_state_series(results, ("gen_8", :ω));
            o9 = PSID.get_state_series(results, ("gen_9", :ω));
            o10 = PSID.get_state_series(results, ("gen_10", :ω));
            o11 = PSID.get_state_series(results, ("gen_11", :ω));
            o12 = PSID.get_state_series(results, ("gen_12", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));

            results_omega.time = va1[1]
            results_omega.o5 = o5[2]
            results_omega.o6 = o6[2]
            results_omega.o7 = o7[2]
            results_omega.o8 = o8[2]
            results_omega.o9 = o9[2]
            results_omega.o10 = o10[2]
            results_omega.o11 = o11[2]
            results_omega.o12 = o12[2]
            results_omega.o13 = o13[2]
        elseif fall == 6
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o7 = PSID.get_state_series(results, ("gen_7", :ω));
            o8 = PSID.get_state_series(results, ("gen_8", :ω));
            o9 = PSID.get_state_series(results, ("gen_9", :ω));
            o10 = PSID.get_state_series(results, ("gen_10", :ω));
            o11 = PSID.get_state_series(results, ("gen_11", :ω));
            o12 = PSID.get_state_series(results, ("gen_12", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));

            results_omega.time = va1[1]
            results_omega.o5 = o5[2]
            results_omega.o7 = o7[2]
            results_omega.o8 = o8[2]
            results_omega.o9 = o9[2]
            results_omega.o10 = o10[2]
            results_omega.o11 = o11[2]
            results_omega.o12 = o12[2]
            results_omega.o13 = o13[2]
        elseif fall == 7
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o7 = PSID.get_state_series(results, ("gen_7", :ω));
            o8 = PSID.get_state_series(results, ("gen_8", :ω));
            o9 = PSID.get_state_series(results, ("gen_9", :ω));
            o10 = PSID.get_state_series(results, ("gen_10", :ω));
            o11 = PSID.get_state_series(results, ("gen_11", :ω));
            o12 = PSID.get_state_series(results, ("gen_12", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));

            results_omega.time = va1[1]
            results_omega.o5 = o5[2]
            results_omega.o7 = o7[2]
            results_omega.o8 = o8[2]
            results_omega.o9 = o9[2]
            results_omega.o10 = o10[2]
            results_omega.o11 = o11[2]
            results_omega.o12 = o12[2]
            results_omega.o13 = o13[2]
        elseif fall == 8
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o8 = PSID.get_state_series(results, ("gen_8", :ω));
            o9 = PSID.get_state_series(results, ("gen_9", :ω));
            o10 = PSID.get_state_series(results, ("gen_10", :ω));
            o11 = PSID.get_state_series(results, ("gen_11", :ω));
            o12 = PSID.get_state_series(results, ("gen_12", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));

            results_omega.time = va1[1]
            results_omega.o5 = o5[2]
            results_omega.o8 = o8[2]
            results_omega.o9 = o9[2]
            results_omega.o10 = o10[2]
            results_omega.o11 = o11[2]
            results_omega.o12 = o12[2]
            results_omega.o13 = o13[2]

        elseif fall ==9
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o9 = PSID.get_state_series(results, ("gen_9", :ω));
            o10 = PSID.get_state_series(results, ("gen_10", :ω));
            o11 = PSID.get_state_series(results, ("gen_11", :ω));
            o12 = PSID.get_state_series(results, ("gen_12", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));

            results_omega.time = va1[1]
            results_omega.o5 = o5[2]
            results_omega.o9 = o9[2]
            results_omega.o10 = o10[2]
            results_omega.o11 = o11[2]
            results_omega.o12 = o12[2]
            results_omega.o13 = o13[2]
        elseif fall == 10
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o10 = PSID.get_state_series(results, ("gen_10", :ω));
            o11 = PSID.get_state_series(results, ("gen_11", :ω));
            o12 = PSID.get_state_series(results, ("gen_12", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));
            results_omega.time = va1[1]
            results_omega.o5 = o5[2]
            results_omega.o10 = o10[2]
            results_omega.o11 = o11[2]
            results_omega.o12 = o12[2]
            results_omega.o13 = o13[2]

        elseif fall == 11
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o11 = PSID.get_state_series(results, ("gen_11", :ω));
            o12 = PSID.get_state_series(results, ("gen_12", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));

            results_omega.time = va1[1]
            results_omega.o5 = o5[2]
            results_omega.o11 = o11[2]
            results_omega.o12 = o12[2]
            results_omega.o13 = o13[2]

        elseif fall == 12
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o12 = PSID.get_state_series(results, ("gen_12", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));
            results_omega.time = va1[1]
            results_omega.o5 = o5[2]
            results_omega.o12 = o12[2]
            results_omega.o13 = o13[2]
        elseif fall == 13
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            o13 = PSID.get_state_series(results, ("gen_13", :ω));
            results_omega.time = va1[1]
            results_omega.o5 = o5[2]
            results_omega.o13 = o13[2]
        else
            o5 = PSID.get_state_series(results, ("gen_5", :ω));
            
            results_omega.time = va1[1]
            results_omega.o5 = o5[2]

        end
        CSV.write(string("PowerSystems.jl/Marius/02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/Ergebnisse/omega/",fall,"/results_omega_NNF_",NNF,"_Fall_",fall,".csv"),results_omega)


        results_voltage = DataFrame()
        results_voltage.time = v1[1]
        results_voltage.v0 = v0[2]
        results_voltage.v1 = v1[2]
        results_voltage.v2 = v2[2]
        results_voltage.v3 = v3[2]
        results_voltage.v4 = v4[2]
        results_voltage.v5 = v5[2]
        results_voltage.v6 = v6[2]
        results_voltage.v7 = v7[2]
        results_voltage.v8 = v8[2]
        results_voltage.v9 = v9[2]
        results_voltage.v10 = v10[2]
        results_voltage.v11 = v11[2]
        results_voltage.v12 = v12[2]
        results_voltage.v13 = v13[2]

        CSV.write(string("PowerSystems.jl/Marius/02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/Ergebnisse/voltage/",fall,"/results_voltage_NNF_",NNF,"_Fall_",fall,".csv"),results_voltage)


        results_vangle = DataFrame()
        results_vangle.time = va1[1]
        results_vangle.va0 = va0[2]
        results_vangle.va1 = va1[2]
        results_vangle.va2 = va2[2]
        results_vangle.va3 = va3[2]
        results_vangle.va4 = va4[2]
        results_vangle.va5 = va5[2]
        results_vangle.va6 = va6[2]
        results_vangle.va7 = va7[2]
        results_vangle.va8 = va8[2]
        results_vangle.va9 = va9[2]
        results_vangle.va10 = va10[2]
        results_vangle.va11 = va11[2]
        results_vangle.va12 = va12[2]
        results_vangle.va13 = va13[2]

        CSV.write(string("PowerSystems.jl/Marius/02_Berechnungen/03_Berechnung_Verteilung_ohne_Optimierung/Ergebnisse/voltage_angle/",fall,"/results_vangle_NNF_",NNF,"_Fall_",fall,".csv"),results_vangle)
    end
end