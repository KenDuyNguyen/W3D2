class Question 
  def self.find_by_author_id(author_id)
    question = QDB.instance.execute(<<-SQL, author_id)
      SELECT 
        *
      FROM 
        questions 
      WHERE 
        user_id = ?
    SQL
    
    Question.new(question.first)
  end 
  
  def self.find_by_id(question_id)
    question = QDB.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    
    Question.new(question.first)
  end
  
  def self.most_followed(n)
    Follow.most_followed_questions(n)
  end
  
  def self.most_liked(n)
    Like.most_liked_questions(n)
  end
  
  attr_reader :id, :user_id, :title, :body
  
  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @title = options["title"]
    @body = options["body"]
  end
  
  def author
    User.find_by_id(user_id)
  end
  
  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    Follow.followers_for_question_id(id)
  end 
  
  def likers 
    Like.likers_for_question_id(id)
  end 
  
  def num_likes 
    Like.num_likes_for_question_id(id)
  end 
  
end

