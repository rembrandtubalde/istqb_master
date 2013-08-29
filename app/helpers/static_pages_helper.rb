module StaticPagesHelper
  def load_question
    self.current_question = Question.find_by_id(1 + rand(Question.count))
  end
  
  def current_question=(question)
    @current_question = question
    session[:id] = @current_question.id
  end
  
  def current_question
    @current_question ||= Question.find_by_id(session[:id])
  end
end
