cur_dir = @__DIR__
test = false
part2 = true



function LoadData(test,part2)
    #Define file name based on wether it is a test and wether it is part2.
    if test
        filename ="test1.txt"
    else
        filename ="input.txt"
    end
    # Get the absolute file path
    filepath = joinpath(cur_dir,filename)
    # Open the file
    f = open(filepath, "r")
    # read entire file into a string
    s = read(f, String)  
    #
    close(f)
    return s
end

mutable struct Gear
    id::Int
    part1_id::Int
    part2_id::Int
    part3_id::Int
    part4_id::Int
    row_idx::Int
    col_idx::Int
end

mutable struct Part
    id::Int
    init::Bool
    part_str::String
    symbols_connected::String
    row_idx::Int
    col_idx::Int
    length::Int
end

function AdventOfCode(s,part2)
    split_string = split(s,"\r\n")
    row_size = length(split_string)
    col_size = 0
    # scan to make sure each row is the same number of column
    for line in split_string
        line_col_size = length(line)
        col_size = max(col_size,line_col_size)
    end
    # Pad the c
    padded_col_size = col_size + 2
    padded_row_size = row_size + 2
    # Pre-allocate matrix (dont care about content)
    #m = Array{Float64}(undef, padded_row_size, padded_col_size)
    #fill!(m,NaN)
    m=zeros(padded_row_size,padded_col_size)

    # part number
    j = 2
    parts = Array{Part}(undef, 0)
    gears = Array{Gear}(undef, 0)
    gears_dict = Dict()
    current_part = Part(0,false,"","",-1,-1,-1)
    for line in split_string
        i = 2
        for char in line
            unique_key = string(j) * "_" * string(i)
            if isdigit(char)
                m[j,i] = 0
                # Is the current part initialized
                if current_part.init
                    current_part.length+=1
                else
                    current_part.init = true
                    current_part.length = 1
                    current_part.row_idx = j
                    current_part.col_idx = i
                end
                current_part.part_str = current_part.part_str * char
            else
                if current_part.init
                    #Push the current part
                    push!(parts,current_part)
                    current_part = Part(length(parts),false,"","",-1,-1,-1)
                end
                if char=='.'
                    m[j,i] = 0.0
                else
                    if char=='*'
                        new_gear = Gear(length(gears),0,0,0,0,j,i)
                        gears_dict[unique_key] = new_gear
                        push!(gears,new_gear)
                    end
                        m[j,i] = 1.0
                end
            end
            i+=1
        end
        j+=1
    end
    
    running_total = 0.0
    for part in parts
        part_number = parse(Int,part.part_str)
        surrounding_col_idxs = (part.col_idx -1) : (part.col_idx + part.length -1 + 1)
        surrounding_row_idxs = (part.row_idx-1) : (part.row_idx+1)
        for row_idx in surrounding_row_idxs
            for col_idx in surrounding_col_idxs
                surrounding_key = string(row_idx) * "_" * string(col_idx)
                if haskey(gears_dict,surrounding_key)
                    gear = gears_dict[surrounding_key]
                    if gear.part1_id == 0
                        gear.part1_id = part_number
                    elseif gear.part2_id == 0
                        gear.part2_id = part_number
                    elseif gear.part3_id == 0
                        gear.part3_id = part_number
                    elseif gear.part4_id == 0
                        gear.part4_id = part_number
                    end

                end
            end
        end

        sub_m = m[surrounding_row_idxs,surrounding_col_idxs]
        summed = sum(sub_m)
        part.symbols_connected = string(summed)
        if summed > 0.0
            running_total += part_number
        end
        #print(sub_m)
    end

    gear_score = [0.0]
    for gear in gears
        new_score =gear.part1_id* gear.part2_id
        gear_score = [gear_score new_score]
    end

    if part2
        R = gear_score
    else
        R = [running_total]
    end
    return R
end

s= LoadData(test,part2)
# Get the resulting digits
@time R = AdventOfCode(s,part2)
@time R = AdventOfCode(s,part2)
# Sum the resulting digits
result = sum(R)
result_int=Integer(result)
print(result_int)
print("The End")
