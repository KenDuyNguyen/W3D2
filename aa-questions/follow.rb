
class Follow
  def self.followers_for_question_id(question_id)
    followers = QDB.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, fname, lname
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.user_id
      WHERE
        question_follows.question_id = ?
    SQL
        
    followers.map { |follower| User.new(follower) }    
  end
  
  def self.followed_questions_for_user_id(user_id)
    questions = QDB.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, body, title, questions.user_id
      FROM
        questions
      JOIN
        question_follows ON questions.id = question_follows.question_id
      WHERE
        question_follows.user_id = ?
    SQL
        
    questions.map { |question| Question.new(question) }  
  end
  
  def self.most_followed_questions(n)
    questions = QDB.instance.execute(<<-SQL, n)
      SELECT 
        questions.id, body, title, questions.user_id
      FROM 
        questions 
      JOIN 
        question_follows ON questions.id = question_follows.question_id
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