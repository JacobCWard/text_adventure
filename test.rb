#################
# Control Logic #
#################

@current_page_number = 0

def evaluate_user_input(str)
  exit if str == "exit"

  next_page_number = str.to_i
  @current_page_number = next_page_number
end

stat = Random.new

@luck = [1,2,3,4,5,6,7,8,9,10]

@goblin = {
  name: "goblin",
  strength: stat.rand(3..5),
  intelligence: stat.rand(1..4),
  dexterity: stat.rand(4..8),
  vitality: stat.rand(1..3),
  beauty: stat.rand(1..2),
  gold: stat.rand(1..3),
  xp_value: 10,
  weapon: "short sword"
  }

@enemy_adjective =["smelly", "foul", "warty", "grotesque", "carbuncular", "shrieking", "mangy", "vile", "glum", "slimey", "repugnant", "flatulent"]

@melee_body_part =["chest", "abdomen", "arm", "thigh", "face", "gut", "ribs", "armpit", "sholder"]

def level_up_check(level)

  if (@stats[:level] == 1 && @stats[:xp] > 50)
    level_up
    return
  elsif (@stats[:level] == 2 && @stats[:xp] > 125)
    level_up
    return
  elsif (@stats[:level] == 3 && @stats[:xp] > 225)
    level_up
    return
  elsif (@stats[:level] == 4 && @stats[:xp] > 375)
    level_up
    return
  end
end

def level_up
  check = "repeat"
  while check == "repeat" do
    puts "You have leveled up. Vitality increases! Choose another skill to increase."
    @stats[:level] += 1
    @stats[:vitality] += 2
    puts "1) strength"
    puts "2) intelligence"
    puts "3) dexterity"
    puts "4) vitality"
    puts "5) beauty"
    check = gets.to_i
    if check == 1
      @stats[:strength] += 1
    elsif check == 2
      @stats[:intelligence] += 1
    elsif check == 3
      @stats[:dexterity] += 1
    elsif check == 4
      @stats[:vitality] += 1
    elsif check == 5
      @stats[:beauty] += 1
    else
      puts "please enter the correct input"
      check = "repeat"
    end

  end
  puts "Here are your new stats! #{@stats}"
  return    
end

def death_check
  if (@stats[:strength] < 1 || @stats[:intelligence] < 1 || @stats[:dexterity] < 1 || @stats[:vitality] < 1 || @stats[:beauty] < 1)
    return true
  else
    return
  end
end

def death
  puts ""
  puts "THE END!"
  puts ""
  puts "1) If you would like to play again."
  puts "2) If you are done for now."
  result = gets.to_i
  check = "repeat"
  while check == "repeat" do
    if result == 1
      return adventure(@goblin, @stats, @enemy_adjective, @melee_body_part, @luck)
    elsif result == 2
      return 
    else 
      puts "Please make the proper input"
      check = "repeat"
      result = gets.to_i
    end
  end
end

def monster_death?(monster, enemy_adjective)
  if monster[:vitality] < 0
    puts "With a shiver, the #{@enemy_adjective.sample} #{monster[:name]} collapses in a heap."
    return monster_death(monster, @stats, @enemy_adjective)
  else
    return
  end
end

def monster_death(monster, character, enemy_adjective)
  character[:xp] += monster[:xp_value]
  character[:gold] += monster[:gold]
  puts "A quick check of the #{@enemy_adjective.sample} #{monster[:name]}'s body yields #{monster[:gold]} gold pieces."
  puts ""
  puts "stats reminder #{@stats}"
  level_up_check(@stats[:level])
end


def attack(monster, character, enemy_adjective, melee_body_part, luck)
  puts "player #{@stats}"
  puts "golin #{monster}"
  enemy_adjective = @enemy_adjective.sample
  puts "The #{enemy_adjective} #{monster[:name]} attacks! Swinging it's #{monster[:weapon]}!"
  puts ""
  @luck = Random.new
  @luck = @luck.rand(1..10)
  puts "player @luck #{@luck}"
  injury = melee_body_part.sample
  if (monster[:dexterity] > character[:dexterity] && @luck < 8)
    puts "The #{enemy_adjective} #{monster[:name]}'s #{monster[:weapon]} slips past your defense, slashing against your #{injury}."
    puts ""
    damage = character[:vitality] - monster[:strength]
    if damage < 0
      damage = 0
    end
    character[:vitality] -= damage
    puts @stats
    if death_check
      puts "You place a hand to your #{injury}, and see blood welling up. As you see your life flee from you, a sense of panic overcomes you. As you drop to a knee overcome by weakness you feel blades slicing into your body and then you know no more."
      return death
    end
  else 
    puts "As the #{enemy_adjective} #{monster[:name]} attacks, you slip your sword in past its guard slicing it in the #{melee_body_part.sample}."
    puts ""
    monster[:vitality] = monster[:vitality] - character[:strength]
    monster_death?(monster, @enemy_adjective)
  end
  puts "monster #{monster[:vitality]}"
  puts "character #{character[:vitality]}"
  current_monster = monster
  if monster[:vitality] > 0 && character[:vitality] > 0

    return combat(current_monster, @stats, luck, enemy_adjective, melee_body_part)
  end

