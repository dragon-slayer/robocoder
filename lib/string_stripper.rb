module StringStripper
  def clean_string(desc)
    desc = desc.downcase
    desc.gsub!('"', "'")
    desc.gsub!(/\W/, ' ')

    # get rid of html
    desc.gsub!(/\sbr\s/, '')

    # get rid of leading numbers
    desc.gsub!(/^\d+\s/, '')

    #stop repeating strings
    letters = desc.gsub(' ','')
    p "hmm"
    result = letters.scan(/^(.+)\1+/)
    if not result.empty?
      substring = result.first.first
      position = 0
      sub_position = 0
      while xx = substring[sub_position]
        if desc[position] == xx
          sub_position += 1
        end

        position += 1
      end

      desc = desc[0..position]
    end

    desc.strip!

    desc
  end
end
