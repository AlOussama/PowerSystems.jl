using PowerSystems

function generatePowerSystem()
    

sys = System(230,frequency = 50)

nodes()=[
    Bus(
    number = 1, # Node Number
    name = "Node1", # Node Name
    bustype = "REF", # Node Type
    angle = 0, # Voltage Angle
    magnitude = 1.0, # Voltage in p.u
    voltage_limits = (min = 0.9, max = 1.05), #Voltage Limits
    base_voltage = 380, #Base Voltage
    area = nothing, # Area
    load_zone = nothing # Land Zone
    ),

    Bus(
        number = 2, # Node Number
        name = "Node2", # Node Name
        bustype = "PQ", # Node Type
        angle = 0, # Voltage Angle
        magnitude = 1.0, # Voltage in p.u
        voltage_limits = (min = 0.9, max = 1.05), #Voltage Limits
        base_voltage = 380, #Base Voltage
        area= nothing, # Area
        load_zone = nothing # Land Zone
        ),
];

add_components!(sys,nodes())

branches() =[
    Line(   
    name = "2-3", # Name
    available = true, # Availability
    active_power_flow = 0.0 , # Activ Powerflow
    reactive_power_flow = 0.0, # Reactive Powerflow
    arc = Arc(from = get_bus(sys,"Node1"), to = get_bus(sys,"Node2")), #Von Knoten nach Knoten
    r = 0.06, # Resistanz (r)
    x = 0.25, # Reaktanz (x)
    b = (from = 0.00356, to = 0.00356),
    rate = 2.0, # rate --> was ist das?
    angle_limits = (min = -0.7, max = 0.7)  # Winkelbegrenzung
),

];
add_components!(sys,branches())


new_renewable() = [
RenewableDispatch(
            name = "00001_Solar_2",
            available = true,
            bus = get_component(Bus, sys,"Node2"),
            active_power = 2.0,
            reactive_power = 0.0,
            rating = 1.2,
            prime_mover = PrimeMovers.PVe,
            reactive_power_limits = (min = 0.0, max = 0.0),
            base_power = 100.0,
            operation_cost = TwoPartCost(22.0, 0.0),
            power_factor = 1.0
        ),

        RenewableDispatch(
            name = "000001_Wind Onshore_02",
            available = true,
            bus = get_component(Bus, sys,"Node2"),
            active_power = 1.5,
            reactive_power = 1.0,
            rating = 1.2,
            prime_mover = PrimeMovers.WT,
            reactive_power_limits = (min = 0.0, max = 0.0),
            base_power = 100.0,
            operation_cost = TwoPartCost(22.0, 0.0),
            power_factor = 1.0
        ),
];

add_components!(sys,new_renewable())

standard_dispatch() =[
ThermalStandard(
        name = "00001_Gas_01",
        available = true,
        status = true,
        bus = get_bus(sys, "Node1"),
        active_power = 3.0,
        reactive_power = 0.5,
        rating = 1.0,
        prime_mover = PrimeMovers.GT,
        fuel = ThermalFuels.NATURAL_GAS,
        active_power_limits = (min = 0.0, max = 10),
        reactive_power_limits = (min = -0.30, max = 20),
        time_limits = nothing,
        ramp_limits = nothing,
        operation_cost = ThreePartCost((0.0, 1400.0), 0.0, 4.0, 2.0),
        base_power = 100.0,
    ),

    HydroDispatch(
    name = "1_Run of River_01",
    available = true,
    bus = get_bus(sys, "Node1"),
    active_power = 1.0,
    reactive_power=2.0,
    rating = 1.0,
    prime_mover = PrimeMovers.HA,
    active_power_limits = (min = 0.0, max = 10),
    reactive_power_limits = (min = -0.30, max = 20),
    time_limits = nothing,
    ramp_limits = nothing,
    base_power=100.0,
    ),

    HydroDispatch(
        name = "2_Run of River_02",
        available = true,
        bus = get_bus(sys, "Node2"),
        active_power = 1.0,
        reactive_power=2.0,
        rating = 1.0,
        prime_mover = PrimeMovers.HA,
        active_power_limits = (min = 0.0, max = 10),
        reactive_power_limits = (min = -0.30, max = 20),
        time_limits = nothing,
        ramp_limits = nothing,
        base_power=100.0,
        ),

    HydroPumpedStorage(
        name = "1_HPS_01",
        available = true,
        bus = get_bus(sys, "Node2"),
        active_power = 1.0,
        reactive_power = 2.0,
        rating = 1.0,
        base_power = 1.0,
        prime_mover = PrimeMovers.PS,
        active_power_limits =  (min = 0.0, max = 10),
        reactive_power_limits  = (min = -0.30, max = 20),
        ramp_limits= nothing,
        time_limits = nothing,
        rating_pump = 20.0,
        active_power_limits_pump = (min = -0.30, max = 20),
        reactive_power_limits_pump = (min = -0.30, max = 20),
        ramp_limits_pump = (up = 10.0, down = 5.0),
        time_limits_pump= (up = 2.0, down = 1.0),
        storage_capacity= (up = 100.0, down = 100.0),
        inflow = 0.0,
        outflow = 0.0,
        initial_storage = (up = 100.0, down = 100.0),
        storage_target= (up = 100.0, down = 100.1),
        operation_cost = ThreePartCost((0.0, 1400.0), 0.0, 4.0, 2.0),
        pump_efficiency = 1.0,
        conversion_factor = 1.0,
        time_at_status = 1.0,
    ),

    HydroPumpedStorage(
        name = "1_HPS_02",
        available = true,
        bus = get_bus(sys, "Node2"),
        active_power = 1.0,
        reactive_power = 2.0,
        rating = 1.0,
        base_power = 1.0,
        prime_mover = PrimeMovers.PS,
        active_power_limits =  (min = 0.0, max = 10),
        reactive_power_limits  = (min = -0.30, max = 20),
        ramp_limits= nothing,
        time_limits = nothing,
        rating_pump = 20.0,
        active_power_limits_pump = (min = -0.30, max = 20),
        reactive_power_limits_pump = (min = -0.30, max = 20),
        ramp_limits_pump = (up = 10.0, down = 5.0),
        time_limits_pump= (up = 2.0, down = 1.0),
        storage_capacity= (up = 100.0, down = 100.0),
        inflow = 0.0,
        outflow = 0.0,
        initial_storage = (up = 100.0, down = 100.0),
        storage_target= (up = 100.0, down = 100.1),
        operation_cost = ThreePartCost((0.0, 1400.0), 0.0, 4.0, 2.0),
        pump_efficiency = 1.0,
        conversion_factor = 1.0,
        time_at_status = 1.0,
    ),

];
add_components!(sys,standard_dispatch());

load2 =  PowerLoad(
    name = "Load_1",
    available = true,
    bus = get_bus(sys, "Node1"),
    model = LoadModels.ConstantPower,
    active_power = 0.9,
    reactive_power = 0.5,
    base_power = 300.0 ,
    max_active_power = 3.0,
    max_reactive_power = 1.0,
),

return sys
end
