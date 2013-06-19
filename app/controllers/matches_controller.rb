class MatchesController < ApplicationController
  include RegexCreator

  before_filter :find_match, only: [:show, :edit]

  def new
    @match = Match.new
  end

  def create
    match_params = params[:match]

    # get codes
    codes = []
    code_counter = 1
    while (match_params.has_key?("code#{code_counter}"))
      code_string = match_params.delete("code#{code_counter}")
      numbers = code_string.scan(/\d+/)
      code_id = numbers.join
      codes << Code.find(code_id)
      code_counter += 1
    end

    @match = Match.new(match_params)
    codes.each {|c| @match.codes << c}
    if @match.save
      regex_params = regex_create(@match)
      @pattern = Pattern.new(regex_params)
      codes.each {|c| @pattern.codes << c}
      if @pattern.save
        redirect_to controller: 'matches', action: 'index'
      end
    end
  end

  def show
    @code_matches = []
    @match.all_word_combinations.each do |combo|
       roboclassify(combo).each do |code|
         @code_matches << code unless @code_matches.include? code
       end
    end
  end

  def index
    @matches = Match.all(order: "updated_at DESC")
  end

  private
  def find_match
    @match = Match.find(params[:id])
  end
end