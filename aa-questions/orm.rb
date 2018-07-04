require 'sqlite3'
require 'Singleton'
load 'reply.rb'
load 'question.rb'
load 'user.rb'
load 'follow.rb'

class QDB < SQLite3::Database
  include Singleton
  
  def initialize
    super("questions.db")
    self.type_translation = true
    self.results_as_hash = true
  end 
end 

class Like
  def self.likers_for_question_id(question_id)
    likers = QDB.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, fname, lname
      FROM
        users
      JOIN
        question_likes ON users.id = user_id
      WHERE
        question_id = ?
    SQL
    
    likers.map { |liker| User.new(liker)}
  end
  
  def self.num_likes_for_question_id(question_id)
    likes = QDB.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*) as c 
      FROM 
        question_likes 
      WHERE 
        question_id = ?
    SQL
    
    likes.first["c"]
  end
  
  def self.liked_questions_for_user_id(user_id)
    questions = QDB.instance.execute(<<-SQL, user_id)
      SELECT
        questions.user_id, title, body, questions.id 
      FROM
        questions 
      JOIN
        question_likes ON questions.id = question_id
      WHERE
        user_id = ?
    SQL
    
    questions.map { |question| User.new(question)}
  end
  
  
  def self.most_liked_questions(n)
    questions = QDB.instance.execute(<<-SQL, n)
      SELECT 
        questions.id, body, title, questions.user_id
      FROM 
        questions 
      JOIN 
        question_likes ON questions.id = question_likes.question_id
      GROUP BY 
        questions.id
      ORDER BY 
        COUNT(questions.id)
      DESC 
      LIMIT 
        ?
    SQL
    
    questions.map { |question| Question.new(question)}
  end 
end 
