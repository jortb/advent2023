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

function UpdateSeedWithMapping(map_content,current_seed,debug=false)
    # Winning numbers
    map_matches = eachmatch(r"(\d+)\s+(\d+)\s+(\d+)\s+" ,map_content,overlap=false)
    for map_match in map_matches
        dst_start = parse(Int,map_match.captures[1]) # Destination needs to be 0-indexed
        src_start = parse(Int,map_match.captures[2]) # The source needs to be 1-indexed
        count = parse(Int,map_match.captures[3])
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

function AdventOfCode(s,part2,debug=false)
    m=match(r"seeds:([\d\s]+)" ,s)
    seeds = Float64[]
    for mm in eachmatch(r"(\d+)\s*" ,m.captures[1],overlap=false)
        number = parse(Int,mm.captures[1])
        push!(seeds,number)
    end
    if part2
        all_seeds = Int64[]
        for i in range(1,length(seeds)/2)
            ii = Int(2 * i)-1
            start_idx = Int(seeds[ii])
            nr_idxs = Int(seeds[ii+1])
            indices = range(start_idx,nothing,nr_idxs)
            append!(all_seeds,collect(indices))
        end
    else
        all_seeds = seeds
    end
    # Winning numbers
    matches = eachmatch(r"([\w]+)-to-([\w]+)\s+map:\s+([\d\s]+)" ,s,overlap=false)

    scores = [1e9]
    for seed in all_seeds
        next_idx_faster = Int(seed)+1
        for match in matches
            if debug print("Next mapping : "* string(next_idx_faster-1) * "\r\n") end
            map_content = match.captures[3]
            #print("Capture3 : " * map_content * "\r\n")
            results = UpdateSeedWithMapping(map_content,next_idx_faster)
            if results > 0
                next_idx_faster = results
            end
            
        end
        idx_zero_based = next_idx_faster-1
        if debug print("Final mapping : "* string(idx_zero_based) * "\r\n") end
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
