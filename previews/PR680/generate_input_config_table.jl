@info "Generating Input Configuration Descriptor Table"
function generate_input_config_table(filepath::AbstractString)
    descriptor = PowerSystems._read_config_file(joinpath(
        dirname(pathof(PowerSystems)),
        "descriptors",
        "power_system_inputs.json",
    ))

    columns = [
        "name",
        "description",
        "unit",
        "unit_system",
        "base_reference",
        "default_value",
        "value_options",
        "value_range",
    ]
    header = "| " * join(columns, " | ") * " |\n" * repeat("|--", length(columns)) * "|\n"

    open(filepath, "w") do io
        write(io, "# Data Requirements\n\n")
        write(
            io,
            "The following tables describe CSV column definitions accepted by the `PowerSystemeTableData` parser:\n\n",
        )
        for (cat, items) in descriptor
            csv = ""
            for name in PowerSystems.INPUT_CATEGORY_NAMES
                if name[2] == cat
                    csv = name[1]
                    break
                end
            end

            write(io, "## $csv.csv:\n\n")
            write(io, header)
            for item in items
                extra_cols = setdiff(keys(item), columns)
                if !isempty(extra_cols)
                    # make sure that there arent unexpected entries
                    throw(@error "config file fields not included in header" extra_cols)
                end
                row = []
                for col in columns
                    val = string(get(item, col, " "))
                    if col == "default_value" && val == " "
                        val = "*REQUIRED*"
                    end
                    push!(row, val)
                end
                write(io, "|" * join(row, "|") * "|\n")
            end
            write(io, "\n\n")
        end
    end
end

generate_input_config_table(joinpath(
    dirname(pathof(PowerSystems)),
    "../docs/src/modeler_guide/generated_tabledata_config_table.md",
))
