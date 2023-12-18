cur_dir = @__DIR__
test = false
part2 = true

mutable struct MappingRow
    src_start::Int
    src_end::Int
    dst_start::Int
    dst_end::Int
    count::Int
    offset::Int
end


mutable struct MappingTable
    id::Int
    mapping_type::Array{MappingRow}
end

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

function CheckSeedNumberValid(seed_nr,seed_start_indices,seed_end_indices)
    for i in range(1,length(seed_start_indices))
        if seed_nr >= seed_start_indices[i] && seed_nr <= seed_end_indices[i]
            return true
        end
    end
    return false
end

function UpdateEndNumberWithMapping(mapping_type,end_number,debug=false)
    for mapping_row in reverse(mapping_type)
        src_start   = mapping_row.dst_start     # Reverse Mapping
        dst_start   = mapping_row.src_start     # Reverse Mapping
        count       = mapping_row.count
        #
        src_start_one_index = src_start + 1
        src_end_one_index = src_start_one_index + count
        #
        if end_number >= src_start_one_index && end_number < src_end_one_index
            offset = dst_start - src_start
            new_number = end_number + offset
            return new_number
        end
    end
    return -1
end

function UpdateSeedWithMapping(mapping_type,current_seed,debug=false)
    for mapping_row in mapping_type
        dst_start   = mapping_row.dst_start
        src_start   = mapping_row.src_start
        count       = mapping_row.count
        #
        src_start_one_index = src_start + 1
        src_end_one_index = src_start_one_index + count
        #
        if current_seed >= src_start_one_index && current_seed < src_end_one_index
            offset = dst_start - src_start
            new_seed = current_seed + offset
            return new_seed
        end
    end
    return -1
end

function OptimizeSeeds(all_seeds)

end

function OptimizeMappings(mapping_type,debug)
    
    #new_mapping = deepcopy(mapping_type)
    #new_mapping = sort!(new_mapping, by = x ->x.src_start)#,rev=true)

    mapping_type = sort!(mapping_type, by = x ->x.src_start)#,rev=true)
    start_indices = Array{Int}(undef,0)
    end_indices = Array{Int}(undef,0)
    for mapping_row in mapping_type
        dst_start   = mapping_row.dst_start
        src_start   = mapping_row.src_start
        count       = mapping_row.count
        offset      = mapping_row.offset
        dst_end     = dst_start + count
        src_end     = src_start + count
        src_range   = src_start : src_end

        push!(start_indices,src_start)
        push!(end_indices,src_end)
    end

    for i in 1:length(start_indices)-1
        #if start_indices[i+1] == end_indices[i]
        #    print("Exact match\r\n")
        #else
        start_next_idx = start_indices[i+1]
        current_end_idx = end_indices[i]
        if start_next_idx < current_end_idx
            print("Problem match\r\n") # This is because there will be overlap if this is true
        elseif start_next_idx == current_end_idx
            if debug print("Exact Match\r\n") end
        else
            if debug print("Gap Match\r\n") end
        end;
    end
end

