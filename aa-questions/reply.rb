class Reply 
  def self.find_by_question_id(question_id)
    replies = QDB.instance.execute(<<-SQL, question_id)
      SELECT 
        *
      FROM 
        replies
      WHERE 
        question_id = ?
    SQL
    
    replies.map { |reply| Reply.new(reply) }
  end
  
  def self.find_by_reply_id(reply_id)
    options = QDB.instance.execute(<<-SQL, reply_id)
      SELECT *
      FROM replies 
      WHERE id = ?
      SQL
      
    Reply.new(options.first)
  end
  
  def self.find_children_of(parent_id)
    options = QDB.instance.execute(<<-SQL, parent_id)
      SELECT *
      FROM replies 
      WHERE reply_id = ?
      SQL
      
    Reply.new(options.first)
  end
  
  def self.find_by_user_id(user_id)
    replies = QDB.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    
    replies.map { |reply| Reply.new(reply) }
  end
  
  
  attr_reader :id, :question_id, :user_id, :body, :reply_id
  
  def initialize(options)
    @id = options['id'] 
    @question_id = options['question_id'] 
    @user_id = options['user_id'] 
    @body = options['body'] 
    @reply_id = options['reply_id']
  end
  
  def author 
    User.find_by_id(user_id)
  end 
  
  def question 
    Question.find_by_author_id(user_id)
  end 
  
  def parent_reply
    return nil unless reply_id
    Reply.find_by_reply_id(reply_id)
  end 
  
  def child_replies 
    Reply.find_children_of(id)
  end 
  
end  
