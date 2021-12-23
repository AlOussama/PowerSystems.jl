using PowerSystems

function generateStaticGenerator(sys)
    bus_numbers = get_bus_numbers(sys);

    for i in 1:length(bus_numbers);
        println("This is Bus Nr: ", bus_numbers[i])
        bus_name = string("Bus ",i-1)
        println(bus_name)
        println(get_bus(sys,bus_name))
        gen_name = string("gen_", i-1)
        load_name = string("load_", i-1)
        
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
                active_power_limits = (min = 0.0, max = 10),
                reactive_power_limits = (min = -10, max = 10),
                time_limits = nothing,
                ramp_limits = nothing,
                operation_cost = ThreePartCost((0.0, 1400.0), 0.0, 4.0, 2.0),
                base_power = 100.0,
            );
            add_component!(sys,stat_gen)

        stat_load =  PowerLoad(
                name = load_name,
                available = true,
                bus = get_bus(sys, bus_name),
                model = LoadModels.ConstantPower,
                active_power = 0.9,
                reactive_power = 0.5,
                base_power = 100.0 ,
                max_active_power = 10.0,
                max_reactive_power = 10.0,
            );
            add_component!(sys,stat_load)
        
    end
    new_sys = "Test"
    return new_sys
end