end

def parry(monster, character, enemy_adjective, melee_body_part, luck)
  enemy_adjective = @enemy_adjective.sample
  puts "You raise your sword, meeting the #{enemy_adjective} #{monster[:name]}'s attack with a clash of steel."
  puts""

  @luck = Random.new
  @luck = @luck.rand(1..10)
  injury = @melee_body_part.sample
  if (monster[:intelligence] > character[:intelligence] && @luck < 4)
    puts "The #{enemy_adjective} #{monster[:name]}'s #{monster[:weapon]} glances off your sword, grazing your #{injury}"
    puts ""
    damage = (character[:vitality] - (monster[:strength]/2))
    if damage < 0
      damage = 0
    end
    character[:vitality] -= damage
    if death_check
      puts "You place a hand to your #{injury}, and see blood welling up. As you see your life flee from you, a sense of panic overcomes you. As you drop to a knee overcome by weakness you feel blades slicing into your body and then you know no more."
      puts ""
      return death
    end
  else
    puts "You see an opening in the #{enemy_adjective} #{monster[:name]}'s guard and you make your move. Scoring a light blow on the #{monster[:name]}'s #{melee_body_part.sample}"
    puts ""
    enemy_damage = (monster[:vitality] - (character[:strength]/2))
    if enemy_damage < 0
      enemy_damage = 0
    end
    monster[:vitality] -= enemy_damage
    monster_death?(monster, @enemy_adjective)
  end
  puts "monster #{monster[:vitality]}"
  puts "character #{character[:vitality]}"
  current_monster = monster
  if monster[:vitality] > 0 && character[:vitality] > 0
    return combat(current_monster, @stats, luck, enemy_adjective, melee_body_part)
  end

end

def run_away(monster, character, luck)
  puts "goblin #{monster}"
  puts @stats
  @luck = Random.new
  @luck = @luck.rand(1..10)
  puts "@luck is #{@luck}"
  puts "Realizing that you are hard pressed you turn and run from the #{monster[:name]}. It takes a swing and half heartedly runs after you. "
  if ((monster[:dexterity] > character[:dexterity]) && @luck < 4)
    damage = character[:vitality] - monster[:strength]
    if damage < 0
      damage = 0
    end
    character[:vitality] -= damage
    puts @stats
    if death_check
      puts "You feel hard steel sink into your back and you realize that the end is nigh."
      return death
    end
  end
end 

def combat(monster, character, luck, enemy_adjective, melee_body_part)
  
  puts "The #{@enemy_adjective.sample} #{monster[:name]} approaches with its #{monster[:weapon]} drawn. Murder in its eyes."
  puts ""
  puts "1) You ready your weapon for battle and attack uttering a yell as you go for an all out assault of fury, throwing caution to the wind."
  puts "2) Best to approach this battle with care. I shall parry it's initial charge and look for an openeing in which to strike."
  puts "3) Run away!!!!!"
  result = gets.to_i
  puts ""
  check = "repeat"
  while check == "repeat" do
    if result == 1
      return attack(monster, character, @enemy_adjective, @melee_body_part, @luck)
      
    elsif result == 2
      return parry(monster, character, @enemy_adjective, @melee_body_part, @luck)
    elsif result == 3
      return run_away(monster, character, @luck)
    else 
      puts "Please make the proper input"
      check = "repeat"
      result = gets.to_i
    end
  end


end

def stat_generator
  
  stat = Random.new
  @stats = {
  strength: stat.rand(1..10),
  intelligence: stat.rand(1..10),
  dexterity: stat.rand(1..10),
  vitality: stat.rand(1..10),
  beauty: stat.rand(1..10),
  gold: 0,
  xp: 0,
  level: 1,
  inventory: []
  }

  puts "Please review your stats. 10 is the max."
  puts ""
  puts @stats
  
end

#####################
# Game Instructions #
#####################

pages = [
  {
    description: "What is your name brave adventurer?",
    options: [
      {
        text: "",
        page_number: 1
      },
      {
        text: "",
        page_number: 2
        },
      {
        text: "",
        page_number: 3
      }
    ]
  },
  {
    description: "Hi, it must be your first day of class! You'll be meeting in classroom 8.",
    options: [
      {
        text: "Go to classroom 8",
        page_number: 2
      },
      {
        text: "Go home",
        page_number: 3
      }
    ]
  },
  {
    description: "Class is canceled!",
    options: [
      {
        text: "Go home",
        page_number: 3
      }
    ]
  }
]

#############
# Game Play #
#############

# Infinite Loop!
while true do

  current_page = pages[@current_page_number]
  puts current_page[:description]
  current_page[:options].each do |option|
    puts "#{option[:page_number]}) #{option[:text]}"
  end

  print "~> "
  user_input = gets.chomp
  if (user_input)
    evaluate_user_input(user_input)
  end

  puts "-------------"

end

puts "Goodbye!"