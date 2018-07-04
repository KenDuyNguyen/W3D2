class User
  
  def self.find_by_id(user_id)
    options = QDB.instance.execute(<<-SQL, user_id)
      SELECT *
      FROM users 
      WHERE id = ?
      SQL
      
    User.new(options.first)
  end
  
  def self.find_by_name(fname,lname)
    options = QDB.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    
    User.new(options.first)
  end 
  
  attr_reader :id, :fname, :lname
  
  def initialize(options)
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end
  
  def authored_questions
    Question.find_by_author_id(id)
  end
  
  def authored_replies
    Reply.find_by_user_id(id)
  end
  
  def followed_questions 
    Follow.followed_questions_for_user_id(id)
  end 
  
  def liked_questions 
    Like.liked_questions_for_user_id(id)
  end 
  
  def average_karma
    karma = QDB.instance.execute(<<-SQL, id)
      SELECT
        COUNT(questions.id) / COUNT(DISTINCT(questions.id)) as FLOAT
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        questions.user_id = ?
      GROUP BY
        questions.id
      
    SQL
    
    karma
  end
end
