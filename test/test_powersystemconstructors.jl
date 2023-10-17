
include("data_5bus_pu.jl")
include("data_14bus_pu.jl")

checksys = false

@testset "Test System constructors from .jl files" begin
    tPowerSystem = System(nothing)
    nodes_5 = nodes5()
    nodes_14 = nodes14()

    for node in nodes_5
        node.angle = deg2rad(node.angle)
    end

    # Components with time_series cannot be added to multiple systems, so clear them on each
    # test.

    sys5 = System(
        100.0,
        nodes_5,
        thermal_generators5(nodes_5),
        loads5(nodes_5);
        runchecks = checksys,
    )
    clear_components!(sys5)

    sys5b = System(
        100.0,
        nodes_5,
        thermal_generators5(nodes_5),
        loads5(nodes_5),
        battery5(nodes_5);
        runchecks = checksys,
    )
    clear_components!(sys5b)

    # GitHub issue #234 - fix time_series5 in data file, use new format
    #_sys5b = PowerSystems._System(nodes_5, thermal_generators5(nodes_5), loads5(nodes_5), nothing, battery5(nodes_5),
    #                              100.0, time_series5, nothing, nothing)
    #sys5b = System(_sys5b)

    sys5bh = System(
        100.0,
        nodes_5,
        thermal_generators5(nodes_5),
        hydro_generators5(nodes_5),
        loads5(nodes_5),
        branches5(nodes_5),
        battery5(nodes_5);
        runchecks = checksys,
    )
    clear_components!(sys5bh)

    # Test Data for 14 Bus

    # GitHub issue #234 - fix time_series5 in data file, use new format
    #_sys14 = PowerSystems._System(nodes_14, thermal_generators14, loads14, nothing, nothing,
    #                            100.0, Dict{Symbol,Vector{<:TimeSeriesData}}(),nothing,nothing)
    #sys14 = System(_sys14)

    for node in nodes_14
        node.angle = deg2rad(node.angle)
    end

    sys14b = PowerSystems.System(
        100.0,
        nodes_14,
        thermal_generators14(nodes_14),
        loads14(nodes_14),
        battery14(nodes_14);
        runchecks = checksys,
    )
    clear_components!(sys14b)
    sys14b = PowerSystems.System(
        100.0,
        nodes_14,
        thermal_generators14(nodes_14),
        loads14(nodes_14),
        branches14(nodes_14),
        battery14(nodes_14);
        runchecks = checksys,
    )
    clear_components!(sys14b)
end

@testset "Test System constructor from Matpower" begin
    # Include a System kwarg to make sure it doesn't get forwarded to PM functions.
    kwarg_test =
        () -> begin
            sys = System(
                joinpath(BAD_DATA,
                    "case5_re.m");
                runchecks = true,
            )
        end
    @test_logs (:error,) min_level = Logging.Error match_mode = :any kwarg_test()
end

@testset "Test accessor functions of PowerSystems auto-generated types" begin
    # If this test fails because a type doesn't have a constructor that takes nothing,
    # it's because not all fields in that type are defined in power_system_structs.json
    # with nullable values. Consider adding them so that this "demo-constructor" works.
    # If that isn't appropriate for this type, add it to types_to_skip below.
    # You can also call test_accessors wherever an instance has been created.

    types_to_skip = (TestDevice, TestRenDevice)
    types = vcat(
        IS.get_all_concrete_subtypes(Component),
        IS.get_all_concrete_subtypes(DynamicComponent),
        IS.get_all_concrete_subtypes(PowerSystems.ActivePowerControl),
        IS.get_all_concrete_subtypes(PowerSystems.ReactivePowerControl),
    )
    sort!(types; by = x -> string(x))
    for ps_type in types
        ps_type in types_to_skip && continue
        component = ps_type(nothing)
        test_accessors(component)
    end
end

@testset "Test required accessor functions of subtypes of Component " begin
    types = IS.get_all_concrete_subtypes(Component)
    types_to_skip = (TestDevice, TestRenDevice)
    sort!(types; by = x -> string(x))
    for ps_type in types
        ps_type in types_to_skip && continue
        component = ps_type(nothing)
        @test get_name(component) isa String
        @test IS.get_internal(component) isa IS.InfrastructureSystemsInternal
    end
end

@testset "Test component conversion" begin
    # Reusable resources for this testset
    load_test_system = () -> System(joinpath(BAD_DATA, "case5_re.m"))
    function setup_time_series!(sys::System, component::Component, ts_name::String)
        dates = collect(
            Dates.DateTime("2020-01-01T00:00:00"):Dates.Hour(1):Dates.DateTime(
                "2020-01-01T23:00:00",
            ),
        )
        data = collect(1:24)
        ta = TimeSeries.TimeArray(dates, data, [get_name(component)])
        time_series = SingleTimeSeries(; name = ts_name, data = ta)
        add_time_series!(sys, component, time_series)
        @test get_time_series(SingleTimeSeries, component, ts_name) isa SingleTimeSeries
    end

    function test_forward_conversion(
        new_type::Type{<:Component},
        old_component::Component,
        sys,
        component_name,
        ts_name,
    )
        convert_component!(new_type, old_component, sys)
        println(typeof(old_component))
        @test isnothing(get_component(typeof(old_component), sys, component_name))
        new_component = get_component(new_type, sys, component_name)
        @test !isnothing(new_component)
        @test get_name(new_component) == component_name
        @test get_time_series(SingleTimeSeries, new_component, ts_name) isa SingleTimeSeries
        return new_component
    end

    """Tests Line <-> MonitoredLine conversion"""
    test_line_conversion =
        () -> begin
            sys = load_test_system()
            l = get_component(Line, sys, "bus2-bus3-i_4")
            ts_name = "active_power_flow"
            setup_time_series!(sys, l, ts_name)

            # Conversion to MonitoredLine
            mline =
                test_forward_conversion(MonitoredLine, l, sys, "bus2-bus3-i_4", ts_name)

            # Conversion back (must be forced)
            @test_throws ErrorException convert_component!(
                Line,
                get_component(MonitoredLine, sys, "bus2-bus3-i_4"),
                sys,
            )
            convert_component!(
                Line,
                get_component(MonitoredLine, sys, "bus2-bus3-i_4"),
                sys;
                force = true,
            )
            line = get_component(Line, sys, "bus2-bus3-i_4")
            @test !isnothing(mline)
            @test get_time_series(SingleTimeSeries, line, ts_name) isa SingleTimeSeries
        end

    """Tests PowerLoad --> StandardLoad conversion"""
    test_load_conversion =
        () -> begin
            sys = load_test_system()
            l = get_component(PowerLoad, sys, "bus2")
            ts_name = "max_active_power"
            setup_time_series!(sys, l, ts_name)

            # Conversion to StandardLoad
            sload = test_forward_conversion(StandardLoad, l, sys, "bus2", ts_name)

            # Conversion back is not implemented
        end

    @test_logs (:error,) min_level = Logging.Error match_mode = :any test_line_conversion()
    @test_logs (:error,) min_level = Logging.Error match_mode = :any test_load_conversion()
end