function AdventOfCode(s,part2,debug=false)
    m=match(r"seeds:([\d\s]+)" ,s)
    seeds = Float64[]
    for mm in eachmatch(r"(\d+)\s*" ,m.captures[1],overlap=false)
        number = parse(Int,mm.captures[1])
        push!(seeds,number)
    end
    
    seed_start_indices = Array{Int}(undef,0)
    seed_end_indices = Array{Int}(undef,0)
    if part2    
        start_indices = Array{Int}(undef,0)
        end_indices = Array{Int}(undef,0)
        for i in range(1,length(seeds)/2)
            ii = Int(2 * i)-1
            start_idx = Int(seeds[ii])
            nr_idxs = Int(seeds[ii+1])
            end_idx = start_idx + nr_idxs
            indices = range(start_idx,nothing,nr_idxs)

            push!(start_indices,start_idx)
            push!(end_indices,end_idx)
        end

        sorted_indices = sortperm(start_indices)
        seed_start_indices = start_indices[sorted_indices]
        seed_end_indices = end_indices[sorted_indices]

        for i in 1:length(start_indices)-1
            j0 = i
            j1 = i+1
            start_next_idx = seed_start_indices[j1]
            current_end_idx = seed_end_indices[j0]
            if start_next_idx < current_end_idx
                print("Problem match\r\n") # This is because there will be overlap if this is true
            elseif start_next_idx == current_end_idx
                if debug print("Exact Match\r\n") end
            else
                if debug print("Gap Match\r\n") end
            end;
        end
    else
        for _seed in seeds 
            push!(seed_start_indices,Int(_seed))
            push!(seed_end_indices,Int(_seed))
        end
    end
    # Winning numbers
    Mappings = Array{MappingTable}(undef,0)
    #
    matches = eachmatch(r"([\w]+)-to-([\w]+)\s+map:\s+([\d\s]+)" ,s,overlap=false)
    idx = 1
    for match in matches
        map_content = match.captures[3]
        current_row = Array{MappingRow}(undef,0)
        # Winning numbers
        map_matches = eachmatch(r"(\d+)\s+(\d+)\s+(\d+)\s+" ,map_content,overlap=false)
        for map_match in map_matches
            dst_start = parse(Int,map_match.captures[1]) # Destination needs to be 0-indexed
            src_start = parse(Int,map_match.captures[2]) # The source needs to be 1-indexed
            offset      = src_start - dst_start
            count = parse(Int,map_match.captures[3])
            dst_end = dst_start + count
            src_end = src_start + count
            mapping_type = MappingRow(src_start,src_end,dst_start,dst_end,count,offset)
            push!(current_row,mapping_type)
        end
        mapping_table = MappingTable(idx,current_row)
        push!(Mappings,mapping_table)
        idx += 1
    end

    #
    #NewMappings = Array{MappingTable}(undef,0)
    if part2
        for table_type in Mappings
            OptimizeMappings(table_type.mapping_type,debug)
        end
    end

    if ! part2
        scores = [1e9]
        counter = 0
        print("Started Main Loop:\r\n")
        for i in range(1,length(seed_start_indices))
            Threads.@threads for j in range(seed_start_indices[i],seed_end_indices[i])
                next_idx_faster = Int(j)+1
                for table_type in Mappings
                #for match in matches
                    if debug print("Next mapping : "* string(next_idx_faster-1) * "\r\n") end
                    results = UpdateSeedWithMapping(table_type.mapping_type,next_idx_faster)
                    if results > 0
                        next_idx_faster = results
                    #else
                    #    print("Keeping the number the same\r\n")
                    end
                    
                end
                idx_zero_based = next_idx_faster-1
                if debug print("Final mapping : "* string(idx_zero_based) * "\r\n") end
                scores = [scores idx_zero_based]
                #counter += 1
                #if counter > 1000000
                #    counter = 0
                #    print(".")
                #end
            end
            #print("Seed Range done : "* string(seed_start_indices[i]))
            #print("\r\n")
        end
    end

    reverse_mapping = reverse(Mappings)
    solution_found = false
    counter = 0
    next_print_count = 1000000
    while ! solution_found
        next_idx_faster = counter
        for table_type in reverse_mapping
            results = UpdateEndNumberWithMapping(table_type.mapping_type,next_idx_faster)
            if results > 0
                if debug 
                    check = UpdateSeedWithMapping(table_type.mapping_type,results)
                    valid_reverse = check == next_idx_faster
                else
                    valid_reverse = true
                end

                if valid_reverse
                    next_idx_faster = results
                    if debug print("Previous mapping : " *string(next_idx_faster)*"\r\n") end
                else
                    if debug print("Mismatch in reverse table") end
                end
            else
                next_idx_faster = next_idx_faster # Keep it the same
                if debug  print("Previous mapping : " *string(next_idx_faster)*"(the same)\r\n") end
            end
        end
        
        this_number_is_a_valid_seed = CheckSeedNumberValid(next_idx_faster,seed_start_indices,seed_end_indices)
        if this_number_is_a_valid_seed
            print("Found result at end location: " *string(counter-1)*"\r\n")
            print("Found result at seed number : " *string(next_idx_faster-1)*"\r\n")
            scores = [counter-1]
            solution_found = true
            break
        end
        counter += 1
        if debug  print("Counter increasing to : " *string(counter)*"\r\n") end
        if counter % next_print_count ==0
            if counter % (10*next_print_count) == 0
                if counter % (100*next_print_count) == 0
                    print(":\r\n")
                else
                    print(":")
                end
            else
                print(".")
            end
        end
        if counter > 379811651+100
            print("Failed to find\r\n")
            break
        end
    end
    

    R = [minimum(scores)]
    return R
end

Threads.@threads for N = 1:20
    println("N = $N (thread $(Threads.threadid()) of out $(Threads.nthreads()))")
end

s= LoadData(test,part2)
# Get the resulting digits
R = AdventOfCode(s,part2,test)
print("Now starting a timed call:\r\n")
@time R = AdventOfCode(s,part2)
#@time R = AdventOfCode(s,part2)
# Sum the resulting digits
result = sum(R)
result_int=Integer(result)
print("The result is : " * string(result_int) * "\r\n")
if ! part2
    print("Should be 379811651 in roughly 0.003840 seconds")
end
print("The End")
