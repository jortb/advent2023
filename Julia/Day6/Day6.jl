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


function AdventOfCode(s,part2,debug=false)
    split_string = split(s,"\r\n")

    # part number
    # Pre-allocate matrix (dont care about content)
    size = 255
    card_copies = Array{Int}(undef, size)
    fill!(card_copies,0)
    indices = 1:length(split_string)
    card_copies[indices] .= 1
    
    scores = [1.0]
    idx = 1
    # Row based CSV
    row_csv_data = Dict()
    for line in split_string
        #
        m=match(r"\s*(\w+)\s*:" ,line)
        if ! isnothing(m)
            # Game ID
            header =  m.captures[1]
            if ! haskey(row_csv_data,header)
                # Get substring after Card
                search_idx = m.offset + length(m.match)
                sub_string = line[search_idx:end]
                if part2
                    sub_string = replace(sub_string,' ' => "")
                end
                # Winning numbers
                matches = eachmatch(r"\s*(\d+)" ,sub_string,overlap=false)
                #
                row_csv_data[header] = zeros(length(collect(matches)))
                idx =1
                for match in matches
                    # Game ID
                    value = parse(Int, match.captures[1])
                    #
                    row_csv_data[header][idx] = value
                    #
                    idx+=1
                end
                
                if debug print(row_csv_data[header]) end
                if debug print("New data header found :" * header * ".\r\n") end
            end
        end
    end

    if haskey(row_csv_data,"Time") && haskey(row_csv_data,"Distance")
        nr_games = length(row_csv_data["Time"])

        
        for idx in range(1,nr_games)
            time_ms = Int(row_csv_data["Time"][idx])
            distance_to_beat = row_csv_data["Distance"][idx]

            distance_travelled = zeros(1,time_ms)
            for i in range(1,time_ms-1)
                speed = Float64(i)
                distance = speed * (time_ms-i)
                distance_travelled[1,i] = distance
                if debug print("Distance travelled by getting to speed " * string(speed) * " is : " * string(distance)*".\r\n") end
            end
            faster_mask = zeros(1,time_ms)
            faster_indices = distance_travelled.>distance_to_beat
            faster_mask[faster_indices] .= 1.0
            my_score = sum(faster_mask)
            if debug print("Number of ways to be faster : " * string(my_score) * ".\r\n") end
            scores = [scores my_score]
        end
    end

    R = [prod(scores)]
    return R
end

s= LoadData(test,part2)
# Get the resulting digits
R = AdventOfCode(s,part2)
print("Now starting a timed call:\r\n")
@time R = AdventOfCode(s,part2)
#@time R = AdventOfCode(s,part2)
# Sum the resulting digits
result = sum(R)
result_int=Integer(result)
print("The result is : " * string(result_int) * ".\r\n")
print("The End")
