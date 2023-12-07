cur_dir = @__DIR__
test = false
part2 = false



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

function UpdateMapping(map_content,max_seed,current_mapping,debug=false)
    # Winning numbers
    map_matches = eachmatch(r"(\d+)\s+(\d+)\s+(\d+)\s+" ,map_content,overlap=false)
    
    for i in range(1,length(current_mapping)-1)
        if i !=  current_mapping[i+1]
            print("PROBLEMSSS")
        end
    end

    for map_match in map_matches
        dst_start = parse(Int,map_match.captures[1]) # Destination needs to be 0-indexed
        src_start = parse(Int,map_match.captures[2]) # The source needs to be 1-indexed
        src_start_one_index = src_start + 1
        src_start_one_index = min(src_start_one_index,max_seed)
        
        src_check = current_mapping[src_start_one_index]
        count = parse(Int,map_match.captures[3])
        if debug print("Capture1 : " * string(mapp) * "\r\n") end
        max_count = src_start+count
        if src_start_one_index <= max_seed
            if max_count > max_seed
                lcount = Int(count - (max_count-max_seed))
            else
                lcount = count
            end
            src_ii = range(src_start_one_index,nothing,lcount)
            dst_ii = range(dst_start,nothing,lcount)

            current_mapping[src_ii] = dst_ii
        else
            print("ERROR")
        end
    end
end

function AdventOfCode(s,part2,debug=false)
    m=match(r"seeds:([\d\s]+)" ,s)
    seeds = Float64[]
    for mm in eachmatch(r"(\d+)\s*" ,m.captures[1],overlap=false)
        number = parse(Int,mm.captures[1])
        push!(seeds,number)
        #seeds = [seeds number]
    end
    max_seed = maximum(seeds)
    #
    seed_to_soil = collect( 0:max_seed)
    # Winning numbers
    matches = eachmatch(r"([\w]+)-to-([\w]+)\s+map:\s+([\d\s]+)" ,s,overlap=false)

    mappings = [seed_to_soil]
    idx = 1
    for match in matches
        print("Match number : " *string(idx)*"\r\n")
        map_src = match.captures[1]
        print("Capture1 : " * map_src * "\r\n")
        map_dst = match.captures[2]
        print("Capture2 : " * map_dst * "\r\n")
        map_content = match.captures[3]
        print("Capture3 : " * map_content * "\r\n")
        
        current_mapping = mappings[idx]
        current_max = length(current_mapping)
        UpdateMapping(map_content,current_max,current_mapping)
        new_max = maximum(current_mapping)
        next_mapping = collect( 0:new_max)
        push!(mappings,next_mapping)
        idx += 1
        #if idx ==6
        #    break
        #end
        #print("Current mapping:\r\n")
        print(current_mapping)
        print("\r\n")
    
    end

    scores = [1e9]
    print("number of mappings : " * string(length(mappings))*"\r\n")
    for seed in seeds
        next_idx = Int(seed)+1
        for mapping in mappings
            #idx_zero_based = next_idx-1
            #print("Next mapping : "* string(idx_zero_based) * "\r\n")
            next_idx = Int(mapping[next_idx])+1
        end
        idx_zero_based = next_idx-1
        print("Final mapping : "* string(idx_zero_based) * "\r\n")
        scores = [scores idx_zero_based]
    end
    

    R = [minimum(scores)]
    return R
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
print("The result is : " * string(result_int) * ".\r\n")
print("The End")
