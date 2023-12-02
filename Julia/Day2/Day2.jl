cur_dir = @__DIR__
test = false
part2 = true



function AdventOfCode(s)
    R = true
    nr_blue = 14
    nr_red = 12
    nr_green = 13
    available_balls = Dict()
    available_balls["blue"] = nr_blue
    available_balls["red"] = nr_red
    available_balls["green"] = nr_green

    
    
    possible_games = [0.0]
    split_string = split(s,'\n')
    for line in split_string
        minimal_balls = Dict()
        minimal_balls["blue"] = 0
        minimal_balls["red"] = 0
        minimal_balls["green"] = 0

        myregex = r"\s*Game (\d+)\s*:" 
        m=match(myregex,line)
        impossible = false
        if ! isnothing(m)
            game_id = parse(Int, m.captures[1])
            search_idx = m.offset + length(m.match)
            draws_string = line[search_idx:end]
            draws_split_string = split(draws_string,';')
            for ss in draws_split_string
                myregex2 = r"(\d+)\s+(green|blue|red)" 
                matches = eachmatch(myregex2,ss,overlap=false)
                found_colors = Dict()
                for match in matches 
                    
                    #print(match.match)
                    number = parse(Int,match.captures[1])
                    color = match.captures[2]
                    #print("number is : " * string(number))
                    #print("color is : " * string(color))
                    found_colors[color] = number
                end

                
                #if haskey(found_colors,"blue") & found_colors["blue"] > nr_blue
                #    impossible = true
                #end

                for key in keys(available_balls)
                    if haskey(found_colors,key) && found_colors[key] > available_balls[key]
                        impossible = true
                    end
                end

                for key in keys(minimal_balls)
                    if haskey(found_colors,key)
                        current_min = minimal_balls[key]
                        new_value = found_colors[key]
                        if new_value > current_min 
                            minimal_balls[key] = new_value
                        end
                    end
                end
            end
        if part2
            score = 1
            for key in keys(minimal_balls)
                score = score * minimal_balls[key]
            end
            possible_games = [possible_games score]
            #print("The power of this set of cubes is " * string(score) * "\r\n")
        else
            if ! impossible
                possible_games = [possible_games game_id]
            end
        end
        end
    end
    
            R = possible_games
          
    return R
end


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
# Get the resulting digits
R = AdventOfCode(s)
# Sum the resulting digits
result = sum(R)

print(result)
close(f)