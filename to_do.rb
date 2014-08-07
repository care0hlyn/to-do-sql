require './lib/list'
require './lib/task'
require 'pg'
require 'pry'

DB = PG.connect(:dbname => "to_do")

@user_decision = nil

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
  default_completed = 'n'
  due_date = nil
  new_task = Task.new(user_task, list_id, default_completed, due_date)
  # binding.pry
  new_task.save

  puts "#{new_task.name} has been added."
  puts "+Add due date to #{new_task.name}? Y or N."

  user_date = gets.chomp

  if user_date == 'y'
    due_date(new_task)
  elsif user_date == 'n'
    puts "Ok, fine."
  end

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

def due_date new_task
  task_id = new_task.id
  puts "Enter due date for this task (YYYY-MM-DD):"

  user_decision = gets.chomp
  # binding.pry
  Task.due_date(user_decision, task_id)
  puts "#{user_decision} has been added to #{new_task.name}."

end

def list_lists
  puts "Here are all your lists:"
  List.all.select { |list| puts "#{list.id}. #{list.name}"}

  puts "\n\n+ Remove a list? Press 'y'\n"
  puts "+ To view tasks, enter the index number.\n\n"

  @user_decision = gets.chomp

  if @user_decision == 'y'
    remove_list
  elsif @user_decision == List.find_list(@user_decision.to_i)
    list_tasks
  else
    puts "Invalid."
    main_menu
  end
  main_menu
end

def list_tasks

  puts "Here are all your tasks sorted by due date:"
  Task.sort_by_due_date(@user_decision).select { |task| puts "#{task.id}. #{task.name}.  Complete? #{task.completed}  Due Date: #{task.due_date}" }
  # puts "Here are all your tasks:"
  # Task.view(@user_decision).select { |task| puts "#{task.id}. #{task.name}.  Complete? #{task.completed}  Due Date: #{task.due_date}" }

  puts "Would you like to mark a task as complete? Y/N"
  response = gets.chomp
  if response == 'y'
    puts "\n\nEnter the index number to mark task as done."
    user_decision = gets.chomp.to_i
    Task.complete(user_decision)
    puts "#{user_decision} marked complete!"
    view_menu
  elsif response == 'n'
  view_menu
  end
end

def view_menu
  puts "\nHere are all your completed tasks:"
  puts Task.complete_list.select { |task| puts "#{task.id}. #{task.name}"}

  puts "\nHere are your incomplete tasks:"
  puts Task.incomplete_list.select { |task| puts "#{task.id}. #{task.name}"}
  main_menu
end

def remove_list
  puts "Enter the index number of the list to delete:"

  user_index = gets.chomp.to_i
  List.remove_list(user_index)
  puts "#{user_index} deleted!"
  main_menu
end

main_menu

