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

function ExtrapolateLeftDict(my_dict)
    derivative_level =my_dict["derivative_level"]
    for i in derivative_level:-1:0
        cur_key = "d"*string(i)
        higher_key = "d"*string(i+1)
        new_value = -my_dict[higher_key][1]+my_dict[cur_key][1+1]
        my_dict[cur_key][1] = new_value
        #print(new_value)
       # print("\r\n")
    end
    #print("----\r\n")
end

function ExtrapolateRightDict(my_dict)
    derivative_level =my_dict["derivative_level"]
    #print("::::\r\n")
    for i in derivative_level:-1:0
        cur_key = "d"*string(i)
        higher_key = "d"*string(i+1)
        new_value = my_dict[higher_key][end]+my_dict[cur_key][end-1]
        my_dict[cur_key][end] = new_value
        #print(new_value)
       # print("\r\n")
    end
    #print("----\r\n")
end

function MakeDictDerivatives(my_dict, derivative_level,extrapolate_left,extrapolate_right)
    if derivative_level > my_dict["derivative_level"]
        my_dict["derivative_level"] = derivative_level
    end
    cur_key =  "d"*string(derivative_level)
    next_key = "d"*string(derivative_level+1)
    d_cur = my_dict[cur_key]
    d_next = zeros(length(d_cur)-1)
    for i in (1+extrapolate_left):(length(d_cur)-1-extrapolate_right)
        d_next[i] = d_cur[i+1] - d_cur[i]
    end
    my_dict[next_key] = d_next
    summed = sum(x->x!=0.0, d_next)
    if summed != 0 
        MakeDictDerivatives(my_dict,derivative_level+1,extrapolate_left,extrapolate_right)
    else
        return 
    end
end


function AdventOfCode(s,part2,debug=false)
    split_string = split(s,"\r\n")
    extrapolate_right = 1
    extrapolate_left = 1
    score = zeros(length(split_string))
    for idx in range(1,length(split_string))
        line = split_string[idx]
        #
        matches = eachmatch(r"([-\d]+)\s*",line,overlap=false)
        sequence = Dict()
        sequence["derivative_level"] = 0
        c_matches = collect(matches)
        amount_nummer = length(c_matches)
        sequence["d0"] = zeros(amount_nummer+extrapolate_right+extrapolate_left)
        
        for idx in 1:amount_nummer 
            match = c_matches[idx]
            #print(match.match)
            number = parse(Int,match.match)
            #print(number)
            #print("\r\n")

            sequence["d0"][idx+extrapolate_left] = number
        end
        MakeDictDerivatives(sequence,0,extrapolate_left,extrapolate_right)
        
        if part2
            ExtrapolateLeftDict(sequence)
            my_score = sequence["d0"][1]
        else
            ExtrapolateRightDict(sequence)
            my_score = sequence["d0"][end]
        end
        score[idx] = my_score
        #print(sequence)
    end

    R = score
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
print("The result is : " * string(result_int) * "\r\n")
print("The End")
# 1666172641 Correct
