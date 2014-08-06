require './lib/list'
require './lib/task'
require 'pry'

DB = PG.connect(:dbname => "to_do")

def main_menu

  puts "\n\nPress '1' to create list."
  puts "Press '2' to list list(s)."
  puts "Press 'x' to exit program."

  case user_decision = gets.chomp
  when '1'
    create_list
  when '2'
    list_lists
  when 'x'
    puts "Goodbye Alfred."
    exit
  else
    puts "Invalid."
    main_menu
  end

end

def create_list
  puts "Please name your list:"
  user_name = gets.chomp
  new_list = List.new(user_name)
  new_list.save
  puts "#{new_list.name} has been added!\n\n"
  puts "Would you like to add a task to #{new_list.name}? Y or N?"
  case user_decision = gets.chomp
  when 'y'
    add_task(new_list)
  when 'n'
    main_menu
  else
    puts "Invalid."
    main_menu
  end
end

def add_task new_list
  list_id = new_list.id
  puts "Enter task:"
  user_task = gets.chomp
  new_task = Task.new(user_task, list_id)
  new_task.save

  puts "#{new_task.name} has been added."
  puts "+ Add more? Y or N?"

  case user_decision = gets.chomp
  when 'y'
    add_task(new_list)
  when 'n'
    main_menu
  else
    puts "Invalid."
    main_menu
  end
end

def list_lists
  puts "Here are all your lists:"
  # binding.pry
  List.all.select { |list| puts "#{list.id}. #{list.name}"}

  puts "Would you like to remove a list? Y or N?"

  case user_decision = gets.chomp
  when 'y'
    remove_list
  when 'n'
    puts "Goodbye!"
    main_menu
  else
    puts "Invalid."
    main_menu
  end
end

def remove_list
  puts "Enter the index number of the list to delete:"

  user_index = gets.chomp.to_i
  List.remove_list(user_index)
  puts "#{user_index} deleted!"
  main_menu

end

main_menu

