cur_dir = @__DIR__
test = false
part2 = true



function LoadData(test,part2)
    #Define file name based on wether it is a test and wether it is part2.
    if test
        if part2
            filename ="test2.txt"
        else
            filename ="test1.txt"
        end
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

    current_nodes = []
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

            if part2
                if src[end]=='A'
                    push!(current_nodes,src)
                end
            else
                if src=="AAA"
                    push!(current_nodes,src)
                end
            end
        end
    end

    rythm = Dict()
    
    reached_z = Dict()
    disable = []
    for idx in range(1,length(current_nodes))
        rythm[idx] =[]
        reached_z[idx] = []
        push!(disable,false)
    end
    divs = zeros(length(current_nodes)+1)
    divs[length(current_nodes)+1]= nr_moves
    
    destination_node = "ZZZ"
    counter = 0
    reached_destination = false
    rythms_found = 0
    while !reached_destination && counter < 1e9
        move = moves[1+counter%nr_moves]
        reached_counter = 0
        
        if rythms_found < length(current_nodes)
            for idx in range(1,length(current_nodes))
                if !disable[idx]
                #if debug print("Doing move "*move*" on room "*current_node*"\r\n") end
                    current_nodes[idx] = node_data[current_nodes[idx]][move]
                    if debug print("Step number "*string(counter+1)*" Next room is "*current_nodes[idx]*"\r\n") end
                    if part2 
                        if current_nodes[idx][end]=='Z'
                            reached_counter += 1
                            
                            if length(reached_z[idx])>=2
                                found_rythm = false
                                
                                for i in range(1,length(reached_z[idx])-1)
                                    difference = reached_z[idx][i+1]-reached_z[idx][i]
                                    mod = difference % nr_moves
                                    if mod == 0
                                        #print(string(difference))
                                        #print("...")
                                        #print(string(mod))
                                        #print(";")
                                        found_rythm = true
                                        rythms_found += 1
                                        rythm[idx] = difference
                                        break
                                    end
                                    
                                end
                                if found_rythm
                                    print("-----\r\n")
                                    #print("\r\n")
                                    print("Found rythm for "*string(idx)*" disabling search.\r\n")
                                    print(rythm[idx])
                                    print("\r\n")
                                    
                                end
                                disable[idx] = found_rythm 
                            else
                                push!(reached_z[idx],counter)
                            end
                        end
                    else
                        if current_nodes[idx] == destination_node
                            reached_counter += 1
                        end
                    end
                end
            end
        else
            
            for idx in range(1,length(current_nodes))
                div = rythm[idx]/nr_moves
                divs[idx] = div
                #divs[idx] = rythm[idx]
                print("Divison for idx "*string(idx)*" = ")
                print(div)
                print("\r\n")
                reached_counter+=1
            end 
        end

        counter += 1
        if counter%1e6==0
            if counter%1e7==0
                print(":")
            else
                print(".")
            end
        end
        reached_destination = reached_counter >= length(current_nodes)
        if reached_destination
            print("Found end\r\n")
        end
    end

    if part2
        R = divs
    else
        R = [counter]
    end
    return R
end

s= LoadData(test,part2)
# Get the resulting digits
R = AdventOfCode(s,part2,test)
print("Now starting a timed call:\r\n")
@time R = AdventOfCode(s,part2)
#@time R = AdventOfCode(s,part2)
# Sum the resulting digits
result = prod(R)
result_int=Integer(result)
print("The result is : " * string(result_int) * "\r\n")
print("The End")
