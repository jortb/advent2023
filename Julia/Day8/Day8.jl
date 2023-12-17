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


function AdventOfCode(s,part2,debug=false)
    split_string = split(s,"\r\n")

    scores = [1.0]
    idx = 1
    # Row based CSV
    node_data = Dict()

    moves = []
    
    first_line = split_string[1]
    m=match(r"([LR]+)" ,first_line)
    if ! isnothing(m)
        moves = m.captures[1]
    end
    nr_moves = length(moves)

    for idx in range(3,length(split_string))
        line = split_string[idx]
        #
        m=match(r"(\w\w\w)\s+=\s+\((\w\w\w),\s+(\w\w\w)\)" ,line)
        if ! isnothing(m)
            src = m.captures[1]
            dst_l = m.captures[2]
            dst_r = m.captures[3]
            if ! haskey(node_data,src)
                #
                dst_dict = Dict()
                dst_dict['L'] = dst_l
                dst_dict['R'] = dst_r
                node_data[src] = dst_dict
            else
                print("Error we did not expect a node to be mentioned twice \r\n")
            end
        end
    end

    current_node = "AAA"
    destination_node = "ZZZ"
    counter = 0
    while current_node != destination_node && counter < 1e9
        move = moves[1+counter%nr_moves]
        if debug print("Doing move "*move*" on room "*current_node*"\r\n") end
        current_node = node_data[current_node][move]
        
        counter += 1
        if debug print("Step number "*string(counter)*" Next room is "*current_node*"\r\n") end
    end

    R = [counter]
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
print("The result is : " * string(result_int) * "\r\n")
print("The End")
