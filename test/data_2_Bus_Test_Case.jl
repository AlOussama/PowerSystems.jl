using PowerSystems

function generatePowerSystem()
    

sys = System(230,frequency = 50)

nodes()=[
    Bus(
    1, # Node Number
    "Node1", # Node Name
    "SLACK", # Node Type
    0, # Voltage Angle
    1.0, # Voltage in p.u
    (min = 0.9, max = 1.05), #Voltage Limits
    380, #Base Voltage
    nothing, # Area
    nothing # Land Zone
    ),

    Bus(
        2, # Node Number
        "Node2", # Node Name
        "PQ", # Node Type
        0, # Voltage Angle
        1.0, # Voltage in p.u
        (min = 0.9, max = 1.05), #Voltage Limits
        380, #Base Voltage
        nothing, # Area
        nothing # Land Zone
        ),
];

add_components!(sys,nodes())

branches() =[
    Line(   "2-3", # Name
    true, # Availability
    0.0 , # Activ Powerflow
    0.0, # Reactive Powerflow
    Arc(from = get_bus(sys,"Node1"), to = get_bus(sys,"Node2")), #Von Knoten nach Knoten
    0.06, # Resistanz (r)
    0.25, # Reaktanz (x)
    (from = 0.00356, to = 0.00356),
    2.0, # rate --> was ist das?
    (min = -0.7, max = 0.7)  # Winkelbegrenzung
),

];
add_components!(sys,branches())


new_renewable() = [
RenewableDispatch(
            name = "Solar_2",
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
            name = "Wind Onshore_2",
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
        name = "Gas_1",
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

];
add_components!(sys,standard_dispatch());

return sys
end
