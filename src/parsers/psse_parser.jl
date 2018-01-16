export psse_parser

function parse_value(s::String)
    """
    Takes in a string and returns an Integer or Float64 if possible. 
    If not, return the original string stripped of leading/ending whitespaces.

    Args:
        s: A string.
    """

    s = strip(s)
    val = tryparse(Int64, s)
    if isnull(val)
        val = tryparse(Float64, s)
        if isnull(val)
            return s
        end
    end
    return get(val)
end

# Function to read the raw files from psse 

function psse_parser(rawfile_name::String)
    current_row = 0
    f = open(rawfile_name);
    lines = readlines(f)
    section = "BUS"
    i = 0
    branches = Dict{Any,Any}()
    gens = Dict{Any,Any}()
    buses = Dict{Any,Any}()

    name = split(split(rawfile_name, "/")[end],".")[1]
    case = Dict{String,Any}(
        "per_unit" => true,
        "name" => name,
        "dcline" => Dict{String,Any}(),
        "baseMVA" => [],
        # "gencost" => [],
        "multinetwork" => false,
        "version" => "psse raw file",
    )
    case["baseMVA"] = parse(Int,split(split(lines[1], ',')[2],'.')[1])
    for ln in lines
        
        # @show ln
        # parsing line LN into an array DATA separated by commas
        # row_data = split(ln, ",")
        # put line into dictionary based on section
        current_row += 1

        if contains(ln, "END")
            start = split(ln, ",")[end]
            section = split(start)[2]
            i = 0
            @show section
            continue
        end
        if current_row == 1
            row = split(ln, ",")
            baseS = parse(Float64, row[2])
        elseif section == "BUS" && current_row > 3
            bus_row = split(ln, ",")
            #@show bus_row
            bus_data = Dict{String,Any}(
                "index" => parse(Int, bus_row[1]),
                "bus_name" => strip(bus_row[2],['\'']),
                 "bus_i" => parse(Int, bus_row[1]),
                 "bus_type" => parse(Int, bus_row[4]),
                 "pd" => 0.0,
                 "qd" => 0.0,
                 "gs" => 0.0,
                 "bs" => 0.0,
                 "area" => parse(Int, bus_row[5]),
                 "vm" => parse(Float64, bus_row[8]),
                 "va" => parse(Float64, bus_row[9]),
                 "base_kv" => parse(Float64, bus_row[3]),
                 "zone" => parse(Int, bus_row[6]),
                "vmax" => 1.05, #change this later
                "vmin" => .95,
            )
            buses[strip(bus_row[1])] = bus_data
        
        elseif section == "GENERATOR" 
            gen_row = split(ln, ",")
            gen_data = Dict{String,Any}(
                "index" => parse(Int, gen_row[1]),
                "gen_bus" => parse(Int, gen_row[8]),
                "pg" => parse(Float64, gen_row[3]),
                "qg" => parse(Float64, gen_row[4]),
                "qmax" => parse(Float64, gen_row[5]),
                "qmin" => parse(Float64, gen_row[6]),
                "vg" => parse(Float64, gen_row[7]),
                "mbase" => parse(Float64, gen_row[9]),
                "gen_status" => parse(Int, gen_row[15]),
                "pmax" => parse(Float64, gen_row[17]),
                "pmin" => parse(Float64, gen_row[18]),
                # "pc1" => 0.0,
                # "pc2" => 0.0,
                # "qc1min" => 0.0,
                # "qc1max" => 0.0,
                # "qc2min" => 0.0,
                # "qc2max" => 0.0,
                # "ramp_agc" => 0.0,
                # "ramp_10" => 0.0,
                # "ramp_30" => 0.0,
                # "ramp_q" => 0.0,
                "apf" => parse(Float64, gen_row[end]),
            )
            gens[strip(gen_row[1])] = gen_data

        elseif section == "LOAD"
            load_row = split(strip(ln, [' ']), ",")
            buses[load_row[1]]["pd"] = parse(Float64, load_row[6])/case["baseMVA"]
            buses[load_row[1]]["qd"] = parse(Float64, load_row[7])/case["baseMVA"]
        
        elseif section == "BRANCH"
            branch_row = split(ln, ",")
            branch_data = Dict{String,Any}(
                "index" => i,
                "f_bus" => parse(Int, branch_row[1]),
                "t_bus" => parse(Int, branch_row[2]),
                "br_r" => parse(Float64, branch_row[4]),
                "br_x" => parse(Float64, branch_row[5]),
                "br_b" => parse(Float64, branch_row[6]),
                "rate_a" => parse(Float64, branch_row[7]),
                "rate_b" => parse(Float64, branch_row[8]),
                "rate_c" => parse(Float64, branch_row[9]),
                "tap" => 1.0,
                "shift" => 0.0,
                "br_status" => parse(Int, branch_row[14]),
                "angmin" => 0.0,
                "angmax" => 0.0,
                "transformer" => false,
            )
            branches[strip(string(i))] = branch_data
            i = i + 1
        # elseif section == "TRANSFORMER"
        #     transf_row = split(strip(ln, [' ']), ",")
        #     branch_data = Dict{String,Any}(
        #         "index" => i,
        #         "f_bus" => parse(Int, branch_row[1]),
        #         "t_bus" => parse(Int, branch_row[2]),
        #         "br_r" => parse(Float64, branch_row[4]),
        #         "br_x" => parse(Float64, branch_row[5]),
        #         "br_b" => parse(Float64, branch_row[6]),
        #         "rate_a" => parse(Float64, branch_row[7]),
        #         "rate_b" => parse(Float64, branch_row[8]),
        #         "rate_c" => parse(Float64, branch_row[9]),
        #         "tap" => 1.0,
        #         "shift" => 0.0,
        #         "br_status" => parse(Int, branch_row[14]),
        #         "angmin" => 0.0,
        #         "angmax" => 0.0,
        #         "transformer" => true,
        #     )
        #     branches[strip(string(i))] = branch_data
        #     i = i + 1
        elseif section == "FIXED"
            shunt_row = split(strip(ln, [' ']), ",")
            buses[shunt_row[1]]["gs"] = (parse(Float64, shunt_row[3])*parse(Float64, shunt_row[4]))/case["baseMVA"]
            buses[shunt_row[1]]["bs"] = (parse(Float64, shunt_row[3])*parse(Float64, shunt_row[5]))/case["baseMVA"]
        end

    end
    case["branch"] = branches
    case["gen"] = gens
    case["bus"] = buses
    close(f)
    #write_dict(case, "IEEE_output.txt")
    return case
end
