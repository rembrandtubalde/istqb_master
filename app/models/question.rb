class Question < ActiveRecord::Base
  has_many :attempts, dependent: :destroy

  
  validates :question, presence:true
  validates :option_one, presence:true
  validates :option_two, presence:true
  validates :correct_answer, presence:true, :inclusion => { :in => [1,2,3,4] }
  
  def self.save_file(upload)
    name =  upload.original_filename
    directory = "tmp/"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload.read) }
    self.read_questions(path)
    self.drop_file(path)
  end
  
  def self.read_questions(path)
    file = CSV.read(path, {headers: true, col_sep: ';', quote_char: '"'})
    rows = file.to_a
    header = rows[0]
    rows.delete_at(0)
    rows.each do |row|
      hash = Hash[header.zip(row)]
      insert_data(hash)
      
    end
  end
  
  def self.drop_file(path)
    File.delete(path)
  end
  
  def self.insert_data(hash)
	  import_question = Question.find_by_id(hash["id"]) || Question.new
	  import_question.attributes = hash
	  import_question.save	
  end
  

  
end
