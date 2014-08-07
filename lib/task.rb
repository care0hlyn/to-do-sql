class Task
  def initialize(id=nil, name, list_id, completed, due_date)
    @name = name
    @list_id = list_id
    @id = id
    @completed = completed
    @due_date = due_date
  end

  def id
    @id
  end

  def name
    @name
  end

  def completed
    @completed
  end

  def list_id
    @list_id
  end

  def due_date
    @due_date
  end

  def save
    results = DB.exec ("INSERT INTO tasks (name, list_id, completed, due_date) VALUES ('#{@name}', #{@list_id}, '#{@completed}', '#{due_date}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def self.all
    results = DB.exec("SELECT * FROM tasks;")
    tasks = []
    results.each do |result|
      name = result["name"]
      list_id = result["list_id"].to_i
      completed = result["completed"]
      due_date = result["due_date"]
      tasks << Task.new(name, list_id, completed, due_date)
    end
    tasks
  end

  def Task.view(id)
    view = DB.exec("SELECT * FROM tasks WHERE list_id = #{id};")
    tasks = []
    view.each do |view|
      id = view["id"]
      name = view["name"]
      list_id = view["list_id"].to_i
      completed = view["completed"]
      due_date = view['due_date']
      tasks << Task.new(id, name, list_id, completed, due_date)
    end
    tasks
  end

  def self.complete_list
    result = DB.exec("SELECT * FROM tasks WHERE completed = 'y';")
    tasks = []
    result.each do |result|
      id = result["id"]
      name = result["name"]
      list_id = result["list_id"].to_i
      completed = result["completed"]
      due_date = result["due_date"]
      tasks << Task.new(id, name, list_id, completed, due_date)
    end
    tasks
  end

  def self.incomplete_list
    result = DB.exec("SELECT * FROM tasks WHERE completed = 'n';")
    tasks = []
    result.each do |result|
      id = result["id"]
      name = result["name"]
      list_id = result["list_id"].to_i
      completed = result["completed"]
      due_date = result["due_date"]
      tasks << Task.new(id, name, list_id, completed, due_date)
    end
    tasks
  end

  def Task.due_date(date, id)
    DB.exec("UPDATE tasks SET due_date = '#{date}' WHERE id = #{id};")
  end

  def Task.sort_by_due_date_asc(id)
    result = DB.exec("SELECT * FROM tasks WHERE list_id = #{id} ORDER BY due_date ASC;")
    tasks = []
    result.each do |result|
      id = result["id"]
      name = result["name"]
      list_id = result["list_id"].to_i
      completed = result["completed"]
      due_date = result["due_date"]
      tasks << Task.new(id, name, list_id, completed, due_date)
    end
    tasks
  end


  def Task.sort_by_due_date_desc(id)
    result = DB.exec("SELECT * FROM tasks WHERE list_id = #{id} ORDER BY due_date DESC;")
    tasks = []
    result.each do |result|
      id = result["id"]
      name = result["name"]
      list_id = result["list_id"].to_i
      completed = result["completed"]
      due_date = result["due_date"]
      tasks << Task.new(id, name, list_id, completed, due_date)
    end
    tasks
  end



  def self.complete(id)
    DB.exec("UPDATE tasks SET completed = 'y' WHERE id = #{id};")
  end

  def ==(another_task)
    self.name == another_task.name && self.list_id == another_task.list_id
  end
end
