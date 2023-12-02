cur_dir = @__DIR__
test = false
part2 = true



function AdventOfCode(s)
    #s = replace(s,"one" => 1)
    #s = replace(s,"one" => 1)
    #s = replace(s,"two" => 2)
    #s = replace(s,"three" => 3)
    #s = replace(s,"four" => 4)
    #s = replace(s,"five" => 5)
    #s = replace(s,"six" => 6)
    #s = replace(s,"seven" => 7)
    #s = replace(s,"eight" => 8)
    #s = replace(s,"nine" => 9)
    split_string = split(s,'\n')

    #results = [0,0]
    #results = Vector{Float64}([0,0])
    R = [0.0  0.0]
    #array = [1.0, 3.0]
    #A= [results;[1.0 2.0]]
    #B= vcat(results,[1.0 2.0])
    for line in  split_string
        if part2
            myregex = r"(one|two|three|four|five|six|seven|eight|nine|\d)" 
        else
            myregex = r"(\d)" 
        end
        matches = eachmatch(myregex,line,overlap=true)
        found_text_digits = Dict()
        first_num = nothing
        last_num = nothing

        for match in matches 
            #print(match)
            #print(match.match)
            digit_txt = match.match
            #print(match.offset)
            #print(length(match.match))
            start_idx = match.offset
            end_idx = start_idx + length(match.match)
            char = digit_txt[1]
             if isdigit(char)
                digit = parse(Int, char)
             elseif occursin("one", digit_txt)
                digit = 1
            elseif occursin("two", digit_txt)
                digit = 2
            elseif occursin("three", digit_txt)
                digit = 3
            elseif occursin("four", digit_txt)
                digit = 4
            elseif occursin("five", digit_txt)
                digit = 5
            elseif occursin("six", digit_txt)
                digit = 6
            elseif occursin("seven", digit_txt)
                digit = 7
            elseif occursin("eight", digit_txt)
                digit = 8
            elseif occursin("nine", digit_txt)
                digit = 9
            end
            #found_text_digits[start_idx] = digit
            #digit_str = string(digit)
            #test = line[start_idx:end_idx-1] 
            #line[start_idx:end_idx-1] = "TES"
            if isnothing(first_num)
                first_num = digit
            end
            last_num = digit
        end
        #global R
        #print(line)
        #first_num = nothing
        #first_idx = -1
        #last_num = nothing
        #last_idx = -1
        #idx = 0
        #for char in line
        #    if isdigit(char)
        #        if isnothing(first_num)
        #            first_num = parse(Int, char)
        #        end
        #        last_num = parse(Int, char)
        #    end
        #    idx += 1
        #end
        #append!(results,(first_num, last_num))
        #push!(results,(first_num, last_num))
        new_row = [10first_num  last_num]
        #vcat(results,new_row)
        #results = results2
        R = [R;new_row]
    end
    return R
end

#Define file name based on wether it is a test and wether it is part2.
if test
    if part2
        filename ="test2.txt"
    else
        filename ="test.txt"
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
# Get the resulting digits
R = AdventOfCode(s)
# Sum the resulting digits
result = sum(R)

print(result)
close(f)