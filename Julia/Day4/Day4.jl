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


function AdventOfCode(s,part2)
    split_string = split(s,"\r\n")

    # part number
    # Pre-allocate matrix (dont care about content)
    size = 255
    card_copies = Array{Int}(undef, size)
    fill!(card_copies,0)
    indices = 1:length(split_string)
    card_copies[indices] .= 1
    
    scores = [0.0]
    idx = 1
    for line in split_string
        #
        game_id = -1
        #
        my_winning_numbers = [0.0]
        #
        m=match(r"\s*Card\s+(\d+)\s*:" ,line)
        if ! isnothing(m)
            # Winning numbers Dict
            winning_numbers_dict = Dict()
            # Game ID
            game_id = parse(Int, m.captures[1])
            # Get substring after Card
            search_idx = m.offset + length(m.match)
            card_string = line[search_idx:end]
            card_split_string = split(card_string,'|')
            # First the winning numbers string
            winning_numbers_string = card_split_string[1]
            # Then my numbers string
            my_numbers_string = card_split_string[2]
            # Winning numbers
            matches = eachmatch(r"(\d+)\s+" ,winning_numbers_string,overlap=false)
            for match in matches 
                
                #print(match.match)
                number = parse(Int,match.captures[1])
                if ! haskey(winning_numbers_dict,number)
                    winning_numbers_dict[number] = true
                else
                    print("Weird, this number is double winning")
                end
            end

            # My numbers
            matches = eachmatch(r"\s*(\d+)\s*" ,my_numbers_string,overlap=false)
            for match in matches 
                # My number
                number = parse(Int,match.captures[1])
                if haskey(winning_numbers_dict,number)
                    my_winning_numbers = [my_winning_numbers number]
                end
            end
        end
        winning_numbers = length(my_winning_numbers)-1.0
        my_score = 0.0
        if winning_numbers >= 1
            my_score = 2^(winning_numbers-1)
            #part2
            won_card_idxs = Int(idx+1):Int(idx+winning_numbers)
            copies_of_this_card = card_copies[idx]
            card_copies[won_card_idxs] .+= copies_of_this_card
            
            print("Won new cards :" * string(winning_numbers) *".\r\n")
        end
        idx+=1

        print("Score of card " * string(game_id) * " is " * string(my_score) * "(because of " * string(length(my_winning_numbers)-1)*" winning numbers).\r\n")
        scores = [scores my_score]
    end

    for i in range(idx,size)
        if card_copies[i] > 0
            card_copies[i]=0
        end
    end
    if ! part2
        R = scores
    else
        R = card_copies
    end
    return R
end

s= LoadData(test,part2)
# Get the resulting digits
R = AdventOfCode(s,part2)
@time R = AdventOfCode(s,part2)
#@time R = AdventOfCode(s,part2)
# Sum the resulting digits
result = sum(R)
result_int=Integer(result)
print("The result is : " * string(result_int) * ".\r\n")
print("The End")
