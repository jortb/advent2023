cur_dir = @__DIR__
test = false
part2 = false


mutable struct Handcards
    id::Int
    cards::Vector{Int}
    power::Int
    bid::Int
end

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

function PlaycardToHex(substring)
    char = substring[1]
    if isdigit(char)
        digit = parse(Int, char)
     elseif occursin("T", substring)
        digit = 10
    elseif occursin("J", substring)
        digit = 11
    elseif occursin("Q", substring)
        digit = 12
    elseif occursin("K", substring)
        digit = 13
    elseif occursin("A", substring)
        digit = 14
    else
        digit = 0
    end
    return digit
end

function AdventOfCode(s,part2,debug=false)
    split_string = split(s,"\r\n")
    #my_hands = Vector{Handcards}[]
    my_hands = Array{Handcards}(undef, 0)
    idx = 1
    for sub_string in split_string
        m=match(r"(\w)(\w)(\w)(\w)(\w)\s+(\d+)" ,sub_string)
        if ! isnothing(m)
            cards = zeros(Int8,5)

            bid  = parse(Int, m.captures[6])

            nr_of_each_card = zeros(Int8,15)
            cards[1] = PlaycardToHex(m.captures[1])
            cards[2] = PlaycardToHex(m.captures[2])
            cards[3] = PlaycardToHex(m.captures[3])
            cards[4] = PlaycardToHex(m.captures[4])
            cards[5] = PlaycardToHex(m.captures[5])

            nr_of_each_card[cards[1]] += 1
            nr_of_each_card[cards[2]] += 1
            nr_of_each_card[cards[3]] += 1
            nr_of_each_card[cards[4]] += 1
            nr_of_each_card[cards[5]] += 1
            
            sub_array = nr_of_each_card[nr_of_each_card.>Int8(0)]
            max_equals = maximum(sub_array)   # Used to detect 2 of a kind, 3 of a kind, 4 of a kind and 5 of a kind.
            prod_equals = prod(sub_array)     # Used to detect full house (2x3=6) and two pair (2x2=4)
            
            if max_equals == 2 && prod_equals == 2
                combination = 1
            elseif max_equals == 2 && prod_equals == 4
                combination = 2
            elseif max_equals == 3 && prod_equals == 3
                combination = 3
            elseif max_equals == 3 && prod_equals == 6
                combination = 4
            elseif max_equals == 4
                combination = 5
            elseif max_equals == 5
                combination = 6
            else
                combination = 0
            end
            
            total_power = 0
            combination_power= combination *2^(4*6)
            power_card1 = cards[1]*2^(4*4)
            power_card2 = cards[2]*2^(4*3)
            power_card3 = cards[3]*2^(4*2)
            power_card4 = cards[4]*2^(4*1)
            power_card5 = cards[5]*2^(4*0)
            
            total_power = power_card1 + power_card2 + power_card3 + power_card4 + power_card5 + combination_power
            my_hand = Handcards(idx,cards,total_power,bid)
            push!(my_hands,my_hand)
            if debug
                print("My cards are: \r\n")
                print(cards)
                print("My power only based  on cards :\r\n")
                power_string = string(Int(total_power), base = 16)
                print(power_string)
                print("\r\n")
            end
        end
        idx+=1
    end

    sort!(my_hands, by = x ->x.power)
    R =[0.0]
    for i in 1 : length(my_hands)
        product = my_hands[i].bid * i
        R = [R product]
    end

    
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
