cur_dir = @__DIR__
test = false
part2 = false

               
@enum pipe_field begin
    empty_location
    north_south = 0b1010
    east_west
    north_east
    north_west
    south_west
    south_east
    start_location
end
#| is a vertical pipe connecting north and south.
#- is a horizontal pipe connecting east and west.
#L is a 90-degree bend connecting north and east.
#J is a 90-degree bend connecting north and west.
#7 is a 90-degree bend connecting south and west.
#F is a 90-degree bend connecting south and east.
#. is ground; there is no pipe in this tile.
#S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.


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

function ShowMap(map_input)
    for idx in range(1,size(map_input, 1))
        for jdx in range(1,size(map_input, 2))
            print(map_input[idx,jdx])
        end
        print("\r\n")
    end
end

function WalkThroughBitmaskMapToSalesmanMap(bitmask_map,salesman_map,walkers,traveltime)
    new_walkers = []
    for walker in walkers 
        search_north = bitmask_map[walker] & 0b1000 >0
        search_east  = bitmask_map[walker] & 0b0100 >0
        search_south = bitmask_map[walker] & 0b0010 >0
        search_west  = bitmask_map[walker] & 0b0001 >0
        if search_north 
            north_coord = walker + CartesianIndex{2}((-1,0))
            accept_south = bitmask_map[north_coord] & 0b0010 > 0
            if accept_south # The north coord accept an incoming south pipe
                if salesman_map[north_coord] < 1 
                    salesman_map[north_coord] = traveltime
                    push!(new_walkers,north_coord)
                end
            end
        end

        if search_east
            east_coord  = walker + CartesianIndex{2}((0,1))
            accept_west = bitmask_map[east_coord] & 0b0001 > 0
            if accept_west # The north coord accept an incoming south pipe
                if salesman_map[east_coord] < 1
                    salesman_map[east_coord] = traveltime
                    push!(new_walkers,east_coord)
                end
            end
        end

        if search_south
            south_coord  = walker + CartesianIndex{2}((1,0))
            accept_north = bitmask_map[south_coord] & 0b1000 > 0
            if accept_north # The north coord accept an incoming south pipe
                if salesman_map[south_coord] < 1 
                    salesman_map[south_coord] = traveltime
                    push!(new_walkers,south_coord)
                end
            end
        end

        if search_west
            west_coord  = walker + CartesianIndex{2}((0,-1))
            accept_east = bitmask_map[west_coord] & 0b0100 > 0
            if accept_east # The north coord accept an incoming south pipe
                if salesman_map[west_coord] < 1 
                    salesman_map[west_coord] = traveltime
                    push!(new_walkers,west_coord)
                end
            end
        end
        
        
    end

    if length(new_walkers) >0
        WalkThroughBitmaskMapToSalesmanMap(bitmask_map,salesman_map,new_walkers,traveltime+1)
    end
end

function VisualMapToBitmaskMap(map_input)
    rows = size(map_input, 1)
    cols = size(map_input, 2)
    bitmask_map = Matrix{Int8}(undef,rows,cols)
    for idx in range(1,rows)
        for jdx in range(1,cols)
            if map_input[idx,jdx] == '║'
                bitmask = 0b1010 # North South
            elseif map_input[idx,jdx] == '═'
                bitmask = 0b0101 # East West
            elseif map_input[idx,jdx] == '╚'
                bitmask = 0b1100 # North East
            elseif map_input[idx,jdx] == '╝'
                bitmask = 0b1001 # North West
            elseif map_input[idx,jdx] == '╗'
                bitmask = 0b0011 # South West
            elseif map_input[idx,jdx] == '╔'
                bitmask = 0b110 # South East
            elseif map_input[idx,jdx] == 'S'
                bitmask = 0b11111 # North South
            else
                bitmask = 0b0000
            end
            bitmask_str = string(bitmask)
            bitmask_str = lpad(bitmask_str,3,' ')
            #print(bitmask_str)
            bitmask_map[idx,jdx] = bitmask
        end
        #print("\r\n")
    end
    return bitmask_map
end

function AdventOfCode(s,part2,debug=false)
    split_string = split(s,"\r\n")
    cols = length(split_string[1])
    rows = length(split_string)
    padding = 1
    #salesman = zeros(rows+2*padding,cols+2*padding)
    salesman = Matrix{Int}(undef,rows + 2 *padding,cols+2*padding)
    fill!(salesman,0)
    map_input = Matrix{Char}(undef,rows + 2 *padding,cols+2*padding)
    fill!(map_input,' ')
    #
    start_index = nothing
    #
    for idx in range(1,length(split_string))
        line = split_string[idx]
        for jdx in range(1,length(line))
            char = line[jdx]
            if char =='|'
                map_input[idx+padding,jdx+padding] = '║'
            elseif char =='-'
                map_input[idx+padding,jdx+padding] = '═'
            elseif char =='L'
                map_input[idx+padding,jdx+padding] = '╚'
            elseif char =='J'
                map_input[idx+padding,jdx+padding] = '╝'
            elseif char =='7'
                map_input[idx+padding,jdx+padding] = '╗'
            elseif char =='F'
                map_input[idx+padding,jdx+padding] = '╔'
            elseif char =='S'
                map_input[idx+padding,jdx+padding] = 'S'
                #start_index = [idx;jdx]
                start_index = CartesianIndex{2}((idx+padding,jdx+padding))
                salesman[start_index] = 1.0
            end
            #| is a vertical pipe connecting north and south.
            #- is a horizontal pipe connecting east and west.
            #L is a 90-degree bend connecting north and east.
            #J is a 90-degree bend connecting north and west.
            #7 is a 90-degree bend connecting south and west.
            #F is a 90-degree bend connecting south and east.
            #. is ground; there is no pipe in this tile.
            #S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.

        end
    end
    if debug ShowMap(map_input) end
    ShowMap(map_input)
    bitmask_map = VisualMapToBitmaskMap(map_input)
    WalkThroughBitmaskMapToSalesmanMap(bitmask_map,salesman,[start_index],2)

    #ShowMap(salesman)
    test = map_input[start_index]
    R = salesman .- 1
    return R
end
 

s= LoadData(test,part2)
# Get the resulting digits
R = AdventOfCode(s,part2,test)
print("Now starting a timed call:\r\n")
@time R = AdventOfCode(s,part2)
#@time R = AdventOfCode(s,part2)
# Sum the resulting digits
result = maximum(R)
result_int=Integer(result)
print("The result is : " * string(result_int) * "\r\n")
print("The End")
# 1666172641 Correct
